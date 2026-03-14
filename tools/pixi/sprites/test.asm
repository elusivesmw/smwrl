!CoinsToAdd = 10
!SoundEffect = $01
!SoundPort = $1DFC

print "INIT ",pc
RTL

print "MAIN ",pc
PHB : PHK : PLB
	JSR MainCode
PLB : RTL

MainCode:
	JSR Graphics

	LDA #$00
	%SubOffScreen()	; Check if offscreen

	LDA $14C8,x		; Only run when sprite is living
	CMP #$08
	BNE Return
	LDA $9D			; And if nothing is frozen
	BNE Return

	JSL $01A7DC		; Check for contact
	BCC Return

	LDA $13CC		; Add coins
	CLC : ADC #!CoinsToAdd
	STA $13CC

	STZ $14C8,x		; Remove sprite

	STZ $00 : STZ $01
	LDA #$1B : STA $02
	LDA #$05
	%SpawnSmoke()	; Spawn a glitter smoke

	LDA #!SoundEffect
	STA !SoundPort	; Play a sound effect

Return:
RTS


Graphics:
	%GetDrawInfo()

	LDA $00
	STA $0300,y	; X position
	LDA $01
	STA $0301,y	; Y position
	LDA #$24
	STA $0302,y	; Tile number
	LDA $15F6,x
	ORA $64
	STA $0303,y	; Properties

	LDA #$00	; Tile to draw - 1
	LDY #$02	; 16x16 sprite
	JSL $01B7B3
RTS