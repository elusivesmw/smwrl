; hex edits related to rogue behavior in here
; generic ones are fine in asar patches folder

pushpc

; bonus game: disable input immediately when the music starts
org $00A1EF
db $44

pullpc