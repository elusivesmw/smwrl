;Behaves $130 (so dropped sprites like a shell gets pushed out of block)
;This is a vanilla muncher that is seen on map16 editor tile $12F.

;Unlike blockreator, this block, when touched on the side without overlapping
;(overlapping as in, moving into the block) with mario's hitbox will not damage
;the player, this happens on the original smw (the spikes from ghost houses
;and castles too).

;You can also set what side not to hurt mario (but it will instead, act like a
;harmless cement block, why would you allow the player to walk through a solid
;muncher?!), Like in NSMBWII in world 9-7 (oh god its ridiculously hard, unless
;if you are mini mario and use spinjump to jump high enough over tall pipes.)

!reverse	= 0
;^reverse flags:
; *0 = muncher when ram flag is 0.
; *1 = muncher when ram flag non-zero.

!Ram_Switch	= $14AE|!addr
;^what ram address switches between muncher and coin:
; *$14AD = blue p-switch.
; *$14AE = silver p-switch
; *$14AF = on/off switch.

!HurtKill	= 1
;^Damage:
; *0 = hurt
; *1 = instant kill

!Damage_Top		= 1
!Damage_Bottom		= 1
!Damage_LeftSide	= 1
!Damage_RightSide	= 1
;^Enable (set to 1) or disable (set to 0) damage on specific side. When Mario touches
; a non-damaging side, would simply act like a solid cement block when in "muncher" mode and
; and always a coin regardless if the side the player touches harms or not if in "coin" mode.

db $42
JMP MarioBelow : JMP MarioAbove : JMP MarioSide : JMP SpriteV : JMP SpriteH : JMP Return
JMP MarioFireBall : JMP MarioAbove : JMP BodyInside : JMP HeadInside

;========================================================================================
	MarioAbove:
	LDA !Ram_Switch
	if !Damage_Top != 0
		if !reverse == 0
			BEQ CheckYoshi
		else
			BNE CheckYoshi
		endif
	else
		if !reverse == 0
			BEQ AboveReturn	;>branch out of range
		else
			BNE AboveReturn
		endif
	endif
	JMP Coin
	if !Damage_Top != 0
		CheckYoshi:
		;LDA $187A|!addr		;\If player isn't riding yoshi, then hurt him.
		BEQ Muncher		;/
	endif
	AboveReturn:
	RTL		;>and return (as a solid)

;========================================================================================
MarioSide:
HeadInside:
	LDA !Ram_Switch
	if or(notequal(!Damage_LeftSide, 0), notequal(!Damage_RightSide, 0))
		if !reverse == 0
			BEQ ContactSide
		else
			BNE ContactSide
		endif
	else
		if !reverse == 0
			BEQ SideReturn
		else
			BNE SideReturn
		endif
	endif
	JMP Coin
	if or(notequal(!Damage_LeftSide, 0), notequal(!Damage_RightSide, 0))
		ContactSide:
		%side_contact_check()
		BEQ SideReturn
		
		if !Damage_LeftSide == 0		;\act as a solid cement block if the player touches the harmless right/left side
			CMP #$01			;|
			BEQ SideReturn			;|
		endif					;|
		if !Damage_RightSide == 0		;|
			CMP #$02			;|
			BEQ SideReturn			;|
		endif					;/
		BRA Muncher
	endif
	SideReturn:
	RTL

;========================================================================================
	MarioBelow:
	BodyInside:
	LDA !Ram_Switch
	if !Damage_Bottom != 0
		if !reverse == 0
			BEQ Muncher
		else
			BNE Muncher
		endif
	else
		if !reverse == 0
			BEQ Return
		else
			BNE Return
		endif
	endif

	Coin:
	JSR passable		;>coins are not solid!
	INC $13CC|!addr		;>in case the player grabs 2 coins simultaneously
	LDA #$01		;\coin sfx
	STA $1DFC|!addr		;/
	%erase_block()		;>delete block
	;%give_points()		;>give player points (only happens if you get coins from ? and turn blocks)

	;glitter
	PHY			;>protect tile behavor
	PHK			;\the JSL-RTS trick.
	PEA.w .jslrtsreturn-1	;|Thanks LX5 and imamelia!
	PEA.w $84CF-1		;/
	JML $00FD5A		;>glitter subroutine

	.jslrtsreturn
	PLY			;>end protect to avoid stack overflow.
	RTL
;========================================================================================
	MarioFireBall:
	SpriteV:
	SpriteH:
	LDA !Ram_Switch
	if !reverse == 0
		BEQ Return
	else
		BNE Return
	endif
	JSR passable

	Return:
	RTL		;>return as a solid
;========================================================================================
	Muncher:
	if !HurtKill == 0
		JSL $00F5B7	;>hurt the player
	else
		JSL $00F606	;>kill the player
	endif
	RTL

	passable:
	LDY #$00
	LDA #$25
	STA $1693|!addr
	RTS
	if !reverse == 0
		print "OMNOMNOMNOMNOMNOMN"
	else
		print "NWONWONWONWONWONWO"
	endif