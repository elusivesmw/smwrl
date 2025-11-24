!freeram = $7FA200

; clear 256 bytes
init:
	lda #$00
	ldx #$00
	.loop:
	sta.l !freeram,x
	inx
	bne .loop
	
	rtl
