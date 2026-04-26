; jump flags
; 00 - none
; 01 - normal
; 02 - spin
; 03 - both

; offset from vanilla table (initial nerf amount)
!offset_normal = 16
!offset_spin = 10
!offset_boost = 24

pushpc

org $00D645
    jml try_spin_jump

org $00D65E
    jml try_normal_jump
    nop #2

org $01AA3B
    autoclean jml boost_jump
    nop #2

; index based on speed
; even - normal jump
; odd - spin jump

; params: X contains table index based on speed and jump type
; return: A with mario's jump height
org $00D663
    jml get_height
    nop

pullpc

; ----

try_spin_jump:
    lda !jump_flags
    ; is any jump enabled?
    beq no_jump
    ; is spin jump enabled?
    and #02 : beq normal
do_spin_jump:
    ; slightly modified original code
    lda #$01 : sta $140D
    ; return
    jml $00D649
normal:
    jml do_normal_jump

try_normal_jump:
    lda !jump_flags
    ; is any jump enabled?
    beq no_jump
    ; is normal jump enabled?
    and #$01 : beq spin
do_normal_jump:
    ; original code
    lda #$01 : sta $1DFA
    ; return
    jml $00D663
spin:
    jml do_spin_jump

no_jump:
    jml $00D61E ; skip jumping code

; ----

get_height:
    lda.l jump_height,x
    pha
    txa
    bit #$01
    bne .odd
    .even:
    pla
    sec : sbc !jump_normal
    bra +
    .odd:
    pla
    sec : sbc !jump_spin
    +
    sta !debug_out ; TODO: remove
    bpl .return
    ; save
    sta $7d
    .return
    jml $00D668

jump_height:
    db $B0+!offset_normal,$B6+!offset_spin,$AE+!offset_normal,$B4+!offset_spin,$AB+!offset_normal,$B2+!offset_spin,$A9+!offset_normal,$B0+!offset_spin
    db $A6+!offset_normal,$AE+!offset_spin,$A4+!offset_normal,$AB+!offset_spin,$A1+!offset_normal,$A9+!offset_spin,$9F+!offset_normal,$A6+!offset_spin

; ----

boost_jump:
    bpl .save ; original code
    lda #$A8+!offset_boost
    sec : sbc !jump_boost
    sta !debug_out ; TODO: remove
    .save:
    sta $7d
    .return:
    jml $01AA41

; ----

; TODO: yoshi dismount with normal jump screwed up by setting the in-air flag to $0B here
;LDA.b #$0B                 ;$00D668
;STA $72                    ;$00D67D
; because a normal jump was detected, but we are still dismounting yoshi at
;LDY $72                    ;$01EDB3
;BNE CODE_01EDC1            ;$01EDB5

; TODO: tie to normal jump height
;LDA.b #$B0                  ;$01DA33    | jumping off a rope
;LDA.b #$AA                  ;$00EA9F    | jumping out of water

; TODO: maybe not handle
;LDA.w DATA_00DABB,Y         ;$00DBA0    | jumping off a net

; intentionally unhandled
;LDA.b #$F8                  ;$01A928    | spinning on an enemy
;LDA.b #$90                  ;$00F606    | death animation
;LDA.w DATA_02CE07,Y         ;$02CFE5    | bouncing (A/B not held) off a green bean 
;LDA.w DATA_02CDFF,Y         ;$02CDE7    | jumping (A/B held) off the green bean
;LDA.b #$A0                  ;$02916C    | bouncing off a noteblock
;LDA.b #$C0                  ;$01EDBF    | jumping off Yoshi on the ground
;LDA.b #$80                  ;$00F029    | bouncing off a purple triangle with Yoshi
;LDA.b #$E0                  ;$00EB6F    | jumping out of a wall-run
;LDA.b #$C0                  ;$01E88C    | jumping out of a Lakitu cloud
;LDA.b #$D0                  ;$01D2F9    | bouncing on Morton/Roy/Ludwig (edge case)
;LDA.b #$D0                  ;$01C2BC    | bouncing off of flying key (sprite 80) (edge case)