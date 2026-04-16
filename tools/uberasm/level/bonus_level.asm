; thanks to Thomas for example and stripe tool:
; https://www.smwcentral.net/?p=viewthread&t=93207
; https://jsfiddle.net/ankougo/vgkb8f3m/

incsrc "chars.asm"

; test
main:
    lda #$00
    jsr load_stripe
    jsr write_stripe
rtl

!header_size = 4
!palette = $28
!curr_header = $00 ; scratch (2)
!curr_text = $02 ; scratch (2)
!curr_len = $04 ; scratch (1)

macro stripe_message(label, message)
    print "stripe_message written at PC: ", pc
    <label>:
        db $59,$09,$00 ; positioning, etc. ; TODO: parameterize
        db ((<label>_end-<label>_text)*2)-1; index of body
    <label>_text:
        db "<message>"
    <label>_end:
endmacro

%stripe_message(elusive, "elusive .,*-!=:")
%stripe_message(test2, "another message")
%stripe_message(test3, "third message")

print "stripe_table written at PC: ", pc
stripe_table:
    dw elusive, elusive_text
    dw test2, test2_text 
    dw test3, test3_text 

; input: A = index of message to load
load_stripe:
    rep #$20 ; 16 bit A
    asl #2 ; *4 two dw pointers per entry = 4 bytes
    tax
    lda.w stripe_table,x  ; header pointer
    sta.w !curr_header
    
    lda.w stripe_table+2,x ; text pointer
    sta.w !curr_text
    sep #$20 ; 8 bit A
rts


; input: A = index of message to write
write_stripe:
    lda $7F837B : tax ; get current stripe index

    ldy #$00 ; number of header bytes written
    .header:
    lda (!curr_header),y ; copy header byte
    sta $7F837D,x
    inx : iny
    cpy.b #!header_size
    bmi .header

    ldy #$03
    lda (!curr_header),y ; go to last byte of header
    inc : lsr ; /2 = text length
    sta !curr_len

    ; reset y
    ldy #$00 ; number of tiles written
    .body
    lda (!curr_text),y ; copy text byte
    sta $7F837D,x
    inx

    lda #!palette ; copy palette byte
    sta $7F837D,x
    inx : iny

    cpy.b !curr_len ; text length
    bmi .body

    lda #$FF ; write $FF as the ending byte
    sta $7F837D,x
    txa : sta $7F837B ; store stripe end index
rts