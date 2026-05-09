pushpc

; get bonus level destination
org $05DBBF
    jml bonus_destination
    nop #5

pullpc

bonus_destination:
    cpy #$01        ; replaces table at $05DBA9
    bne .bonus
    lda #$C8        ; yoshi wings level lo byte
    sta $19B8,x
    bra .return

    .bonus:
    ; TODO: define conditions that change which bonus room to go to
    ; for now, always go to 100:
    lda #$00        ; lo byte destination
    sta $19b8,x
    lda #$01        ; hi byte destination (format: HHHHwush)
    sta $19d8,x

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
;03BB03  9C D8 19       stz $19d8       ; clear out low byte
;03BB06  9C 93 1B       stz $1b93       ; clear secondary exit flag
;03BB09  EE 1A 14       inc $141a       ; inc sublevel counter
;03BB0C  64 95          stz $95         ; reset player position...
;03BB0E  64 97          stz $97         ;
;03BB10  64 94          stz $94         ;
;03BB12  64 96          stz $96         ;
;03BB14  6B             rtl
