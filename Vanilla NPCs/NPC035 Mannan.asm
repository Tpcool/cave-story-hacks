OFFSET NPC035 ;42CCB0

PUSH EBP ;setting up...
MOV EBP, ESP ;...the stack
SUB ESP, 0 ;setting up local variables
SETPOINTER

:StateCheck
CMP NPC.ScriptState, 3 ;if NPC is in the dead state...
JGE :FindState ;jump to behavior script
CMP NPC.Health, 5A ;if the health of the NPC, which is coded to 100, is greater than or equal to 90... (this means that the health of this NPC is 11 in practice)
JGE :FindState ;jump to behavior script

:DeathSequence
PUSH 1 ;in sound channel 1?... 
PUSH 47 ;with the explosion sound (ID: 71)... 
CALL PlaySound ;play the sound effect 
ADD ESP, 8 ;fix the stack
SETPOINTER
PUSH 8 ;create 8 smoke entities 
PUSH NPC.ViewBox ;that weird ass value is the range that the smoke will spawn
PUSH NPC.Y ;spawn smoke on the Y position of the NPC
PUSH NPC.X ;spawn smoke on the X position of the NPC 
CALL CreateExplosion ;now MAKE THE SMOKE 
ADD ESP, 10 ;fix the stack
SETPOINTER
PUSH NPC.EXP ;amount of XP to spawn: the amount dropped by the NPC!
PUSH NPC.Y ;spawn XP on NPC Y position 
PUSH NPC.X ;spawn XP on NPC X position
CALL CreateXp ;spawn XP 
ADD ESP, 0C ;fix the stack
SETPOINTER
MOV NPC.ScriptState, 3 ;set the NPC to the DEAD state
MOV NPC.ScriptTimer, 0 ;reset the script timer to 0
MOV NPC.FrameNum, 2 ;set the NPC frame to dead
AND NPC.Flags, FFFFFFDF ;store the flag to make the NPC non-shootable in the dead state
MOV NPC.Damage, 0 ;deal no damage to the player

:FindState
CMP NPC.ScriptState, 3 ;if the NPC is in the "dead no more blinking" state...
JG :Render ;render the NPC
MOV EDX, NPC.ScriptState ;stores the current scriptstate
JMP [EDX*4+:StateTable] ;jump to the scripttable to go to the current state

:State1Undisturbed
XOR EDX, EDX ;MOVZX ECX, [EAX+9C] ;stores flag determining if the enemy has been hit
MOV EDX, NPC.HitTrue
TEST EDX, EDX ;if the NPC has not been hit...
JE :Render ;render the NPC

:Shoot
PUSH 100 ;with this entity slot... 
PUSH 0 ;with no parent or tracker... 
MOV EAX, NPC.Direction
PUSH EAX ;with the same direction as this NPC... 
PUSH 0 ;with no Y velocity... 
PUSH 0 ;with no X velocity... 
MOV EDX, NPC.Y ;store the Y position of this NPC 
ADD EDX, 1000 ;offset the Y position a bit further away 
PUSH EDX ;with the Y position slightly away from this NPC... 
SHR EAX, 1 ;dynamically calculate which direction to offset 
IMUL EAX, EAX, 2000
SUB EAX, 1000
MOV EDX, NPC.X ;store the X position of this NPC 
ADD EDX, EAX ;offset the X position a bit further away 
PUSH EDX ;with the X position slightly away from this NPC...
PUSH 67 ;with the Mannan projectile...
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack
SETPOINTER

:InitialHit
MOV NPC.FrameNum, 1 ;set the NPC frame to hit
MOV NPC.ScriptState, 2 ;set the NPC to hit
MOV NPC.ScriptTimer, 0 ;set the scripttimer to 0
JMP :Render ;render the NPC

:State2Hit
INC NPC.ScriptTimer
CMP NPC.ScriptTimer, 14 ;if it hasn't been long enough...
JLE :Render ;render the NPC
MOV NPC.ScriptTimer, 0 ;reset the scripttimer to 0
MOV NPC.ScriptState, 1 ;revert the NPC back to the undisturbed state
MOV NPC.FrameNum, 0 ;set the NPC frame to undisturbed
JMP :Render ;render the NPC

:State3DeadBlink
INC NPC.ScriptTimer
CMP NPC.ScriptTimer, 32 ;first blink
JE :SetBlink
CMP NPC.ScriptTimer, 35 ;first unblink
JE :SetUnblink
CMP NPC.ScriptTimer, 3C ;second blink
JE :SetBlink
CMP NPC.ScriptTimer, 3F ;second unblink
JE :SetUnblink
CMP NPC.ScriptTimer, 64 ;set final state
JG :SetFinalState
JMP :Render

:SetBlink
MOV NPC.FrameNum, 3
JMP :Render

:SetUnblink
MOV NPC.FrameNum, 2
JMP :Render

:SetFinalState
MOV NPC.ScriptState, 4

:Render
MOV EDX, NPC.FrameNum ;store the framenum
IMUL EDX, EDX, 18 ;multiply framenum by 24 to dynamically locate the frame to render
ADD EDX, 60 ;sprite for NPC begins at 96 X position
MOV NPC.DisplayL, EDX ;render left display rect
ADD EDX, 18 ;shift position from left of the sprite to right
MOV NPC.DisplayR, EDX ;render right display rect
MOV EDX, NPC.Direction ;store the direction of the NPC
SHL EDX, 4 ;multiply direction by 16 to dynamically locate left/right facing sprites
ADD EDX, 40 ;sprite for NPC begins at 64 Y position
MOV NPC.DisplayU, EDX ;render up display rect
ADD EDX, 20 ;shift position from top of the sprite to bottom
MOV NPC.DisplayD, EDX ;render down display rect

:EndOfCode
MOV ESP, EBP
POP EBP
RETN

:StateTable
print :State1Undisturbed
print :State1Undisturbed
print :State2Hit
print :State3DeadBlink