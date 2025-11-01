!offset_normal = 10
!offset_spin = -5
; index based on speed
; even - normal jump
; odd - spin jump
org $00D2BD
db $B0+!offset_normal,$B6+!offset_spin,$AE+!offset_normal,$B4+!offset_spin,$AB+!offset_normal,$B2+!offset_spin,$A9+!offset_normal,$B0+!offset_spin
db $A6+!offset_normal,$AE+!offset_spin,$A4+!offset_normal,$AB+!offset_spin,$A1+!offset_normal,$A9+!offset_spin,$9F+!offset_normal,$A6+!offset_spin

; TODO: boost jump height