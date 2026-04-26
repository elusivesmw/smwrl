!freeram = $7FA300
!trigger_bonus_game = !freeram+3

; disable showing bonus stars
org $01C17A
nop #4

; disable course clear bonus counter
org $05CD79
db $80

; disable course clear timer x 50 points tilemap
org $05CC42
nop #31

; disable course clear score tallying and drumroll
org $05CDD8
db $80

; disable giving bonus stars and activating bonus game this way
org $008F5B
    bra .return
    nop #22
    .return:

; change the condition of the bonus game.
; rather than counting bonus stars,
; set bonus game flag if trigger bonus game flag is set
; which will be set by uberasm
org $05CC84
    autoclean jml course_clear
    nop

freecode

course_clear:
    lda !trigger_bonus_game
    beq .return
    lda #$FF
    sta $1425

    ; restore and return
    .return:
    lda #$01
    sta $13D5
    jml $05CC89