; import rogue defines
incsrc "../../uberasm/rogue/ram.asm"

; config
!this_sprite_num = $AF
!sparkle        = 1 ; should perk sparkle?
!perk_count     = 9 ; perks max index + 1
!inc_amount     = 2 ; how much to increase jump height by
!jump_max_inc   = 32 ; normal/spin increment max
!boost_max_inc  = 24 ; boost increment max

; convert palette number into CCC format
function pal(val) = (val-8)*2

print "INIT ",pc
    jsr init
rtl

print "MAIN ",pc
phb : phk : plb
    jsr main 
plb : rtl

init:
    ; check if perk is random
    lda !extra_byte_1,x
    cmp #$ff : bne .return
    ; init random perk type
    jsr init_random_perk
    sta $160E,x

    jsr graphics
    .return:
rts

main:
    jsr graphics
if !sparkle == 1
    jsr sparkle
endif

    ; check if offscreen
    lda #$00
    %SubOffScreen()

    ; check if sprite is living
    lda $14C8,x
    cmp #$08
    bne .return
    
    ; check if not frozen
    lda $9D
    bne .return

    ; check for contact
    jsl $01A7DC
    bcc .return

    ; get perk type
    jsr perk_index
    ; and store
    sta.l !perk_index

    ; TODO: change this to a pointer table
    cmp #$00 : bne +
    jsr jump_ability
    jmp .cleanup
+
    cmp #$01 : bne +
    jsr normal_jump
    jmp .cleanup
+
    cmp #$02 : bne +
    jsr spin_jump
    jmp .cleanup
+
    cmp #$03 : bne +
    jsr boost_jump
    jmp .cleanup
+
    cmp #$04 : bne +
    jsr enable_p_speed
    jmp .cleanup
+
    cmp #$05 : bne +
    jsr enable_carry
    jmp .cleanup
+
    cmp #$06 : bne +
    jsr one_up
    jmp .cleanup
+
    cmp #$07 : bne +
    jsr three_up
    jmp .cleanup
+
    cmp #$08 : bne +
    jsr hiking_boots
    jmp .cleanup
+
    cmp #$fe : bne .return
    jsr placeholder
    ;jmp .cleanup

    .cleanup:
    jsr cleanup

    .return:
rts

graphics:
    %GetDrawInfo()

    ; X position
    lda $00
    sta $0300,y
    ; Y offset for animation
    inc $1570,x
    lda $1570,x
    lsr #4 ; speed
    and #$07 ; max index
    phx : tax
    lda y_offset,x
    plx
    sta $02
    ; Y position
    lda $01
    clc : adc $02 ; add Y offset for animation
    sta $0301,y
    clc : adc #$10
    ; tile numbers
    phx
    jsr perk_index : tax  ; get perk index in x 
    lda tile_map,x
    sta $0302,y
    lda palette,x
    sta $0F ; store palette in scratch
    plx
    ; properties
    lda $15F6,x
    ora $64
    and #%11110001 ; clear palette
    ora $0F ; set palette from scratch
    sta $0303,y
    
    ; finish oam write
    lda #$00 ; number tiles to draw - 1
    ldy #$02 ; tile size
    jsl $01B7B3
rts

palette:
    db pal($0C),pal($0C),pal($0C),pal($0C),pal($0B),pal($08),pal($0D),pal($0A)
    db pal($08)
y_offset:
    db 0,0,0,-1,-2,-3,-2,-1
tile_map:
    db $80,$82,$84,$86,$88,$8A,$8C,$8E
    db $A0

sparkle:
    ; how often to spawn a sparkle
    lda $13
    and #$1F
    ora $9D
    ora $186C,X ; vertical offscreen flag
    ora $9D
    bne .return

    ; set sparkle position
    jsl $01ACF9 ; get random
    and #$0F
    clc
    ldy #$00
    adc #$FC
    bpl +
    dey
+
    ; random X offset in the range #$FFFC-#$000B, unless offscreen
    clc
    adc $E4,X
    sta $02
    tya
    adc $14E0,X
    pha
    lda $02
    cmp $1A
    pla
    sbc $1B
    bne .return

    ;random Y offset in the range #$00FE-#$010D
    lda $148E
    and #$0F
    clc
    adc #$FE
    adc $D8,X
    sta $00
    lda $14D4,X
    adc #$00
    sta $01

    ; find slot and spawn the sparkle
    jsr find_slot
    .return:
rts

; find an empty minor extended sprite slot
find_slot:
    LDY #$0B
-
    lda $17F0,Y
    beq draw_sparkle
    dey
    bpl -
rts

draw_sparkle:
    lda #$05 ; minor extended sprite to spawn (sparkle)
    sta $17F0,Y
    lda #$00
    sta $1820,Y
    lda $00
    sta $17FC,Y ; set Y position
    lda $02
    sta $1808,Y ; set X postion
    lda #$17
    sta $1850,Y ; set lifespan in frames
rts

; determine random perk
; return perk index in A
init_random_perk:
    ; TODO: figure out how to use RNG
    ;jsl $01ACF9
    ;lda $148C

    ; janky frame counter/sprite slot based RNG for now...
    lda $7fA300 ; retry resets frame counter $13 so we can't use that
    stx $00
    eor $00 ; eor with X so all aren't the same
-
    sec : sbc #!perk_count
    cmp #!perk_count : bcs - 
    .return:
rts

; return effective perk index in A
perk_index:
    ; check extra byte 1 for perk type 
    lda !extra_byte_1,x
    ; if random, load effective perk
    cmp #$ff : bne .return
    lda $160E,x
    .return
rts

; ---- perks ----
jump_ability:
    ; set both jump flags
    lda #03
    sta !jump_flags
rts

normal_jump:
    ; add height to normal jump
    lda !jump_normal
    clc : adc #!inc_amount
    cmp #!jump_max_inc
    bcs .return
    .save:
    sta !jump_normal
    .return:
rts

spin_jump:
    ; add height to normal jump
    lda !jump_spin
    clc : adc #!inc_amount
    cmp #!jump_max_inc
    bcs .return
    .save:
    sta !jump_spin
    .return:
rts

boost_jump:
    ; add height to boost jump
    lda !jump_boost
    clc : adc #!inc_amount
    cmp #!boost_max_inc
    bcs .return
    .save:
    sta !jump_boost
    .return:
rts

enable_p_speed:
    ; clear disable p speed flag
    lda #$00
    sta !disable_p_speed
rts

enable_carry:
    ; clear disable carry flag
    lda #$00
    sta !disable_carry
rts

one_up:
    ; add one live
    inc $0DBE
rts

three_up:
    ; add three live
    lda $0DBE
    clc : adc #3
    sta $0DBE
rts

hiking_boots:
    ; set muncher invinciblity flag
    lda #$01
    sta !muncher_inv
rts

placeholder:
    ; next powerup
    .return:
rts
; ---- end perks ----

cleanup:
    ; remove sprite
    stz $14C8,x
    ; spawn glitter
    stz $00 
    stz $01
    lda #$1B : sta $02
    lda #$05
    %SpawnSmoke()
    ; play sound effect
    lda #$1C
    sta $1DF9

    ; remove other perk sprites
    jsr remove_others

    ; end bonus game
    lda #$44
    sta $14AB

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
    stz $00
    stz $01
    lda #$1B : sta $02
    lda $E4,x : sta $04
    lda $14E0,x : sta $05
    lda $D8,x : sta $06
    lda $14D4,x : sta $07
    lda #$01
    %SpawnSmokeGeneric()
    ; play sound effect
    lda #$25
    sta $1DFC
+
    dex : bpl -
    plx
rts
