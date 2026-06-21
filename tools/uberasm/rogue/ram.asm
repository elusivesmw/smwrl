; ram setup
!rogue_saveram          = $7FA200
!jump_flags             = !rogue_saveram+0  ; format: "---- --sn" (s: spin, n: normal)
!jump_normal            = !rogue_saveram+1
!jump_spin              = !rogue_saveram+2
!jump_boost             = !rogue_saveram+3
!disable_p_speed        = !rogue_saveram+4
!disable_carry          = !rogue_saveram+5
!muncher_inv            = !rogue_saveram+6
!powerup_flags          = !rogue_saveram+7 ; format: "---- -Ffm" (F: feather, f: flower, m: mushroom)

!rogue_freeram          = $7FA300
!inital_seed            = !rogue_freeram+0 ; 2
!current_seed           = !rogue_freeram+2 ; 2
!debug_out              = !rogue_freeram+4
!frame_counter          = !rogue_freeram+5
!perk_num               = !rogue_freeram+6
!trigger_bonus_game     = !rogue_freeram+7