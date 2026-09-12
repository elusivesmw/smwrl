incsrc "../../uberasm/rogue/ram.asm"
incsrc "../../uberasm/rogue/random.asm"

init:
    jsl generate_system_seeds
    jsl retry_api_save_game
rtl
