; ram setup
!saveram            = $7FA200
!jump_flags         = !saveram+0
!jump_normal        = !saveram+1
!jump_spin          = !saveram+2
!jump_boost         = !saveram+3
!disable_p_speed    = !saveram+4
!disable_carry      = !saveram+5

!freeram            = $7FA300
!debug_out          = !freeram+0
!frame_counter      = !freeram+1
!perk_index         = !freeram+2
!trigger_bonus_game = !freeram+3