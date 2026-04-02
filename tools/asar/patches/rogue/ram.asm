; freeram ram start address
!freeram = $7FA200;

; vars
!jump_flags     = !freeram+0
!jump_normal    = !freeram+1
!jump_spin      = !freeram+2
!jump_boost     = !freeram+3

!disable_carry  = !freeram+4

!debug_out      = !freeram+16
