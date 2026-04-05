namespace nested off

; load file macros (thanks kevin)
macro incsrc(file)
    namespace <file>
        incsrc "../rogue/<file>.asm"
    namespace off
endmacro

; load shared ram
%incsrc(ram)

; load level asm
%incsrc(level)

; TODO: move hijacks in here
