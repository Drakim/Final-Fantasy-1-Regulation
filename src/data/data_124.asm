.segment "DATA_124"

.include "src/global-import.inc"

.export TEXT_EXAMPLE_EQUIP_LIST, TEXT_SHOP_DONTFORGET, TEXT_SHOP_NOBODYDEAD, TEXT_SHOP_WHOWILLLEARNSPELL, TEXT_SHOP_YOUCANTAFFORDTHAT, TEXT_INTRO_STORY_3, TEXT_TITLE_SELECT_NAME, TEXT_CLASS_NAME_MASTER, LUT_METASPRITE_CHR_LO, LUT_METASPRITE_CHR_HI, METASPRITE_CURSOR_CHR, METASPRITE_BLACK_BELT_CHR, METASPRITE_BLACK_MAGE_CHR, METASPRITE_FIGHTER_CHR, METASPRITE_RED_MAGE_CHR, METASPRITE_THIEF_CHR, METASPRITE_WHITE_MAGE_CHR

; address 0 - 51 (bytes 0 - 51)
TEXT_EXAMPLE_EQUIP_LIST:
.byte $0f, $7e, $13, $36, $33, $32, $7e, $1d, $3b, $33, $36, $28, $7f, $0f, $7e, $13, $36, $33, $32, $7e, $12, $29, $30, $31, $29, $38, $7f, $0f, $7e, $0c, $36, $25, $27, $29, $30, $29, $38, $7f, $7e, $7e, $21, $33, $33, $28, $29, $32, $7e, $0b, $3c, $29, $00

; address 51 - 89 (bytes 0 - 38)
TEXT_SHOP_DONTFORGET:
.byte $0e, $33, $32, $46, $38, $7f, $2a, $33, $36, $2b, $29, $38, $3f, $7f, $2d, $2a, $7e, $3d, $33, $39, $7f, $30, $29, $25, $3a, $29, $7f, $3d, $33, $39, $36, $7f, $2b, $25, $31, $29, $3f, $00

; address 89 - 118 (bytes 0 - 29)
TEXT_SHOP_NOBODYDEAD:
.byte $23, $33, $39, $7e, $28, $33, $7f, $32, $33, $38, $7f, $32, $29, $29, $28, $7e, $31, $3d, $7f, $2c, $29, $30, $34, $7f, $32, $33, $3b, $40, $00

; address 118 - 144 (bytes 0 - 26)
TEXT_SHOP_WHOWILLLEARNSPELL:
.byte $21, $2c, $33, $7f, $3b, $2d, $30, $30, $7f, $30, $29, $25, $36, $32, $7f, $38, $2c, $29, $7f, $37, $34, $29, $30, $30, $42, $00

; address 144 - 167 (bytes 0 - 23)
TEXT_SHOP_YOUCANTAFFORDTHAT:
.byte $23, $33, $39, $7f, $27, $25, $32, $46, $38, $7f, $25, $2a, $2a, $33, $36, $28, $7f, $38, $2c, $25, $38, $40, $00

; address 167 - 183 (bytes 0 - 16)
TEXT_INTRO_STORY_3:
.byte $38, $2c, $29, $7e, $37, $29, $25, $7e, $2d, $37, $7e, $3b, $2d, $30, $28, $00

; address 183 - 196 (bytes 0 - 13)
TEXT_TITLE_SELECT_NAME:
.byte $1d, $0f, $16, $0f, $0d, $1e, $7e, $7e, $18, $0b, $17, $0f, $00

; address 196 - 203 (bytes 0 - 7)
TEXT_CLASS_NAME_MASTER:
.byte $17, $0b, $1d, $1e, $0f, $1c, $00

; address 203 - 210 (bytes 0 - 7)
LUT_METASPRITE_CHR_LO:
.byte <METASPRITE_CURSOR_CHR, <METASPRITE_BLACK_BELT_CHR, <METASPRITE_BLACK_MAGE_CHR, <METASPRITE_FIGHTER_CHR, <METASPRITE_RED_MAGE_CHR, <METASPRITE_THIEF_CHR, <METASPRITE_WHITE_MAGE_CHR

; address 210 - 217 (bytes 0 - 7)
LUT_METASPRITE_CHR_HI:
.byte >METASPRITE_CURSOR_CHR, >METASPRITE_BLACK_BELT_CHR, >METASPRITE_BLACK_MAGE_CHR, >METASPRITE_FIGHTER_CHR, >METASPRITE_RED_MAGE_CHR, >METASPRITE_THIEF_CHR, >METASPRITE_WHITE_MAGE_CHR

; address 217 - 224 (bytes 0 - 7)
METASPRITE_CURSOR_CHR:
.byte $03, <TILE_CURSOR_0, >TILE_CURSOR_0, $01, <TILE_CURSOR_1, >TILE_CURSOR_1, $ff

; address 224 - 258 (bytes 0 - 34)
METASPRITE_BLACK_BELT_CHR:
.byte $03, <TILE_BLACK_BELT_0, >TILE_BLACK_BELT_0, $03, <TILE_BLACK_BELT_1, >TILE_BLACK_BELT_1, $03, <TILE_BLACK_BELT_2, >TILE_BLACK_BELT_2, $03, <TILE_BLACK_BELT_3, >TILE_BLACK_BELT_3, $03, <TILE_BLACK_BELT_4, >TILE_BLACK_BELT_4, $03, <TILE_BLACK_BELT_5, >TILE_BLACK_BELT_5, $03, <TILE_BLACK_BELT_6, >TILE_BLACK_BELT_6, $03, <TILE_BLACK_BELT_7, >TILE_BLACK_BELT_7, $03, <TILE_BLACK_BELT_8, >TILE_BLACK_BELT_8, $03, <TILE_BLACK_BELT_9, >TILE_BLACK_BELT_9, $03, <TILE_BLACK_BELT_10, >TILE_BLACK_BELT_10, $ff

; address 258 - 292 (bytes 0 - 34)
METASPRITE_BLACK_MAGE_CHR:
.byte $03, <TILE_BLACK_MAGE_0, >TILE_BLACK_MAGE_0, $03, <TILE_BLACK_MAGE_1, >TILE_BLACK_MAGE_1, $03, <TILE_BLACK_MAGE_2, >TILE_BLACK_MAGE_2, $03, <TILE_BLACK_MAGE_3, >TILE_BLACK_MAGE_3, $03, <TILE_BLACK_MAGE_4, >TILE_BLACK_MAGE_4, $03, <TILE_BLACK_MAGE_5, >TILE_BLACK_MAGE_5, $03, <TILE_BLACK_MAGE_6, >TILE_BLACK_MAGE_6, $03, <TILE_BLACK_MAGE_7, >TILE_BLACK_MAGE_7, $03, <TILE_BLACK_MAGE_8, >TILE_BLACK_MAGE_8, $03, <TILE_BLACK_MAGE_9, >TILE_BLACK_MAGE_9, $03, <TILE_BLACK_MAGE_10, >TILE_BLACK_MAGE_10, $ff

; address 292 - 326 (bytes 0 - 34)
METASPRITE_FIGHTER_CHR:
.byte $03, <TILE_FIGHTER_0, >TILE_FIGHTER_0, $03, <TILE_FIGHTER_1, >TILE_FIGHTER_1, $03, <TILE_FIGHTER_2, >TILE_FIGHTER_2, $03, <TILE_FIGHTER_3, >TILE_FIGHTER_3, $03, <TILE_FIGHTER_4, >TILE_FIGHTER_4, $03, <TILE_FIGHTER_5, >TILE_FIGHTER_5, $03, <TILE_FIGHTER_6, >TILE_FIGHTER_6, $03, <TILE_FIGHTER_7, >TILE_FIGHTER_7, $03, <TILE_FIGHTER_8, >TILE_FIGHTER_8, $03, <TILE_FIGHTER_9, >TILE_FIGHTER_9, $03, <TILE_FIGHTER_10, >TILE_FIGHTER_10, $ff

; address 326 - 360 (bytes 0 - 34)
METASPRITE_RED_MAGE_CHR:
.byte $03, <TILE_RED_MAGE_0, >TILE_RED_MAGE_0, $03, <TILE_RED_MAGE_1, >TILE_RED_MAGE_1, $03, <TILE_RED_MAGE_2, >TILE_RED_MAGE_2, $03, <TILE_RED_MAGE_3, >TILE_RED_MAGE_3, $03, <TILE_RED_MAGE_4, >TILE_RED_MAGE_4, $03, <TILE_RED_MAGE_5, >TILE_RED_MAGE_5, $03, <TILE_RED_MAGE_6, >TILE_RED_MAGE_6, $03, <TILE_RED_MAGE_7, >TILE_RED_MAGE_7, $03, <TILE_RED_MAGE_8, >TILE_RED_MAGE_8, $03, <TILE_RED_MAGE_9, >TILE_RED_MAGE_9, $03, <TILE_RED_MAGE_10, >TILE_RED_MAGE_10, $ff

; address 360 - 394 (bytes 0 - 34)
METASPRITE_THIEF_CHR:
.byte $03, <TILE_THIEF_0, >TILE_THIEF_0, $03, <TILE_THIEF_1, >TILE_THIEF_1, $03, <TILE_THIEF_2, >TILE_THIEF_2, $03, <TILE_THIEF_3, >TILE_THIEF_3, $03, <TILE_THIEF_4, >TILE_THIEF_4, $03, <TILE_THIEF_5, >TILE_THIEF_5, $03, <TILE_THIEF_6, >TILE_THIEF_6, $03, <TILE_THIEF_7, >TILE_THIEF_7, $03, <TILE_THIEF_8, >TILE_THIEF_8, $03, <TILE_THIEF_9, >TILE_THIEF_9, $03, <TILE_THIEF_10, >TILE_THIEF_10, $ff

; address 394 - 428 (bytes 0 - 34)
METASPRITE_WHITE_MAGE_CHR:
.byte $03, <TILE_WHITE_MAGE_0, >TILE_WHITE_MAGE_0, $03, <TILE_WHITE_MAGE_1, >TILE_WHITE_MAGE_1, $03, <TILE_WHITE_MAGE_2, >TILE_WHITE_MAGE_2, $03, <TILE_WHITE_MAGE_3, >TILE_WHITE_MAGE_3, $03, <TILE_WHITE_MAGE_4, >TILE_WHITE_MAGE_4, $03, <TILE_WHITE_MAGE_5, >TILE_WHITE_MAGE_5, $03, <TILE_WHITE_MAGE_6, >TILE_WHITE_MAGE_6, $03, <TILE_WHITE_MAGE_7, >TILE_WHITE_MAGE_7, $03, <TILE_WHITE_MAGE_8, >TILE_WHITE_MAGE_8, $03, <TILE_WHITE_MAGE_9, >TILE_WHITE_MAGE_9, $03, <TILE_WHITE_MAGE_10, >TILE_WHITE_MAGE_10, $ff

; 428 - 8192
.res 7764

