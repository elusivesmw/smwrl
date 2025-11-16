; freeram ram start address
!freeram = $7FA200;

; vars
!jump_normal = !freeram
!jump_spin   = !freeram+1
!debug_out = !freeram+2
!ability_carry = !freeram+3