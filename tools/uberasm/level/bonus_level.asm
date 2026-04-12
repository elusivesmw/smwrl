incsrc "chars.asm"

; test
main:
    jsr WriteStripe2
rtl


StripeTable:
db $59,$09,$00,$0D ; 0D = 2x7-1
db 'E',$28,'L',$28,'U',$28,'S',$28,'I',$28,'V',$28,'E',$28

; ty thomas
WriteStripe:
    LDY #$00		; counter for how many tiles written
    lda $7F837B : tax ; get current stripe index
    .loop
    LDA StripeTable,y	; copy one byte
    STA $7F837D,x
    INX			; increment indices
    INY
    CPY #$1A ; compare 2*$0D ; if not at the end of the table, repeat
    BMI .loop

    LDA #$FF		; write $FF as the ending byte
    STA $7F837D,x
    txa : sta $7F837B		; store stripe end index
    RTS



stripe_text:
    db "howdy";

stripe_body:
    db 'H',$28,'O',$28,'W',$28,'D',$28,'Y',$28
stripe_body_end:
!body_size = stripe_body_end-stripe_body

stripe_header:
    db $59,$09,$00 ; positioning, etc.
    db #!body_size-1; last index of body
stripe_header_end:
!header_size = stripe_header_end-stripe_header ; #$04

; ty thomas
WriteStripe2:
    lda $7F837B : tax ; get current stripe index

wdm
    ldy #$00 ; number of header bytes written
    .header:
    lda stripe_header,y ; copy header byte
    sta $7F837D,x
    inx : iny
    cpy.b #!header_size
    bmi .header

    ; reset y
    ldy #$00 ; number of tiles/palettes (bytes) written
    .body

    ..text
    lda stripe_body,y ; copy text byte
    sta $7F837D,x
    inx : iny
    cpy.b #!body_size;
    bmi .body_text

    lda #$FF ; write $FF as the ending byte
    sta $7F837D,x
    txa : sta $7F837B ; store stripe end index
rts