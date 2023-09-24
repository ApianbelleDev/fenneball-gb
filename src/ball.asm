include "inc/hardware.inc"
include "inc/defines.inc"

section "ball data", rom0
initBall::
	; init vars
	ld a, -1
	ld [wBallDX], a
	ld a, 1
	ld [wBallDY], a

	; copy ball tile into vram
	ld de, ball
	ld hl, $8020
	ld bc, ball.end - ball
	call memcpy

	; initialize ball tile values in OAM
	ld a, 73 + 16 ; y
	ld [_OAMRAM + 8], a
	ld a, 62 + 8; x
	ld [_OAMRAM + 9], a
	ld a, 2 ; tile num
	ld [_OAMRAM + 10], a
	xor a ; attributes
	ld [_OAMRAM + 11], a
	ret
updateBall::
	; move ball left
	ld a, [wBallDX]     ; load ball's x velocity into a
	ld b, a             ; load a into b
	ld a, [_OAMRAM + 9] ; load the ball's x position in OAM into a
	add a, b            
	ld [_OAMRAM + 9], a ; load the added value back into the ball's X position in OAM

	; move ball downwards
	ld a, [wBallDY]     ; load the ball's y velocity into a
	ld b, a             ; load a into b
	ld a, [_OAMRAM + 8] ; load the ball's y position in OAM into a
	add a, b            
	ld [_OAMRAM + 8], a ; load the added value back into the ball's y position

	; CURRENTLY IMPLEMENTING!!!! DO NOT TOUCH :3	
	; bounce checks
;	ld a, [_OAMRAM + 8]
;	cp 144
;	jr c, .false
;.true:
;	ld a, [wBallDY]
;	dec a
;	cpl
;	ld b, b
;	jr .done
;.false:
;	ld a, 1
;	ld [wBallDY], a
;.done:	
	ret
section "ball graphics", rom0
ball:
	incbin "res/ball.2bpp"
.end:

section "ball vars", wram0
wBallDX: ds 1
wBallDY: ds 1	
