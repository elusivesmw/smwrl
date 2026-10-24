incsrc "../../uberasm/rogue/ram.asm"
incsrc "../../uberasm/rogue/random.asm"

init:
    jsl generate_system_seeds
    jsl retry_api_save_game
    ; TODO: figure out how rom data is transfered to work ram
    ; look into CODE_05801E, LoadLevel
rtl
