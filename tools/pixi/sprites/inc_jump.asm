!freeram = $7FA200
!normal_jump = !freeram+1
!max_inc = 32 ; don't allow jump increase past a certain point

!tile_num_1 = $80
!tile_num_2 = $A0

!sound_effect = $1C
!sound_bank = $1DF9

print "INIT ",pc
rtl

print "MAIN ",pc
phb : phk : plb
    jsr main 
plb : rtl

main:
    jsr graphics

    ; check if offscreen
    lda #$00
    %SubOffScreen()

    ; check if sprite is living
    lda $14C8,x
    cmp #$08
    bne return
    
    ; check if not frozen
    lda $9D
    bne return

    ; check for contact
    jsl $01A7DC
    bcc return

    ; add height to normal jump
    lda !normal_jump
    clc : adc #$02
    cmp #!max_inc
    bcs return
    .save:
    sta !normal_jump

    ; remove sprite
    stz $14C8,x

    ; TODO: remove other powerup sprites

    ; spawn smoke
    stz $00 : stz $01
    lda #$1B : sta $02
    lda #$05
    %SpawnSmoke()

    ; play sounds effect
    lda #!sound_effect
    sta !sound_bank

return:
rts


graphics:
    %GetDrawInfo()

    ; X position
    lda $00
    sta $0300,y
    sta $0304,y
    ; Y position
    lda $01
    sta $0301,y
    clc : adc #$10
    sta $0305,y
    ; tile numbers
    lda #!tile_num_1
    sta $0302,y
    lda #!tile_num_2
    sta $0306,y
    ; properties
    lda $15F6,x
    ora $64
    sta $0303,y
    sta $0307,y
    
    ; finish oam write
    lda #$01 ; number tiles to draw - 1
    ldy #$02 ; tile size
    jsl $01B7B3
rts