incsrc "chars.asm"

; test
main:
    jsr WriteStripe
rtl

StripeTable:
db $59,$09,$00,$0D
db 'E',$28,'L',$28,'U',$28,'S',$28,'I',$28,'V',$28,'E',$28


; ty thomas
WriteStripe:
	LDY #$00		; counter for how many tiles written
    lda $7F837B : tax ; get current stripe index
    .loop
	LDA StripeTable,y	; copy one byte
	STA $7F837D,x
	INX			; increment indices
	INY
	CPY #$1A		; if not at the end of the table, repeat
	BMI .loop

	LDA #$FF		; write $FF as the ending byte
	STA $7F837D,x
    txa : sta $7F837B		; store stripe end index
	RTS