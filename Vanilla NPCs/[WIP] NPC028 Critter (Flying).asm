OFFSET NPC028 ;42BAE0
; State 0: adjusts positioning of NPC upon initializing, then goes to state 1
; State 1: NPC is idle. tests how close the player is. if the player is close, NPC will begin to jump
; State 2: jump startup. wait some frames while idle, then sets the initial jump velocity
; State 3: jump sequence. NPC will jump until its velocity reaches a certain point, and then transition into its flight state
; State 4: 
; State 5: landing sequence. the gravity code will keep running until the NPC hits the ground, at which point it will go back to the idle state

#DEFINE

;these values determine how close the NPC must be to the player before the NPC's frame changes to its alert appearance
HORIZONTAL_DISTANCE_CHECK_FRAME = 10000
UP_DISTANCE_CHECK_FRAME = 10000
DOWN_DISTANCE_CHECK_FRAME = 6000

;these values determine how close the NPC must be to the player before the NPC switches to its attack state
HORIZONTAL_DISTANCE_CHECK_ATTACK = C000
UP_DISTANCE_CHECK_ATTACK = C000
DOWN_DISTANCE_CHECK_ATTACK = 6000

WAIT_BEFORE_ALERT = 8 ;how long the NPC will wait before it checks to see if it should change its frame to its alert appearance
WAIT_BEFORE_ATTACK = 8 ;how long the NPC will wait before it checks to see if it should attack or not

#ENDDEFINE

ENTER 0, 0
SETPOINTER

:FindState
CMP NPC.ScriptState, 5
JG :SetGravity
MOV EDX, NPC.ScriptState
JMP [EDX*4+:StateTable]

:State0
ADD NPC.Y, 600
MOV NPC.ScriptState, 1

:State1
;;; section 1 - checks distance to see if NPC should be put in its alert frame ;;;
CMP NPC.ScriptTimer, WAIT_BEFORE_ALERT ;if it hasn't been this many frames yet, don't do the player distance check
JL :SetIdleFrameForState1
MOV EDX, NPC.X
SUB EDX, HORIZONTAL_DISTANCE_CHECK_FRAME
CMP EDX, PlayerXPos ;check if the NPC X position is far away from the player
JGE :SetIdleFrameForState1 ;if it is, then skip to the next section
MOV EDX, NPC.X
ADD EDX, HORIZONTAL_DISTANCE_CHECK_FRAME ;check if the NPC X position is far away from the player (from the other direction this time)
CMP EDX, PlayerXPos ;if it is, then skip to the next section
JLE :SetIdleFrameForState1
;check if the NPC Y position is far away from the player (far test)
MOV EDX, NPC.Y
SUB EDX, UP_DISTANCE_CHECK_FRAME ;check if the NPC Y position is far away from the player
CMP EDX, PlayerYPos ;if it is, then skip to the next section
JGE :SetIdleFrameForState1
MOV EDX, NPC.Y
ADD EDX, DOWN_DISTANCE_CHECK_FRAME ;check if the NPC Y position is far away from the player (from the other direction this time)
CMP EDX, PlayerYPos ;if it is, then skip to the next section
JLE :SetIdleFrameForState1
MOV EDX, NPC.X
CMP EDX, PlayerXPos ;set the NPC direction based on where the player is relative to the NPC
JLE :SetDirectionRightForState1
MOV NPC.Direction, 0
JMP :SetAlertFrameForState1

:SetDirectionRightForState1
MOV NPC.Direction, 2

:SetAlertFrameForState1
MOV NPC.FrameNum, 1 ;if we haven't done a jump from the distance checks, then the player is close to the NPC and should be put in its alert frame
JMP :CheckDamageTakenForState1

:SetIdleFrameForState1
MOV NPC.FrameNum, 0

:CheckDamageTakenForState1
INC NPC.ScriptTimer
MOV EDX, NPC.HitTrue
TEST EDX, EDX ;if the NPC has not been hit...
JE :CheckScriptTimerForState1 ;...then skip to the next section
MOV NPC.ScriptState, 2 ;if the NPC has been hit, then set it up to put it in the attack state
MOV NPC.FrameNum, 0
MOV NPC.ScriptTimer, 0

:CheckScriptTimerForState1
CMP NPC.ScriptTimer, WAIT_BEFORE_ATTACK ;if the wait period has not yet passed...
JL :SetGravity ;...then skip this section

;;; section 2 - checks distance to see if NPC should be put in its attack state ;;;
MOV EDX, NPC.X
SUB EDX, HORIZONTAL_DISTANCE_CHECK_ATTACK
CMP EDX, PlayerXPos ;check if the NPC X position is far away from the player
JGE :SetGravity ;if it is, then skip this section
MOV EDX, NPC.X
ADD EDX, HORIZONTAL_DISTANCE_CHECK_ATTACK
CMP EDX, PlayerXPos ;check if the NPC X position is far away from the player (from the other direction this time)
JLE :SetGravity ;if it is, then skip this section
MOV EDX, NPC.Y
SUB EDX, UP_DISTANCE_CHECK_ATTACK
CMP EDX, PlayerYPos ;check if the NPC Y position is far away from the player
JGE :SetGravity ;if it is, then skip to the next section
MOV EDX, NPC.Y
ADD EDX, DOWN_DISTANCE_CHECK_ATTACK
CMP EDX, PlayerYPos ;check if the NPC Y position is far away from the player (from the other direction this time)
JLE :SetGravity ;if it is, then skip to the next section
MOV NPC.ScriptState, 2 ;if we haven't done a jump from the distance checks, then the player is close to the NPC and should be set up to go to its attack state
MOV NPC.FrameNum, 0
MOV NPC.ScriptTimer, 0
JMP :SetGravity

:State2
INC NPC.ScriptTimer
CMP NPC.ScriptTimer, 8 ;wait this many frames before starting the jump
JLE :SetGravity
MOV NPC.ScriptState, 3
MOV NPC.FrameNum, 2 ;jumping frame
MOV NPC.MoveY, -4CC ;jump velocity
PUSH 1 
PUSH 1E 
CALL PlaySound ;jump sound effect
ADD ESP, 8
SETPOINTER
MOV EDX, NPC.X
CMP EDX, PlayerXPos ;set NPC direction left/right to face the player
JLE :SetDirectionRightForState2
MOV NPC.Direction, 0
JMP :CheckDirectionForState2

:SetDirectionRightForState2
MOV NPC.Direction, 2

:CheckDirectionForState2
CMP NPC.Direction, 0 ;using the direction that was just set, set the X velocity in that direction
JNE :SetRightXVelocityForState2
MOV NPC.MoveX, -100
JMP :SetGravity

:SetRightXVelocityForState2
MOV NPC.MoveX, 100
JMP :SetGravity

:State3
CMP NPC.MoveY, 100 ;wait until the gravity starts bringing the NPC down, per the gravity that is being applied every frame
JLE :SetGravity
MOV EDX, NPC.Y
MOV NPC.Directive, EDX ;save the initial Y position of the flight state to use as an anchor point later
MOV NPC.ScriptState, 4 ;setup for the flight state
MOV NPC.FrameNum, 3
MOV NPC.ScriptTimer, 0
JMP :SetGravity

;start of flight state
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

;landing after flying state
:State5
MOV EDX, NPC.Collision
AND EDX, 00000008 ;if the NPC is not colliding with the floor...
JE :SetGravity ;...then continue setting the gravity
MOV NPC.Damage, 2 ;if the NPC has hit the ground, then reset variables and go back to the idle state
MOV NPC.MoveX, 0
MOV NPC.ScriptTimer, 0
MOV NPC.FrameNum, 0
MOV NPC.ScriptState, 1
PUSH 1 
PUSH 17 
CALL PlaySound ;hit the ground sound effect
ADD ESP, 8
SETPOINTER

:SetGravity
CMP NPC.ScriptState, 4 
JE :CheckXVelocity
ADD NPC.MoveY, 40 ;add to the Y velocity to simulate gravity pulling down
CMP NPC.MoveY, 5FF ;cap falling speed
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
CMP EDX, NPC.Directive
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
LEAVE
RETN

:StateTable
print :State0
print :State1
print :State2
print :State3
print :State4
print :State5
