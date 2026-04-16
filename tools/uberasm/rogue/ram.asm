; ram setup
!saveram        = $7FA200
!jump_flags     = !saveram+0
!jump_normal    = !saveram+1
!jump_spin      = !saveram+2
!jump_boost     = !saveram+3
!disable_carry  = !saveram+4

!freeram        = $7FA300
!debug_out      = !freeram+0
!frame_counter  = !freeram+1
!stripe_message_index = !freeram+2