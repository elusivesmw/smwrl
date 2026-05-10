pushpc

; get bonus level destination
org $05DBBF
    jml bonus_destination
    nop #5

pullpc

function hi(x) = (x>>8)&$FF
;print "hi: ", hex(hi($1234))
function lo(x) = x&$FF
;print "lo: ", hex(lo($1234))

; input: X should contain current screen number
macro level_destination(level_num)
    lda.b #lo(<level_num>)      ; lo byte destination
    sta $19B8,x
    lda.b #hi(<level_num>)      ; hi byte destination (format: HHHHwush)
    ora #$04                    ; set modified by lunar magic flag
    sta $19D8,x
endmacro

bonus_destination:
    cpy #$01        ; replaces table at $05DBA9
    bne .bonus
    lda #$C8        ; yoshi wings level lo byte
    sta $19B8,x
    bra .return

    .bonus:
    ; get current level
    lda $13BF
    cmp #$24
    bcc +
    clc : adc #$DC ; add to get $24 to $100
    +
    ; A now contains the current translevel number
    ; go to bonus room based on translevel number
    cmp #$01
    bne .default

    .level_01:
    %level_destination($00FF)
    bra .return

    .default:
    %level_destination($0100)

    .return:
    inc $141A   ; inc sublevel count
    jml $05DBC8 ; and jump back to vanilla rts

; reference: jump to lunar magic hijack
;05DBAC  A0 00          ldy #$00
;05DBAE  AD 95 1B       lda $1b95
;05DBB1  F0 02          beq $05dbb5
;05DBB3  A0 01          ldy #$01
;05DBB5  A6 95          ldx $95
;05DBB7  A5 5B          lda $5b
;05DBB9  29 01          and #$01
;05DBBB  F0 02          beq $05dbbf
;05DBBD  A6 97          ldx $97
;05DBBF  B9 A9 DB       lda $dba9,y
;-
;05DBC2  9D B8 19       sta $19b8,x     ; original code
;05DBC5  EE 1A 14       inc $141a       ;
;05DBC8  60             rts             ;
;+
;05DBC2  22 00 BB 03    jsl $03bb00     ; jump to lunar magic hijack (first byte globbered by my jml)
;05DBC6  EA             nop             ;
;05DBC7  EA             nop             ;
;05DBC8  60             rts             ;

; reference lunar magic hijack
;03BB00  8D B8 19       sta $19b8       ; take A as level hi byte
;03BB03  9C D8 19       stz $19d8       ; clear out lo byte
;03BB06  9C 93 1B       stz $1b93       ; clear secondary exit flag
;03BB09  EE 1A 14       inc $141a       ; inc sublevel counter
;03BB0C  64 95          stz $95         ; reset player position...
;03BB0E  64 97          stz $97         ;
;03BB10  64 94          stz $94         ;
;03BB12  64 96          stz $96         ;
;03BB14  6B             rtl
