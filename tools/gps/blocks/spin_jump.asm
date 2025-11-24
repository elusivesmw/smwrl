!freeram = $7FA200
!spin_jump = !freeram+1
!max_inc = 32 ; don't allow jump increase past a certain point

db $42 ; or db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
; JMP WallFeet : JMP WallBody ; when using db $37

MarioBelow:

; TODO: fix this
;lda #$00 ; sprite num
;ldx #$07 ; tile after
;ldy #$00 ; direction
;%spawn_bounce_sprite()

; add height to spin jump
lda !spin_jump
clc : adc #$02
cmp #!max_inc
bcs return
.save:
sta !spin_jump

MarioAbove:
MarioSide:

TopCorner:
BodyInside:
HeadInside:

;WallFeet:	; when using db $37
;WallBody:

SpriteV:
SpriteH:

MarioCape:
MarioFireball:

return:
RTL

print "Increases spin jump height"
