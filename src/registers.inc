;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PPU I/O regs (CPU side)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;   PPU_CTRL:
;   0-1: Name table address, changes between the four name tables at $2000 (0), $2400 (1), $2800 (2) and $2C00 (3).
;   2: Clear, PPU incs by 1 ("horizontal"); Set, PPU incs by 32 ("vertical")
;   3: Which pattern table holds for sprites; 0 for PT1 ($0000) or 1 for PT2 ($1000)
;   4: Which pattern table holds for BG; 0 for PT1 ($0000) or 1 for PT2 ($1000)
;   5: Set to use 8x16 sprites instead of 8x8
;   6:
;   7: Set to generate VBlank NMIs
PPU_CTRL            := $2000     ; Write only

;   PPU_MASK:
;   0: Clear for color, set for mono
;   1: Clear to clip 8 left pixels of BG
;   2: Clear to clip 8 left pixels of sprites
;   3: If clear, BG hidden
;   4: If clear, sprites hidden
;   5-7: BG color in mono mode, "color intensity" in color mode (??)
PPU_MASK            := $2001     ; Write only

;   PPU_STATUS:
;   4: if set, can write to VRAM, else writes ignored
;   5: if set, sprite overflow occurred on scanline
;   6: Set if any non-transparent pixel of sprite 0 is overlapping a non-transparent pixel of BG
;   7: VBlank is occurring (cleared after read)
PPU_STATUS          := $2002

; Sprites: 256 bytes, each sprite takes 4, so 64 sprites total
; Only 8 sprites per scanline, sprite 0 is drawn on top (thus highest priority)
; PPU_SPR_ADDR / PPU_SPR_DATA
; * Byte 0 - Stores the y-coordinate of the top left of the sprite minus 1.
; * Byte 1 - Index number of the sprite in the pattern tables.
; * Byte 2 - Stores the attributes of the sprite.
;   * Bits 0-1 - Most significant two bits of the colour.  (Or "palette" 0-3)
;   * Bit 5 - Indicates whether this sprite has priority over the background.
;   * Bit 6 - Indicates whether to flip the sprite horizontally.
;   * Bit 7 - Indicates whether to flip the sprite vertically.
; * Byte 3 - X coordinate
OAM_ADDR        := $2003     ; Set address sprite data
OAM_DATA        := $2004     ; Read or write this sprite byte
OAM_DMA         := $4014     ; Sprite DMA Register -- DMA from CPU memory at $100 x n to SPR-RAM (256 bytes)

PPU_SCROLL     := $2005     ; Scroll register; read PPU_STAT, then write horiz/vert scroll
PPU_ADDR       := $2006     ; VRAM address (first write is high, next write is low)
PPU_DATA       := $2007     ; Data to read/write at this address

; Note that all transparent colors ($3F04, $3F08, $3F0C, $3F10, $3F14, $3F18 and $3F1C) are mirrored from 3F00
PPU_BG_PAL          := $3F00     ; 3F00-3F0F
PPU_SPR_PAL         := $3F10     ; 3F10-3F1F

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SOUND I/O regs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; $4000(rct1)/$4004(rct2)/$400C(noise) bits
; ---------------------------------------
; 0-3   volume / envelope decay rate
; 4 envelope decay disable
; 5 length counter clock disable / envelope decay looping enable
; 6-7   duty cycle type (unused on noise channel)

; Duty cycles:
; 00 = a weak, grainy tone.  (12.5% Duty), 01 = a solid mid-strength tone. (25% Duty),
; 10 = a strong, full tone (50% Duty), 11 = sounds a lot like 01 (25% Duty negated)

PAPU_CTL1           := $4000 ; pAPU Pulse 1 Control Register.
PAPU_CTL2           := $4004 ; pAPU Pulse 2 Control Register.
PAPU_NCTL1          := $400C ; pAPU Noise Control Register 1.


; $4008(tri) bits
; ---------------
; 0-6   linear counter load register
; 7 length counter clock disable / linear counter start
PAPU_TCR1           := $4008 ; pAPU Triangle Control Register 1.


; $4001(rct1)/$4005(rct2) bits
; --------------------------
; 0-2   right shift amount
; 3 decrease / increase (1/0) wavelength
; 4-6   sweep update rate
; 7 sweep enable
PAPU_RAMP1          := $4001 ; pAPU Pulse 1 Ramp Control Register.
PAPU_RAMP2          := $4005 ; pAPU Pulse 2 Ramp Control Register.


; $4002(rct1)/$4006(rct2)/$400A(Tri) bits
; -------------------------------------
; 0-7   8 LSB of wavelength
PAPU_FT1            := $4002 ; pAPU Pulse 1 Fine Tune (FT) Register.
PAPU_FT2            := $4006 ; pAPU Pulse 2 Fine Tune (FT) Register.
PAPU_TFREQ1         := $400A ; pAPU Triangle Frequency Register 1.


; $400E(noise) bits
; -----------------
; 0-3   playback sample rate
; 4-6   unused
; 7 random number type generation
PAPU_NFREQ1         := $400E ; pAPU Noise Frequency Register 1.

; $4003(rct1)/$4007(rct2)/$400B(tri)/$400F(noise) bits
; --------------------------------------------------
; 0-2   3 MS bits of wavelength (unused on noise channel) (the "high" frequency)
; 3-7   length of tone
PAPU_CT1            := $4003 ; pAPU Pulse 1 Coarse Tune (CT) Register.
PAPU_CT2            := $4007 ; pAPU Pulse 2 Coarse Tune (CT) Register.
PAPU_TFREQ2         := $400B ; pAPU Triangle Frequency Register 2.
PAPU_NFREQ2         := $400F ; pAPU Noise Frequency Register 2.

; $4010 - DMC Play mode and DMA frequency

; Bits 0-3:
;    f   period
;    ----------
;    0   $1AC
;    1   $17C
;    2   $154
;    3   $140
;    4   $11E
;    5   $0FE
;    6   $0E2
;    7   $0D6
;    8   $0BE
;    9   $0A0
;    A   $08E
;    B   $080
;    C   $06A
;    D   $054
;    E   $048
;    F   $036
; Bits 6-7: this is the playback mode.
;   00 - play DMC sample until length counter reaches 0 (see $4013)
;   x1 - loop the DMC sample (x = immaterial)
;   10 - play DMC sample until length counter reaches 0, then generate a CPU
PAPU_MODCTL         := $4010 ; pAPU Delta Modulation Control Register.

PAPU_MODDA          := $4011 ; pAPU Delta Modulation D/A Register.
PAPU_MODADDR        := $4012 ; pAPU Delta Modulation Address Register.
PAPU_MODLEN         := $4013 ; pAPU Delta Modulation Data Length Register.

; read
; ----
; 0 rectangle wave channel 1 length counter status
; 1 rectangle wave channel 2 length counter status
; 2 triangle wave channel length counter status
; 3 noise channel length counter status
; 4 DMC is currently enabled (playing a stream of samples)
; 5 unknown
; 6 frame IRQ status (active when set)
; 7 DMC's IRQ status (active when set)
;
; write
; -----
; 0 rectangle wave channel 1 enable
; 1 rectangle wave channel 2 enable
; 2 triangle wave channel enable
; 3 noise channel enable
; 4 enable/disable DMC (1=start/continue playing a sample;0=stop playing)
; 5-7   unknown
PAPU_EN             := $4015 ; R/W pAPU Sound Enable

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; OTHER I/O regs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Read / Write Joypad 1/2:
;                   *  Bit 0 - Reads data from joypad or causes joypad strobe
;                      when writing.
;                   *  Bit 3 - Indicates whether Zapper is pointing at a sprite.
;                   *  Bit 4 - Cleared when Zapper trigger is released.
;                   Only bit 0 is involved in writing.
JOYPAD              := $4016

; Frame counter control
; Changes the frame counter that changes updates on sound; any write resets
; the frame counter, good for synchronizing sound with VBlank etc.
; 0        4, 0,1,2,3, 0,1,2,3,..., etc.
; 1        0,1,2,3,4, 0,1,2,3,4,..., etc.
; bit 6 - enable frame IRQs (when zero)
; bit 7 - 0 = 60 IRQs a frame / 1 = 48 IRQs a frame (obviously need bit 6 clear to use)
; Interestingly, both of the above are clear on bootup, meaning IRQs are being generated,
; but the 6502 ignores NMIs on startup; also, need to read from $4015 (PAPU_EN) to acknowledge
; the interrupt, otherwise it holds the status on!
FRAMECTR_CTL        := $4017

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MMC5 regs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MIRROR_HORIZONTAL   = $44
MIRROR_VERTICAL     = $50

MMC5_PRG_MODE       := $5100
MMC5_CHR_MODE       := $5101
MMC5_EXRAM_MODE     := $5104
MMC5_MIRROR         := $5105
MMC5_RAM_PROTECT_1  := $5102
MMC5_RAM_PROTECT_2  := $5103
MMC5_IRQ_COUNTER    := $5203
MMC5_IRQ_STATUS     := $5204
MMC5_UPPER_CHR_BANK := $5130
MMC5_SPLIT_MODE     := $5200

; RAM and program banks
MMC5_RAM_BANK       := $5113 ; $6000-$7FFF
MMC5_PRG_BANK0      := $5114 ; $8000-$9FFF
MMC5_PRG_BANK1      := $5115 ; $A000-$BFFF
MMC5_PRG_BANK2      := $5116 ; $C000-$DFFF
MMC5_PRG_BANK3      := $5117 ; $E000-$FFFF

; Sprite banks
MMC5_SPRITE_CHR_BANK0      := $5120 ; $0000-$03FF
MMC5_SPRITE_CHR_BANK1      := $5121 ; $0400-$07FF
MMC5_SPRITE_CHR_BANK2      := $5122 ; $0800-$0BFF
MMC5_SPRITE_CHR_BANK3      := $5123 ; $0C00-$0FFF
MMC5_SPRITE_CHR_BANK4      := $5124 ; $1000-$13FF
MMC5_SPRITE_CHR_BANK5      := $5125 ; $1400-$17FF
MMC5_SPRITE_CHR_BANK6      := $5126 ; $1800-$1BFF
MMC5_SPRITE_CHR_BANK7      := $5127 ; $1C00-$1FFF

; Background banks
MMC5_BACKGROUND_CHR_BANK0      := $5128 ; $0000-$03FF and $1000-$13FF
MMC5_BACKGROUND_CHR_BANK1      := $5129 ; $0400-$07FF and $1400-$17FF
MMC5_BACKGROUND_CHR_BANK2      := $512A ; $0800-$0BFF and $1800-$1BFF
MMC5_BACKGROUND_CHR_BANK3      := $512B ; $0C00-$0FFF and $1C00-$1FFF

; Multiplier
MMC5_MULTI_1        := $5205
MMC5_MULTI_2        := $5206

; Audio
MMC5_PCM_MODE_IRQ   := $5100
