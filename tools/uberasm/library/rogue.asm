namespace nested off

; load file macros (thanks kevin)
macro incsrc(folder, file)
    namespace <file>
        incsrc "../rogue/<folder>/<file>.asm"
    namespace off
endmacro

; load shared ram
%incsrc("", ram)

; load level asm
%incsrc("", level)

; load hijacks
; WARNING: this uberasm is no longer safe to apply to the source rom (levels.smc)
; it should only be applied to the copied rom (patched.smc)
; maybe build in an uninstall option, but currently i always patch uber and asar to the copy
%incsrc(hijacks, one_player)
%incsrc(hijacks, permadeath)
%incsrc(hijacks, level_end)
%incsrc(hijacks, jump_height)
%incsrc(hijacks, disable_p_speed)
%incsrc(hijacks, disable_carry)
%incsrc(hijacks, pipe_to_overworld)
%incsrc(hijacks, bonus_destination)