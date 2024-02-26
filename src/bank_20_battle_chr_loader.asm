.segment "BANK_20"

.include "src/global-import.inc"

.import Impl_FARPPUCOPY, LUT_Battle_Backdrop_0, LUT_Battle_Backdrop_1

.export LoadBattleBackdropCHR, LoadBattleFormationCHR








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

    LDY PPUSTATUS ; reset PPU Addr toggle
    LDA #$00      ; Dest address = $0000
    STA PPUADDR   ; write high byte of dest address
    STA PPUADDR   ; write low byte:  0

    LDA #(.bank(LUT_Battle_Backdrop_0) * 2) | %10000000
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

    LDY PPUSTATUS ; reset PPU Addr toggle
    LDA #$00      ; Dest address = $0000
    STA PPUADDR   ; write high byte of dest address
    STA PPUADDR   ; write low byte:  0

    LDA #(.bank(LUT_Battle_Backdrop_1) * 2) | %10000000
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
    LDY PPUSTATUS ; reset PPU Addr toggle
    LDA #$01      ; Dest address = $0120
    STA PPUADDR
    LDA #$20
    STA PPUADDR
    LDA #(.bank(LUT_Battle_Backdrop_0) * 2) | %10000000
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
    LDY PPUSTATUS ; reset PPU Addr toggle
    LDA #$01      ; Dest address = $0120
    STA PPUADDR
    LDA #$20
    STA PPUADDR
    LDA #(.bank(LUT_Battle_Backdrop_1) * 2) | %10000000
    LDY #$20
    LDX #7                  ; load 7 rows              
    JUMP Impl_FARPPUCOPY
