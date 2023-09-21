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
	call updatePlayer
	jp main	
