.segment "DATA_118"

.include "src/global-import.inc"

.export TEXT_ALPHABET, TEXT_CLASS_NAME_WHITE_MAGE, TEXT_SHOP_TITLEWEAPON, TEXT_HERO_0_NAME, TEXT_ITEM_DESCRIPTION

; address 0 - 146 (bytes 0 - 146)
TEXT_ALPHABET:
.byte $2a, $61, $2b, $61, $2c, $61, $2d, $61, $2e, $61, $2f, $61, $30, $61, $31, $61, $32, $61, $33, $7f, $7f, $34, $61, $35, $61, $36, $61, $37, $61, $38, $61, $39, $61, $3a, $61, $3b, $61, $3c, $61, $3d, $7f, $7f, $3e, $61, $3f, $61, $40, $61, $41, $61, $42, $61, $43, $61, $5e, $61, $5f, $61, $60, $61, $61, $7f, $7f, $20, $61, $21, $61, $22, $61, $23, $61, $24, $61, $25, $61, $26, $61, $27, $61, $28, $61, $29, $7f, $7f, $44, $61, $45, $61, $46, $61, $47, $61, $48, $61, $49, $61, $4a, $61, $4b, $61, $4c, $61, $4d, $7f, $7f, $4e, $61, $4f, $61, $50, $61, $51, $61, $52, $61, $53, $61, $54, $61, $55, $61, $56, $61, $57, $7f, $7f, $58, $61, $59, $61, $5a, $61, $5b, $61, $5c, $61, $5d, $61, $62, $61, $63, $61, $64, $61, $65, $00

; address 146 - 154 (bytes 0 - 8)
TEXT_CLASS_NAME_WHITE_MAGE:
.byte $40, $4b, $60, $36, $2a, $30, $2e, $00

; address 154 - 161 (bytes 0 - 7)
TEXT_SHOP_TITLEWEAPON:
.byte $40, $2e, $2a, $39, $38, $37, $00

; address 161 - 166 (bytes 0 - 5)
TEXT_HERO_0_NAME:
.byte $90, $80, $00, $91, $00

; address 166 - 171 (bytes 0 - 5)
TEXT_ITEM_DESCRIPTION:
.byte $94, $83, >stringifyActiveItem, <stringifyActiveItem, $00

; 171 - 8192
.res 8021

