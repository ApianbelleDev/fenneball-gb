INCLUDE "inc/defines.inc"
INCLUDE "inc/hardware.inc"

SECTION "code", ROM0
main::
	; wait until it's *not* vblank
	ld a, [rLY]
	cp 144
	jp nz, main
waitVBlank2:
	ld a, [rLY]
	cp 144
	jp nz, waitVBlank2

	; update objects
	call pollPad

	checkUp:
		ld a, [wCurBtn]
		and a, PADF_UP
		jp z, checkDown
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
		jp z, main
	padDown:
		ld a, [_OAMRAM]
		inc a
		ld [_OAMRAM], a

		ld a, [_OAMRAM + 4]
		inc a
		ld [_OAMRAM + 4], a 
		jp main
