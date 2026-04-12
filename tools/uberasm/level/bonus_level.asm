; thanks to Thomas for example and stripe tool:
; https://www.smwcentral.net/?p=viewthread&t=93207
; https://jsfiddle.net/ankougo/vgkb8f3m/

incsrc "chars.asm"

; test
main:
    jsr write_stripe
rtl

stripe_text:
    db "elusive .,*-!=:"
stripe_text_end:
!text_size = stripe_text_end-stripe_text
!body_size = !text_size*2 ; *2 for the palette bytes
!palette = $28

stripe_header:
    db $59,$09,$00 ; positioning, etc.
    db #!body_size-1; last index of body
stripe_header_end:
!header_size = stripe_header_end-stripe_header ; #$04

write_stripe:
    lda $7F837B : tax ; get current stripe index

    ldy #$00 ; number of header bytes written
    .header:
    lda stripe_header,y ; copy header byte
    sta $7F837D,x
    inx : iny
    cpy.b #!header_size
    bmi .header

    ; reset y
    ldy #$00 ; number of tiles written
    .body
    lda.b stripe_text,y ; copy text byte
    sta $7F837D,x
    inx

    lda.b #!palette ; copy palette byte
    sta $7F837D,x
    inx : iny

    cpy.b #!text_size;
    bmi .body

    lda #$FF ; write $FF as the ending byte
    sta $7F837D,x
    txa : sta $7F837B ; store stripe end index
rts