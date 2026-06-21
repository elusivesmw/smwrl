; copy of vanilla RNG routine at $01ACF9
!seed1 = $148B
!seed2 = !seed1+1
!output = $148D

GetRand:                        ;-----------| Random number generation routine. Outputs in !seed1/!ouput (returns !seed2)
    PHY                         ;$01ACF9    |
    LDY.b #$01                  ;$01ACFA    |
    JSL CODE_01AD07             ;$01ACFC    | Run RNG for high byte.
    DEY                         ;$01AD00    |
    JSL CODE_01AD07             ;$01AD01    | Run RNG for low byte.
    PLY                         ;$01AD05    |
    RTL                         ;$01AD06    |

CODE_01AD07:
    LDA !seed1                  ;$01AD07    |\ 
    ASL                         ;$01AD0A    ||
    ASL                         ;$01AD0B    || With a = !seed2:
    SEC                         ;$01AD0C    ||  a = 5a + 1;
    ADC !seed1                  ;$01AD0D    ||
    STA !seed1                  ;$01AD10    |/
    ASL !seed2                  ;$01AD13    |\ 
    LDA #$20                    ;$01AD16    ||
    BIT !seed2                  ;$01AD18    || With b = !seed2:
    BCC CODE_01AD21             ;$01AD1B    ||  if (b.4 = b.7) {
    BEQ CODE_01AD26             ;$01AD1D    ||    b = 2b + 1;
    BNE CODE_01AD23             ;$01AD1F    ||  } else {
CODE_01AD21:                    ;           ||    b = 2b;
    BNE CODE_01AD26             ;$01AD21    ||  }
CODE_01AD23:                    ;           ||
    INC !seed2                  ;$01AD23    |/
CODE_01AD26:                    ;           |
    LDA !seed2                  ;$01AD26    |\ 
    EOR !seed1                  ;$01AD29    || Invert byte B with byte A and output the result.
    STA !output,Y               ;$01AD2C    |/
    RTL                         ;$01AD2F    |
