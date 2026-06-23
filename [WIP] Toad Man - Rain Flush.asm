OFFSET NPC162 ;447E90

PUSH EBP ;setting up...
MOV EBP, ESP ;...the stack
SUB ESP, 0 ;setting up local variables
SETPOINTER

#DEFINE

VISUAL_SPEED = 500

#ENDDEFINE

MOV EDX, VISUAL_SPEED
MOV NPC.MoveY, EDX
MOV NPC.MoveX, EDX
MOV EDX, NPC.MoveY
ADD NPC.Y, EDX
MOV EDX, NPC.MoveX
SUB NPC.X, EDX

:Render
MOV NPC.DisplayL, 114 ;render left display rect
MOV NPC.DisplayU, 0 ;render up display rect
MOV NPC.DisplayR, 11B ;render right display rect
MOV NPC.DisplayD, 7 ;render down display rect

:EndOfCode
MOV ESP, EBP
POP EBP
RETN