OFFSET NPC161 ;447CB0
; TOAD MAN - RAIN FLUSH
; This NPC is necessary for the Toad Man NPC. It is spawned by the Toad Man - Rain Flush Generator
; NPC, which spawns many of this NPC to create the visual effect of the acid rain in the Toad Man
; fight. This NPC is very simple. It will move down and to the left at the defined speed, and wrap
; back around to the other side of the screen to create a looping effect. After the defined amount
; of frames has elapsed, it will delete itself.

PUSH EBP ;setting up...
MOV EBP, ESP ;...the stack
SUB ESP, 0 ;setting up local variables
SETPOINTER

#DEFINE

VISUAL_SPEED = A00 ;how fast the NPC moves
FRAMES_ACTIVE = 78 ;how long the NPC is active before going away

#ENDDEFINE

CMP NPC.ScriptTimer, FRAMES_ACTIVE ;check how long the NPC has been active for compared to our preset value...
JGE :DestroyNPC ;jump to the code that removes the NPC
JMP :CheckXPosition ;otherwise, jump to the next check

:DestroyNPC
MOV NPC.InUse, 0 ;flag as not in use, deleting the NPC

:CheckXPosition
CMP NPC.X, 0 ;check if the NPC has reached the edge of the screen
JLE :WrapXPosition ;jump to the code that moves it back to the other side of the screen
JMP :CheckYPosition ;otherwise, jump to the next check

:WrapXPosition
MOV NPC.X, 2A000 ;update the NPC's X position to be on the right edge of the screen

:CheckYPosition
CMP NPC.Y, 20000 ;check if the NPC has reached the bottom of the screen
JGE :WrapYPosition ;jump to the code that moves it back to the top of the screen
JMP :SetMovement ;otherwise, jump to the next check

:WrapYPosition
MOV NPC.Y, 0 ;update the NPC's Y position to be on the top of the screen

:SetMovement
MOV EDX, VISUAL_SPEED ;put the preset speed in a register
ADD NPC.Y, EDX ;move the NPC's Y position by the preset amount
SUB NPC.X, EDX ;move the NPC's X position by the preset amount

:Render ;set the framerects to display the NPC from the sprite sheet
MOV NPC.DisplayL, 114
MOV NPC.DisplayU, 0
MOV NPC.DisplayR, 11C
MOV NPC.DisplayD, 8

:EndOfCode ;update the scripttimer to keep track of how long the NPC is active for, then end the code
ADD NPC.ScriptTimer, 1
MOV ESP, EBP
POP EBP
RETN