
; bonus game: disable input immediately when the music starts
org $00A1EF
db $44

; TODO: fix small mario yoshi peace sign pose

; disable LR scrolling
;org $00CDFC
;db $80

; mario sprite framerule (1/2 frames -> 1/1 frames)
org $01A7EF
db $00

; fireball sprite framerule (1/4 frames -> 1/1 frames), improve efficiency
org $02A0AC
bra 5
nop #5

; yellow koopa jump framerule, improve efficiency
org $018898
bra 5
nop #5

; disable yoshi rescue message
org $01EC36
db $80

; disable getting lives
; org $01AB63
; db $07

; remove lives from ow
; org $05DBF2
; db $6B

; disable moon lives
; org $00F316
; db $00

; on/off block bounce sprite YXPPCCCT
; org $02878E
; db $06 ; page 0

; on/off block bounce sprite tile number
; org $0291F6
; db $C2 ; tile C2

; fix sprite up-throw not activating block
org $0195A5
db $00

; sprite to spawn for one up blocks
; org $03C2EC
; db $21 ; moving coin

; yoshi eaten berry tile using tongue
; org $02BB03
; db $01 ; air tile without setting memory bit (pointer table at $00BFC9)

; yoshi eaten berry tile without tongue
; org $02D208
; db $01 ; air tile without setting memory bit (pointer table at $00BFC9)


; ghost house entrance sprite position
;org $02F786
;db $50			; default $60, shift up one tile


;----------------;
;   reference    ;
;----------------;

; presents logo palette A (handled by presents palette)
;org $0093B0
;db $32 ; yxppccct = 0011 0010 = palette 1 + 8 = 9

; remove reserve item box (handled by retry sprite statusbar)
; org $01C545
; db $EA, $EA, $EA

; disable reznor bridge breaking
; org $03989F
; db $EA, $EA, $EA, $EA

; vertical dolphin tail screen wrap fix
; org $07F69C
; db $25

; fix powerups being covered by the background in levels with transparent layer 3
; org $01C6C2
; db $30

; yoshi stomp hitbox glitch
; org $0286D7
; db $D5

; level 018 glitched yoshi fix
; org $048DDA
; db $80
