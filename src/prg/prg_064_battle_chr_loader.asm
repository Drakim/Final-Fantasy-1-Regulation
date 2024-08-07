.segment "PRG_064"

.include "src/global-import.inc"

.import Impl_FARPPUCOPY, LUT_Battle_Backdrop_0, LUT_Battle_Backdrop_1, LoadMenuCHR, LoadBatSprCHRPalettes

.export LoadBattleBackdropCHR, LoadBattleFormationCHR, LoadBattleBGPalettes, LoadBattleCHRPal, LoadBattlePalette, DrawBattleBackdropRow, LoadBattleAttributeTable
.export LoadBattleSpritePalettes, LoadBattleFormationInto_btl_formdata

LUT_BtlBackdrops:
    .byte $00, $09, $09, $04, $04, $04, $00, $03, $00, $ff, $ff, $ff, $ff, $ff, $08, $ff
    .byte $ff, $ff, $ff, $04, $04, $04, $03, $03, $03, $ff, $ff, $09, $09, $0b, $06, $ff
    .byte $ff, $ff, $ff, $04, $04, $04, $00, $03, $00, $09, $09, $0d, $ff, $ff, $ff, $02
    .byte $ff, $ff, $02, $ff, $02, $02, $06, $06, $09, $09, $02, $00, $ff, $ff, $ff, $00
    .byte $0a, $0a, $06, $06, $0a, $06, $0f, $ff, $ff, $00, $03, $ff, $00, $00, $00, $ff
    .byte $0a, $0a, $06, $06, $00, $07, $00, $05, $05, $00, $00, $ff, $ff, $0c, $ff, $ff
    .byte $00, $00, $07, $07, $0e, $0e, $02, $02, $02, $02, $02, $ff, $02, $00, $01, $ff
    .byte $00, $00, $07, $07, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

LUT_BattleFormations:
    .byte $00, $00, $00, $01, $00, $00, $35, $00, $00, $00, $00, $01, $04, $40, $36, $04
    .byte $02, $08, $15, $18, $00, $00, $24, $00, $00, $00, $0c, $0c, $04, $00, $35, $02
    .byte $00, $28, $01, $02, $03, $00, $13, $02, $02, $02, $00, $01, $04, $a0, $13, $00
    .byte $00, $0a, $02, $03, $00, $00, $12, $00, $00, $00, $00, $01, $04, $40, $46, $01
    .byte $04, $0a, $2b, $2c, $00, $00, $24, $00, $00, $00, $16, $17, $04, $40, $23, $24
    .byte $07, $02, $49, $45, $00, $00, $12, $00, $00, $00, $1a, $21, $37, $40, $00, $24
    .byte $1c, $01, $74, $00, $00, $00, $11, $00, $00, $00, $32, $32, $04, $00, $24, $00
    .byte $22, $0e, $17, $1b, $00, $00, $12, $00, $00, $00, $0d, $0e, $04, $40, $13, $11
    .byte $04, $0a, $2c, $2d, $00, $00, $11, $00, $00, $00, $17, $18, $04, $40, $25, $04
    .byte $10, $07, $09, $06, $00, $00, $00, $11, $00, $00, $02, $01, $04, $40, $13, $02
    .byte $04, $00, $27, $00, $00, $00, $24, $00, $00, $00, $1a, $1a, $5a, $00, $37, $00
    .byte $00, $0a, $03, $02, $00, $00, $25, $03, $00, $00, $00, $01, $04, $80, $48, $00
    .byte $12, $07, $1b, $19, $00, $00, $12, $00, $00, $00, $0e, $10, $04, $40, $13, $02
    .byte $03, $00, $1e, $00, $00, $00, $12, $00, $00, $00, $11, $11, $04, $00, $37, $00
    .byte $20, $38, $01, $04, $09, $00, $05, $13, $02, $00, $01, $02, $21, $60, $25, $02
    .byte $04, $0a, $2e, $2d, $00, $00, $00, $14, $00, $00, $18, $19, $04, $80, $25, $25
    .byte $06, $02, $3e, $00, $00, $00, $23, $00, $00, $00, $1f, $1f, $04, $00, $38, $00
    .byte $00, $0a, $04, $03, $00, $00, $36, $00, $00, $00, $01, $02, $21, $80, $25, $05
    .byte $07, $08, $47, $4a, $00, $00, $00, $14, $00, $00, $21, $22, $37, $80, $25, $05
    .byte $12, $0f, $1c, $1b, $00, $00, $11, $12, $00, $00, $0e, $0f, $04, $80, $14, $02
    .byte $07, $02, $4a, $00, $00, $00, $12, $00, $00, $00, $21, $21, $04, $00, $48, $00
    .byte $03, $08, $1f, $21, $00, $00, $26, $00, $00, $00, $12, $15, $04, $40, $26, $04
    .byte $08, $02, $51, $4f, $00, $00, $26, $00, $00, $00, $25, $26, $04, $80, $26, $15
    .byte $15, $01, $38, $00, $00, $00, $14, $00, $00, $00, $15, $15, $04, $00, $16, $00
    .byte $04, $00, $28, $29, $00, $00, $26, $00, $00, $00, $18, $19, $04, $40, $26, $04
    .byte $15, $0f, $3b, $3a, $00, $00, $00, $13, $00, $00, $1a, $1d, $1b, $40, $13, $02
    .byte $23, $06, $21, $23, $00, $00, $24, $00, $00, $00, $11, $15, $1b, $80, $26, $12
    .byte $13, $07, $25, $23, $00, $00, $12, $01, $00, $00, $11, $12, $1b, $80, $12, $02
    .byte $0b, $00, $67, $00, $00, $00, $24, $00, $00, $00, $32, $32, $21, $01, $37, $00
    .byte $08, $00, $4f, $50, $00, $00, $25, $00, $00, $00, $25, $26, $04, $40, $37, $11
    .byte $10, $03, $09, $00, $00, $00, $12, $00, $00, $00, $02, $02, $04, $00, $24, $00
    .byte $10, $07, $09, $06, $00, $00, $12, $03, $00, $00, $01, $02, $04, $80, $14, $11
    .byte $29, $0b, $5d, $59, $00, $00, $12, $00, $00, $00, $2a, $2b, $1b, $40, $14, $03
    .byte $16, $01, $40, $00, $00, $00, $11, $00, $00, $00, $1c, $1c, $04, $01, $24, $00
    .byte $12, $0d, $1a, $1d, $00, $00, $01, $12, $00, $00, $0d, $10, $37, $41, $13, $02
    .byte $08, $02, $52, $00, $00, $00, $25, $00, $00, $00, $25, $25, $04, $00, $48, $00
    .byte $19, $03, $5e, $00, $00, $00, $11, $00, $00, $00, $03, $03, $04, $00, $44, $00
    .byte $29, $01, $5b, $57, $00, $00, $13, $00, $00, $00, $2a, $2b, $21, $80, $11, $02
    .byte $10, $07, $0b, $07, $00, $00, $12, $00, $00, $00, $03, $03, $04, $00, $11, $13
    .byte $16, $01, $41, $00, $00, $00, $12, $00, $00, $00, $03, $03, $04, $01, $34, $00
    .byte $14, $01, $31, $00, $00, $00, $11, $00, $00, $00, $19, $19, $04, $00, $24, $00
    .byte $10, $01, $07, $00, $00, $00, $11, $00, $00, $00, $03, $03, $04, $00, $24, $00
    .byte $16, $03, $43, $00, $00, $00, $11, $00, $00, $00, $0d, $0d, $04, $00, $24, $00
    .byte $02, $20, $16, $15, $18, $00, $11, $24, $11, $00, $0c, $0d, $04, $80, $36, $00
    .byte $04, $a0, $29, $28, $2e, $2d, $15, $03, $03, $03, $18, $19, $04, $a0, $26, $00
    .byte $00, $02, $05, $00, $00, $00, $37, $00, $00, $00, $04, $04, $04, $00, $47, $00
    .byte $20, $0b, $0a, $05, $00, $00, $11, $02, $00, $00, $04, $04, $04, $01, $22, $26
    .byte $0c, $0a, $72, $73, $00, $00, $14, $00, $00, $00, $24, $2e, $4b, $40, $23, $11
    .byte $16, $03, $42, $00, $00, $00, $12, $00, $00, $00, $07, $07, $04, $00, $34, $00
    .byte $15, $01, $39, $00, $00, $00, $11, $00, $00, $00, $0c, $0c, $04, $00, $12, $00
    .byte $13, $0d, $24, $25, $00, $00, $13, $00, $00, $00, $12, $16, $04, $81, $14, $02
    .byte $05, $02, $37, $34, $00, $00, $35, $00, $00, $00, $0e, $1e, $04, $80, $37, $05
    .byte $25, $0c, $34, $3b, $00, $00, $25, $00, $00, $00, $0e, $1a, $1b, $40, $36, $12
    .byte $2b, $0c, $68, $6c, $00, $00, $25, $00, $00, $00, $33, $34, $04, $40, $16, $12
    .byte $17, $01, $4b, $00, $00, $00, $13, $00, $00, $00, $1d, $1d, $04, $00, $34, $00
    .byte $18, $01, $54, $00, $00, $00, $13, $00, $00, $00, $27, $27, $04, $00, $13, $00
    .byte $17, $03, $4d, $00, $00, $00, $13, $00, $00, $00, $22, $22, $04, $00, $14, $00
    .byte $25, $0e, $36, $3b, $00, $00, $24, $00, $00, $00, $1a, $1d, $1b, $80, $36, $12
    .byte $10, $01, $08, $00, $00, $00, $12, $00, $00, $00, $05, $05, $1b, $00, $24, $00
    .byte $1a, $03, $65, $00, $00, $00, $13, $00, $00, $00, $30, $30, $04, $00, $34, $00
    .byte $14, $01, $30, $00, $00, $00, $11, $00, $00, $00, $1c, $1c, $04, $00, $12, $00
    .byte $18, $07, $55, $53, $00, $00, $11, $00, $00, $00, $28, $29, $04, $80, $11, $01
    .byte $18, $35, $53, $54, $56, $00, $00, $00, $11, $00, $27, $28, $04, $a0, $13, $05
    .byte $1b, $0f, $6c, $6d, $00, $00, $13, $00, $00, $00, $34, $35, $04, $40, $14, $13
    .byte $05, $00, $35, $00, $00, $00, $14, $00, $00, $00, $0f, $0f, $04, $00, $47, $00
    .byte $19, $01, $5c, $00, $00, $00, $11, $00, $00, $00, $2c, $2c, $21, $00, $12, $00
    .byte $23, $0b, $26, $22, $00, $00, $12, $13, $00, $00, $13, $14, $04, $80, $12, $14
    .byte $03, $02, $22, $00, $00, $00, $26, $00, $00, $00, $13, $13, $04, $00, $37, $00
    .byte $23, $32, $22, $20, $26, $00, $16, $25, $22, $00, $13, $14, $04, $20, $15, $03
    .byte $21, $04, $0e, $12, $00, $00, $01, $12, $00, $00, $07, $0b, $04, $80, $36, $22
    .byte $24, $0c, $2a, $33, $00, $00, $00, $11, $00, $00, $07, $16, $04, $41, $25, $00
    .byte $2a, $09, $63, $61, $00, $00, $11, $01, $00, $00, $13, $13, $04, $00, $12, $36
    .byte $11, $0d, $12, $14, $00, $00, $11, $01, $00, $00, $07, $09, $04, $40, $12, $12
    .byte $0a, $02, $61, $00, $00, $00, $13, $00, $00, $00, $13, $13, $04, $01, $36, $00
    .byte $08, $a0, $50, $4f, $51, $52, $15, $08, $08, $08, $25, $26, $04, $a0, $12, $16
    .byte $16, $03, $44, $00, $00, $00, $12, $00, $00, $00, $16, $16, $04, $01, $24, $00
    .byte $0a, $00, $5f, $60, $00, $00, $25, $00, $00, $00, $2e, $2f, $04, $40, $01, $11
    .byte $0c, $00, $6f, $00, $00, $00, $25, $00, $00, $00, $24, $24, $04, $00, $59, $00
    .byte $1b, $01, $6b, $00, $00, $00, $11, $00, $00, $00, $14, $14, $04, $01, $23, $00
    .byte $2c, $01, $75, $6f, $00, $00, $13, $00, $00, $00, $24, $33, $04, $80, $12, $12
    .byte $07, $00, $48, $00, $00, $00, $36, $00, $00, $00, $24, $24, $04, $00, $48, $00
    .byte $0a, $02, $62, $00, $00, $00, $24, $00, $00, $00, $04, $04, $04, $00, $36, $00
    .byte $2a, $09, $64, $62, $00, $00, $11, $01, $00, $00, $04, $2d, $04, $80, $01, $13
    .byte $26, $0c, $3d, $44, $00, $00, $13, $00, $00, $00, $16, $20, $04, $80, $13, $12
    .byte $2c, $04, $70, $75, $00, $00, $11, $12, $00, $00, $17, $33, $04, $40, $12, $12
    .byte $1a, $0f, $65, $66, $00, $00, $12, $12, $00, $00, $30, $31, $04, $40, $11, $00
    .byte $2c, $0b, $76, $73, $00, $00, $11, $00, $00, $00, $2e, $2f, $4b, $80, $00, $12
    .byte $14, $01, $2f, $00, $00, $00, $12, $00, $00, $00, $1b, $1b, $04, $01, $34, $00
    .byte $1b, $03, $6d, $00, $00, $00, $12, $00, $00, $00, $35, $35, $04, $00, $24, $00
    .byte $1b, $01, $6a, $00, $00, $00, $11, $00, $00, $00, $21, $21, $04, $01, $24, $00
    .byte $11, $05, $12, $11, $00, $00, $12, $01, $00, $00, $07, $09, $04, $40, $12, $01
    .byte $21, $30, $0c, $0d, $13, $00, $06, $00, $12, $00, $08, $09, $04, $80, $37, $02
    .byte $21, $06, $10, $11, $00, $00, $15, $00, $00, $00, $09, $0a, $04, $80, $00, $11
    .byte $21, $01, $11, $0c, $00, $00, $12, $02, $00, $00, $08, $09, $04, $c0, $00, $46
    .byte $21, $01, $11, $0d, $00, $00, $11, $01, $00, $00, $08, $09, $04, $80, $12, $03
    .byte $09, $00, $57, $00, $00, $00, $26, $00, $00, $00, $2a, $2a, $04, $00, $38, $00
    .byte $19, $07, $5d, $5b, $00, $00, $12, $02, $00, $00, $2a, $2b, $21, $40, $11, $01
    .byte $23, $23, $26, $20, $22, $00, $12, $02, $02, $00, $13, $14, $04, $80, $11, $03
    .byte $09, $02, $5a, $58, $00, $00, $12, $03, $00, $00, $2c, $2d, $04, $80, $11, $14
    .byte $13, $03, $25, $00, $00, $00, $12, $00, $00, $00, $12, $12, $04, $00, $24, $00
    .byte $13, $01, $23, $00, $00, $00, $12, $00, $00, $00, $11, $11, $1b, $00, $24, $00
    .byte $29, $18, $57, $59, $5b, $00, $02, $02, $11, $00, $2a, $2b, $1e, $60, $24, $02
    .byte $07, $0a, $4a, $49, $45, $46, $12, $02, $01, $01, $1a, $21, $37, $a0, $36, $02
    .byte $25, $0e, $36, $3b, $00, $00, $13, $02, $00, $00, $1a, $1d, $1b, $80, $47, $00
    .byte $06, $00, $3d, $3c, $00, $00, $00, $25, $00, $00, $1f, $20, $04, $80, $11, $36
    .byte $14, $03, $32, $00, $00, $00, $11, $00, $00, $00, $17, $17, $04, $01, $23, $00
    .byte $06, $02, $3f, $00, $00, $00, $25, $00, $00, $00, $20, $20, $04, $00, $37, $00
    .byte $07, $00, $46, $00, $00, $00, $13, $00, $00, $00, $1a, $1a, $04, $00, $47, $00
    .byte $0b, $00, $68, $00, $00, $00, $13, $00, $00, $00, $33, $33, $04, $00, $37, $00
    .byte $12, $01, $1a, $00, $00, $00, $12, $00, $00, $00, $0d, $0d, $37, $00, $34, $00
    .byte $12, $1f, $1d, $1c, $19, $00, $11, $11, $07, $00, $0f, $10, $04, $a0, $13, $02
    .byte $17, $01, $4c, $00, $00, $00, $12, $00, $00, $00, $23, $23, $04, $00, $14, $00
    .byte $18, $01, $53, $00, $00, $00, $13, $00, $00, $00, $28, $28, $04, $00, $14, $00
    .byte $17, $03, $4e, $00, $00, $00, $11, $00, $00, $00, $1c, $1c, $04, $00, $12, $00
    .byte $03, $00, $20, $00, $00, $00, $24, $00, $00, $00, $13, $13, $04, $00, $36, $00
    .byte $3d, $01, $78, $00, $00, $00, $11, $00, $00, $00, $36, $37, $04, $01, $00, $00
    .byte $3d, $00, $7a, $00, $00, $00, $11, $00, $00, $00, $38, $39, $04, $01, $00, $00
    .byte $3e, $02, $7c, $00, $00, $00, $11, $00, $00, $00, $3a, $3b, $04, $01, $00, $00
    .byte $3e, $03, $7e, $00, $00, $00, $11, $00, $00, $00, $3c, $3d, $04, $01, $00, $00
    .byte $3e, $03, $7d, $00, $00, $00, $11, $00, $00, $00, $3c, $3d, $04, $01, $00, $00
    .byte $3e, $02, $7b, $00, $00, $00, $11, $00, $00, $00, $3a, $3b, $04, $01, $00, $00
    .byte $3d, $00, $79, $00, $00, $00, $11, $00, $00, $00, $38, $39, $04, $01, $00, $00
    .byte $3d, $01, $77, $00, $00, $00, $11, $00, $00, $00, $36, $37, $04, $01, $00, $00
    .byte $4f, $04, $7f, $00, $00, $00, $11, $00, $00, $00, $3e, $3f, $04, $01, $00, $00
    .byte $26, $00, $3c, $00, $00, $00, $11, $00, $00, $00, $1f, $1f, $04, $01, $00, $00
    .byte $2c, $02, $71, $00, $00, $00, $11, $00, $00, $00, $06, $06, $04, $01, $00, $00
    .byte $01, $20, $0e, $0d, $0f, $00, $00, $00, $99, $00, $08, $0b, $04, $a1, $12, $88
    .byte $2b, $0e, $69, $6e, $00, $00, $11, $00, $00, $00, $13, $2e, $04, $41, $00, $12

LUT_BackdropPalette:
    .byte $0f, $31, $29, $30, $0f, $0c, $17, $07, $0f, $1c, $2b, $1b, $0f, $30, $3c, $22
    .byte $0f, $18, $0a, $1c, $0f, $3c, $1c, $0c, $0f, $37, $31, $28, $0f, $27, $17, $1c
    .byte $0f, $1a, $17, $07, $0f, $30, $10, $00, $0f, $22, $1a, $10, $0f, $37, $10, $00
    .byte $0f, $21, $12, $03, $0f, $31, $22, $13, $0f, $26, $16, $06, $0f, $2b, $1c, $0c
    .byte $0f, $30, $00, $31, $0f, $10, $27, $17, $0f, $3c, $1c, $0c, $0f, $3b, $1b, $0b
    .byte $0f, $37, $16, $10, $0f, $36, $16, $07, $0f, $37, $17, $07, $0f, $30, $28, $16
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $09, $09, $04, $04, $04, $00, $03, $00, $ff, $ff, $ff, $ff, $ff, $08, $ff
    .byte $ff, $ff, $ff, $04, $04, $04, $03, $03, $03, $ff, $ff, $09, $09, $0b, $06, $ff
    .byte $ff, $ff, $ff, $04, $04, $04, $00, $03, $00, $09, $09, $0d, $ff, $ff, $ff, $02
    .byte $ff, $ff, $02, $ff, $02, $02, $06, $06, $09, $09, $02, $00, $ff, $ff, $ff, $00
    .byte $0a, $0a, $06, $06, $0a, $06, $0f, $ff, $ff, $00, $03, $ff, $00, $00, $00, $ff
    .byte $0a, $0a, $06, $06, $00, $07, $00, $05, $05, $00, $00, $ff, $ff, $0c, $ff, $ff
    .byte $00, $00, $07, $07, $0e, $0e, $02, $02, $02, $02, $02, $ff, $02, $00, $01, $ff
    .byte $00, $00, $07, $07, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  LUT for Battle Palettes [$8F20 :: 0x30F30]
;;
;;    LUT of 64 4-byte palettes for use with battle formations

LUT_BattlePalettes:
    .byte $0f, $36, $27, $16, $0f, $36, $22, $13, $0f, $25, $29, $1b, $0f, $23, $26, $16
    .byte $0f, $24, $30, $22, $0f, $26, $2b, $19, $0f, $3a, $16, $1b, $0f, $30, $31, $22
    .byte $0f, $37, $26, $16, $0f, $30, $2b, $1c, $0f, $36, $21, $12, $0f, $30, $28, $19
    .byte $0f, $30, $23, $1b, $0f, $37, $25, $16, $0f, $38, $26, $14, $0f, $23, $29, $19
    .byte $0f, $17, $31, $1c, $0f, $36, $26, $14, $0f, $25, $2b, $19, $0f, $30, $2c, $13
    .byte $0f, $30, $22, $12, $0f, $2b, $26, $16, $0f, $16, $2c, $18, $0f, $23, $30, $00
    .byte $0f, $30, $28, $1c, $0f, $30, $2a, $18, $0f, $32, $1c, $0c, $0f, $37, $27, $13
    .byte $0f, $16, $37, $18, $0f, $30, $28, $17, $0f, $25, $2b, $19, $0f, $30, $12, $16
    .byte $0f, $37, $16, $13, $0f, $30, $28, $1a, $0f, $36, $26, $16, $0f, $30, $37, $1a
    .byte $0f, $30, $32, $0c, $0f, $30, $26, $16, $0f, $30, $27, $12, $0f, $30, $27, $16
    .byte $0f, $30, $2c, $1c, $0f, $36, $26, $16, $0f, $26, $3c, $1b, $0f, $25, $2a, $1a
    .byte $0f, $1b, $27, $16, $0f, $37, $32, $00, $0f, $37, $10, $1c, $0f, $30, $26, $00
    .byte $0f, $17, $38, $18, $0f, $13, $37, $1b, $0f, $30, $27, $18, $0f, $14, $30, $22
    .byte $0f, $36, $26, $16, $0f, $36, $10, $00, $0f, $30, $28, $04, $0f, $30, $16, $23
    .byte $0f, $16, $14, $30, $0f, $16, $14, $28, $0f, $27, $30, $23, $0f, $3b, $13, $23
    .byte $0f, $16, $2b, $12, $0f, $27, $2b, $13, $0f, $23, $28, $18, $0f, $30, $28, $18


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Battle Screen Attribute table LUT  [$F400 :: 0x3F410]
;;
;;    A copy of the attribute table for the battle screen.  This is
;;  further modified to set enemy attributes appropriately, but this is
;;  the base for it.
;;
;;    This LUT is copied in full to the attribute table.


LUT_BtlAttrTbl:
  .byte $3F,$0F,$0F,$0F,$3F,$0F,$FF,$FF
  .byte $33,$00,$00,$00,$33,$00,$FF,$FF
  .byte $33,$00,$00,$00,$33,$00,$FF,$FF
  .byte $33,$00,$00,$00,$33,$00,$FF,$FF
  .byte $F3,$F0,$F0,$F0,$F3,$F0,$FF,$FF
  .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
  .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
  .byte $0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Load Battle Sprite Palettes  [$EB99 :: 0x3EBA9]
;;
;;    Loads palettes for all sprites in battle and in menus
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadBattleSpritePalettes:
    LDX #$0F  ; start at $0F
    @Loop:
    LDA @BattleSpritePalettes, X
    STA cur_pal+$10, X   ; copy color to sprite palette
    DEX
    BPL @Loop            ; loop until X wraps ($10 colors copied)
    RTS

    @BattleSpritePalettes:
    .byte $0F,$28,$18,$21,  $0F,$16,$30,$36,   $0F,$30,$22,$12,  $0F,$30,$10,$00


LoadBattleAttributeTable:
  ;; Draw Attribute Table
    LDX #>$23C0
    LDA #<$23C0
    ; set PPU Address to $23C0 (start of attribute table)
    STX PPU_ADDR   ; write X as high byte
    STA PPU_ADDR   ; A as low byte
    LDX #0
    @AttrLoop:
        LDA LUT_BtlAttrTbl, X   ; copy over attribute bytes
        STA PPU_DATA
        INX
        CPX #$40
        BNE @AttrLoop           ; loop until all $40 bytes copied
    RTS

LoadBattleCHRPal:              ; does not load palettes for enemies
    CALL LoadBattleBackdropCHR
    CALL LoadBattleFormationCHR
    FARCALL LoadMenuCHR                ; load CHR for font/menu/etc
    CALL LoadBattleBGPalettes       ; finally.. load palettes for menu and backdrop
    FARJUMP LoadBatSprCHRPalettes

LoadBattleBackdropCHR:

    LDX ow_tile                   ; Get last OW tile we stepped on
    LDA LUT_BtlBackdrops, X       ; Use it as an index to get the backdrop ID
    AND #$0F     ; mask with $0F (there are only 16 battle BGs)

    CMP #8
    BCS @alternative

    STA MMC5_MULTI_1
    LDA #8
    STA MMC5_MULTI_2

    LDA #<(LUT_Battle_Backdrop_0 - $E0)
    STA tmp
    LDA #>(LUT_Battle_Backdrop_0 - $E0)
    CLC
    ADC MMC5_MULTI_1
    STA tmp+1

    LDY PPU_STATUS ; reset PPU Addr toggle
    LDA #$00      ; Dest address = $0000
    STA PPU_ADDR   ; write high byte of dest address
    STA PPU_ADDR   ; write low byte:  0

    LDA #.bank(LUT_Battle_Backdrop_0) | %10000000
    LDY #$E0
    LDX #2                  ; normally 1 row but we are starting under
    JUMP Impl_FARPPUCOPY

    @alternative:

    AND #%00000111
    STA MMC5_MULTI_1
    LDA #8
    STA MMC5_MULTI_2

    LDA #<(LUT_Battle_Backdrop_1 - $E0)
    STA tmp
    LDA #>(LUT_Battle_Backdrop_1 - $E0)
    CLC
    ADC MMC5_MULTI_1
    STA tmp+1

    LDY PPU_STATUS ; reset PPU Addr toggle
    LDA #$00      ; Dest address = $0000
    STA PPU_ADDR   ; write high byte of dest address
    STA PPU_ADDR   ; write low byte:  0

    LDA #.bank(LUT_Battle_Backdrop_1) | %10000000
    LDY #$E0
    LDX #2                  ; normally 1 row but we are starting under
    JUMP Impl_FARPPUCOPY



LoadBattleFormationCHR:

    LDA btlformation ; get battle formation number
    ASL A            ; multiply it by 16
    ASL A
    ASL A
    ASL A
    STA tmp+4        ; put low byte in tmp+4
    LDA btlformation
    AND #$7F         ; drop the "Formation B" bit
    LSR A
    LSR A
    LSR A
    LSR A
    CLC
    ADC #>LUT_BattleFormations   ; add to high byte of pointer
    STA tmp+5         ; and put it in $15.  (tmp+4) now points to LUT_BattleFormations+(formation * 16)

    LDA #<LUT_BattleFormations
    CLC
    ADC tmp+4
    STA tmp+4

    LDA tmp+5
    ADC #0
    STA tmp+5

    LDY #0
    LDA (tmp+4), Y   ; load Enemy CHR page ID from Battle formation data
    AND #$0F         ;  mask out lower bits (higher bits are different formation data)
    LDY #$20         ; set Y to #$20, so that CHR loading will continue 2 tiles into the row
    STA enCHRpage    ; put Enemy CHR page ID in enCHRpage (for future use?)








    AND #$0F     ; mask with $0F (there are only 16 battle BGs)
    CMP #8
    BCS @alternative


    STA MMC5_MULTI_1
    LDA #8
    STA MMC5_MULTI_2
    LDA #<(LUT_Battle_Backdrop_0)
    STA tmp
    LDA #>(LUT_Battle_Backdrop_0)
    CLC
    ADC MMC5_MULTI_1
    STA tmp+1
    INC tmp+1                      ; increment high byte of pointer (enemy CHR starts 1 row in, before that is battle backdrop)
    LDY PPU_STATUS ; reset PPU Addr toggle
    LDA #$01      ; Dest address = $0120
    STA PPU_ADDR
    LDA #$20
    STA PPU_ADDR
    LDA #.bank(LUT_Battle_Backdrop_0) | %10000000
    LDY #$20
    LDX #7                  ; load 7 rows
    JUMP Impl_FARPPUCOPY

    @alternative:
    AND #%00000111
    STA MMC5_MULTI_1
    LDA #8
    STA MMC5_MULTI_2
    LDA #<(LUT_Battle_Backdrop_1)
    STA tmp
    LDA #>(LUT_Battle_Backdrop_1)
    CLC
    ADC MMC5_MULTI_1
    STA tmp+1
    INC tmp+1                      ; increment high byte of pointer (enemy CHR starts 1 row in, before that is battle backdrop)
    LDY PPU_STATUS ; reset PPU Addr toggle
    LDA #$01      ; Dest address = $0120
    STA PPU_ADDR
    LDA #$20
    STA PPU_ADDR
    LDA #.bank(LUT_Battle_Backdrop_1) | %10000000
    LDY #$20
    LDX #7                  ; load 7 rows              
    JUMP Impl_FARPPUCOPY

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Load Battle BG Palettes  [$EB8D :: 0x3EB9D]
;;
;;    Loads both the Battle Backdrop palette, and border palette
;;    Does not load sprite palettes or palette for the enemies
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadBattleBGPalettes:
    CALL LoadBattleBackdropPalette
    LDA #$0F
    STA cur_pal+$E   ; Black to color 2
    LDA #$0F
    STA cur_pal+$C   ; Black always to color 0
    LDA #$00
    STA cur_pal+$D   ; Grey always to color 1
    LDA #$30
    STA cur_pal+$F   ; White always to color 3
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Load Battle Backdrop Palette  [$EB7C :: 0x3EB8C]
;;
;;   Loads required battle backdrop palette.  Note the difference between this and
;;    LoadBackdropPalette.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadBattleBackdropPalette:
    LDX ow_tile              ; Get last OW tile stepped on
    LDA LUT_BtlBackdrops, X  ; use it to index and get battle backdrop ID
    AND #$0F                 ; multiply ID by 4
    ASL A
    ASL A                    ; and load up the palette
    NOJUMP LoadBackdropPalette

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Load Backdrop Palette  [$EB5A :: 0x3EB6A]
;;
;;   Fetches palette for desired backdrop (battle or shop).
;;
;;   Y is unchanged
;;
;;   IN:   A = backdrop ID * 4
;;         * = Required bank must be swapped in
;;
;;   OUT:  $03C0-03C4 = backdrop palette
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadBackdropPalette:
    TAX                       ; backdrop ID * 4 in X for indexing
    LDA LUT_BackdropPalette, X    ; copy the palette over
    STA cur_pal
    LDA LUT_BackdropPalette+1, X
    STA cur_pal+1
    LDA LUT_BackdropPalette+2, X
    STA cur_pal+2
    LDA LUT_BackdropPalette+3, X
    STA cur_pal+3
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Load Battle Palette  [$F471 :: 0x3F481]
;;
;;    Loads a single (4-color) battle palette into 'btl_palettes' with the given
;;  offset.
;;
;;  IN:  A = ID of battle palette (as stored in the battle formation data)
;;       Y = offset from which to index btl_palettes
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadBattlePalette:
    ASL A             ; multiply the palette ID by 4 (4 colors per palette)
    ASL A
    TAX               ; throw in X
    LDA #4
    STA btltmp+10     ; set the loop down counter

  @Loop:
      LDA LUT_BattlePalettes, X   ; get the color from the ROM
      STA btl_palettes, Y         ; write it to our output buffer
      INX             ; inc our indeces
      INY
      DEC btltmp+10   ; dec our loop counter
      BNE @Loop       ; and loop until it expires (4 iterations)

    RTS               ; then exit!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw Battle Backdrop Row  [$F385 :: 0x3F395]
;;
;;    Draws one row of NT data for the battle backdrop.  Does not
;;  do any attribute updates.
;;
;;  IN:  A = low byte of target PPU Addr
;;       Y = tile additive (added to each drawn tile)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleBackdropRow:
    LDX #$20
    STX PPU_ADDR   ; write X as high byte
    STA PPU_ADDR   ; A as low byte

    STY btltmp+10        ; record tile additive for future use
    LDY #14
    STY btltmp+11        ; do 14 columns in the first section of the backdrop (btltmp+11 is column count)
    CALL @Section         ; draw first section

    LDA PPU_DATA            ; inc the PPU address by 2 to skip over those two bars of
    LDA PPU_DATA            ;  the box boundaries.

    LDY #6               ; do 6 columns for the second section
    STY btltmp+11
    NOJUMP @Section         ; draw second section and exit


  @Section:
    LDX #0
   @Loop:
      LDA @lut_BackdropLayout, X   ; get the tile to draw in this column
      CLC
      ADC btltmp+10                ; add to that our additive (to draw the right row)
      STA PPU_DATA                    ; draw the tile
      INX                          ; inc our loop counter
      CPX btltmp+11                ; and loop until we've drawn the desired number of columns
      BNE @Loop
    RTS

  ;; the layout of the battle backdrop -- the way the columns are arranged

    @lut_BackdropLayout:
  .byte 1,2,3,4,3,4,1,2,1,2,3,4,3,4

LoadBattleFormationInto_btl_formdata:
    LDA btlformation        ; get the formation ID
    AND #$7F                  ; remove the 'Formation B' bit to get the raw formation ID
    LDX #0                    ;  mulitply the formation ID by 16 (shift by 4) and rotate
    STX btltmp+11             ;  bits into btltmp+11.  The end result is that (btltmp+10) will
    ASL A                     ;  be formation*16
    ROL btltmp+11
    ASL A
    ROL btltmp+11
    ASL A
    ROL btltmp+11
    ASL A
    ROL btltmp+11
    STA btltmp+10

    CLC                       ; add to that the high byte of the formation data pointer
    LDA btltmp+11             ;  and (btltmp+10) now points to our formation data.
    ADC #>LUT_BattleFormations
    STA btltmp+11

    LDA btltmp+10
    CLC
    ADC #<LUT_BattleFormations
    STA btltmp+10

    LDA btltmp+11
    ADC #0
    STA btltmp+11


    LDX #$10                  ; $10 bytes of formation data (down counter)
    LDY #0                    ; index  (seems pointless to use both X and Y here -- could've just used Y)
    @FormationLoop:
        LDA (btltmp+10), Y      ; copy a byte from the LUT in ROM
        STA btl_formdata, Y     ;  to our formation data buffer in RAM
        INY                     ; inc index
        DEX                     ; dec loop counter
        BNE @FormationLoop      ; and loop until all $10 bytes copied
    RTS
