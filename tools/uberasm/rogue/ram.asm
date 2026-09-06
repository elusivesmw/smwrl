; ram setup
!rogue_saveram          = $7FA200
!global_seed            = !rogue_saveram+0 ; 2 immutable (seed of the run) needs to inited and saved
!jump_flags             = !rogue_saveram+1 ; format: "---- --sn" (s: spin, n: normal)
!jump_normal            = !rogue_saveram+2
!jump_spin              = !rogue_saveram+3
!jump_boost             = !rogue_saveram+4
!disable_p_speed        = !rogue_saveram+5
!disable_carry          = !rogue_saveram+6
!muncher_inv            = !rogue_saveram+7
!powerup_flags          = !rogue_saveram+8 ; format: "---- -Ffm" (F: feather, f: flower, m: mushroom)

!rogue_freeram          = $7FA300
!perk_seed              = !rogue_freeram+0 ; 2 mutable (system seed) save immediate (probably move in !rogue_saveram_xx)
!level_seed             = !rogue_freeram+2 ; 2 mutable (system seed) needs to save after level end
!debug_out              = !rogue_freeram+4 ; 1
!frame_counter          = !rogue_freeram+5 ; 1 TODO: remove after rng routine is finished
!perk_num               = !rogue_freeram+6 ; 1
!trigger_bonus_game     = !rogue_freeram+7 ; 1