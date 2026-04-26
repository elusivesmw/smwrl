; disable p meter sprites
org $00D96A
    autoclean jml disable_p_speed 

freecode

disable_p_speed:
    lda !disable_p_speed
    beq .p_speed
    ; no p-speed
    jml $00D97F

    .p_speed
    ; restore and return
    lda $13E4
    clc
    jml $00D96E
