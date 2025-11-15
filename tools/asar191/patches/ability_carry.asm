!freeram = $7FA200;

; vars
!ability_carry = !freeram+3

org $01AA5E

autoclean jml check_carry
nop #2

freecode

check_carry:
lda $1470
ora $187A
ora !ability_carry
.return
jml $01AA64