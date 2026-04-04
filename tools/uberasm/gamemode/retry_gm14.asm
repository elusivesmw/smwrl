!frame_counter = $7FA300

main:
    jsl retry_in_level_main

    lda !frame_counter
    inc : sta !frame_counter 
    rtl

nmi:
    jsl retry_nmi_level
    rtl

end:
    jsl retry_in_level_end
    rtl
