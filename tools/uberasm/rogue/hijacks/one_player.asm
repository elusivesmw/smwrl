; skip player select
org $009DFA
    jmp $9E0A
    nop

; set one player
org $009E0A
    ldx #$00
    nop

; don't change tilemap to 1/2 player select menu
org $009D24
    ldy #$00
