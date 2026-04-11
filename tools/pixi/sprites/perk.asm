; config
!this_sprite_num = $AF
!sparkle        = 1 ; should perk sparkle?
!perk_count     = 7 ; perks max index + 1
!inc_amount     = 2 ; how much to increase jump height by
!jump_max_inc   = 32 ; normal/spin increment max
!boost_max_inc  = 24 ; boost increment max


; ram setup
!saveram        = $7FA200
!jump_flags     = !saveram+0
!jump_normal    = !saveram+1
!jump_spin      = !saveram+2
!jump_boost     = !saveram+3
!disable_carry  = !saveram+4



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
    jsr CODE_01B14E
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
    jsr enable_carry
    jmp .cleanup
+
    cmp #$05 : bne +
    jsr one_up
    jmp .cleanup
+
    cmp #$06 : bne +
    jsr three_up
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
    sta $0304,y
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
    sta $0305,y
    ; tile numbers
    phx
    jsr perk_index : tax  ; get perk index in x 
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

y_offset:
    db 0,0,0,-1,-2,-3,-2,-1
tile_map_1:
    db $80,$82,$84,$86,$88,$8A,$8C
tile_map_2:
    db $A0,$A2,$A4,$A6,$A8,$AA,$AC




CODE_01B14E:					;-----------| Sprite glitter subroutine.
	LDA $13						;$01876A	|\ 
	AND.b #$1F					;$01876C	|| Make the sphere glitter.
	ORA $9D						;$01876E	||
CODE_01B152:					;```````````|
	ORA.w $186C,X				;$01B152	|\ 
	ORA $9D						;$01B155	|| Return if game frozen or sprite offscreen.
	BNE Return01B191			;$01B157	|/
	JSL $01ACF9					;$01B159	|\ get rand
	AND.b #$0F					;$01B15D	||
	CLC							;$01B15F	||
	LDY.b #$00					;$01B160	||
	ADC.b #$FC					;$01B162	||
	BPL CODE_01B167				;$01B164	||
	DEY							;$01B166	||
CODE_01B167:					;			||
	CLC							;$01B167	|| Give a random X offset in the range #$FFFC-#$000B.
	ADC $E4,X					;$01B168	|| Return if that would stick the sparkle offscreen.
	STA $02						;$01B16A	||
	TYA							;$01B16C	||
	ADC.w $14E0,X				;$01B16D	||
	PHA							;$01B170	||
	LDA $02						;$01B171	||
	CMP $1A						;$01B173	||
	PLA							;$01B175	||
	SBC $1B						;$01B176	||
	BNE Return01B191			;$01B178	|/
	LDA.w $148E					;$01B17A	|\ 
	AND.b #$0F					;$01B17D	||
	CLC							;$01B17F	||
	ADC.b #$FE					;$01B180	||
	ADC $D8,X					;$01B182	|| Give a random Y offset in the range #$00FE-#$010D.
	STA $00						;$01B184	||
	LDA.w $14D4,X				;$01B186	||
	ADC.b #$00					;$01B189	||
	STA $01						;$01B18B	|/
	JSR CODE_0285BA				;$01B18D	| Spawn the sparkle.
Return01B191:					;			|
	RTS							;$01B191	|


CODE_0285BA:					;			|
	LDY.b #$0B					;$0285BA	|\ 
CODE_0285BC:					;			||
	LDA.w $17F0,Y				;$0285BC	||
	BEQ CODE_0285C5				;$0285BF	|| Find an empty minor extended sprite slot. Return if none found.
	DEY							;$0285C1	||
	BPL CODE_0285BC				;$0285C2	||
	RTS							;$0285C4	|/

CODE_0285C5:
	LDA.b #$05					;$0285C5	|\\ Minor extended sprite to spawn (sparkle).
	STA.w $17F0,Y				;$0285C7	|/
	LDA.b #$00					;$0285CA	|\ Clear Y speed?
	STA.w $1820,Y				;$0285CC	|/
	LDA $00						;$0285CF	|\ Set Y position.
	STA.w $17FC,Y				;$0285D1	|/
	LDA $02						;$0285D4	|\ Set X position.
	STA.w $1808,Y				;$0285D6	|/
	LDA.b #$17					;$0285D9	|\\ Number of frames to keep the sprite active for.
	STA.w $1850,Y				;$0285DB	|/
	RTS							;$0285DE	|




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

one_up:
    ; add one live
    inc $0DBE
rts

three_up:
    ; add three live
    wdm
    lda $0DBE
    clc : adc #3
    sta $0DBE
rts

enable_carry:
    ; clear disable carry flag
    lda #$00
    sta !disable_carry
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
    lda #$08 : sta $01
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
    lda #$08 : sta $01
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
