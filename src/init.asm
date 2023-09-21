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
clearOam:
	ld [hli], a
	dec b 
	jp nz, clearOam
	
	call initPlayer
		
	; turn on display and enable background, objects, and 8x16 mode after tiles and tilemap are loaded
	ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16
	ld [rLCDC], a

	; set default palettes.
	ld a, %11100100
	ld [rBGP], a
	ld [rOBP0], a

	jp main
bg:
incbin "res/bg.2bpp"
bgEnd:

bgTilemap:
incbin "res/bg.tilemap"
bgTilemapEnd:
SECTION "Gamestate Variables", WRAM0
wGamestate:: db

