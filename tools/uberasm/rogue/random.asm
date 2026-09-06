; copy of vanilla RNG routine at $01ACF9
; modified to use different input and output addresses, and keep original seed if requested
!seed1_copy = $00
!seed2_copy = !seed1_copy+1
!output = $02 ; 2 bytes


generate_system_seeds:
    ; make a copy because we never modify the global seed
    lda !global_seed
    sta !seed1_copy
    lda !global_seed+1
    sta !seed2_copy

wdm
    ; order matters
    jsl generate_perk_seed
    jsl generate_level_seed
    jsl GetRand
    jsl GetRand
    jsl GetRand

    ; TODO: move elsewhere, testing system independence
    ; order between systems does not matter
    jsl next_perk
    jsl next_level
    jsl next_perk
    jsl next_level
    jsl next_perk
    jsl next_level

    ; TODO: hash to mix other inputs to define subsystem seed:
    ; i.e. something to identify system, such as level, or perks
rtl

generate_perk_seed:
    jsl GetRand
    ; need output for each system
    lda !output : sta !perk_seed
    lda !output+1 : sta !perk_seed+1
    ; ...
rtl

next_perk:
    lda !perk_seed : sta !seed1_copy
    lda !perk_seed+1 : sta !seed2_copy
    jsl GetRand
    ; update perk seed
    lda !seed1_copy : sta !perk_seed
    lda !seed2_copy : sta !perk_seed+1
rtl

generate_level_seed:
    jsl GetRand
    ; need output for each system
    lda !output : sta !level_seed
    lda !output+1 : sta !level_seed+1
    ; ...
rtl

next_level:
    lda !level_seed : sta !seed1_copy
    lda !level_seed+1 : sta !seed2_copy
    jsl GetRand
    ; update perk seed
    lda !seed1_copy : sta !level_seed
    lda !seed2_copy : sta !level_seed+1
rtl

; clobbers $00, $01
GetRand:                        ;-----------| Random number generation routine. Outputs in !seed1/!ouput (returns !seed2)
    PHx                         ;$01ACF9    |
    LDx.b #$01                  ;$01ACFA    |
    JSL CODE_01AD07             ;$01ACFC    | Run RNG for high byte.
    DEx                         ;$01AD00    |
    JSL CODE_01AD07             ;$01AD01    | Run RNG for low byte.
    PLx                         ;$01AD05    |
    RTL                         ;$01AD06    |

; INPUT:
;   X, index of output byte
; OUTPUT:
;   random numbers in !output and !output+1
CODE_01AD07:
    LDA !seed1_copy             ;$01AD07    |\ 
    ASL                         ;$01AD0A    ||
    ASL                         ;$01AD0B    || With a = !seed2:
    SEC                         ;$01AD0C    ||  a = 5a + 1;
    ADC !seed1_copy             ;$01AD0D    ||
    STA !seed1_copy             ;$01AD10    |/ TODO: this currently overwrites inbitial seed, don't want to do this
    ASL !seed2_copy             ;$01AD13    |\ 
    LDA #$20                    ;$01AD16    ||
    BIT !seed2_copy             ;$01AD18    || With b = !seed2:
    BCC CODE_01AD21             ;$01AD1B    ||  if (b.4 = b.7) {
    BEQ CODE_01AD26             ;$01AD1D    ||    b = 2b + 1;
    BNE CODE_01AD23             ;$01AD1F    ||  } else {
CODE_01AD21:                    ;           ||    b = 2b;
    BNE CODE_01AD26             ;$01AD21    ||  }
CODE_01AD23:                    ;           ||
    inc !seed2_copy             ;$01AD23    |/
CODE_01AD26:                    ;           |
    LDA !seed2_copy             ;$01AD26    |\ 
    EOR !seed1_copy             ;$01AD29    || Invert byte B with byte A and output the result.
    STA !output,x               ;$01AD2C    |/

    .return:
RTL                             ;$01AD2F    |


; compare to vanilla
GetRand2:
    lda !global_seed
    sta $148B
    lda !global_seed+1
    sta $148C

    jsl $01ACF9
    rtl