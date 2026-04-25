init:
    ; TODO: don't set bonus flag until after the level is beaten,
    ; which means this code will go elsewhere

    ; set bonus game flag if level hasn't been beaten yet
    lda $13BF : tax ; get translevel number as index
    lda $1EA2,x : and #$80 ; check level beaten flag
    bne .return

    ; set bonus game flag
    lda #$01 : sta $1425
    ; TODO: other flags related to which bonus room to go to
    .return:
rtl

main:
    ; increment frame counter (not reset by retry)
    lda !frame_counter : inc
    sta !frame_counter
rtl