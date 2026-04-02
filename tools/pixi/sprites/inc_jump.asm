!this_sprite_num = $AF

!freeram     = $7FA200
!normal_jump = !freeram+1
!spin_jump   = !freeram+2
!max_inc = 32 ; don't allow jump increase past a certain point

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

    ; check property byte 1 for powerup type
    lda !extra_byte_1,x
    bne +
    jmp .normal_jump
+   cmp #$01
    bne +
    jmp .spin_jump
+   cmp #$02
    bne return
    jmp .placeholder

.normal_jump:
    ; add height to normal jump
    lda !normal_jump
    clc : adc #$02
    cmp #!max_inc
    bcs return
    ..save:
    sta !normal_jump
    jmp .cleanup

.spin_jump:
    ; add height to normal jump
    lda !spin_jump
    clc : adc #$02
    cmp #!max_inc
    bcs return
    ..save:
    sta !spin_jump
    jmp .cleanup

.placeholder:
    ; next powerup
    jmp .cleanup

.cleanup:
    ; remove sprite
    stz $14C8,x
    ; spawn glitter
    stz $00 : stz $01
    lda #$1B : sta $02
    lda #$05
    %SpawnSmoke()
    ; play sounds effect
    lda #$1C
    sta $1DF9

    ; remove other powerup sprites
    jsr remove_others

    ; end bonus game
    lda #$44
    sta $14AB

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
    phx
    lda !extra_byte_1,x : tax  ; get extra byte 1 in x 
    lda tile_map_1,x
    sta $0302,y
    lda tile_map_2,x
    sta $0306,y
    plx
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

remove_others:
    phx
    ldx #$0B
-
    lda $14C8,x
    beq +
    lda $7FAB9E,x
    cmp #!this_sprite_num
    bne +
    ; remove this sprite
    stz $14C8,x
    ; spawn smoke 
    stz $00 : stz $01
    lda #$1B : sta $02
    lda $E4,x : sta $04
    lda $14E0,x : sta $05
    lda $D8,x : sta $06
    lda $14D4,x : sta $07
    lda #$01
    %SpawnSmokeGeneric()
    ; play sounds effect
    lda #$25
    sta $1DFC
+
    dex : bpl -
    plx
rts


tile_map_1:
db $80,$82
tile_map_2:
db $A0,$A2