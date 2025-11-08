!freeram = $7FA200;

; vars
!jump_normal = !freeram
!jump_spin   = !freeram+1
!debug_out = !freeram+2

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
sta !debug_out ; todo: remove this
bpl .return
.save
sta $7d
.return
jml $00D667


jump_height:
db $B0+!offset_normal,$B6+!offset_spin,$AE+!offset_normal,$B4+!offset_spin,$AB+!offset_normal,$B2+!offset_spin,$A9+!offset_normal,$B0+!offset_spin
db $A6+!offset_normal,$AE+!offset_spin,$A4+!offset_normal,$AB+!offset_spin,$A1+!offset_normal,$A9+!offset_spin,$9F+!offset_normal,$A6+!offset_spin

; TODO: handle boost jump heights also

;LDA.w DATA_00DABB,Y         ;$00DBA0    |\ Set Y speed for jumping off a net.
;STA $7D                     ;$00DBA3    |/

;LDA.b #$AA                  ;$00EA9F    |\\ Y speed to give Mario when jumping out of water.
;STA $7D                     ;$00EAA1    |/

;LDA.b #$E0                  ;$00EB6F    |\\ Y speed to give when jumping out of a wall-run.
;STA $7D                     ;$00EB71    |/

;LDA.b #$80                  ;$00F029    |\\ Y speed to give Mario when bouncing off a purple triangle with Yoshi.
;STA $7D                     ;$00F02B    |/

;LDA.b #$90                  ;$00F606    |\\ Speed at which Mario jumps upward.
;STA $7D                     ;$00F608    |/

;LDA.b #$F8                  ;$01A928    |\\ Y speed of Mario when stomping an enemy while spinjumping.
;STA $7D                     ;$01A92A    ||

;BoostMarioSpeed:                ;-----------| Routine to handle Mario's speed from bouncing off of an enemy.
;    LDA $74                     ;$01AA33    |\ If climbing, don't bounce.
;    BNE Return01AA41            ;$01AA35    |/
;    LDA.b #$D0                  ;$01AA37    |\\ Speed Mario bounces off of an enemy without A being pressed.
;    BIT $15                     ;$01AA39    ||
;    BPL CODE_01AA3F             ;$01AA3B    ||
;    LDA.b #$A8                  ;$01AA3D    ||| Speed Mario bounces off of an enemy with A pressed.
;CODE_01AA3F:                    ;           ||
;    STA $7D                     ;$01AA3F    |/

;CODE_01C2AF:                    ;```````````| Sprite 80 (flying key).
;    CMP.b #$80                  ;$01C2AF    |\ Branch if not sprite 80.
;    BNE CODE_01C2CE             ;$01C2B1    |/
;    LDA $7D                     ;$01C2B3    |\ Return if Mario is moving upward.
;    BMI Return01C2D2            ;$01C2B5    |/
;    LDA.b #$09                  ;$01C2B7    |\ Make carryable.
;    STA.w $14C8,X               ;$01C2B9    |/
;    LDA.b #$D0                  ;$01C2BC    |\ Bounce Mario.
;    STA $7D                     ;$01C2BE    |/


;LDA.b #$D0                  ;$01D2F9    |\\ Y speed to give Mario after bouncing on Morton/Roy/Ludwig.
;STA $7D                     ;$01D2FB    |/

;LDA.b #$B0                  ;$01DA33    |\\ Y speed given when jumping off a rope mechanism.
;STA $7D                     ;$01DA35    |/

;LDA.b #$C0                  ;$01E88C    ||\\ Y speed to give Mario when jumping out of a Lakitu cloud.
;STA $7D                     ;$01E88E    ||/

;LDA.b #$C0                  ;$01EDBF    ||| Y speed to give Mario when jumping off Yoshi on the ground.
;CODE_01EDC1:                    ;           ||
;STA $7D                     ;$01EDC1    |/

;LDA.b #$A0                  ;$02916C    |\ Y speed given when bouncing off a noteblock.
;STA $7D                     ;$02916E    |/

;LDA.w DATA_02CDFF,Y         ;$02CDE7    || Give Mario Y speed for jumping off the wall springboard. 
;STA $7D                     ;$02CDEA    |/

;LDA.w DATA_02CE07,Y         ;$02CFE5    || Bounce Mario upwards. (springboara)
;STA $7D                     ;$02CFE8    |/