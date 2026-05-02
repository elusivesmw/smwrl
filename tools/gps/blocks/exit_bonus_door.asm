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

    ; enter door SFX
    lda #$0F : sta $1DFC

    ; end bonus game (superfluous)
    lda #$00 : sta $14AB

    ; disable input (superfluous)
    stz $15 : stz $16 : stz $17 : stz $18

    ; disable animation (superfluous)
    lda #$0D : sta $71

    ; return to overworld
    ; NOTE: $0DD5 already contains how the level was beaten (normal or secret)
    inc $1DE9 ; set activate event
    lda #$0B : sta $0100 ; change game mode to 0B (fade to black)

Return:
rtl

print "A door that exits the bonus game."
