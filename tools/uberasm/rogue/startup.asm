; NOTE: not currently called
init:
    ; clear 256 bytes
	lda #$00
	ldx #$00
	.loop:
	sta.l !freeram,x
	inx
	bne .loop
	
	rtl
