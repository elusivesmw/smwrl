; ram setup
!rogue_saveram          = $7FA200
!global_seed            = !rogue_saveram+0 ; 2 immutable (seed of the run) needs to inited and saved
!perk_seed              = !rogue_saveram+2 ; 2 mutable (system seed) needs to save on some interval
!level_seed             = !rogue_saveram+4 ; 2 mutable (system seed) needs to save after level end
!jump_flags             = !rogue_saveram+6 ; format: "---- --sn" (s: spin, n: normal)
!jump_normal            = !rogue_saveram+7
!jump_spin              = !rogue_saveram+8
!jump_boost             = !rogue_saveram+9
!disable_p_speed        = !rogue_saveram+10
!disable_carry          = !rogue_saveram+11
!muncher_inv            = !rogue_saveram+12
!powerup_flags          = !rogue_saveram+13 ; format: "---- -Ffm" (F: feather, f: flower, m: mushroom)

!rogue_freeram          = $7FA300
!current_perk_seed      = !rogue_freeram+0 ; 2 out of sync with sram perk_seed until save
!current_level_seed     = !rogue_freeram+2 ; 2 out of sync with sram perk_level until save
!debug_out              = !rogue_freeram+4 ; 1
!perk_num               = !rogue_freeram+5 ; 1
!trigger_bonus_game     = !rogue_freeram+6 ; 1