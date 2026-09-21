OFFSET NPC162 ;447E90
; TOAD MAN
; This NPC is made to be a near exact recreation of the Toad Man boss in Mega Man 4. Like in that fight,
; this NPC will wait around and start dancing, and will then spawn the Rain Flush - Generator NPC if the
; shoot button is not pressed. If it is, then the NPC will jump towards the player.

;-- ScriptState 0, Idle
;-- ScriptState 1, Jump
;-- ScriptState 2, Dance
;-- ScriptState 3, Attack
;-- ScriptState 4, Crouch before jump
;-- ScriptState 5, Crouch after jump

;-- FrameNum 0, Idle
;-- FrameNum 1, Crouch
;-- FrameNum 2, Pose
;-- FrameNum 3, Raise Hands 1
;-- FrameNum 4, Raise Hands 2
;-- FrameNum 5, Dance 1
;-- FrameNum 6, Dance 2
;-- FrameNum 7, Jump

#DEFINE

JUMP_AIR_TIME = 32 ;how many frames the NPC will be in the air for after jumping
GRAVITY = 70 ;how high the NPC will jump
GRAVITY_CAP = EF1 ;if the NPC continues to fall, the fall speed will cap out to this amount. for reference, the amount EF1 is the highest you can go without him falling through the floor.
IDLE_TIME = 40 ;how long the NPC waits before starting the attack. in line with the logic this NPC is based on, the idle time counter will not reset after landing from a jump.

#ENDDEFINE

ENTER 0, 0 ;set up the stack
SETPOINTER

:StateCheck
MOV EDX, NPC.ScriptState
JMP [EDX*4+:StateTable] ;Jump to current ScriptState

:State0
MOV EDX, PlayerXPos
MOV EAX, NPC.X
CMP EDX, EAX
JL :SetLeftDirection ;If player is to the left of NPC, set left
MOV NPC.Direction, 2 ;Otherwise, face right
JMP :State0CheckAction

:SetLeftDirection
MOV NPC.Direction, 0
JMP :State0CheckAction

:State0CheckAction
CMP NPC.ScriptTimer, IDLE_TIME ;After idling the preset amount of time...
JE :SetState2 ;Start the dance
TEST KeyPressed, 00000020 ;check if SHOOT is pressed
JNZ :SetState4 ;if it is, go to the jump state
INC NPC.ScriptTimer
JMP :Render

:SetState1
MOV NPC.ScriptState, 1
MOV NPC.FrameNum, 7
MOV NPC.FrameTimer, 0
;X velocity
MOV EAX, PlayerXPos
SUB EAX, NPC.X
CDQ
MOV EBX, JUMP_AIR_TIME
IDIV EBX
MOV NPC.MoveX, EAX ;store the quotient, which is how far the NPC will need to go each frame to reach the target
MOV NPC.Directive, EDX ;in an unused function, store the remainder, which is used to more precisely determine where the NPC will need to land frame-by-frame
;Y velocity
MOV EDX, JUMP_AIR_TIME
SHR EDX, 1 ;get half of the air time
IMUL EDX, EDX, -GRAVITY
MOV NPC.MoveY, EDX
ADD NPC.Y, EDX
;play jump noise
PUSH 1 
PUSH 6C 
CALL PlaySound 
ADD ESP, 8
SETPOINTER
JMP :Render

:State1
;end the jumping state code if the NPC has reached the floor
MOV EDX, NPC.Collision
AND EDX, 8
JNE :SetState5
;Use the X movement that was calculated to update X position depending on the NPC's direction
MOV EDX, NPC.MoveX
CMP NPC.Direction, 0
JE :XLeftMovement
ADD NPC.X, EDX
JMP :YMovement

:XLeftMovement
ADD NPC.X, EDX

;Move the NPC further up or down depending on the preset gravity value, and set the maximum fall speed if it's reached
:YMovement
ADD NPC.MoveY, GRAVITY
CMP NPC.MoveY, GRAVITY_CAP
JL :SetYMovement

:CapYMovement
MOV NPC.MoveY, GRAVITY_CAP 

:SetYMovement
MOV EDX, NPC.MoveY
ADD NPC.Y, EDX
MOV EDX, NPC.Y
JMP :Render

:SetState2
MOV NPC.ScriptState, 2
MOV NPC.ScriptTimer, 0
MOV NPC.FrameNum, 3
MOV NPC.FrameTimer, 0

:State2
CMP NPC.ScriptTimer, 30 ;after 48 more frames of idling...
JE :SetState3 ;start the attack
TEST KeyPressed, 00000020 ;check if the player has pressed the shoot button
JNZ :Restart ;go back to idle state
CMP NPC.ScriptTimer, 6 ;on the 6th frame of this state, update the animation where the NPC begins to raise its hands
JE :SetRaiseArms
CMP NPC.FrameTimer, 6 ;on every 6th frame, update the animation
JE :SetDanceFrame1
CMP NPC.FrameTimer, C ;on every 12th frame, update the animation, and reset the frame timer
JE :SetDanceFrame2
INC NPC.ScriptTimer
INC NPC.FrameTimer
JMP :Render

:SetRaiseArms
MOV NPC.FrameNum, 4
INC NPC.ScriptTimer
MOV NPC.FrameTimer, 0
JMP :Render

:SetDanceFrame1
MOV NPC.FrameNum, 5
INC NPC.ScriptTimer
INC NPC.FrameTimer
JMP :Render

:SetDanceFrame2
MOV NPC.FrameNum, 6
INC NPC.ScriptTimer
MOV NPC.FrameTimer, 0
JMP :Render

:SetState3
MOV NPC.ScriptState, 3
MOV NPC.ScriptTimer, 0
MOV NPC.FrameNum, 4
MOV NPC.FrameTimer, 0

:State3
CMP NPC.ScriptTimer, 7 ;on the 7th frame, spawn the attack
JE :SpawnAttack
CMP NPC.ScriptTimer, 80 ;on the 80th frame, go back to the idle state
JE :Restart
CMP NPC.FrameTimer, B ;on every 11th frame, update the animation
JE :SetDanceFrame1
CMP NPC.FrameTimer, 16 ;on every 22nd frame, update the animation, and reset the frame timer
JE :SetDanceFrame2
INC NPC.ScriptTimer
INC NPC.FrameTimer
JMP :Render

:SpawnAttack
MOV NPC.FrameTimer, C
MOV NPC.FrameNum, 5
;create NPC
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, NPC.Y
PUSH EDX ;Y position of NPC
MOV EDX, NPC.X
PUSH EDX ;X position of NPC
PUSH A0 ;rain flush generator NPC
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack
;play attack sound effect
PUSH 1 
PUSH 99 ;99 = hiopen
CALL PlaySound 
ADD ESP, 8
SETPOINTER
INC NPC.ScriptTimer
JMP :Render

:SetState4
MOV NPC.ScriptState, 4
MOV NPC.FrameNum, 1
MOV NPC.FrameTimer, 0

:State4
CMP NPC.FrameTimer, 6 ;animate crouching for 6 frames before going into jumping state
JE :SetState1
INC NPC.FrameTimer
JMP :Render

:SetState5 
MOV NPC.ScriptState, 5
MOV NPC.FrameNum, 1
MOV NPC.FrameTimer, 0
;play landing sound effect
PUSH 1 
PUSH 6F ;6F = large critter landing
CALL PlaySound 
ADD ESP, 8
SETPOINTER

:State5
CMP NPC.FrameTimer, 7 ;animate crouching for 7 frames before going back into idle state
JE :RestartAfterLanding
INC NPC.FrameTimer
JMP :Render

:RestartAfterLanding ;this restart snippet has the distinction of not resetting the script timer which allows the dance scriptstate to potentially begin sooner after langing from a jump
MOV NPC.ScriptState, 0
MOV NPC.FrameNum, 0
MOV NPC.FrameTimer, 0
JMP :Render

:Restart ;reset all values back to the idle state
MOV NPC.ScriptTimer, 0
MOV NPC.ScriptState, 0
MOV NPC.FrameNum, 0
MOV NPC.FrameTimer, 0

:Render
MOV EDX, NPC.FrameNum
CMP EDX, 5 ;if the framenum is higher than 5 then we need to do some extra math to account for the sprites that overflow into the additional rows...
JG :RenderHigherFrameNum
IMUL EDX, EDX, 2E ;multiply framenum by 46 to dynamically locate the frame to render
MOV NPC.DisplayL, EDX ;render left display rect
ADD EDX, 2E ;shift position from left of the sprite to right
MOV NPC.DisplayR, EDX ;render right display rect
MOV EDX, NPC.Direction ;store the direction of the NPC
IMUL EDX, EDX, 14 ;multiply direction by 20 to dynamically locate left/right facing sprites
MOV NPC.DisplayU, EDX ;render up display rect
ADD EDX, 28 ;shift position from top of the sprite to bottom
MOV NPC.DisplayD, EDX ;render down display rect
JMP :EndOfCode

:RenderHigherFrameNum
SUB EDX, 6 ;frame 6 will fall into frame 0 of the new row, and 7 -> 1
IMUL EDX, EDX, 2E ;multiply framenum by 46 to dynamically locate the frame to render
MOV NPC.DisplayL, EDX ;render left display rect
ADD EDX, 2E ;shift position from left of the sprite to right
MOV NPC.DisplayR, EDX ;render right display rect
MOV EDX, NPC.Direction ;store the direction of the NPC
IMUL EDX, EDX, 14 ;multiply direction by 20 to dynamically locate left/right facing sprites
ADD EDX, 50
MOV NPC.DisplayU, EDX ;render up display rect
ADD EDX, 28 ;shift position from top of the sprite to bottom
MOV NPC.DisplayD, EDX ;render down display rect

:EndOfCode
LEAVE
RETN

:StateTable
print :State0
print :State1
print :State2
print :State3
print :State4
print :State5