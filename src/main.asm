include "inc/defines.inc"
include "inc/hardware.inc"

section "code", rom0
main::
	; wait until it's *not* vblank
	ldh a, [rLY]
	cp 144
	jr nz, main
.waitvblank
	ldh a, [rLY]
	cp 144
	jr nz, .waitvblank

	; update objects
	call pollPad

	checkUp:
		ld a, [wCurBtn]
		and a, PADF_UP
		jr z, checkDown
	padUp:
		ld a, [_OAMRAM] ; top half of paddle (will make constant later)
		dec a
		ld [_OAMRAM], a

		ld a, [_OAMRAM + 4] ; bottom half of paddle (will make constant later)
		dec a
		ld [_OAMRAM + 4], a
	checkDown:
		ld a, [wCurBtn]
		and a, PADF_DOWN
		jr z, main
	padDown:
		ld a, [_OAMRAM]
		inc a
		ld [_OAMRAM], a

		ld a, [_OAMRAM + 4]
		inc a
		ld [_OAMRAM + 4], a 
		jr main
