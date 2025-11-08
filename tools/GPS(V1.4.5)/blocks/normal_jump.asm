!freeram = $7FA200
!normal_jump = !freeram
!max_inc = 32 ; don't allow jump increase past a certain point

db $42 ; or db $37
JMP MarioBelow : JMP MarioAbove : JMP MarioSide
JMP SpriteV : JMP SpriteH : JMP MarioCape : JMP MarioFireball
JMP TopCorner : JMP BodyInside : JMP HeadInside
; JMP WallFeet : JMP WallBody ; when using db $37

MarioBelow:

; add height to normal jump
lda !normal_jump
clc : adc #$02
cmp #!max_inc
bcs return
.save:
sta !normal_jump

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

print "Increases normal jump height"
