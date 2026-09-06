incsrc "../../uberasm/rogue/ram.asm"
incsrc "../../uberasm/rogue/random.asm"

init:
    jsl generate_system_seeds 
rtl
