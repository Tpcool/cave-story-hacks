OFFSET NPC161 ;447CB0

PUSH EBP ;setting up...
MOV EBP, ESP ;...the stack
SUB ESP, 0 ;setting up local variables
SETPOINTER

#DEFINE

VISUAL_SPEED = A00
FRAMES_ACTIVE = 78

#ENDDEFINE

CMP NPC.ScriptTimer, FRAMES_ACTIVE
JGE :DestroyNPC
JMP :CheckXPosition

:DestroyNPC
MOV NPC.InUse, 0

:CheckXPosition
CMP NPC.X, 0
JLE :WrapXPosition
JMP :CheckYPosition

:WrapXPosition
MOV NPC.X, 2A000

:CheckYPosition
CMP NPC.Y, 20000
JGE :WrapYPosition
JMP :SetMovement

:WrapYPosition
MOV NPC.Y, 0

:SetMovement
;MOV EDX, NPC.X
;MOV EDX, NPC.Y
;MOV EDX, PlayerXPos
;MOV EDX, PlayerYPos

MOV EDX, VISUAL_SPEED
MOV NPC.MoveY, EDX
MOV NPC.MoveX, EDX
MOV EDX, NPC.MoveY
ADD NPC.Y, EDX
MOV EDX, NPC.MoveX
SUB NPC.X, EDX

:Render
MOV NPC.DisplayL, 114
MOV NPC.DisplayU, 0
MOV NPC.DisplayR, 11C
MOV NPC.DisplayD, 8

:EndOfCode
ADD NPC.ScriptTimer, 1
MOV ESP, EBP
POP EBP
RETN