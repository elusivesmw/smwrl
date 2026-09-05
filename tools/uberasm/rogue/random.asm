; copy of vanilla RNG routine at $01ACF9
!seed1 = !initial_seed
!seed2 = !seed1+1
!seed2_copy = $00
!output = !current_seed 

; clobbers $00 and !seed1,!seed
; TODO: dont' clobber !seed1,!seed2
GetRand:                        ;-----------| Random number generation routine. Outputs in !seed1/!ouput (returns !seed2)
    PHx                         ;$01ACF9    |
    LDx.b #$01                  ;$01ACFA    |
    JSL CODE_01AD07             ;$01ACFC    | Run RNG for high byte.
    DEx                         ;$01AD00    |
    JSL CODE_01AD07             ;$01AD01    | Run RNG for low byte.
    PLx                         ;$01AD05    |
    RTL                         ;$01AD06    |

CODE_01AD07:
    lda !seed2 ; move to scratch for asl and bit operations
    sta !seed2_copy

    LDA !seed1                  ;$01AD07    |\ 
    ASL                         ;$01AD0A    ||
    ASL                         ;$01AD0B    || With a = !seed2:
    SEC                         ;$01AD0C    ||  a = 5a + 1;
    ADC !seed1                  ;$01AD0D    ||
    STA !seed1                  ;$01AD10    |/ TODO: this currently overwrites inbitial seed, don't want to do this
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
    LDA !seed2_copy                  ;$01AD26    |\ 
    sta !seed2 ; restore from copy, TODO: this currently overwrites initial seed, don't want to do this
    EOR !seed1                  ;$01AD29    || Invert byte B with byte A and output the result.
    STA !output,x               ;$01AD2C    |/

    RTL                         ;$01AD2F    |
