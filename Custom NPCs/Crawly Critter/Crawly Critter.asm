OFFSET NPC028 ;42BAE0
; State 0: adjusts positioning of NPC upon initializing, then goes to state 1
; State 1: NPC is idle. tests how close the player is. if the player is close, NPC will begin to jump
; State 2: jump startup. wait some frames while idle, then sets the initial jump velocity
; State 3: jump sequence. NPC will jump until its velocity reaches a certain point, and then transition into its flight state
; State 4: flying sequence. plays sfx and cycles through flying frames. ends after collision or enough time, and sets up for landing
; State 5: landing sequence. the gravity code will keep running until the NPC hits the ground, at which point it will go back to the idle state
; State 6: 
; State 7: On ground
; State 8: On left wall
; State 9: On ceiling
; State A: On right wall

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

HORIZONTAL_LEAP_DISTANCE = 100 ;upon jumping, how far the NPC will go left/right

FLIGHT_TIME = 64 ;how many frames the NPC should be in flight before falling down

MAX_FALL_SPEED = 5FF ;max possible falling velocity
GRAVITY = 40 ;how much the NPC will be pulled back down to the ground every frame

X_VELOCITY_SCALE = 20 ;how much the horizontal movement will increase every frame during flight
Y_VELOCITY_SCALE = 10 ;how much the vertical movement will increase every frame during flight
X_VELOCITY_CAP = 200 ;max horizontal speed during flight
Y_VELOCITY_CAP = 200 ;max vertical speed during flight

CRAWL_SPEED = B0
CRAWL_GRAVITY = 400

OFF_PLATFORM_ADJUST_X = 600;C00
OFF_PLATFORM_ADJUST_Y = 600

#ENDDEFINE

ENTER 0, 0
SETPOINTER

:FindState
CMP NPC.ScriptState, A
JG :SetGravity
MOV EDX, NPC.ScriptState
JMP [EDX*4+:StateTable]

:State0
ADD NPC.Y, 600
MOV NPC.ScriptState, 6

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
MOV NPC.MoveX, -HORIZONTAL_LEAP_DISTANCE
JMP :SetGravity

:SetRightXVelocityForState2
MOV NPC.MoveX, HORIZONTAL_LEAP_DISTANCE
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

:State4
MOV EDX, NPC.X
CMP EDX, PlayerXPos ;set the direction towards the player
JGE :SetDirectionForState4
MOV NPC.Direction, 2
JMP :IncrementAndCheckScriptTimer

:SetDirectionForState4
MOV NPC.Direction, 0

:IncrementAndCheckScriptTimer
INC NPC.ScriptTimer
AND NPC.Collision, 00000007 ;if the NPC has made contact with the wall or ceiling...
JNE :SetState5ForState4 ;...then end the current state and set up for the falling sequence
CMP NPC.ScriptTimer, FLIGHT_TIME ;if enough frames have not elapsed...
JLE :CheckScriptTimerForFlightSound ;...then continue in this state and do not activate the falling sequence yet

:SetState5ForState4
MOV NPC.Damage, 3 ;set up the falling state
MOV NPC.ScriptState, 5
MOV NPC.FrameNum, 2
MOV EAX, NPC.MoveX
CDQ ;set EDX to 0 if the velocity is positive, 1 if it's negative
SUB EAX, EDX ;add 1 to the velocity if it's negative, do nothing if it's positive
SAR EAX, 1 ;divide velocity by 2 (the previous operations made it possible to divide cleanly even with a negative velocity)
MOV NPC.MoveX, EAX
JMP :SetGravity 

:CheckScriptTimerForFlightSound
MOV EDX, NPC.ScriptTimer ;the following section will play the critter flying sound effect every few frames
AND EDX, 00000003 ;reduce the scripttimer to a multiple of the given number
CMP EDX, 1 ;if it is NOT reduced down to 1...
JNE :CheckCollisionForState4 ;...then jump to the next section
PUSH 1 ;otherwise, play the critter flying sound effect
PUSH 6D 
CALL PlaySound 
ADD ESP, 8
SETPOINTER

:CheckCollisionForState4
MOV EDX, NPC.Collision
AND EDX, 00000008 ;if the NPC is NOT colliding with the floor...
JE :CheckFlyingFrame ;...then jump to the next section
MOV NPC.MoveY, -200 ;otherwise, push the NPC away from the ground. however, i wasn't able to get this interaction to trigger, so it may not be necessary.

:CheckFlyingFrame
INC NPC.FrameNum
CMP NPC.FrameNum, 5 ;if the NPC has NOT reached the final flying frame in the cycle...
JLE :SetGravity ;...then skip the remaining state code
MOV NPC.FrameNum, 3 ;otherwise, reset the framenum back to the first flying frame in the cycle
JMP :SetGravity

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

:State6
MOV EDX, NPC.Collision
AND EDX, 00000008 ;if the NPC is NOT colliding with the floor...
JE :SetGravity ;...then keep the gravity in effect
MOV NPC.ScriptState, 7 ;otherwise, set up the next state
MOV NPC.FrameTimer, 0
MOV NPC.ScriptTimer, 0
JMP :SetGravity

;42BAE0
:State7
MOV EDX, NPC.Collision
TEST EDX, 00000008 ;if NOT making contact with floor...
JE :State7OffPlatform
TEST EDX, 00000001 ;if making contact with the wall from the left...
JNE :State7ContactLeft
TEST EDX, 00000004 ;if making contact with wall from the right...
JNE :State7ContactRight

:State7Movement
CMP NPC.Direction, 0
JE :State7MovementLeft
ADD NPC.X, CRAWL_SPEED
ADD NPC.Y, CRAWL_GRAVITY
JMP :SetCrawlFrame

:State7MovementLeft
SUB NPC.X, CRAWL_SPEED
ADD NPC.Y, CRAWL_GRAVITY
JMP :SetCrawlFrame

:State7ContactLeft
MOV NPC.ScriptState, A
JMP :StateAMovement

:State7ContactRight
MOV NPC.ScriptState, 8
JMP :State8Movement

:State7OffPlatform
MOV EDX, NPC.Collision
TEST EDX, 0000000F
JNE :State7MoveOffPlatform
ADD NPC.Y, OFF_PLATFORM_ADJUST_Y
INC NPC.ScriptTimer
CMP NPC.ScriptTimer, 2
JE :FallenOff
JMP :SetCrawlFrame

:State7MoveOffPlatform
XOR EDX, EDX
MOV NPC.ScriptTimer, EDX
MOV EDX, NPC.Direction
CMP EDX, 0
JE :State7OffPlatformLeft
MOV NPC.ScriptState, A
JMP :StateAMovement

:State7OffPlatformLeft
MOV NPC.ScriptState, 8
JMP :State8Movement

:FallenOff
MOV NPC.ScriptTimer, 0
MOV NPC.ScriptState, 1
JMP :Render

:State8
MOV EDX, NPC.Collision
TEST EDX, 00000004 ;if NOT making contact with wall from the right...
JE :State8OffPlatform
TEST EDX, 00000008 ;if making contact with the floor...
JNE :State8ContactLeft
TEST EDX, 00000002 ;if making contact with the ceiling...
JNE :State8ContactRight

:State8Movement
CMP NPC.Direction, 0
JE :State8MovementLeft
ADD NPC.X, CRAWL_GRAVITY
SUB NPC.Y, CRAWL_SPEED
JMP :SetCrawlFrame

:State8MovementLeft
ADD NPC.X, CRAWL_GRAVITY
ADD NPC.Y, CRAWL_SPEED
JMP :SetCrawlFrame

:State8ContactLeft
MOV NPC.ScriptState, 7
JMP :State7Movement

:State8ContactRight
MOV NPC.ScriptState, 9
JMP :State9Movement

:State8OffPlatform
MOV EDX, NPC.Collision
TEST EDX, 0000000F
JNE :State8MoveOffPlatform
ADD NPC.X, OFF_PLATFORM_ADJUST_X
INC NPC.ScriptTimer
CMP NPC.ScriptTimer, 2
JE :FallenOff
JMP :SetCrawlFrame

:State8MoveOffPlatform
XOR EDX, EDX
MOV NPC.ScriptTimer, EDX
MOV EDX, NPC.Direction
CMP EDX, 0
JE :State8OffPlatformLeft
MOV NPC.ScriptState, 7
JMP :State7Movement

:State8OffPlatformLeft
MOV NPC.ScriptState, 9
JMP :State9Movement

:State9
MOV EDX, NPC.Collision
TEST EDX, 00000004 ;if making contact with the wall from the right...
JNE :State9ContactLeft
TEST EDX, 00000001 ;if making contact with the wall from the left...
JNE :State9ContactRight
TEST EDX, 00000002 ;if NOT making contact with ceiling...
JE :State9OffPlatform ;change its movement

:State9Movement
CMP NPC.Direction, 0
JE :State9MovementLeft
SUB NPC.X, CRAWL_SPEED
SUB NPC.Y, CRAWL_GRAVITY
JMP :SetCrawlFrame

:State9MovementLeft
ADD NPC.X, CRAWL_SPEED
SUB NPC.Y, CRAWL_GRAVITY
JMP :SetCrawlFrame

:State9ContactLeft
MOV NPC.ScriptState, 8
JMP :State8Movement

:State9ContactRight
MOV NPC.ScriptState, A
JMP :StateAMovement

:State9OffPlatform
SUB NPC.Y, OFF_PLATFORM_ADJUST_Y
MOV EDX, NPC.Direction
CMP EDX, 0
JE :State9OffPlatformLeft
MOV NPC.ScriptState, 8
JMP :State8Movement

:State9OffPlatformLeft
MOV NPC.ScriptState, A
JMP :StateAMovement

:StateA
MOV EDX, NPC.Collision
TEST EDX, 00000002 ;if making contact with the ceiling...
JNE :StateAContactLeft
TEST EDX, 00000008 ;if making contact with the floor...
JNE :StateAContactRight
TEST EDX, 00000001 ;if NOT making contact with wall...
JE :StateAOffPlatform

:StateAMovement
CMP NPC.Direction, 0
JE :StateAMovementLeft
SUB NPC.X, CRAWL_GRAVITY
ADD NPC.Y, CRAWL_SPEED
JMP :SetCrawlFrame

:StateAMovementLeft
SUB NPC.X, CRAWL_GRAVITY
SUB NPC.Y, CRAWL_SPEED
JMP :SetCrawlFrame

:StateAContactLeft
MOV NPC.ScriptState, 9
JMP :State9Movement

:StateAContactRight
MOV NPC.ScriptState, 7
JMP :State7Movement

:StateAOffPlatform
SUB NPC.X, OFF_PLATFORM_ADJUST_X
MOV EDX, NPC.Direction
CMP EDX, 0
JE :StateAOffPlatformLeft
MOV NPC.ScriptState, 9
JMP :State9Movement

:StateAOffPlatformLeft
MOV NPC.ScriptState, 7
JMP :State7Movement

:SetCrawlFrame
INC NPC.FrameTimer
CMP NPC.FrameTimer, 8
JE :SetCrawlFrame1
CMP NPC.FrameTimer, F
JE :SetCrawlFrame2
JMP :Render

:SetCrawlFrame1
MOV NPC.FrameNum, 1
JMP :Render

:SetCrawlFrame2
MOV NPC.FrameNum, 0
MOV NPC.FrameTimer, 0
JMP :Render

:SetGravity
CMP NPC.ScriptState, 4 ;if the NPC is in the flight state...
JE :CheckXVelocity ;...then jump to its unique gravity section
ADD NPC.MoveY, GRAVITY ;add to the Y velocity to simulate gravity pulling down
CMP NPC.MoveY, MAX_FALL_SPEED ;if the current Y velocity is NOT greater than the set cap...
JLE :AddVelocitiesToPositions ;...then jump to the next section
MOV NPC.MoveY, MAX_FALL_SPEED ;otherwise, cap the falling speed
JMP :AddVelocitiesToPositions

:CheckXVelocity
MOV EDX, NPC.X
CMP EDX, PlayerXPos ;if the NPC is to the right of the player...
JGE :DecreaseXVelocity ;...then add a negative X velocity to have the NPC go in the player's direction
ADD NPC.MoveX, 20 ;otherwise, add positive X velocity
JMP :CheckYVelocity

:DecreaseXVelocity
SUB NPC.MoveX, 20

:CheckYVelocity
MOV EDX, NPC.Y
CMP EDX, NPC.Directive ;if the NPC's current Y position is less than its original Y position when it started its flight state...
JLE :IncreaseYVelocity ;...then increase the Y velocity to ascend
SUB NPC.MoveY, 10 ;otherwise, decrease the Y velocity to descend
JMP :CapPositiveYVelocity

:IncreaseYVelocity
ADD NPC.MoveY, 10

:CapPositiveYVelocity
CMP NPC.MoveY, Y_VELOCITY_CAP ;if the Y velocity is NOT too high...
JLE :CapNegativeYVelocity ;...then skip to the next section
MOV NPC.MoveY, Y_VELOCITY_CAP ;otherwise, cap the Y velocity

:CapNegativeYVelocity
CMP NPC.MoveY, -Y_VELOCITY_CAP ;if the Y velocity is NOT too low...
JGE :CapPositiveXVelocity ;...then skip to the next section
MOV NPC.MoveY, -Y_VELOCITY_CAP ;otherwise, cap the Y velocity

:CapPositiveXVelocity
CMP NPC.MoveX, X_VELOCITY_CAP ;if the X velocity is NOT too high...
JLE :CapNegativeXVelocity ;...then skip to the next section
MOV NPC.MoveX, X_VELOCITY_CAP ;otherwise, cap the X velocity

:CapNegativeXVelocity
CMP NPC.MoveX, -X_VELOCITY_CAP ;if the X velocity is NOT too low...
JGE :AddVelocitiesToPositions ;...then skip to the next section
MOV NPC.MoveX, -X_VELOCITY_CAP ;otherwise, cap the X velocity

:AddVelocitiesToPositions
MOV EDX, NPC.MoveX
ADD NPC.X, EDX ;add the pre-calculated X velocity to the NPC's X position
MOV EDX, NPC.MoveY
ADD NPC.Y, EDX ;add the pre-calculated Y velocity to the NPC's Y position

:Render
MOV EDX, NPC.FrameNum ;store the framenum
SHL EDX, 4 ;multiply framenum by 16d to dynamically locate the frame to render
MOV NPC.DisplayL, EDX ;render left display rect
ADD EDX, 10 ;shift position from left of the sprite to right
MOV NPC.DisplayR, EDX ;render right display rect
MOV EDX, NPC.Direction ;store the direction of the NPC
SHL EDX, 3 ;multiply direction by 8 to dynamically locate left/right facing sprites
ADD EDX, 30 ;sprite for NPC begins at 48d Y position
MOV EAX, NPC.ScriptState
CMP EAX, 7
JL :RenderUpDown
SUB EAX, 7
SHL EAX, 5
ADD EDX, EAX

:RenderUpDown
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
print :State6
print :State7
print :State8
print :State9
print :StateA