INCLUDE "inc/defines.inc"
INCLUDE "inc/hardware.inc"

SECTION "player paddle", ROM0
initPlayer::
	ld a, 72
	ld [wPaddleY1], a ; load initial Y position into the paddle's Y variable

	ld a, 72 + 16
	ld [wPaddleY2], a
	; copy paddle tile into vram
	ld de, paddle
	ld hl, $8000
	ld bc, paddleEnd - paddle
	call memcpy
		
	; init top half of the paddle's position
	ld hl, _OAMRAM
	ld a, [wPaddleY1]    ; y position
	ld [hli], a
	ld a, PADDLE1_X ; x position
	ld [hli], a
	ld a, 0             
	ld [hli], a         ; tile num
	ld [hli], a         ; attributes

	; init bottom half of the paddle's position
	ld hl, _OAMRAM + 4
	ld a, [wPaddleY2]
	ld [hli], a
	ld a, PADDLE1_X
	ld [hli], a
	ld a, 0
	ld [hli], a
	ld a, OAMF_YFLIP
	ld [hli], a
	ret ; return from function. NOTE: NOT RETURNING WILL HAVE RANDOM AND UNWANTED EFFECTS!!
	
paddle:
	incbin "res/paddle.2bpp"
	;dw `33333333 
	;dw `33333333 
	;dw `33333333 
	;dw `33333333 
	;dw `33333333 
	;dw `33333333 
	;dw `33333333 
	;dw `33333333 
	;dw `33333333 
	;dw `33333333 
	;dw `33333333 
	;dw `33333333 
	;dw `33333333 
	;dw `33333333 
	;dw `33333333 
	;dw `33333333 


paddleEnd:
section "player variables", WRAM0
wPaddleY1:: db
wPaddleY2:: db
