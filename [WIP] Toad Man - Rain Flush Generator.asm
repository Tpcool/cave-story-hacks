OFFSET NPC161 ;447CB0

#DEFINE

LEFT_DAMAGE_RANGE = 1A000
UP_DAMAGE_RANGE = 1A000
RIGHT_DAMAGE_RANGE = 1A000
DOWN_DAMAGE_RANGE = 1A000
DAMAGE_INFLICTED = 8

#ENDDEFINE

PUSH EBP ;setting up...
MOV EBP, ESP ;...the stack
SUB ESP, 0 ;setting up local variables
SETPOINTER

CMP NPC.ScriptTimer, 8
JE :SetAttack
CMP NPC.ScriptTimer, 8
JG :DestroyNPC
INC NPC.ScriptTimer
JMP :Render

:DestroyNPC
MOV NPC.InUse, 0
JMP :Render

:SetAttack
MOV NPC.HitRectL, LEFT_DAMAGE_RANGE
MOV NPC.HitRectU, UP_DAMAGE_RANGE
MOV NPC.HitRectR, RIGHT_DAMAGE_RANGE
MOV NPC.HitRectD, DOWN_DAMAGE_RANGE
MOV NPC.Damage, DAMAGE_INFLICTED
;PUSH 100 ;with this entity slot... 
;PUSH 0 ;with no parent or tracker... 
;MOV EAX, NPC.Direction
;PUSH EAX ;with the same direction as this NPC... 
;PUSH 0 ;with no Y velocity... 
;PUSH 0 ;with no X velocity... 
;PUSH ??? ;Y position
;PUSH ??? ;X position
;PUSH A2 ;rain flush visual
;CALL CreateNPC ;spawn the NPC 
;ADD ESP, 20 ;fix the stack
;SETPOINTER
INC NPC.ScriptTimer

:Render
MOV NPC.DisplayL, 114 ;render left display rect
MOV NPC.DisplayR, 11B ;render right display rect
MOV NPC.DisplayU, 8 ;render up display rect
MOV NPC.DisplayD, F ;render down display rect

:EndOfCode
MOV ESP, EBP
POP EBP
RETN