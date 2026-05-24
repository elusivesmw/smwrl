; https://www.smwcentral.net/?p=section&a=details&id=30840

; customization:
; spawns a mushroom if perk to unlock mushrooms has been obtained,
; otherwise spawns a coin

; import rogue defines
incsrc "../../uberasm/rogue/ram.asm"

; Block specific defines
!SoundEffect = $02          ; Set to zero to play no sound effect
!APUPort = $1DFC|!addr      ; Refer to the RAM Map or AMK for more information

!bounce_num         = $03   ; See RAM $1699 for more details. If set to 0, the block changes into the Map16 tile directly
!bounce_direction   = $00   ; Should be generally $00
!bounce_block       = $0D   ; See RAM $9C for more details. Can be set to $FF to change the tile manually
!bounce_properties  = $00   ; YXPPCCCT properties

; If !bounce_block is $FF.
!bounce_Map16 = $0132       ; Changes into the Map16 tile directly (also used if !bounce_num is 0x00)
!bounce_tile = $2A          ; The tile number (low byte) if BBU is enabled

!item_memory_dependent = 0  ; Makes the block stay collected
!invisible_block = 0        ; Not solid, doesn't detect sprites, can only be hit from below
!activate_per_spin_jump = 0 ; Activateable with a spin jump (doesn't work if invisible)
; 0 for false, 1 for true


; Placed there for technical reasons
incsrc question_block_base.asm


; Spawn specific defines
!Sprite     = $77           ; sprite number
!IsCustom   = CLC           ; CLC for normal, SEC custom sprite
!State      = $08           ; $08 for normal, $09 for carryable sprites
!1540_val   = $3E           ; If you use powerups, this should be $3E
                            ; Carryable sprites use it as the stun timer

!ExtraByte1 = $00           ; First extra byte
!ExtraByte2 = $00           ; Second extra byte
!ExtraByte3 = $00           ; Third extra byte
!ExtraByte4 = $00           ; Fourth extra byte

!XPlacementCoin = $00       ; Remember: $01-$7F moves the sprite to the right and $80-$FF to the left.
!YPlacementCoin = $F0       ; Remember: $01-$7F moves the sprite to the bottom and $80-$FF to the top.

!XPlacementSprite = $00     ; Remember: $01-$7F moves the sprite to the right and $80-$FF to the left.
!YPlacementSprite = $00     ; Remember: $01-$7F moves the sprite to the bottom and $80-$FF to the top.

; Code stuff
SpawnThing:
    lda.l !powerup_flags
    and #$04 ; check if feather is unlocked
    bne SpawnFeather

SpawnCoin:
    LDX #$03
-   LDA $17D0|!addr,x
    BEQ .found_free
    DEX
    BPL -
    DEC $1865|!addr
    BPL .dont_reset
    LDA #$03
    STA $1865|!addr
.dont_reset
    LDX $1865|!addr
.found_free
    JSL $05B34A|!bank
    INC $17D0|!addr,x
    LDA $9A
    AND #$F0
    CLC : ADC #!XPlacementCoin
    STA $17E0|!addr,x
    LDA $9B
if !XPlacementCoin < $80
    ADC #$00
else
    SBC #$00
endif
    STA $17EC|!addr,x
    LDA $98
    AND #$F0
    CLC : ADC #!YPlacementCoin
    STA $17D4|!addr,x
    LDA $99
if !YPlacementCoin < $80
    ADC #$00
else
    SBC #$00
endif
    STA $17E8|!addr,x
    LDA $1933|!addr
    STA $17E4|!addr,x
    LDA #$D0
    STA $17D8|!addr,x

    .Return:
RTS

SpawnFeather:
    LDA #!Sprite
    !IsCustom

    %spawn_sprite_block()
    TAX
    if !XPlacementSprite
        LDA #!XPlacementSprite
        STA $00
    else
        STZ $00
    endif
    if !YPlacementSprite
        LDA #!YPlacementSprite
        STA $01
    else
        STZ $01
    endif
    TXA
    %move_spawn_relative()

    LDA #!State
    STA !14C8,x
    LDA #!1540_val
    STA !1540,x
    LDA #$D0
    STA !AA,x
    LDA #$2C
    STA !154C,x

    LDA #!ExtraByte1
    STA !extra_byte_1,x
    LDA #!ExtraByte2
    STA !extra_byte_2,x
    LDA #!ExtraByte3
    STA !extra_byte_3,x
    LDA #!ExtraByte4
    STA !extra_byte_4,x

    LDA !190F,x
    BPL .Return
    LDA #$10
    STA !15AC,x

    .Return:
RTS 

print "Rogue: Feather/Coin"
