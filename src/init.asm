include "inc/defines.inc"
include "inc/hardware.inc"

section "header", rom0[$100]

	jr entryPoint
	
	ds $150 - @, 0 ; make room for the header
entryPoint:
	di ; disable interupts
reset::
	xor a
	ldh [rNR52], a ; disable audio until needed
.waitvblank
	ldh a, [rLY]
	cp 144
	jr c, .waitvblank

	; turn the screen off
	xor a
	ldh [rLCDC], a

	; goal: set up the bare minimum before we turn the screen back on
	; load background tiles into vram
	ld de, bg
	ld hl, $9000
	ld bc, bgEnd - bg
	call memcpy

	; load background tilemap into vram
	ld de, bgTilemap
	ld hl, $9800
	ld bc, bgTilemapEnd - bgTilemap
	call memcpy

	; clear OAM and prepare to draw objects
	ld a, 0
	ld b, 160
	ld hl, _OAMRAM
.clearoam
	ld [hli], a
	dec b
	jr nz, .clearoam	

	call initPlayer
	; turn on display and enable background, objects, and 8x16 mode after tiles and tilemap are loaded
	ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16
	ldh [rLCDC], a

	; set default palettes.
	ld a, %11_10_01_00
	ldh [rBGP], a
	ldh [rOBP0], a

	jp main
bg:
incbin "res/bg.2bpp"
bgEnd:

bgTilemap:
incbin "res/bg.tilemap"
bgTilemapEnd:
section "Gamestate Variables", wram0
wGamestate:: db
