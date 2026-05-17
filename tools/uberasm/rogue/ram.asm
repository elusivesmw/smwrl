; ram setup
!rogue_saveram          = $7FA200
!jump_flags             = !rogue_saveram+0
!jump_normal            = !rogue_saveram+1
!jump_spin              = !rogue_saveram+2
!jump_boost             = !rogue_saveram+3
!disable_p_speed        = !rogue_saveram+4
!disable_carry          = !rogue_saveram+5
!muncher_inv            = !rogue_saveram+6

!rogue_freeram          = $7FA300
!debug_out              = !rogue_freeram+0
!frame_counter          = !rogue_freeram+1
!perk_index             = !rogue_freeram+2
!trigger_bonus_game     = !rogue_freeram+3