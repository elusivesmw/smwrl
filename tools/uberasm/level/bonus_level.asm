; thanks to Thomas for example and stripe tool:
; https://www.smwcentral.net/?p=viewthread&t=93207
; https://jsfiddle.net/ankougo/vgkb8f3m/

incsrc "chars.asm"

!freeram        = $7FA300
!perk_index     = !freeram+2

!header_size = 4
!palette = $28
!curr_header = $00 ; scratch (2)
!curr_text = $02 ; scratch (2)
!curr_len = $04 ; scratch (1)

; EHHHYXyy yyyxxxxx DRLLLLLL llllllll
; E: End of data. Setting this ignores everything after and ends the upload routine.
; HHH: VRAM destination - hardcoded to layer 3
; Yyyyyy: Y position
; Xxxxxx: X position
; D: Stripe direction (0 = horizontal, 1 = vertical)
; R: RLE flag. If clear, the data consists of <length> individual tiles; if set, it consists of a single tile repeated <length> times.
; LLLLLLllllllll: Length of the data to write.
;
; ignore E, HHH, D, R for now
; EHHHYXyy yyyxxxxx DRLLLLLL llllllll
function xb(x) = ((x&$FF)<<8)|($FF&(x>>8)) ; swap high and low bytes
function yoff(y) = ((y&%00011111)<<5)|((y&%00100000)<<6) ; fixes the gap between Y bytes in "YXyyyyy"
function xoff(x) = (x&%00011111)|((x&%00100000)<<5) ; fixes the gap between X bytes in "Xyyyyyxxxxx"
function stripe_header1(x,y) = xb($5000|yoff(y)|xoff(x)) ; layer (3), location
function stripe_header2(l) = xb(l) ; just length for now (implied horizontal and non-rle behavior)

!message_count = 0
macro stripe_message(label,x,y,message)
    !message_count #= !message_count+1
    print "stripe_message ", "<label>", " written at PC: ", pc
    <label>:
        dw stripe_header1(<x>,<y>) ; position
        dw stripe_header2(((<label>_end-<label>_text)*2)-1) ; length
    <label>_text:
        db "<message>"
    <label>_end:
endmacro

%stripe_message(jump_ability, 9, 40,"all jumps unlocked")
%stripe_message(normal_jump, 9, 41, "normal jump height increased")
%stripe_message(spin_jump, 9, 40, "spin jump height increased")
%stripe_message(boost_jump, 9, 40, "boost jump height increased")
%stripe_message(enable_carry, 9, 40, "carrying items now enabled")
print "message_count ", "!message_count"

print "stripe_table written at PC: ", pc
stripe_table:
    dw jump_ability, jump_ability_text
    dw normal_jump, normal_jump_text
    dw spin_jump, spin_jump_text
    dw boost_jump, boost_jump_text
    dw enable_carry, enable_carry_text

print "perk_msgs written at PC: ", pc
perk_msgs:
    dw perk_00_msgs
    dw perk_01_msgs
    dw perk_02_msgs
    dw perk_03_msgs
    dw perk_04_msgs
    dw perk_05_msgs

perk_00_msgs:
    lda #$00
    jsr load_stripe
    jsr write_stripe
    ; example of writing a second message
    lda #$01
    jsr load_stripe
    jsr write_stripe
rts
perk_01_msgs:
    lda #$01
    jsr load_stripe
    jsr write_stripe
rts
perk_02_msgs:
    lda #$02
    jsr load_stripe
    jsr write_stripe
rts
perk_03_msgs:
    lda #$03
    jsr load_stripe
    jsr write_stripe
rts
perk_04_msgs:
    lda #$04
    jsr load_stripe
    jsr write_stripe
rts
perk_05_msgs:
    lda #$05
    jsr load_stripe
    jsr write_stripe
rts


main:
    lda.l !perk_index

    ; ensure index within bounds
    cmp.b #!message_count
    bcs .return

    ; load messages to write
    wdm
    asl
    tax
    jsr (perk_msgs,x)

    .return:
rtl


; input: A = index of message to load
load_stripe:
    rep #$20 ; 16 bit A
    and #$00FF ; clear high byte of 16 bit A
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