; copy of vanilla RNG routine at $01ACF9
; modified to use different input and output addresses, and keep original seed if requested
!seed1 = !initial_seed
!seed2 = !seed1+1
!seed1_copy = $00
!seed2_copy = !seed1_copy+1
!output = !current_seed
!mutate = $02 ; 00 - immutable, 01 - mutable


GetSubSystemSeed:
    lda #$00 : sta !mutate ; don't mutate the global seed
    ; TODO: hash to mix other inputs to define subsystem seed:
    ; i.e. something to identify system, such as level, or perks
rtl

GetRandomLevel:
    lda #$01 : sta !mutate ; mutate non-global seeds
    ; need output for each system
    ; ...
rtl

GetRandomPerk:
    lda #$01 : sta !mutate ; mutate non-global seeds
    ; need output for each system
    ; ...
rtl


; clobbers $00, $01, and optionally !seed1, !seed2
; TODO: dont' clobber !seed1,!seed2
GetRand:                        ;-----------| Random number generation routine. Outputs in !seed1/!ouput (returns !seed2)
    PHx                         ;$01ACF9    |
    LDx.b #$01                  ;$01ACFA    |
    JSL preprocess              ;$01ACFC    | Run RNG for high byte.
    DEx                         ;$01AD00    |
    JSL preprocess              ;$01AD01    | Run RNG for low byte.
    PLx                         ;$01AD05    |
    RTL                         ;$01AD06    |

preprocess:
    ; move to scratch to not mutate input, also no long addressing for asl and bit ops
    lda !seed1
    sta !seed1_copy
    lda !seed2 
    sta !seed2_copy

; INPUT:
;   X, index of output byte
;   $02, 00 - immutable, 01 - mutable
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

    ; mutate if input says to
    lda !mutate : beq .return

    .mutate:
    lda !seed1_copy : sta !seed1
    lda !seed2_copy : sta !seed2 

    .return:
RTL                             ;$01AD2F    |


; compare to vanilla
GetRand2:
    lda !seed1
    sta $148B
    lda !seed2
    sta $148C

    jsl $01ACF9
    rtl