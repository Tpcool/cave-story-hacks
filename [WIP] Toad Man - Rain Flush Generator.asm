OFFSET NPC160 ;Pooh Black, 447700

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
JMP :EndOfCode;:Render

:DestroyNPC
MOV NPC.InUse, 0
JMP :EndOfCode;:Render

:SetAttack
MOV NPC.HitRectL, LEFT_DAMAGE_RANGE
MOV NPC.HitRectU, UP_DAMAGE_RANGE
MOV NPC.HitRectR, RIGHT_DAMAGE_RANGE
MOV NPC.HitRectD, DOWN_DAMAGE_RANGE
MOV NPC.Damage, DAMAGE_INFLICTED

;(8,12)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, 19600
PUSH EDX ;Y position
MOV EDX, 10E00
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack
SETPOINTER

;(10,12)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, 19600
PUSH EDX ;Y position
MOV EDX, 15200
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack
SETPOINTER

;(12,12)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, 19600
PUSH EDX ;Y position
MOV EDX, 19600
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack
SETPOINTER

;(3,0)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, 1200
PUSH EDX ;Y position
MOV EDX, 2000
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack
SETPOINTER

;(5,0)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, 1200
PUSH EDX ;Y position
MOV EDX, BA00
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack
SETPOINTER

;(7,0)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, 1200
PUSH EDX ;Y position
MOV EDX, FA00
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack
SETPOINTER

;(9,0)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, 1E000
PUSH EDX ;Y position
MOV EDX, 13E00
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack
SETPOINTER

;(12,0)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, 1200
PUSH EDX ;Y position
MOV EDX, 18200
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack
SETPOINTER

;(14,0)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, 1E000
PUSH EDX ;Y position
MOV EDX, 1C600
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack
SETPOINTER

;(16,0)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, 1200
PUSH EDX ;Y position
MOV EDX, 20800
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack
SETPOINTER

;(16,2)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, 4200
PUSH EDX ;Y position
MOV EDX, 21A00
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack
SETPOINTER

;(16,4)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, 8600
PUSH EDX ;Y position
MOV EDX, 25A00
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack
SETPOINTER

;(16,6)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, CA00
PUSH EDX ;Y position
MOV EDX, 21A00
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack
SETPOINTER

;(16,8)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, 10E00
PUSH EDX ;Y position
MOV EDX, 25A00
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack
SETPOINTER

;(16,10)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, 15000
PUSH EDX ;Y position
MOV EDX, 21A00
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack
SETPOINTER

;(16,12)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, 19400
PUSH EDX ;Y position
MOV EDX, 25A00
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack
SETPOINTER

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(4,4)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, 8800
PUSH EDX ;Y position
MOV EDX, 8400
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack

;(6,3)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, 7600
PUSH EDX ;Y position
MOV EDX, DA00
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack

;(7,4)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, 9800
PUSH EDX ;Y position
MOV EDX, FA00
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack

;(7,5)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, AA00
PUSH EDX ;Y position
MOV EDX, FA00
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack

;(12,4)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, 8600
PUSH EDX ;Y position
MOV EDX, 19400
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack

;(3,6)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, DA00
PUSH EDX ;Y position
MOV EDX, 7400
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack

;(12,6)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, DA00
PUSH EDX ;Y position
MOV EDX, 18200
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack
;(8,7)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, E800
PUSH EDX ;Y position
MOV EDX, 11E00
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack

;(3,8)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, 11E00
PUSH EDX ;Y position
MOV EDX, 7400
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack

;(12,8)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, 10E00
PUSH EDX ;Y position
MOV EDX, 19400
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack

;(13,9)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, 12E00
PUSH EDX ;Y position
MOV EDX, 1B600
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack

;(4,10)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, 14000
PUSH EDX ;Y position
MOV EDX, 2000
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack

;(5,11)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, 17200
PUSH EDX ;Y position
MOV EDX, A800
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack

;(6,11)
XOR EDX, EDX
PUSH EDX ;with this entity slot... 
PUSH EDX ;with no parent or tracker... 
PUSH EDX ;with no particular direction...
PUSH EDX ;with no Y velocity... 
PUSH EDX ;with no X velocity... 
MOV EDX, 17200
PUSH EDX ;Y position
MOV EDX, DA00
PUSH EDX ;X position
PUSH A1 ;rain flush visual
CALL CreateNPC ;spawn the NPC 
ADD ESP, 20 ;fix the stack
SETPOINTER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

INC NPC.ScriptTimer

:EndOfCode
MOV ESP, EBP
POP EBP
RETN
