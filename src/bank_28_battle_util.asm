.segment "BANK_28"

.include "src/global-import.inc"

.import BattleRNG, WaitForVBlank, MusicPlay
.import LoadBattleFormationInto_btl_formdata, Battle_PPUOff, SetPPUAddr_XA, BattleBox_vAXY, BattleBox_vAXY, Battle_PlayerBox, LoadBattleAttributeTable
.import LoadBattlePalette, DrawBattleBackdropRow, PrepBattleVarsAndEnterBattle
.import BattleDraw_AddBlockToBuffer, ClearUnformattedCombatBoxBuffer, DrawBlockBuffer

.export BattleScreenShake, BattleUpdateAudio_FixedBank, Battle_UpdatePPU_UpdateAudio_FixedBank, ClearBattleMessageBuffer, EnterBattle, DrawDrinkBox
.export DrawBattle_Division

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Combat Drink Box lut    [$FA16 :: 0x3FA26]
;;
;;      The weird miniature box that pops up for the DRINK menu

lut_CombatDrinkBox:
;       hdr    X    Y   wd   ht 
  .byte $00, $03, $01, $0C, $06
  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Enter Battle  [$F28D :: 0x3F29D]
;;
;;    Called to initiate a battle.  Does a lot of prepwork, then calls
;;  another routine to do more prepwork and enter the battle loop.
;;
;;    This routine assumes some CHR and palettes have already been loaded.
;;  Specifically... LoadBattleCHRPal should have been called prior to this routine.
;;
;;    Also somewhat oddly, absolute mode is forced for a lot of zero page vars
;;  here (hence all the "a:" crap).  I have yet to understand that.  Must've been
;;  an assembler quirk.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EnterBattle:
    CALL WaitForVBlank       ; wait for VBlank and do Sprite DMA
    LDA #>oam                 ;  this seems incredibly pointless as the screen is turned
    STA OAMDMA                 ;  off at this point

    ;; Load formation data to buffer in RAM

    FARCALL LoadBattleFormationInto_btl_formdata

    ;; Turn off PPU and clear nametables

    LDA #0
    STA menustall           ; disable menu stalling
    CALL Battle_PPUOff         ; turn PPU off
    LDA PPUSTATUS                 ; reset PPU toggle

    LDX #>PPUCTRL
    LDA #<PPUCTRL
    CALL SetPPUAddr_XA         ; set PPU address to PPUCTRL (start of nametable)

    LDY #8                    ; loops to clear $0800 bytes of NT data (both nametables)
    @ClearNT_OuterLoop:
        LDX #0
        @ClearNT_InnerLoop:         ; inner loop clears $100 bytes
            STA PPUDATA
            DEX
            BNE @ClearNT_InnerLoop
        DEY                       ; outer loop runs inner loop 8 times
        BNE @ClearNT_OuterLoop    ;  clearing $800 bytes total

    ;; Draw Various (hardcoded) boxes on the screen

    LDA #1              ; box at 1,1
    STA box_x         ; with dims 16,18
    LDX #16             ;  this is the box housing the enemies (big box on the left)
    LDY #18
    CALL BattleBox_vAXY

    LDA #17             ; box at 17,1
    STA box_x         ; with dims 8,16
    LDA #1              ;  this is the box housing the player sprites (box on right)
    LDX #8
    LDY #18
    CALL BattleBox_vAXY

    LDA #25               ; draw the four boxes that will house player stats
    LDX #21               ; draw them from the bottom up so that top boxes appear to lay over
    CALL Battle_PlayerBox  ;  top of the bottom boxes
    LDX #15
    CALL Battle_PlayerBox
    LDX #9
    CALL Battle_PlayerBox
    LDX #3
    CALL Battle_PlayerBox

    FARCALL LoadBattleAttributeTable

    ;; Load palettes

    LDX #0
    @PalLoop:                   ; copy the loaded palettes (backdrop, menu, sprites)
        LDA cur_pal, X          ;  to the battle palette buffer
        STA btl_palettes, X
        INX
        CPX #$20
        BNE @PalLoop            ; all $20 bytes

    LDA btlform_plts          ; use the formation data to get the ID of the palettes to load
    LDY #4                    ;   load the first one into the 2nd palette slot ($xxx4)
    FARCALL LoadBattlePalette
    LDA btlform_plts+1        ;   and the second one into the 3rd slot ($xxx8)
    LDY #8
    FARCALL LoadBattlePalette

  ;; Draw the battle backdrop

    LDA #<$2042                 ; draw the first row of the backdrop
    LDY #0<<2                   ;  to $2042
    FARCALL DrawBattleBackdropRow
    LDA #<$2062                 ; then at $2062
    LDY #1<<2                   ;   draw the next row
    FARCALL DrawBattleBackdropRow
    LDA #<$2082                 ; etc
    LDY #2<<2
    FARCALL DrawBattleBackdropRow
    LDA #<$20A2
    LDY #3<<2
    FARCALL DrawBattleBackdropRow   ; 4 rows total

  ;; Clear the '$FF' tile so it's fully transparent instead of
  ;;   fully solid (normally is innards of box body)

    CALL WaitForVBlank     ; wait for VBlank again  (why!  PPU is off!)
    LDX #>$0FF0
    LDA #<$0FF0             ;  set PPU addr to $0FF0 (CHR for tile $FF)
    CALL SetPPUAddr_XA

    LDA #0
    LDX #$10
  @ClearFFLoop:
      STA PPUDATA             ; write $10 zeros to clear the tile
      DEX
      BNE @ClearFFLoop

    LDA #BANK_BATTLE        ; swap in the battle bank
    STA battle_bank
    FARJUMP PrepBattleVarsAndEnterBattle            ; and jump to battle routine!

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  BattleScreenShake  [$F440 :: 0x3F450]
;;
;;  Shakes the screen for a few frames (when an enemy attacks)
;;
;;  This routine takes 13 frames, and during that time, the sound effects
;;  are NOT updated.  This results in the sound effect the game makes when
;;  an enemy attacks to hang on the low-pitch 'BOOM' noise longer than
;;  its sound effect data indicates it should.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BattleScreenShake:
    LDA #$06
    STA loop_counter           ; loop down counter.  6*2 = 12 frames  (2 frames per loop)
  @Loop:
      CALL @Stall2Frames ; wait 2 frames
      
      FARCALL BattleRNG
      AND #$03          ; get a random number betwee 0-3
      STA PPUSCROLL         ; use as X scroll
      FARCALL BattleRNG
      AND #$03          ; another random number
      STA PPUSCROLL         ; for Y scroll
      
      DEC loop_counter
      BNE @Loop
    
    JUMP Battle_UpdatePPU_UpdateAudio_FixedBank  ; 1 more frame (with reset scroll)
    
    
  @Stall2Frames:
    CALL @Frame          ; do 1 frame
    LDX #$00            ; wait around -- presumably so we don't try
    : NOP               ;   to wait during VBlank (even though that wouldn't
      NOP               ;   be a problem anyway)
      NOP
      DEX
      BNE :-            ; flow into doing another frame
    
  @Frame:
    CALL WaitForVBlank
    JUMP BattleUpdateAudio_FixedBank


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Battle_UpdatePPU_UpdateAudio_FixedBank  [$F485 :: 0x3F495]
;;
;;  Resets scroll and PPUMASK, then updates audio.
;;
;;  Used by only a few routines in the fixed bank.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Battle_UpdatePPU_UpdateAudio_FixedBank:
    LDA btl_soft2001
    STA PPUMASK
    LDA #$00            ; reset scroll
    STA PPUSCROLL
    STA PPUSCROLL
    NOJUMP BattleUpdateAudio_FixedBank

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  BattleUpdateAudio_FixedBank  [$F493 :: 0x3F4A3]
;;
;;  Same idea as BattleUpdateAudio from bank $C... just in the fixed bank.
;;
;;  Note that this routine does NOT update battle sound effects.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
BattleUpdateAudio_FixedBank:
    LDA a:music_track
    BPL :+
      LDA btl_followupmusic
      STA a:music_track
    :   
    FARJUMP MusicPlay


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  ClearBattleMessageBuffer  [$F620 :: 0x3F630]
;;
;;  Clears the battle message buffer in memory, but does not do any actual drawing.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ClearBattleMessageBuffer:
    ; Clear the message buffer
    LDY #$00
    LDA #$00
    : STA btl_msgbuffer, Y      ; clear the message buffer
      STA btl_msgbuffer+$80, Y  ;   (write $180 bytes)
      INY
      BNE :-
    
    ; After the message buffer is clear, it has to draw the bottom row of the
    ;  bounding box for the enemies/player.  This gets drawn over by other boxes.
    
    LDA #$FD                    ; tile FD is the bottom-box tile
    : STA btl_msgbuffer+1, Y    ; draw the row
      INY
      CPY #$17
      BNE :-
    
    LDA #$FC                    ; FC = lower left corner tile
    STA btl_msgbuffer+$01       ; for enemy box
    STA btl_msgbuffer+$11       ; for player box
    LDA #$FE                    ; FE = lower right corner tile
    STA btl_msgbuffer+$10       ; for enemy box
    STA btl_msgbuffer+$18       ; for player box
    
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawDrinkBox  [$F921 :: 0x3F931]
;;
;;    Draws the "Drink box" that appears in the battle menu when the player
;;  selects the DRINK option in the battle menu
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawDrinkBox:
    LDY #$05
    : 
    LDA lut_CombatDrinkBox-1, Y       ; load the specs for the drink box
    STA btl_msgdraw_hdr-1, Y          ; -1 because Y is 1-based
    DEY
    BNE :-
    
    CALL BattleDraw_AddBlockToBuffer     ; add the box to the block buffer
    
    CALL ClearUnformattedCombatBoxBuffer ; clear the unformatted buffer (we'll be drawing to it)
    
    INC btl_msgdraw_hdr                 ; For text, hdr=1
    INC btl_msgdraw_x                   ; move text right+down 1 tile from where the box was drawn
    INC btl_msgdraw_y
    LDA btl_potion_heal
    BEQ :+                              ; if there are any heal potions
        STA btl_unfmtcbtbox_buffer + 5    ; set buffer to:   FF 0E 19 FF 11 xx xx 00  noting:
        LDA #$11                          ;   FF       = space
        STA btl_unfmtcbtbox_buffer + 4    ;   0E 19    = 0E prints an item name, 19 indicates the Heal Potion item
        LDA #$19                          ;   11 xx xx = 11 prints a number, xx xx is the qty (which in this case is 
        STA btl_unfmtcbtbox_buffer + 2    ;                  the number of potions
        LDA #$0E
        STA btl_unfmtcbtbox_buffer + 1
    : 
    LDA #$00
    STA btl_unfmtcbtbox_buffer + 6      ; The high byte of the qty
    STA btl_unfmtcbtbox_buffer + 7      ; The null terminator
    
    LDA #<btl_unfmtcbtbox_buffer        ; set the block pointer to the data
    STA btl_msgdraw_srcptr
    LDA #>btl_unfmtcbtbox_buffer
    STA btl_msgdraw_srcptr+1
    CALL BattleDraw_AddBlockToBuffer     ; and add the block (drawing the Heal Potions)
    
    INC btl_msgdraw_y                   ; move down 2 rows for Pure portions
    INC btl_msgdraw_y
    LDA btl_potion_pure
    BEQ :+
        STA btl_unfmtcbtbox_buffer + $25  ; Exact same deal as above, only it works for the Pure Potion
        LDA #$11
        STA btl_unfmtcbtbox_buffer + $24
        LDA #$1A
        STA btl_unfmtcbtbox_buffer + $22
        LDA #$0E
        STA btl_unfmtcbtbox_buffer + $21
    : 
    LDA #$00
    STA btl_unfmtcbtbox_buffer + $26
    STA btl_unfmtcbtbox_buffer + $27
    
    LDA #<(btl_unfmtcbtbox_buffer + $20)
    STA btl_msgdraw_srcptr
    LDA #>(btl_unfmtcbtbox_buffer + $20)
    STA btl_msgdraw_srcptr+1
    CALL BattleDraw_AddBlockToBuffer     ; add the block for the Pure potions
    
    JUMP DrawBlockBuffer                 ; then draw the actual blocks and exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattle_Division   [$FAFC :: 0x3FB0C]
;;
;;    Kind of a junky division routine that is used by FormatBattleString
;;  to draw numerical values.
;;
;;  end result:
;;                  A = btltmp6,7 / YX
;;          btltmp6,7 = btltmp6,7 % YX   (remainder)
;;
;;    This division routine is a simple "keep subtracting until we
;;  fall below zero".  Which means that if btltmp+6,7 is zero, the
;;  routine will loop forever and the game will deadlock.  This routine
;;  is kind of junky.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattle_Division:
    LDA #$00
    STA btl_magdataptr         ; initialize result with zero
  @Loop:
    STX btlsfxnse_len
    LDA btltmp+6
    SEC
    SBC btlsfxnse_len
    PHA             ; low byte = btlsfxnse_len-X, back it up
    
    STY btlsfxnse_len
    LDA btltmp+7
    SBC btlsfxnse_len         ; high byte = $97-Y
    
    BMI @Done       ; if result is negative, we're done
    
    INC btl_magdataptr         ; otherwise, increment our result counter
    STA btltmp+7    ; overwrite btltmp+6 with the result of the subtraction
    PLA
    STA btltmp+6
    JUMP @Loop       ; and keep going until we fall below zero
    
  @Done:            ; once the result is negative
    PLA             ; throw away the back-up byte
    LDA btl_magdataptr         ; and put the result in A before exiting
    RTS
