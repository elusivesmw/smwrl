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



StripeTable2:
    db 'E',$28,'L',$28,'U',$28,'S',$28,'I',$28,'V',$28,'E',$28
EndStripeTable2:
!body_size = EndStripeTable2-StripeTable2

stripe_header:
    db $59,$09,$00 ; positioning, etc.
    db #!body_size-1; last index of body
stripe_header_end:
!header_size = stripe_header_end-stripe_header ; #$04

stripe_text:
    db "howdy";

; ty thomas
WriteStripe2:
    lda $7F837B : tax ; get current stripe index

wdm
    ldy #$00 ; counter for header size
    .header:
    lda stripe_header,y ; copy header byte
    sta $7F837D,x
    inx ; increment indices
    iny
    cpy.b #!header_size; header size
    bmi .header

    ; reset y
    ldy #$00 ; counter for how many tiles written
    .body
    lda StripeTable2,y ; copy text byte
    sta $7F837D,x
    inx ; increment indices
    iny
    cpy.b #!body_size; compare 2*$0D ; if not at the end of the table, repeat
    bmi .body

    lda #$FF ; write $FF as the ending byte
    sta $7F837D,x
    txa : sta $7F837B ; store stripe end index
rts