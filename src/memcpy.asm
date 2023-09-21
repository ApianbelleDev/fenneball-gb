SECTION "memcpy", ROM0

; Copy bytes from one area to another.
; @param de: Source
; @param hl: Destination
; @param bc: Length
memcpy::
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or a, c
    jp nz, memcpy
    ret
