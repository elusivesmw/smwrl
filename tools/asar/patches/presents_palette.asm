; credit: Roy
; https://www.smwcentral.net/?p=section&a=details&id=14754

if read1($00FFD5) == $23
    sa1rom
    !addr = $6000
    !bank = $000000
else
    lorom
    !addr = $0000
    !bank = $800000
endif

;===================================================================================================
; DEFINES
;===================================================================================================

!BackdropColour = $0000         ; Nintendo Presents BG colour.
!Palette = $08                  ; Affected palette.

org $0093D7|!bank
autoclean JSL Main              ; Overwrite some colours.
NOP                             ; \ Useless bytes.
NOP                             ;  | We don't need them.
NOP                             ;  |
NOP                             ;  |
NOP                             ; /

freecode

Main:
LDA $0100|!addr                 ; \ Check if game mode is 'Nintendo Presents'
BEQ OnlyNinPre                  ; / If so, branch.

PHK                             ; Preserve program bank.
PER Return-1                    ; Push next return address.
PHB                             ; Preserve data bank.
LDA #$00                        ; \ A = #$00
PHA                             ;  | Transfer A...
PLB                             ; / ... to data bank.
PEA $84CD                       ; Push return address.
JML $00ABED|!bank               ; Jump, long.

Return:
STZ $0701|!addr                 ; \ BG = black.
STZ $0702|!addr                 ; /
RTL                             ; Return

OnlyNinPre:
REP #$20                        ; Accumulator = 16-bit.
LDX #$00                        ; X = #$00

Loop:
LDA.l PaletteTable,x            ; \ Load RGB value.
STA !Palette*$20+$0703|!addr,x  ; / Store in slots of palette.

INX
INX
CPX #$20
BCC Loop
LDA #!BackdropColour            ; \ Background colour...
STA $0701|!addr                 ; / ... on 'Nintendo Presents'.
SEP #$20
RTL                             ; Return

PaletteTable:
dw $0000      ;  Colour 0 - black
dw $7FFF      ;  Colour 1 - white
dw $0063      ;  Colour 2 - dark
dw $00C6      ;  Colour 3 - v
dw $0108      ;  Colour 4 - v
dw $014A      ;  Colour 5 - v
dw $01CE      ;  Colour 6 - v
dw $0210      ;  Colour 7 - v
dw $0000      ;  Colour 8 - null
dw $0272      ;  Colour 9 - v
dw $02B5      ;  Colour A - v
dw $0318      ;  Colour B - v
dw $037B      ;  Colour C - v
dw $03BD      ;  Colour D - v
dw $03FF      ;  Colour E - yellow
dw $001F      ;  Colour F - red
