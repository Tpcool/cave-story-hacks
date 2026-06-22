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

OFFSET NPC160 ;Pooh Black, 447700

#DEFINE

GRAVITY = 70

#ENDDEFINE

PUSH EBP ;setting up...
MOV EBP, ESP ;...the stack
SUB ESP, 0 ;setting up local variables
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
CMP NPC.ScriptTimer, 40 ;After 64 frames of idling...
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
MOV EBX, 32 ;50 frame jump
IDIV EBX ;use EBX instead?
MOV NPC.MoveX, EAX ;store the quotient (use local var instead?)
MOV NPC.ObjectTimer, EDX ;store the remainder (use local var instead?)
;Y velocity
MOV EDX, 19 ;half of the 50 frame jump...
IMUL EDX, EDX, -GRAVITY
MOV NPC.MoveY, EDX
ADD NPC.Y, EDX
JMP :Render

:State1 ;JUMPS FOR EXACTLY 50 FRAMES
;CMP NPC.MoveY, 0
;JLE :test
;CMP NPC.Collision, 8 ;check if the NPC is making contact with the ground
MOV EDX, NPC.Collision
AND EDX, 8
JNE :SetState5 ;end the jumping state code

;AND NPC.Collision, 6 ;check if the NPC is making contact with a wall
;JNE :CollisionWall
;CMP NPC.Collision, 2 ;check if the NPC is making contact with the ceiling
;JNE :CollisionCeiling

;X velocity
MOV EDX, NPC.MoveX
CMP NPC.Direction, 0
JE :XLeftMovement
ADD NPC.X, EDX
JMP :YMovement

:XLeftMovement
ADD NPC.X, EDX

;Y velocity
:YMovement
ADD NPC.MoveY, GRAVITY
MOV EDX, NPC.MoveY
ADD NPC.Y, EDX
MOV EDX, NPC.Y
;Gravity stuff
JMP :Render

:CollisionWall
;Stop X axis movement
;Set Y axis movement depending on current spot in the jump
;Gravity stuff Y axis
CMP NPC.Collision, 2 ;check if the NPC is also touching the ceiling
JNE :CollisionCeiling
JMP :Render

:CollisionCeiling
;Stop Y axis movement
JMP :Render

:SetState2
MOV NPC.ScriptState, 2
MOV NPC.ScriptTimer, 0
MOV NPC.FrameNum, 3
MOV NPC.FrameTimer, 0

:State2 ;6 frames in between each dance frame
CMP NPC.ScriptTimer, 30 ;after 48 more frames of idling...
JE :SetState3 ;start the attack
TEST KeyPressed, 00000020 ;check if SHOOT is pressed
JNZ :Restart ;if it is, restart
CMP NPC.ScriptTimer, 6
JE :SetRaiseArms
CMP NPC.FrameTimer, 6 ;cycle between dance frames
JE :SetDanceFrame1
CMP NPC.FrameTimer, C
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

:State3 ;7 frames when arms are tucked (no rain flush) 
;11 frames between each dance frame, attack is present for 120 frames
;first 8 frames of rain flush doesn't hurt!
;last 8 frames he is still dancing but no more rain flush
CMP NPC.ScriptTimer, 7
JE :SpawnAttack
CMP NPC.ScriptTimer, 80
JE :Restart
CMP NPC.FrameTimer, B
JE :SetDanceFrame1
CMP NPC.FrameTimer, 16
JE :SetDanceFrame2
INC NPC.ScriptTimer
INC NPC.FrameTimer
JMP :Render

:SpawnAttack
MOV NPC.FrameTimer, C
MOV NPC.FrameNum, 5
;call rain flush NPC, lasts for 120 frames
;first 8 frames do not hurt
;only hurts right when it spawns
INC NPC.ScriptTimer
JMP :Render

:SetState4
MOV NPC.ScriptState, 4
MOV NPC.FrameNum, 1
MOV NPC.FrameTimer, 0

:State4 ;crouch before jumping for 6 frames
CMP NPC.FrameTimer, 6
JE :SetState1
INC NPC.FrameTimer
JMP :Render

:SetState5 
MOV NPC.MoveY, 0
MOV NPC.ScriptState, 5
MOV NPC.FrameNum, 1
MOV NPC.FrameTimer, 0

:State5 ;crouch after landing for 7 frames
MOV EDX, NPC.MoveY
MOV EDX, NPC.Y
CMP NPC.FrameTimer, 7
JE :RestartAfterLanding
INC NPC.FrameTimer
JMP :Render

:RestartAfterLanding
MOV NPC.ScriptState, 0
MOV NPC.FrameNum, 0
MOV NPC.FrameTimer, 0
JMP :Render

:Restart
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

; Run this once per frame instead if you want perfect precision for x axis jump

; 1. Move by base velocity
;mov eax, [EnemyCurrentX]
;add eax, [VelocityX]

; 2. Accumulate the remainder
;mov ecx, [CurrentAccumulator]
;add ecx, [XRemainder]          ; Add the remainder we saved earlier

;cmp ecx, 50                    ; Have we accumulated a full pixel?
;jl .skip_extra_pixel           ; If less than 50, skip extra movement

; 3. Add the extra pixel and adjust accumulator
;inc eax                        ; Move 1 extra pixel
;sub ecx, 50                    ; Subtract 50 from accumulator

;.skip_extra_pixel:
;mov [CurrentAccumulator], ecx  ; Save updated accumulator
;mov [EnemyCurrentX], eax       ; Save updated X position