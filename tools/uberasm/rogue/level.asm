init:
    ; set bonus game flag
    lda #$01 : sta $7E1425
    ; TODO: other flags related to which bonus room to go to
rtl

main:
    ; increment frame counter (not reset by retry)
    lda !frame_counter : inc
    sta !frame_counter
rtl