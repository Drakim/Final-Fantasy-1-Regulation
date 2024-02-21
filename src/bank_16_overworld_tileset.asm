.segment "BANK_16"

.include "src/global-import.inc"

.export LoadOWTilesetData

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Load Overworld Tileset Data  [$C30F :: 0x3C31F]
;;
;;    Copies $400 bytes of overworld tileset data to RAM.
;;
;;  This fills the following buffers:
;;    tileset_prop
;;    tsa_ul, tsa_ur, tsa_dl, tsa_dr
;;    tsa_attr
;;    load_map_pal
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;


LoadOWTilesetData:
    LDA #<LUT_OWTileset ; set low bytes of source pointer
    STA tmp

    LDA #>LUT_OWTileset ; high byte of source pointer
    STA tmp+1

    LDA #<tileset_data
    STA tmp+2           ; low byte of dest pointer

    LDA #>tileset_data  ; high byte of dest pointer
    STA tmp+3



    LDX #4              ; high byte of loop counter ($400 iterations)
    LDY #0              ; low byte of loop counter and index

  @Loop:
    LDA (tmp), Y        ; copy over a byte
    STA (tmp+2), Y
    INY                 ; inc our index
    BNE @Loop           ; loop until it wraps

    INC tmp+1           ; once it wraps, inc high bytes of both pointers
    INC tmp+3
    DEX                 ; and decrement overall loop counter

    BNE @Loop           ; and keep looping until that expires ($400 iterations)

    RTS                 ; then exit

LUT_OWTileset:
    .byte $06, $40, $0e, $89, $0e, $89, $0e, $40, $1e, $40, $0e, $40, $0e, $40, $0b, $42
    .byte $0e, $40, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0e, $8e, $2e, $00
    .byte $0f, $00, $0f, $00, $0f, $00, $0e, $40, $1e, $40, $0e, $40, $0b, $42, $0b, $42
    .byte $0b, $42, $0f, $00, $0f, $00, $0e, $8a, $0e, $8a, $4e, $98, $0e, $00, $2e, $00
    .byte $0f, $00, $0f, $00, $0f, $00, $0e, $40, $0e, $40, $0e, $40, $0e, $40, $0b, $42
    .byte $0e, $40, $0e, $8b, $0e, $8b, $0e, $90, $0f, $00, $0f, $00, $0f, $00, $0e, $94
    .byte $0f, $00, $0f, $00, $0e, $95, $0f, $00, $0e, $99, $0e, $9a, $86, $00, $ce, $00
    .byte $0e, $8c, $0e, $8c, $0e, $96, $0e, $00, $0f, $00, $0e, $00, $0f, $00, $0e, $00
    .byte $0d, $41, $0d, $41, $0e, $40, $0e, $40, $0d, $41, $0e, $40, $0d, $93, $0f, $00
    .byte $0f, $00, $0e, $81, $0e, $82, $0f, $00, $0e, $83, $0e, $84, $0e, $85, $0f, $00
    .byte $0d, $41, $0d, $41, $0e, $40, $0e, $40, $06, $40, $0e, $40, $06, $00, $0e, $8d
    .byte $0e, $8d, $06, $00, $0e, $86, $0f, $00, $0f, $00, $0e, $87, $0f, $00, $0f, $00
    .byte $06, $40, $06, $40, $0e, $40, $0e, $40, $0e, $8f, $0e, $8f, $0e, $91, $0e, $9b
    .byte $0e, $9c, $0e, $9d, $0e, $80, $0f, $00, $0e, $92, $0e, $88, $0e, $97, $0f, $00
    .byte $06, $40, $06, $40, $0e, $40, $0e, $40, $0e, $00, $0e, $00, $06, $00, $2e, $00
    .byte $2e, $00, $2e, $00, $2e, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00, $0f, $00
    .byte $20, $89, $8b, $21, $26, $23, $53, $4f, $3f, $01, $7e, $8d, $01, $73, $1c, $f5
    .byte $02, $07, $04, $37, $2d, $2c, $4d, $3b, $3b, $81, $83, $ac, $ae, $77, $59, $01
    .byte $18, $0c, $0d, $33, $2d, $2e, $48, $3b, $42, $ac, $ae, $1c, $01, $01, $01, $1c
    .byte $14, $0e, $1c, $0f, $1c, $1c, $59, $59, $ac, $ae, $1c, $01, $d2, $7c, $7c, $d7
    .byte $55, $54, $62, $5c, $54, $59, $69, $b1, $b3, $96, $93, $01, $9e, $a2, $9a, $d4
    .byte $54, $54, $60, $59, $63, $6b, $01, $ba, $bc, $be, $a2, $d1, $01, $a2, $cd, $d6
    .byte $67, $65, $6f, $6b, $62, $e4, $df, $df, $df, $df, $df, $cf, $df, $96, $df, $7c
    .byte $68, $63, $6b, $6b, $e9, $af, $01, $01, $01, $01, $f5, $cb, $7c, $7c, $c9, $7c
    .byte $20, $8a, $8c, $22, $27, $24, $45, $50, $53, $7d, $01, $8e, $01, $74, $1d, $01
    .byte $03, $08, $05, $2c, $2a, $39, $3c, $3c, $4b, $82, $84, $ad, $d9, $78, $59, $f5
    .byte $0d, $0a, $1a, $2b, $2e, $36, $49, $3c, $43, $ad, $d9, $1d, $01, $01, $01, $1d
    .byte $0e, $0f, $1d, $17, $1d, $1d, $59, $59, $ad, $d9, $1d, $d1, $7c, $7c, $d6, $01
    .byte $54, $56, $5b, $62, $54, $59, $6a, $b2, $b4, $97, $94, $cf, $9f, $a3, $9b, $01
    .byte $54, $54, $59, $5e, $64, $6c, $b9, $bb, $bd, $01, $a3, $d2, $cb, $a3, $01, $d7
    .byte $68, $66, $6c, $70, $e3, $62, $e0, $e0, $e0, $e0, $e0, $7c, $e0, $97, $e0, $d4
    .byte $64, $65, $6c, $6c, $de, $b0, $20, $01, $01, $01, $01, $7c, $7c, $c9, $7c, $cd
    .byte $20, $7c, $91, $25, $2a, $2c, $46, $3d, $40, $01, $80, $8f, $aa, $75, $1e, $f5
    .byte $06, $0c, $0d, $38, $2b, $2e, $4e, $3d, $3d, $85, $87, $da, $dc, $79, $7b, $01
    .byte $19, $0c, $0d, $2f, $34, $31, $53, $51, $44, $da, $dc, $1e, $c5, $c6, $c6, $1e
    .byte $10, $15, $1e, $12, $1e, $1e, $59, $59, $da, $dc, $1e, $01, $7c, $7c, $7c, $d8
    .byte $54, $54, $5a, $59, $54, $59, $69, $b5, $b7, $98, $95, $01, $a0, $a4, $9c, $d5
    .byte $57, $54, $62, $5f, $64, $6d, $01, $c0, $c2, $c4, $a4, $d3, $01, $a4, $ce, $7c
    .byte $68, $64, $6d, $6d, $e5, $e7, $e1, $e1, $e1, $e1, $e1, $d0, $e1, $98, $e1, $7c
    .byte $67, $65, $71, $6d, $a6, $a8, $20, $01, $f5, $f5, $01, $cc, $c8, $c8, $ca, $c8
    .byte $20, $91, $92, $2a, $2b, $28, $47, $3e, $41, $7f, $01, $90, $ab, $76, $1f, $01
    .byte $0a, $0d, $09, $29, $2c, $3a, $3e, $3e, $4c, $86, $88, $db, $dd, $7a, $59, $f5
    .byte $0b, $0b, $1b, $30, $35, $32, $4a, $52, $53, $db, $dd, $1f, $c6, $c6, $c7, $1f
    .byte $11, $16, $1f, $13, $1f, $1f, $59, $59, $db, $dd, $1f, $d3, $7c, $7c, $7c, $01
    .byte $54, $54, $59, $5d, $54, $59, $6a, $b6, $b8, $99, $ea, $d0, $a1, $a5, $9d, $01
    .byte $54, $58, $61, $62, $63, $6e, $bf, $c1, $c3, $01, $a5, $7c, $cc, $a5, $01, $d8
    .byte $63, $65, $6e, $6e, $e6, $e8, $e2, $e2, $e2, $e2, $e2, $7c, $e2, $99, $e2, $d5
    .byte $68, $66, $6e, $72, $a7, $a9, $20, $f5, $f5, $01, $01, $c8, $c8, $ca, $c8, $ce
    .byte $ff, $00, $00, $ff, $ff, $ff, $aa, $aa, $aa, $00, $00, $00, $00, $55, $00, $00
    .byte $00, $00, $00, $ff, $ff, $ff, $aa, $aa, $aa, $00, $00, $00, $00, $55, $55, $00
    .byte $00, $00, $00, $ff, $ff, $ff, $aa, $aa, $aa, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $55, $55, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $aa, $aa, $55, $55, $aa, $55, $aa, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $aa, $aa, $55, $55, $ff, $aa, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $ff, $ff, $aa, $aa, $55, $55, $ff, $ff, $ff, $ff, $ff, $00, $ff, $00, $ff, $00
    .byte $ff, $ff, $aa, $aa, $55, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $0f, $1a, $10, $30, $0f, $1a, $27, $37, $0f, $1a, $31, $21, $0f, $1a, $29, $19
    .byte $0f, $0f, $12, $36, $0f, $0f, $27, $36, $0f, $0f, $27, $30, $0f, $0f, $30, $1a
    .byte $16, $16, $12, $17, $27, $12, $16, $16, $30, $30, $27, $12, $16, $16, $16, $16
    .byte $27, $12, $16, $16, $16, $30, $27, $13, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00