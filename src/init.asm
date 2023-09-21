INCLUDE "inc/defines.inc"
INCLUDE "inc/hardware.inc"

SECTION "header", ROM0[$100]
	jp entryPoint

	ds $150 - @, 0 ; make room for the header
entryPoint:
	; don't turn screen off outside of vblank!!!

	ld a, 0
	ld [rNR52], a ; disable audio until needed
waitVBlank:
	ld a, [rLY]
	cp 144
	jp c, waitVBlank

	; turn the screen off
	ld a, 0
	ld [rLCDC], a

titleState:
	ld a, [wGamestate]
	cp a, STATE_TITLE
	jp nz, gameplayState
initTitle:
	; init title screen here
gameplayState:
	ld a, [wGamestate]
	cp a, STATE_GAME
	jp z, main
initGameplay:
	; load background tiles
	ld de, bg
	ld hl, $9000
	ld bc, bgEnd - bg
	call memcpy

bg:
; uh... it should be pretty obvious, but background tiles for the gameplay state should go here. :3
bgEnd:

SECTION "Gamestate Variables", WRAM0
wGamestate:: db

