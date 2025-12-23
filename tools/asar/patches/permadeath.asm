!ram_current_file = $010A

;!sram_index_hi = $009CCB
;!sram_index_lo = $009CCE
!sram_file_start = $700000
!sram_copy_start = $7001AD

org $009785
    autoclean jml erase_current_file
    nop #2
    sec

freecode

erase_current_file:
    ; get current save file number (0, 1, 2)
    ldx !ram_current_file

    ; get sram location by file into X
    lda.l sram_hi,x         ; original code from $009B49
    xba
    lda.l sram_lo,x
    rep #$10
    tax

    ; clear all bytes in save file and backup
    ldy #$008F
    lda #$00
.loop:
    sta !sram_file_start,x
    sta !sram_copy_start,x
    inx
    dey
    bne .loop
    sep #$10

    ; jump to realod title screen playback
    jml $009C89

    ; restore og code and return?
    ; no need to restore original code since we intentionally skip it

; these exist in the vanilla rom at $009CCB, but i need to look into how retry handles sram
sram_hi:
    db $00,$00,$01
sram_lo:
    db $00,$8F,$1E
