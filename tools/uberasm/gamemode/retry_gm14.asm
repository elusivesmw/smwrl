init:
    jsl rogue_level_init

main:
    jsl retry_in_level_main
    jsl rogue_level_main

nmi:
    jsl retry_nmi_level
    rtl

end:
    jsl retry_in_level_end
    rtl
