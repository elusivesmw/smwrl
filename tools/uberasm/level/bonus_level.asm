; thanks to Thomas for example and stripe tool:
; https://www.smwcentral.net/?p=viewthread&t=93207
; https://jsfiddle.net/ankougo/vgkb8f3m/

incsrc "chars.asm"

!freeram        = $7FA300
!perk_index     = !freeram+2

!header_size = 4
; current table pointers (8 bytes)
!curr_header = $00 ; scratch (2)
!curr_text = $02 ; scratch (2)
!curr_palette = $04 ; scratch (2)
!curr_reserved = $06 ; scratch (2) reserved for future use
!curr_len = $08 ; scratch (1)
; current variable header values
!curr_var_header = $0000 ; (4)
!curr_var_value = $04 ; ...
!curr_var_palette = $05 ; ...

; ram setup
!saveram        = $7FA200
!jump_flags     = !saveram+0
!jump_normal    = !saveram+1
!jump_spin      = !saveram+2
!jump_boost     = !saveram+3
!disable_carry  = !saveram+4

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

; palette num to yxpccctt
function pal(p) = ($20|(p<<2))

macro stripe_header(label,x,y,len)
    <label>:
        dw stripe_header1(<x>,<y>)
        dw stripe_header2(<len>)
endmacro

!message_count = 0
macro stripe_message(label,x,y,message,palette)
    !message_count #= !message_count+1
    print "stripe_message ", "<label>", " written at PC: ", pc
    %stripe_header(<label>,<x>,<y>,((.palette-.text)*2)-1) ; length
    .text:
        db "<message>"
    .palette:
        db pal(<palette>)
    .reserved:
        db $00
    .end:
endmacro

%stripe_message(msg0, 7, 40, "all jumps unlocked", 3)
%stripe_message(msg1, 2, 40, "normal jump height increased", 2)
%stripe_message(msg2, 3, 40, "spin jump height increased", 2)
%stripe_message(msg3, 3, 40, "boost jump height increased", 3)
%stripe_message(msg4, 3, 40, "carrying items now enabled", 2)
%stripe_message(msg5, 14, 40, "1up", 2)
%stripe_message(msg6, 14, 40, "3up", 2)
print "message_count ", "!message_count"

macro table_entry(label)
    dw <label>, <label>_text, <label>_palette, <label>_reserved 
endmacro

; TODO: look into loading the header for variables from a table
;macro stripe_var(label,x,y,var,palette)
;    %stripe_header(label,x,y)
;endmacro

print "stripe_table written at PC: ", pc
stripe_table:
    %table_entry(msg0)
    %table_entry(msg1)
    %table_entry(msg2)
    %table_entry(msg3)
    %table_entry(msg4)
    %table_entry(msg5)
    %table_entry(msg6)

print "perk_msgs written at PC: ", pc
perk_msgs:
    dw perk_00_msgs
    dw perk_01_msgs
    dw perk_02_msgs
    dw perk_03_msgs
    dw perk_04_msgs
    dw perk_05_msgs
    dw perk_06_msgs

perk_00_msgs:
    lda #$00
    jsr write_msg
rts

perk_01_msgs:
    lda #$01
    jsr write_msg

    ; write var
    ; header1
    lda #$59
    sta $00
    lda #$29
    sta $01
    ; header2
    stz $02
    lda #$01
    sta $03
    ; var address
    lda !jump_normal
    sta $04
    ; var palette
    lda #$38
    sta $05
    ; actually write
    jsr write_var
rts

perk_02_msgs:
    lda #$02
    jsr write_msg
rts

perk_03_msgs:
    lda #$03
    jsr write_msg
rts

perk_04_msgs:
    lda #$04
    jsr write_msg
rts

perk_05_msgs:
    lda #$05
    jsr write_msg
rts

perk_06_msgs:
wdm
    lda #$06
    jsr write_msg
rts


init:
    ; clear previously selected perk index
    lda #$FF
    sta !perk_index
rtl


main:
    lda.l !perk_index

    ; ensure index within bounds
    cmp.b #!message_count
    bcs .return

    ; load messages to write
    asl ; *2 one dw pointer per entry = 2 bytes
    tax
    jsr (perk_msgs,x)

    .return:
rtl

; input: $00-$03 = header values
; $04 = tile num
; $05 = tile palette
write_var:
    lda $7F837B : tax ; get current stripe index

    ldy #$00 ; number of header bytes written
    .header:
    lda.w !curr_var_header,y ; copy header byte
    sta $7F837D,x
    inx : iny
    cpy.b #!header_size
    bmi .header

    ; reset y
    ldy #$00 ; number of tiles written
    .body
    lda.b !curr_var_value ; copy text byte
    sta $7F837D,x
    inx

    lda.b !curr_var_palette; copy palette byte
    sta $7F837D,x
    inx : iny

    ;cpy #$01 ; hardcode text length to 1
    ;bmi .body

    lda #$FF ; write $FF as the ending byte
    sta $7F837D,x
    txa : sta $7F837B ; store stripe end index
rts


; input: A = index of message write
write_msg:
    jsr load_stripe
    jsr write_stripe
rts

; input: A = index of message to load
load_stripe:
    rep #$20 ; 16 bit A
    and #$00FF ; clear high byte of 16 bit A
    asl #3 ; *8 four dw pointers per entry = 8 bytes
    tax

    lda.w stripe_table,x  ; header pointer
    sta.w !curr_header

    lda.w stripe_table+2,x ; text pointer
    sta.w !curr_text

    lda.w stripe_table+4,x ; palette pointer
    sta.w !curr_palette

    lda.w stripe_table+6,x ; reserved pointer
    sta.w !curr_reserved

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
 
    ; TODO: look into doing this part in the load_stripe routine
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

    lda (!curr_palette) ; copy palette byte
    sta $7F837D,x
    inx : iny

    cpy.b !curr_len ; text length
    bmi .body

    lda #$FF ; write $FF as the ending byte
    sta $7F837D,x
    txa : sta $7F837B ; store stripe end index
rts