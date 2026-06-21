OFFSET NPC028 ;42BAE0

PUSH EBP
MOV EBP, ESP
SUB ESP, 0
SETPOINTER

:FindState
CMP NPC.ScriptState, 5
JG :SetGravity
MOV EDX, NPC.ScriptState
JMP [EDX*4+:StateTable]

;not entirely sure what the point of this is, as nothing much changes when it's removed, but it appears as if it's starting the NPC slightly further down. possibly for initial gravity?
:State0
ADD NPC.Y, 600
MOV NPC.ScriptState, 1

:State1
CMP NPC.ScriptTimer, 8
JL :Section2ForState1
;check if the NPC X position is far away from the player (far test)
MOV EDX, NPC.X
SUB EDX, 10000
CMP EDX, PlayerXPos
JGE :Section2ForState1
MOV EDX, NPC.X
ADD EDX, 10000
CMP EDX, PlayerXPos
JLE :Section2ForState1
;check if the NPC Y position is far away from the player (far test)
MOV EDX, NPC.Y
SUB EDX, 10000
CMP EDX, PlayerYPos
JGE :Section2ForState1
MOV EDX, NPC.Y
ADD EDX, 6000
CMP EDX, PlayerYPos
JLE :Section2ForState1
MOV EDX, NPC.X
CMP EDX, PlayerXPos
JLE :SetDirectionRightForState1
MOV NPC.Direction, 0
JMP :SetFrameNumForState1

:SetDirectionRightForState1
MOV NPC.Direction, 2

:SetFrameNumForState1
MOV NPC.FrameNum, 1
JMP :CheckDamageTakenForState1

:Section2ForState1
CMP NPC.ScriptTimer, 8
JGE :ResetFrameNumForState1
INC NPC.ScriptTimer

:ResetFrameNumForState1
MOV NPC.FrameNum, 0

:CheckDamageTakenForState1
;check if the NPC has not been hit
MOV EDX, NPC.HitTrue
TEST EDX, EDX
JE :CheckScriptTimerForState1
MOV NPC.ScriptState, 2
MOV NPC.FrameNum, 0
MOV NPC.ScriptTimer, 0

:CheckScriptTimerForState1
CMP NPC.ScriptTimer, 8
JL :SetGravity 
;check if the NPC X position is far from the player (close test)
MOV EDX, NPC.X
SUB EDX, 0C000
CMP EDX, PlayerXPos
JGE :SetGravity 
MOV EDX, NPC.X
ADD EDX, 0C000
CMP EDX, PlayerXPos
JLE :SetGravity 
;check if the NPC Y position is far from the player (close test)
MOV EDX, NPC.Y
SUB EDX, 0C000
CMP EDX, PlayerYPos
JGE :SetGravity 
MOV EDX, NPC.Y
ADD EDX, 6000
CMP EDX, PlayerYPos
JLE :SetGravity 
MOV NPC.ScriptState, 2
MOV NPC.FrameNum, 0
MOV NPC.ScriptTimer, 0
JMP :SetGravity

:State2
INC NPC.ScriptTimer
CMP NPC.ScriptTimer, 8
JLE :SetGravity
MOV NPC.ScriptState, 3
MOV NPC.FrameNum, 2
MOV NPC.MoveY, -4CC
PUSH 1 
PUSH 1E 
CALL PlaySound
ADD ESP, 8
SETPOINTER
MOV EDX, NPC.X
CMP EDX, PlayerXPos
JLE :SetDirectionRightForState2
MOV NPC.Direction, 0
JMP :CheckDirectionForState2

:SetDirectionRightForState2
MOV NPC.Direction, 2

:CheckDirectionForState2
CMP NPC.Direction, 0
JNE :SetRightXVelocityForState2
MOV NPC.MoveX, -100
JMP :SetGravity

:SetRightXVelocityForState2
MOV NPC.MoveX, 100
JMP :SetGravity

:State3
;check if Y velocity is low
CMP NPC.MoveY, 100
JLE :SetGravity
;save Y position in weird NPC variable
MOV EDX, NPC.Y
MOV NPC.CurlyMacro2, EDX
;set scriptstate to 4
MOV NPC.ScriptState, 4
MOV NPC.FrameNum, 3
MOV NPC.ScriptTimer, 0
JMP :SetGravity

:State4
MOV EDX, NPC.X
CMP EDX, PlayerXPos
JGE :SetDirectionLeftForState4
MOV NPC.Direction, 2
JMP :IncrementAndCheckScriptTimer

:SetDirectionLeftForState4
MOV NPC.Direction, 0

:IncrementAndCheckScriptTimer
INC NPC.ScriptTimer
;check if collision with left wall, right wall, ceiling
AND NPC.Collision, 00000007
JNE :SetState5ForState4
CMP NPC.ScriptTimer, 64
JLE :CalculateWeirdScriptTimerThing

:SetState5ForState4
MOV NPC.Damage, 3
MOV NPC.ScriptState, 5
MOV NPC.FrameNum, 2
;research says: this will divide the X velocity by 2 and save it as the new velocity
MOV EAX, NPC.MoveX
CDQ
SUB EAX, EDX
SAR EAX, 1
MOV NPC.MoveX, EAX
JMP :SetGravity 

:CalculateWeirdScriptTimerThing
;research says: this is checking if the scripttimer is negative? does weird stuff with EDX?
MOV EDX, NPC.ScriptTimer
AND EDX, 80000003
JNS :CheckWeirdScriptTimerThing 
;no clue... TBD. it's doing even more stuff with the already weird value
DEC EDX
OR EDX, FFFFFFFC
INC EDX

:CheckWeirdScriptTimerThing
CMP EDX, 1
JNE :CheckCollisionForState4
;play critter fly sfx
PUSH 1 
PUSH 6D 
CALL PlaySound 
ADD ESP, 8
SETPOINTER

:CheckCollisionForState4
;check if the NPC is... NOT colliding with the floor
MOV EDX, NPC.Collision
AND EDX, 00000008
JE :ResetAndIncrementFrameTimer
MOV NPC.MoveY, -200

:ResetAndIncrementFrameTimer
INC NPC.FrameTimer
CMP NPC.FrameTimer, 0
JLE :CheckFlyingFrame
MOV NPC.FrameTimer, 0
INC NPC.FrameNum

:CheckFlyingFrame
;check if the framenum is less than or equal to 5
CMP NPC.FrameNum, 5
JLE :SetGravity
;set the framenum to 3 (in an effort to cycle through the frames of flying)
MOV NPC.FrameNum, 3
JMP :SetGravity

:State5
;check if the NPC is... NOT colliding with the floor
MOV EDX, NPC.Collision
AND EDX, 00000008
JE :SetGravity
MOV NPC.Damage, 2
MOV NPC.MoveX, 0
MOV NPC.ScriptTimer, 0
MOV NPC.FrameNum, 0
MOV NPC.ScriptState, 1
;play hit the ground sfx
PUSH 1 
PUSH 17 
CALL PlaySound 
ADD ESP, 8
SETPOINTER

:SetGravity
CMP NPC.ScriptState, 4
JE :CheckXVelocity
ADD NPC.MoveY, 40
CMP NPC.MoveY, 5FF
JLE :AddVelocitiesToPositions
MOV NPC.MoveY, 5FF
JMP :AddVelocitiesToPositions

:CheckXVelocity
MOV EDX, NPC.X
CMP EDX, PlayerXPos
JGE :DecreaseXVelocity
ADD NPC.MoveX, 20
JMP :CheckYVelocity

:DecreaseXVelocity
SUB NPC.MoveX, 20

:CheckYVelocity
MOV EDX, NPC.Y
CMP EDX, NPC.CurlyMacro2
JLE :IncreaseYVelocity
SUB NPC.MoveY, 10
JMP :CapPositiveYVelocity

:IncreaseYVelocity
ADD NPC.MoveY, 10

:CapPositiveYVelocity
CMP NPC.MoveY, 200
JLE :CapNegativeYVelocity
MOV NPC.MoveY, 200

:CapNegativeYVelocity
CMP NPC.MoveY, -200
JGE :CapPositiveXVelocity
MOV NPC.MoveY, -200

:CapPositiveXVelocity
CMP NPC.MoveX, 200
JLE :CapNegativeXVelocity
MOV NPC.MoveX, 200

:CapNegativeXVelocity
CMP NPC.MoveX, -200
JGE :AddVelocitiesToPositions
MOV NPC.MoveX, -200

:AddVelocitiesToPositions
MOV EDX, NPC.MoveX
ADD NPC.X, EDX
MOV EDX, NPC.MoveY
ADD NPC.Y, EDX

:Render
MOV EDX, NPC.FrameNum ;store the framenum
SHL EDX, 4 ;multiply framenum by 16d to dynamically locate the frame to render
MOV NPC.DisplayL, EDX ;render left display rect
ADD EDX, 10 ;shift position from left of the sprite to right
MOV NPC.DisplayR, EDX ;render right display rect
MOV EDX, NPC.Direction ;store the direction of the NPC
SHL EDX, 3 ;multiply direction by 8 to dynamically locate left/right facing sprites
ADD EDX, 30 ;sprite for NPC begins at 48d Y position
MOV NPC.DisplayU, EDX ;render up display rect
ADD EDX, 10 ;shift position from top of the sprite to bottom
MOV NPC.DisplayD, EDX ;render down display rect

:EndOfCode
MOV ESP, EBP
POP EBP
RETN

:StateTable
print :State0
print :State1
print :State2
print :State3
print :State4
print :State5
