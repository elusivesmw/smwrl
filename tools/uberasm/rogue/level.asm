init:
    ; set bonus game flag if level hasn't been beaten yet
    lda $13BF : tax ; get translevel number as index
    lda $1EA2,x : and #$80 ; check level beaten flag

    ; get level beaten flag into lsb and flip
    lsr #7 : eor #$01
    ; set/clear bonus game flag
    ; NOTE: can't set the actual flag at $1425 directly since it interupts sublevel loading
    ; instead, look for this flag at course clear
    sta !trigger_bonus_game

    ; TODO: other flags related to which bonus room to go to
    ; probably in another file
rtl

main:
    ; increment frame counter (not reset by retry)
    lda !frame_counter : inc
    sta !frame_counter
rtl