!freeram = $7FA200;

; vars
!ability_carry = !freeram+3

; disable carrying sprites
org $01AA5E
    autoclean jml disable_carry 
    nop #2

; disable picking up throwblocks
org $00F26F
    autoclean jml disable_throwblock 
    nop #2

freecode

disable_carry:
    lda $1470
    ora $187A
    ora !ability_carry
    ; return
    jml $01AA64

disable_throwblock:
    lda $148F
    ora $187A
    ora !ability_carry
    ; return
    jml $00F275