db $42

JMP Return : JMP Return : JMP Return
JMP Return : JMP Return
JMP Return : JMP Return
JMP Return : JMP MarioInside : JMP Return

MarioInside:
    lda $16
    and #$08 ; watch for up press
    beq Return
    lda $8F ; backup of $72 (player in the air flag)
    bne Return

    ; is mario centered enough?
    lda $94
    clc : adc #$04
    and #$0F
    cmp #$08
    bcs Return

    ; end bonus game
    lda #$44
    sta $14AB
    ; TODO: maybe disable input immediately
    ; and maybe don't play the outro sound effect

    lda #$0F ; enter door SFX
    sta $1DFC
Return:
rtl

print "A door that exits the bonus game."
