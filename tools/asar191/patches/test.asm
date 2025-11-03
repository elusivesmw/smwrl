!freeram = $7FA200;

!offset_normal = !freeram
!offset_spin   = !freeram+1

!debug_out = !freeram+2

; index based on speed
; even - normal jump
; odd - spin jump

; params: X contains table index based on speed and jump type
; return: A with mario's jump height
org $00D663

autoclean jml get_height
nop

freecode
get_height:
lda.l jump_height,x
clc : adc !offset_normal
sta !debug_out
.return
sta $7d
jml $00D667


jump_height:
db $B0,$B6,$AE,$B4,$AB,$B2,$A9,$B0
db $A6,$AE,$A4,$AB,$A1,$A9,$9F,$A6

; TODO: handle boost jump heights also