; jump flags
; 00 - none
; 01 - normal
; 02 - spin
; 03 - both

org $00D645
    autoclean jml try_spin_jump

org $00D65E
    autoclean jml try_normal_jump
    nop #2

; offset from vanilla table (initial nerf amount)
!offset_normal = 16
!offset_spin = 10

; index based on speed
; even - normal jump
; odd - spin jump

; params: X contains table index based on speed and jump type
; return: A with mario's jump height

org $00D663
    autoclean jml get_height
    nop

freecode

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
.even
    pla
    sec : sbc !jump_normal
    bra +
.odd
    pla
    sec : sbc !jump_spin
+
    sta !debug_out ; TODO: remove
    bpl .return
    ; save
    sta $7d
.return
    jml $00D667

jump_height:
    db $B0+!offset_normal,$B6+!offset_spin,$AE+!offset_normal,$B4+!offset_spin,$AB+!offset_normal,$B2+!offset_spin,$A9+!offset_normal,$B0+!offset_spin
    db $A6+!offset_normal,$AE+!offset_spin,$A4+!offset_normal,$AB+!offset_spin,$A1+!offset_normal,$A9+!offset_spin,$9F+!offset_normal,$A6+!offset_spin

; ----

; TODO: handle boost jump heights also
;BoostMarioSpeed:                ;-----------| Routine to handle Mario's speed from bouncing off of an enemy.
;    LDA $74                     ;$01AA33    |\ If climbing, don't bounce.
;    BNE Return01AA41            ;$01AA35    |/
;    LDA.b #$D0                  ;$01AA37    |\\ Speed Mario bounces off of an enemy without A being pressed.
;    BIT $15                     ;$01AA39    ||
;    BPL CODE_01AA3F             ;$01AA3B    ||
;    LDA.b #$A8                  ;$01AA3D    ||| Speed Mario bounces off of an enemy with A pressed.
;CODE_01AA3F:                    ;           ||
;    STA $7D                     ;$01AA3F    |/

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