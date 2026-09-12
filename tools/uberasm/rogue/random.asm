; copy of vanilla RNG routine at $01ACF9
; modified to use different input and output addresses, and keep original seed if requested
!seed1_copy = $00
!seed2_copy = !seed1_copy+1
!output = $02 ; 2 bytes

; NOTE: make sure to call retry_api_save_game after calling this
generate_system_seeds:
    ; make a copy because we never modify the global seed
    lda !global_seed
    sta !seed1_copy
    lda !global_seed+1
    sta !seed2_copy

    ; NOTE: the order matters here.
    ; generating system seeds in a specific order rather than using a hash to mix in other inputs
    ; means that the order can never be modified (only appended to) without altering the subsequent systems.
    jsl generate_perk_seed
    jsl generate_level_seed
    ;jsl rng
    ;jsl rng
    ;jsl rng

    ; TODO: move elsewhere, testing system independence
    ; order between systems does not matter
    ;jsl next_perk
    ;jsl next_perk
    ;jsl next_perk
    jsl next_level
    jsl next_level
    jsl next_level
rtl

generate_perk_seed:
    jsl rng
    ; need output for each system
    lda !output : sta !perk_seed
    lda !output+1 : sta !perk_seed+1
    ; ...
rtl

next_perk:
    ; NOTE these are currently saved directly to the address that saves to sram,
    ; but it should use !current_perk_seed and copy to !perk_seed only at specific times,
    ; so as not to save prematurely
    lda !perk_seed : sta !seed1_copy
    lda !perk_seed+1 : sta !seed2_copy
    jsl rng 
    ; update perk seed
    lda !seed1_copy : sta !perk_seed
    lda !seed2_copy : sta !perk_seed+1
rtl

generate_level_seed:
    jsl rng 
    ; need output for each system
    lda !output : sta !level_seed
    lda !output+1 : sta !level_seed+1
    ; ...
rtl

next_level:
    ; NOTE these are currently saved directly to the address that saves to sram,
    ; but it should use !current_perk_seed and copy to !perk_seed only at specific times,
    ; so as not to save prematurely
    lda !level_seed : sta !seed1_copy
    lda !level_seed+1 : sta !seed2_copy
    jsl rng 
    ; update perk seed
    lda !seed1_copy : sta !level_seed
    lda !seed2_copy : sta !level_seed+1
rtl

; clobbers $00, $01
rng:                            ;-----------| Random number generation routine. Outputs in !seed1/!ouput (returns !seed2)
    phx                         ;$01ACF9    |
    ldx #$01                    ;$01ACFA    |
    jsl byte_rng                ;$01ACFC    | Run RNG for high byte.
    dex                         ;$01AD00    |
    jsl byte_rng                ;$01AD01    | Run RNG for low byte.
    plx                         ;$01AD05    |
rtl                             ;$01AD06    |

; INPUT:
;   X, index of output byte
; OUTPUT:
;   random numbers in !output,x
byte_rng:
    lda !seed1_copy             ;$01AD07    |\ 
    asl                         ;$01AD0A    ||
    asl                         ;$01AD0B    || With a = !seed2:
    sec                         ;$01AD0C    ||  a = 5a + 1;
    adc !seed1_copy             ;$01AD0D    ||
    sta !seed1_copy             ;$01AD10    |/ TODO: this currently overwrites inbitial seed, don't want to do this
    asl !seed2_copy             ;$01AD13    |\ 
    lda #$20                    ;$01AD16    ||
    bit !seed2_copy             ;$01AD18    || With b = !seed2:
    bcc +                       ;$01AD1B    ||  if (b.4 = b.7) {
    beq +++                     ;$01AD1D    ||    b = 2b + 1;
    bne ++                      ;$01AD1F    ||  } else {
+                               ;           ||    b = 2b;
    bne +++                     ;$01AD21    ||  }
++                              ;           ||
    inc !seed2_copy             ;$01AD23    |/
+++                             ;           |
    lda !seed2_copy             ;$01AD26    |\ 
    eor !seed1_copy             ;$01AD29    || Invert byte B with byte A and output the result.
    sta !output,x               ;$01AD2C    |/
rtl                             ;$01AD2F    |


; compare to vanilla
vanilla_get_rand:
    lda !global_seed
    sta $148B
    lda !global_seed+1
    sta $148C
    jsl $01ACF9
rtl