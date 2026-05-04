pushpc

; check for special pipe to overworld
org $00D273
    jml pipe_to_overworld
    nop #4

pullpc

pipe_to_overworld:
    ; get sublevel low byte
    ldx $95
    lda $5B
    and #$01
    beq .horiz
    ldx $97
    .horiz:
    lda $19B8,X

    ; check for level $0FF or $1FF
    cmp #$FF
    bne .original

    ; return to overworld
    ; NOTE: $0DD5 already contains how the level was beaten (normal or secret)
    inc $1DE9 ; set activate event
    lda #$0B : sta $0100 ; change game mode to 0B (fade to black)
    bra .return

    ; skip setting game mode to 0F
    .original
    inc $141A
    lda #$0F
    sta $0100

    .return:
    jml $00D27B