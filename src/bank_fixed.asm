.segment "BANK_FIXED"

.include "src/registers.inc"
.include "src/constants.inc"
.include "src/macros.inc"
.include "src/ram-definitions.inc"

.import EnterMinimap
.import data_EnemyNames, PrepBattleVarsAndEnterBattle, lut_BattleRates, data_BattleMessages, lut_BattleFormations
.import lut_BattlePalettes
.import EnterEndingScene, MusicPlay, EnterMiniGame, EnterBridgeScene, __Nasir_CRC_High_Byte
.import PrintNumber_2Digit, PrintPrice, PrintCharStat, PrintGold
.import TalkToObject, EnterLineupMenu, NewGamePartyGeneration
.import EnterMainMenu, EnterShop, EnterTitleScreen, EnterIntroStory
.import data_EpilogueCHR, data_EpilogueNT, data_BridgeNT
.import EnvironmentStartupRoutine
.import BattleRNG, GetSMTargetCoords, CanTalkToMapObject
.import DrawMMV_OnFoot, Draw2x2Sprite, DrawMapObject, AnimateAndDrawMapObject, UpdateAndDrawMapObjects, DrawSMSprites, DrawOWSprites, DrawPlayerMapmanSprite, AirshipTransitionFrame
.import ResetRAM, SetRandomSeed, GetRandom, LoadBatSprCHRPalettes_NewGame
.import OpenTreasureChest, AddGPToParty, LoadPrice, LoadBattleBackdropPalette
.import LoadMenuBGCHRAndPalettes, LoadMenuCHR, LoadBackdropPalette, LoadShopBGCHRPalettes, LoadTilesetAndMenuCHR
.import GameStart, LoadOWTilesetData, GetBattleFormation, LoadMenuCHRPal, LoadBatSprCHRPalettes
.import OW_MovePlayer, OWCanMove, OverworldMovement, SetOWScroll, SetOWScroll_PPUOn, MapPoisonDamage, StandardMapMovement, CanPlayerMoveSM
.import UnboardBoat, UnboardBoat_Abs, Board_Fail, BoardCanoe, BoardShip, DockShip, IsOnBridge, IsOnCanal, FlyAirship, AnimateAirshipLanding, AnimateAirshipTakeoff, GetOWTile, LandAirship
.import ProcessOWInput, GetSMTileProperties, GetSMTilePropNow, TalkToSMTile, PlaySFX_Error, PrepDialogueBoxRow, SeekDialogStringPtr, GetBattleMessagePtr

; bank_10_overworld_object
.import MapObjectMove, AimMapObjDown, LoadMapObjects, DrawMapObjectsNoUpdate
; bank_1E_util
.import DisableAPU, ClearOAM, Dialogue_CoverSprites_VBl, UpdateJoy, PrepAttributePos
; bank_18_screen_wipe
.import ScreenWipe_Open, ScreenWipe_Close
; bank_16_overworld_tileset
.import LoadSMTilesetData
; bank_19_menu
.import MenuCondStall
; bank_1A_string
.import DrawComplexString_New, DrawItemBox, SeekItemStringAddress, SeekItemStringPtr, SeekItemStringPtrForEquip, DrawEquipMenuStrings
; bank_1B_map_chr
.import LoadOWBGCHR
; bank_1C_mapman_chr
.import LoadPlayerMapmanCHR
; bank_1D_world_map_obj_chr
.import LoadOWObjectCHR
; bank_1E_util

; bank_1F_standard_map_obj_chr
.import LoadMapObjCHR
; bank_20_battle_bg_chr
.import LoadBattleBackdropCHR, LoadBattleFormationCHR, LoadBattleBGPalettes, LoadBattleCHRPal, LoadBattlePalette, DrawBattleBackdropRow, LoadBattleAttributeTable, LoadBattleFormationInto_btl_formdata
; bank_21_altar
.import DoAltarEffect
; bank_22_bridge
.import LoadBridgeSceneGFX
; bank_23_epilogue
.import LoadEpilogueSceneGFX
; bank_24_sound_util
.import PlayDoorSFX, DialogueBox_Sfx, VehicleSFX
; bank_25_standard_map
.import PrepStandardMap, EnterStandardMap, ReenterStandardMap, LoadNormalTeleportData, LoadExitTeleportData, DoStandardMap
; bank_26_map
.import LoadMapPalettes, BattleTransition, StartMapMove, DrawMapAttributes, DoMapDrawJob
; bank_27_overworld_map
.import LoadOWCHR, EnterOverworldLoop, PrepOverworld, DoOverworld, LoadEntranceTeleportData, DoOWTransitions
; bank_28_battle_util
.import BattleUpdateAudio_FixedBank, Battle_UpdatePPU_UpdateAudio_FixedBank, ClearBattleMessageBuffer, EnterBattle
.import DrawBattle_Division, DrawCombatBox, BattleDrawMessageBuffer, Battle_PPUOff, BattleBox_vAXY, BattleWaitForVBlank
.import BattleDrawMessageBuffer_Reverse, UndrawBattleBlock, DrawBattleBox, DrawRosterBox, DrawBattle_Number
; bank_2A_draw_util
.import DrawBox, CyclePalettes
; bank_2B_dialog_util
.import ShowDialogueBox, EraseBox
; bank_2C_dialog_string
.import DrawDialogueString

.export DrawImageRect
.export DrawPalette
.export WaitForVBlank
.export SwapBtlTmpBytes, FormatBattleString
.export Battle_WritePPUData
.export UndrawNBattleBlocks, DrawCommandBox
.export BattleCrossPageJump
.export Impl_FARCALL, Impl_FARJUMP,Impl_NAKEDJUMP, Impl_FARBYTE, Impl_FARBYTE2, Impl_FARPPUCOPY
.export CHRLoadToA
.export WaitScanline, SetSMScroll
.export EnterOW_PalCyc
.export Copy256, CHRLoad, CHRLoad_Cont
.export CoordToNTAddr
.export DrawMapPalette, lut_CombatItemMagicBox
.export SetPPUAddr_XA, lut_EnemyRosterStrings
.export DrawMapRowCol, SetBattlePPUAddr, Battle_DrawMessageRow_VBlank
.export PrepRowCol, BattleDraw_AddBlockToBuffer, ClearUnformattedCombatBoxBuffer, DrawBlockBuffer
.export LoadOWMapRow, PrepRowCol, ScrollUpOneRow, LoadStandardMap, SetPPUAddrToDest
.export Battle_DrawMessageRow, DrawBattleBoxAndText, DrawBattleBox_Row, BattleMenu_DrawMagicNames
.export DrawBattleString_DrawChar, DrawBattleString_IncDstPtr

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Wait a Scanline  [$D788 :: 0x3D798]
;;
;;    JSRing to this routine eats up exactly 109 cycles 2 times out of 3, and 108
;;  cycles 1 time out of 3.  So it effectively eats 108.6667 cycles.  This includes
;;  the CALL.  When placed inside a simple 'DEX/BNE' loop (DEX+BNE = 5 cycles), it
;;  burns 113.6667 cycles, which is EXACTLY one scanline.
;;
;;    This is used as a timing mechanism for some PPU effects like the screen
;;  wipe transition that occurs when you switch maps.
;;
;;    tmp+2 is used as the 3-step counter to switch between waiting 108 and 109
;;  cycles.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

WaitScanline:
    LDY #16          ; +2 cycles
   @Loop:
      DEY            ;   +2
      BNE @Loop      ;   +3  (5 cycle loop * 16 iterations = 80-1 = 79 cycles for loop)

  CRITPAGECHECK @Loop      ; ensure above loop does not cross page boundary

    LDA tmp+2        ; +3
    DEC tmp+2        ; +5
    BNE @NoReload    ; +3 (if no reload -- 2/3)
                     ;   or +2 (if reload -- 1/3)

  CRITPAGECHECK @NoReload  ; ensure jump to NoReload does not require jump across page boundary

  @Reload:
    LDA #3           ; +2   Both Reload and NoReload use the same
    STA tmp+2        ; +3    amount of cycles.. but Reload reloads tmp+2
    RTS              ; +6    with 3 so that it counts down again

  @NoReload:
    LDA #0           ; +2
    LDA tmp+2        ; +3   LDA -- not STA.  It's just burning cycles, not changing tmp+2
    RTS              ; +6

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Enter Overworld -- PalCyc   [$C762 :: 0x3C772]
;;
;;    Enters the overworld with the palette cycling effect
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

EnterOW_PalCyc:
    FARCALL PrepOverworld       ; do all necessary overworld preparation
    LDA #$01
    FARCALL CyclePalettes       ; cycle palettes with code=01 (overworld, reverse cycle)
    NAKEDJUMP EnterOverworldLoop  ; then enter the overworld loop

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Set SM Scroll  [$CCA1 :: 0x3CCB1]
;;
;;     Sets the scroll for the standard maps.
;;
;;    Changes to SetSMScroll can impact the timing of some raster effects.
;;  See ScreenWipeFrame for details.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetSMScroll:
    LDA NTsoft2000      ; get the NT scroll bits
    STA soft2000        ; and record them in both soft2000
    STA PPUCTRL           ; and the actual PPUCTRL

    LDA sm_scroll_x     ; get the standard map scroll position
    ASL A
    ASL A
    ASL A
    ASL A               ; *16 (tiles are 16 pixels wide)
    ORA move_ctr_x      ; OR with move counter (effectively makes the move counter the fine scroll)
    STA PPUSCROLL           ; write this as our X scroll

    LDA scroll_y        ; get scroll_y
    ASL A
    ASL A
    ASL A
    ASL A               ; *16 (tiles are 16 pixels tall)
    ORA move_ctr_y      ; OR with move counter
    STA PPUSCROLL           ; and set as Y scroll

    RTS                 ; then exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  ScrollUpOneRow  [$D102 :: 0x3D112]
;;
;;    This is used by DrawFullMap to "scroll" up one row so that
;;  the next row can be drawn.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ScrollUpOneRow:
    LDA mapflags        ; see if this is OW or SM by checking map flags
    LSR A
    BCC @OW             ; if OW, jump ahead to OW

  @SM:
    LDA sm_scroll_y     ; otherwise (SM), subtract 1 from the sm_scroll
    SEC
    SBC #$01
    AND #$3F            ; and wrap where needed
    STA sm_scroll_y

    JUMP @Finalize

  @OW:
    LDA ow_scroll_y     ; if OW, subtract 1 from ow_scroll
    SEC
    SBC #$01
    STA ow_scroll_y

  @Finalize:
    LDA scroll_y        ; then subtract 1 from scroll_y
    SEC
    SBC #$01
    BCS :+
      ADC #$0F          ; and wrap 0->E
    :   
    STA scroll_y
    RTS                 ; then exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Load Standard Map   [$D126 :: 0x3D136]
;;
;;  Called to load the standard 64x64 tile maps (towns, dungeons, etc.. anything that isn't overworld)
;;
;;  TMP:  tmp to tmp+5 used
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadStandardMap:
    LDA #BANK_STANDARDMAPS
    CALL SwapPRG     ; swap to bank containing start of standard maps
    LDA cur_map       ; get current map ID
    ASL A             ; double it, and throw it in X (to get index for pointer table)
    TAX
    LDA lut_SMPtrTbl, X   ; get low byte of pointer
    STA tmp               ; put in tmp (low byte of our source pointer)
    LDA lut_SMPtrTbl+1, X ; get high byte of pointer
    TAY                   ; copy to Y (temporary hold)
    AND #$3F          ; convert pointer to useable CPU address (bank will be loaded into $8000-FFFF)
    ORA #$80          ;   AND with #$3F and ORA with #$80 will determine where in the bank the map will start
    STA tmp+1         ; put converted high byte to our pointer.  (tmp) is now the pointer to the start of the map
                      ;   provided the proper bank is swapped in
    TYA               ; restore original high byte of pointer
    ROL A
    ROL A                  ; right shift it by 6 (high 2 bytes become low 2 bytes).
    ROL A                  ;    These ROLs are a shorter way to do it than LSRs.  Effectively dividing the pointer by PAPU_CTL1
    AND #$03               ; mask out low 2 bits (gets bank number for start of this map)
    ORA #BANK_STANDARDMAPS ; Add standard map bank (use ORA to avoid unwanted carry from above ROLs)
    STA tmp+5              ; put bank number in temp ram for future reference
    CALL SwapPRG          ; swap to desired bank
    LDA #<mapdata
    STA tmp+2
    LDA #>mapdata     ; set destination pointer to point to mapdata (start of decompressed map data in RAM).
    STA tmp+3         ; (tmp+2) is now the dest pointer, (tmp) is now the source pointer
    JUMP DecompressMap ; start decompressing the map

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Map routines' Semi-local RTS   [$D156 :: 0x3D166]
;;
;;   It is branched/jumped to by map loading routines
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Map_RTS:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Load World Map Row  [$D157 :: 0x3D167]
;;
;;  Called to load a single row of an overworld map.  Since only so many can be in RAM at once
;;    a new row needs to be loaded every time the player moves up or down on the overworld map.
;;
;;  IN:   mapflags  = indicates whether or not we're on the overworld map
;;        mapdraw_y = indicates which row needs to be loaded
;;
;;  TMP:  tmp to tmp+7 used
;;
;;  NOTES:  overworld map cannot cross bank boundary.  Entire map and all its pointers must all fit on one bank
;;     (which shouldn't be a problem).
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

LoadOWMapRow:
    LDA mapflags     ; get StandardMap flag (to test to see if we're really in the overworld or not)
    LSR A            ; shift flag into C
    BCS Map_RTS      ; if flag is set (in standard map), we're not in the overworld, so don't do anything -- just exit

    LDA #BANK_OWMAP  ;  swap to bank contianing overworld map
    CALL SwapPRG

    LDA #>lut_OWPtrTbl ;  set (tmp+6) to the start of the pointers for the rows of the OW map.
    STA tmp+7          ;   we will then index this pointer table to get the pointer for the start of the row
    LDA #<lut_OWPtrTbl ;  Need to use a pointer because there are 256 rows, which means 512 bytes for indexing
    STA tmp+6          ;    so normal indexing won't work -- have to use indirect mode

    LDA mapdraw_y    ;  Load the row we need to load
    TAX              ;  stuff it in X (temporary)
    ASL A            ;  double it (2 bytes per pointer)
    BCC :+           ;  if there was carry...
      INC tmp+7      ;     inc the high byte of our temp pointer
    :   
    TAY              ;  put low byte in Y for indexing
    LDA (tmp+6), Y   ;  load low byte of row pointer
    STA tmp          ;  put it in tmp
    INY              ;  inc our index
    LDA (tmp+6), Y   ;  load high byte, and put it in tmp+!
    STA tmp+1        ;  (tmp) is now our source pointer for the row

    TXA              ;  get our row number (previously stuffed in X)
    AND #$0F         ;  mask out the low 4 bits
    ORA #>mapdata    ;  and ORA with high byte of mapdata destination
    STA tmp+3        ;  use this as high byte of dest pointer (to receive decompressed map)
    LDA #<mapdata    ;   the row will be decompressed to $7x00-$7xFF
    STA tmp+2        ;   where 'x' is the low 4 bits of the row number
                     ;  (tmp+2) is now our dest pointer for the row
    NOJUMP DecompressMap

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DecompressMap
;;
;;   Decompressed a map from the given source buffer, and puts it in the given dest buffer
;;
;;  IN:  (tmp)   = pointer to source buffer (containing compressed map -- it's assumed it's between $8000-BFFF)
;;       (tmp+2) = pointer to dest buffer (to receive decompressed map.  typically $7xxx)
;;
;;  TMP: tmp to tmp+5 used
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DecompressMap:
    LDY #0          ;  zero Y, our index
    LDA (tmp), Y    ;  read a byte from source
    BPL @SingleTile ;  if high byte clear (not a run), jump ahead to place a single tile
    CMP #$FF        ;  otherwise check for $FF (termination code)
    BEQ Map_RTS     ;  if == $FF, branch to exit

    ; code reaches here if loaded source byte was $80-FE  (need a run of this tile)
    AND #$7F        ;  take low 7 bits (tile to run)
    STA tmp+4       ;  put tile in temp ram
    INC tmp         ;  inc low byte of src pointer (need to leave Y=0)
    BNE @TileRun    ;  if it didn't wrap, jump ahead to TileRun sublabel

      INC tmp+1     ;    low byte of src pointer wrapped, so inc high byte
      BIT tmp+1     ;    check to see if high byte went over $BF (crossed bank boundary)
      BVC @TileRun  ;    if it didn't, proceed to TileRun
      CALL @NextBank ;    otherwise, we need to swap in the next bank, first

  @TileRun:
    LDA (tmp), Y    ;   get next src byte (length of run)
    TAX             ;   put length of run in X
    LDA tmp+4       ;   get tile ID
  @RunLoop:
      STA (tmp+2), Y ;   write tile ID to dest buffer
      INY            ;   INY to increment our dest index
      BEQ @Full256   ;   if Y wrapped... this run was a full 256 tiles long (maximum).  Jump ahead
      DEX            ;   decrement X (our run length)
      BNE @RunLoop   ;   if it isn't zero yet, we jump back to the loop

      TYA            ;   add Y to the low byte of our dest pointer
      CLC
      ADC tmp+2
      STA tmp+2
      BCC :+              ;   if adding Y caused a carry, we'll need to inc the high byte
    @Full256:
        INC tmp+3         ;   inc high byte of dest pointer
 :    INC tmp             ;   inc low byte of src pointer
      BNE DecompressMap   ;   if it didn't wrap, jump back to main map loading loop
      JUMP @IncSrcHigh     ;   otherwise (did wrap), need to increment the high byte of the source pointer

  @SingleTile:
    STA (tmp+2), Y       ;  write tile to dest buffer
    INC tmp+2            ;  increment low byte of dest pointer
    BNE :+               ;  if it wrapped...
      INC tmp+3          ;     inc high byte of dest pointer
 :  INC tmp              ;  inc low byte of src pointer
    BNE DecompressMap    ;  if no wrapping, just continue with map decompression.  Otherwise...

  @IncSrcHigh:
    INC tmp+1            ;  increment high byte of source pointer
    BIT tmp+1            ;  check to see if we've reached end of PRG bank (BIT will set V if the value is >= $C0)
    BVC DecompressMap    ;  if we haven't, just continue with map decompression
    CALL @NextBank        ;  otherwise swap in the next bank
    JUMP DecompressMap    ;  and continue decompression

    ;; NextBank local subroutine
    ;;  called via CALL when a map crosses a bank boundary (so a new bank needs to be swapped in)
    @NextBank:
    LDA #>$8000   ; reset high byte of source pointer to start of the bank:  $8000
    STA tmp+1
    LDA tmp+5     ; get original bank number
    CLC
    ADC #$01      ; increment it by 1
    JUMP SwapPRG ; swap that new bank in and exit
    RTS           ; useless RTS (impossible to reach)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Prep Standard Map Row or Column [$D1E4 :: 0x3D1F4]
;;
;;   Preps the TSA and Attribute bytes of the given row of a Standard map for drawing
;;    Standard maps mainly.  Overworld does not always use this routine.  See PrepRowCol
;;
;;   Data loaded is put in the intermediate drawing buffer to be later drawn
;;    via DrawMapAttributes and DrawMapRowCol
;;
;;   Note while this loads the attribute byte, it does not load other information
;;    necessary to DrawMapAttributes.  For that.. see PrepAttributePos
;;
;;  IN:  X     = Assumed to be set to 0.  This routine does not explicitly set it
;;       (tmp) = pointer to start of map data to prep
;;       tmp+2 = low byte of pointer to the start of the ROW indicated by (tmp).
;;                 basically is (tmp) minus column information
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PrepSMRowCol:
    LDA mapflags      ; see if we're drawing a row/column
    AND #$02
    BNE @ColumnLoop

  @RowLoop:
    LDY #$00          ; zero Y for following index
    LDA (tmp), Y      ; read a tile from source
    TAY               ; put the tile in Y for a source index

    LDA tsa_ul,      Y  ;  copy TSA and attribute bytes to drawing buffer
    STA draw_buf_ul, X
    LDA tsa_ur,      Y
    STA draw_buf_ur, X
    LDA tsa_dl,      Y
    STA draw_buf_dl, X
    LDA tsa_dr,      Y
    STA draw_buf_dr, X
    LDA tsa_attr,    Y
    STA draw_buf_attr, X

    LDA tmp           ; increment source pointer by 1
    CLC
    ADC #1
    AND #$3F          ; but wrap from $3F->00 (standard maps are only 64 tiles wide)
    ORA tmp+2         ; ORA with original address to retain bits 6,7
    STA tmp           ; write incremented+wrapped address back to pointer
    INX               ; increment our dest index
    CPX #$10          ; and loop until it reaches 16 (full row)
    BCC @RowLoop
    RTS

  @ColumnLoop:
    LDY #$00          ; More of the same, as above.  Only we draw a column instead of a row
    LDA (tmp), Y      ; get the tile
    TAY               ; and put it in Y to index

    LDA tsa_ul,      Y  ;  copy TSA and attribute bytes to drawing buffer
    STA draw_buf_ul, X
    LDA tsa_ur,      Y
    STA draw_buf_ur, X
    LDA tsa_dl,      Y
    STA draw_buf_dl, X
    LDA tsa_dr,      Y
    STA draw_buf_dr, X
    LDA tsa_attr,    Y
    STA draw_buf_attr, X

    LDA tmp           ; Add 64 ($40) to our source pointer (since maps are 64 tiles wide)
    CLC
    ADC #$40
    STA tmp
    LDA tmp+1
    ADC #$00          ; Add any carry from the low byte addition
    AND #$0F          ; wrap at $0F
    ORA #>mapdata     ; and ORA with high byte of map data to keep the pointer looking at map data at in RAM $7xxx
    STA tmp+1
    INX               ; increment dest pointer
    CPX #$10          ; and loop until it reaches 16 (more than a full column -- probably could only go to 15)
    BCC @ColumnLoop
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Prep Map Row or Column [$D258 :: 0x3D268]
;;
;;    Same job as PrepSMRowCol, (see that description for details)
;;   The difference is that PrepSMRowCol is specifically geared for Standard Maps,
;;   whereas this routine is built to cater to both Standard and overworld maps (this routine
;;   will jump to PrepSMRowCol where appropriate)
;;
;;   Again note that this does not load other information
;;    necessary to DrawMapAttributes.  For that.. see PrepAttributePos
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PrepRowCol:
    LDX #$00          ; zero X (our dest index)
    LDA mapflags      ; see if we're on the overworld, or in a standard map
    LSR A
    BCC @DoOverworld  ; if we're on the overworld, jump ahead to overworld routine

       ; otherwise (we're in a standard map) -- do some pointer prepwork
       ; then call PrepSMRowCol

       LDA mapdraw_y     ; load the row number we're prepping
       LSR A             ; right shift by 2, rotating bits into tmp+2
       ROR tmp+2         ;  this is effectively the same as rotating left by 6 (multiply by 64)
       LSR A             ;  only much shorter in code
       ROR tmp+2         ; tmp+2 is now *almost* the low byte of the src pointer for the start of this row (still has garbage bits)
       ORA #>mapdata     ; after ORing, A is now the high byte of the src pointer
       STA tmp+1         ; write the src pointer to tmp
       LDA tmp+2         ; get low byte
       AND #$C0          ;  kill garbage bits
       STA tmp+2         ;  and write back
       ORA mapdraw_x     ; OR with current column number
       STA tmp           ; write low byte with column to
       JUMP PrepSMRowCol  ; tmp, tmp+1, and tmp+2 are all prepped to what PrepSMRowCol needs -- so call it

    @DoOverworld:

   LDA mapdraw_y ; get the row number
   AND #$0F      ; mask out the low 4 bits (only 16 rows of the OW map are loaded at a time)
   ORA #>mapdata
   STA tmp+1     ; tmp+1 is now the high byte of the src pointer
   LDA mapdraw_x
   STA tmp       ; and the low byte ($10) is just the column number
   LDA mapflags
   AND #$02      ; see if we are to load a row or a column
   BNE @DoColumn ; jump ahead to column routine if doing a column

  @DoRow:
     LDY #$00      ; zero Y for upcoming index
     LDA (tmp), Y  ; get desired tile from the map
     TAY           ; put that tile in Y to act as src index

     LDA tsa_ul,      Y  ;  copy TSA and attribute bytes to drawing buffer
     STA draw_buf_ul, X
     LDA tsa_ur,      Y
     STA draw_buf_ur, X
     LDA tsa_dl,      Y
     STA draw_buf_dl, X
     LDA tsa_dr,      Y
     STA draw_buf_dr, X
     LDA tsa_attr,    Y
     STA draw_buf_attr, X

     INC tmp       ; increment low byte of src pointer.  no need to catch wrapping, as the map wraps at 256 tiles
     INX           ; increment our dest counter
     CPX #$10      ; and loop until we do 16 tiles (a full row)
     BCC @DoRow
     RTS

  @DoColumn:
     LDY #$00      ; zero Y for upcoming index
     LDA (tmp), Y  ; get tile from the map
     TAY           ; and use it as src index

     LDA tsa_ul,      Y  ;  copy TSA and attribute bytes to drawing buffer
     STA draw_buf_ul, X
     LDA tsa_ur,      Y
     STA draw_buf_ur, X
     LDA tsa_dl,      Y
     STA draw_buf_dl, X
     LDA tsa_dr,      Y
     STA draw_buf_dr, X
     LDA tsa_attr,    Y
     STA draw_buf_attr, X

     LDA tmp+1     ; load high byte of src pointer
     CLC
     ADC #$01      ;  increment it by 1 (next row in the column)
     AND #$0F      ;  but wrap as to not go outside of map data in RAM
     ORA #>mapdata
     STA tmp+1     ; write incremented and wrapped high byte back
     INX           ; increment dest counter
     CPX #$10      ; and loop until we do 16 tiles (a full column)
     BCC @DoColumn
     RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw Map Row or Column  [$D2E9 :: 0x3D2F9]
;;
;;   This will draw all the tiles in 1 row OR 1 column to the nametable
;;   This is done every time the player takes a step on the map to keep the nametables
;;    updated so that the map appears to be drawn correctly as the player scrolls around
;;
;;   Tiles' TSA have been pre-rendered to an intermediate buffer ($0780-07BF)
;;     draw_buf_ul = UL portion of the tiles
;;     draw_buf_ur = UR portion
;;     draw_buf_dl = DL portion
;;     draw_buf_dr = DR portion
;;
;;   This routine simply copies that pre-rendered data to the NT, so that it becomes
;;    visible on-screen
;;
;;   This routine does not update attributes (see DrawMapAttributes)
;;
;;   16 tiles are drawn if it is to draw a full row.  15 if it is to draw a full column.
;;
;;   Code seems verbose here, like it could've been coded to be smaller, however this is
;;    time critical drawing code (must all be completed in VBlank), so it being more verbose
;;    and lengthy probably keeps it faster than it would be otherwise.. which is very important
;;    for this kind of thing.
;;
;;   mapdraw_nty and mapdraw_ntx the Y,X coords on the NT to start drawing to.  Columns
;;    will draw downward from this point, and rows will draw rightward.
;;
;;  TMP:  tmp through tmp+2 used
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawMapRowCol:
    LDX mapdraw_nty           ; get target row draw to
    LDA lut_2xNTRowStartLo, X ; use it to index LUT to find NT address of that row
    STA tmp
    LDA lut_2xNTRowStartHi, X
    STA tmp+1                 ; (tmp) now dest address
    LDA mapdraw_ntx           ; get target column to draw to
    CMP #$10
    BCS @UseNT2400            ; if column >= $10, we need to switch to NT at $2400, otherwise, use NT at PPUCTRL

              ; if column < $10 (use NT PPUCTRL)
    TAX                 ; back up column to X
    ASL A               ; double column number
    ORA tmp             ; OR with low byte of dest pointer.  Dest pointer now points to NT start of desired tile
    STA tmp
    JUMP @DetermineRowOrCol

    @UseNT2400:     ; if column >= $10 (use NT $2400)

    AND #$0F            ; mask low bits
    TAX                 ; put column in X
    ASL A               ; double column number
    ORA tmp             ; OR with low byte of dest pointer.
    STA tmp
    LDA tmp+1           ; add 4 to high byte (changing NT from PPUCTRL to $2400)
    CLC
    ADC #$04            ; Dest pointer is now prepped
    STA tmp+1

       ; no matter which NT (PPUCTRL/$2400) is being drawn to, both forks reconnect here
    @DetermineRowOrCol:

    LDA mapflags          ; find out if we're moving drawing a row or column
    AND #$02
    BEQ @DoRow
    JUMP @DoColumn


   ;;
   ;;  Draw a row of tiles
   ;;

    @DoRow:

    TXA              ; put column number in A
    EOR #$0F         ; invert it
    TAX              ; put it back in X, increment it, then create a back-up of it in tmp+2
    INX              ; This creates a down-counter:  it is '16 - column_number', indicating the number of
    STX tmp+2        ;   columns that must be drawn until we reach the NT boundary
    LDY #$00         ; zero Y -- our source index
    LDA PPUSTATUS        ; reset PPU toggle
    LDA tmp+1
    STA PPUADDR        ; set PPU addr to previously calculated dest addr
    LDA tmp
    STA PPUADDR

    @RowLoop_U:

    LDA draw_buf_ul, Y ; load 2 tiles from drawing buffer and draw them
    STA PPUDATA          ;   first UL
    LDA draw_buf_ur, Y ;   then UR
    STA PPUDATA
    INY              ; inc source index (to look at next tile)
    DEX              ; dec down counter
    BNE :+           ; if it expired, we've reached NT boundary

      LDA tmp+1      ; at NT boundary... so load high byte
      EOR #$04       ;  toggle NT bit
      STA PPUADDR      ;  and write back as the new high byte
      LDA tmp        ; then get low byte
      AND #$E0       ;  snap it to start of the row
      STA PPUADDR      ;  and write back as the new low byte

    :   
    CPY #$10         ; see if we've drawn 16 tiles yet (one full row)
    BCC @RowLoop_U   ; if not, continue looping

    LDA tmp
    CLC              ; add #$20 to low byte of dest pointer so that
    ADC #$20         ;  it points it to the next row of NT tiles
    STA tmp
    LDA tmp+1
    STA PPUADDR        ; then re-copy the dest addr to set the PPU address
    LDA tmp
    STA PPUADDR
    LDY #$00         ; zero our source index again
    LDX tmp+2        ; restore X to our down counter

    @RowLoop_D:

    LDA draw_buf_dl, Y ; repeat same tile copying work done above,
    STA PPUDATA          ;   but this time we're drawing the bottom half of the tiles
    LDA draw_buf_dr, Y ;   first DL
    STA PPUDATA          ;   then DR
    INY                ; inc source index (next tile)
    DEX                ; dec down counter (for NT boundary)
    BNE :+
    
      LDA tmp+1      ; at NT boundary again.. same deal.  load high byte of dest
      EOR #$04       ;   toggle NT bit
      STA PPUADDR      ;   and write back
      LDA tmp        ; load low byte
      AND #$E0       ;   snap to start of row
      STA PPUADDR      ;   write back

    :   
    CPY #$10
    BCC @RowLoop_D   ; loop until all 16 tiles drawn
    RTS              ; and RTS out (full rown drawn)


   ;;
   ;;  Draw a row of tiles
   ;;

    @DoColumn:

    LDA #$0F         ; prep down counter so that it
    SEC              ;  is 15 - target_row
    SBC mapdraw_nty  ;  This is the number of rows to draw until we reach NT boundary (to be used as down counter)
    TAX              ; put downcounter in X for immediate use
    STX tmp+2        ; and back it up in tmp+2 for future use
    LDY #$00         ; zero Y -- our source index
    LDA PPUSTATUS        ; clear PPU toggle
    LDA tmp+1
    STA PPUADDR        ; set PPU addr to previously calculated dest address
    LDA tmp
    STA PPUADDR
    LDA #$04
    STA PPUCTRL        ; set PPU to "inc-by-32" mode -- for drawing columns of tiles at a time

    @ColLoop_L:

    LDA draw_buf_ul, Y ; draw the left two tiles that form this map tile
    STA PPUDATA          ;   first UL
    LDA draw_buf_dl, Y ;   then DL
    STA PPUDATA
    DEX              ; dec our down counter.
    BNE :+           ;   once it expires, we've reach the NT boundary

      LDA tmp+1      ; at NT boundary.. get high byte of dest
      AND #$24       ;   snap to top of NT
      STA PPUADDR      ;   and write back
      LDA tmp        ; get low byte
      AND #$1F       ;   snap to top, while retaining current column
      STA PPUADDR      ;   and write back

    :   
    INY              ; inc our source index
    CPY #$0F
    BCC @ColLoop_L   ; and loop until we've drawn 15 tiles (one full column)


                     ; now that the left-hand tiles are drawn, draw the right-hand tiles
    LDY #$00         ; clear our source index
    LDA tmp+1        ; restore dest address
    STA PPUADDR
    LDA tmp          ; but add 1 to the low byte (to move to right-hand column)
    CLC              ;   note:  the game does not write back to tmp -- why not?!!
    ADC #$01
    STA PPUADDR
    LDX tmp+2        ; restore down counter into X

    @ColLoop_R:

    LDA draw_buf_ur, Y ; load right-hand tiles and draw...
    STA PPUDATA          ;   first UR
    LDA draw_buf_dr, Y ;   then DR
    STA PPUDATA
    DEX                ; dec down counter
    BNE :+             ; if it expired, we're at the NT boundary

      LDA tmp+1      ; at NT boundary, get high byte of dest
      AND #$24       ;   snap to top of NT
      STA PPUADDR      ;   and write back
      LDA tmp        ; get low byte of dest
      CLC            ;   and add 1 (this could've been avoided if it wrote back to tmp above)
      ADC #$01       ;   anyway -- adding 1 move to right-hand column (again)
      AND #$1F       ;   snap to top of NT, while retaining current column
      STA PPUADDR      ;   and write to low byte of PPU address

    :   
    INY              ; inc our source index
    CPY #$0F         ; loop until we've drawn 15 tiles
    BCC @ColLoop_R   ;  once we have... 
    RTS              ;  RTS out!  (full column drawn)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  [$D5E2 :: 0x3D5F2]
;;
;;  These LUTs are used by routines to find the NT address of the start of each row of map tiles
;;    Really, they just shortcut a multiplication by $40
;;
;;  "2x" because they're really 2 rows (each row is $20, these increment by $40).  This is because
;;  map tiles are 2 ppu tiles tall

lut_2xNTRowStartLo:    .byte  $00,$40,$80,$C0,$00,$40,$80,$C0,$00,$40,$80,$C0,$00,$40,$80,$C0
lut_2xNTRowStartHi:    .byte  $20,$20,$20,$20,$21,$21,$21,$21,$22,$22,$22,$22,$23,$23,$23,$23


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   Draw Palette  [$D850 :: 0x3D860]
;;
;;     Copies the palette from its RAM location (cur_pal) to the PPU
;;   There's also an additional routine here, DrawMapPalette, which will
;;   draw the normal palette, or the "in room" palette depending on whether or
;;   not the player is currently inside rooms.  This is called by maps only
;;
;;     Changes to DrawMapPalette can impact the timing of some raster effects.
;;   See ScreenWipeFrame for details.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawPalette:
    LDA PPUSTATUS       ; Reset PPU toggle
    LDA #$3F        ; set PPU Address to $3F00 (start of palettes)
    STA PPUADDR
    LDA #$00
    STA PPUADDR
    LDX #$00        ; set X to zero (our source index)
    JUMP _DrawPalette_Norm   ; and copy the normal palette

DrawMapPalette:
    LDA PPUSTATUS       ; Reset PPU Toggle
    LDA #$3F        ; set PPU Address to $3F00 (start of palettes)
    STA PPUADDR
    LDA #$00
    STA PPUADDR
    LDX #$00        ; clear X (our source index)
    LDA inroom      ; check in-room flag
    BEQ _DrawPalette_Norm   ; if we're not in a room, copy normal palette...otherwise...

    @InRoomLoop:
      LDA inroom_pal, X ; if we're in a room... the BG palette (first $10 colors) come from
      STA PPUDATA         ;   $03E0 instead
      INX
      CPX #$10          ; loop $10 times to copy the whole BG palette
      BCC @InRoomLoop   ;   once the BG palette is drawn, continue drawing the sprite palette per normal

    _DrawPalette_Norm:
    LDA cur_pal, X     ; get normal palette
    STA PPUDATA          ;  and draw it
    INX
    CPX #$20           ; loop until $20 colors have been drawn (full palette)
    BCC _DrawPalette_Norm

    LDA PPUSTATUS          ; once done, do the weird thing NES games do
    LDA #$3F           ;  reset PPU address to start of palettes ($3F00)
    STA PPUADDR          ;  and then to $0000.  Most I can figure is that they do this
    LDA #$00           ;  to avoid a weird color from being displayed when the PPU is off
    STA PPUADDR
    STA PPUADDR
    STA PPUADDR
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  SetPPUAddrToDest  [$DC80 :: 0x3DC90]
;;
;;    Sets the PPU address to have it start drawing at the coords
;;  given by dest_x, dest_y.  The difference between this and the below
;;  CoordToNTAddr routine is that this one actually sets the PPU address
;;  (whereas the below simply does the conversion without setting PPU
;;  address) -- AND this one works when dest_x is between 00-3F (both nametables)
;;  whereas CoordToNTAddr only works when dest_x is between 00-1F (one nametable)
;;
;;  IN:  dest_x, dest_y
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetPPUAddrToDest:
    LDA PPUSTATUS          ; reset PPU toggle
    LDX dest_x         ; get dest_x in X
    LDY dest_y         ; and dest_y in Y
    CPX #$20           ;  the look at the X coord to see if it's on NTB ($2400).  This is true when X>=$20
    BCS @NTB           ;  if it is, to NTB, otherwise, NTA

 @NTA:
    LDA lut_NTRowStartHi, Y  ; get high byte of row addr
    STA PPUADDR                ; write it
    TXA                      ; put column/X coord in A
    ORA lut_NTRowStartLo, Y  ; OR with low byte of row addr
    STA PPUADDR                ; and write as low byte
    RTS

 @NTB:
    LDA lut_NTRowStartHi, Y  ; get high byte of row addr
    ORA #$04                 ; OR with $04 ($2400 instead of PPUCTRL)
    STA PPUADDR                ; write as high byte of PPU address
    TXA                      ; put column in A
    AND #$1F                 ; mask out the low 5 bits (X>=$20 here, so we want to clip those higher bits)
    ORA lut_NTRowStartLo, Y  ; and OR with low byte of row addr
    STA PPUADDR                ;  for our low byte of PPU address
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   Convert Coords to NT Addr   [$DCAB :: 0x3DCBB]
;;
;;   Converts a X,Y coord pair to a Nametable address
;;
;;   Y remains unchanged
;;
;;   IN:    dest_x
;;          dest_y
;;
;;   OUT:   ppu_dest, ppu_dest+1
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CoordToNTAddr:
    LDX dest_y                ; put the Y coord (row) in X.  We'll use it to index the NT lut
    LDA dest_x                ; put X coord (col) in A
    AND #$1F                  ; wrap X coord
    ORA lut_NTRowStartLo, X   ; OR X coord with low byte of row start
    STA ppu_dest              ;  this is the low byte of the addres -- record it
    LDA lut_NTRowStartHi, X   ; fetch high byte based on row
    STA ppu_dest+1            ;  and record it
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Draw Image Rectangle  [$DCBC :: 0x3DCCC]
;;
;;    Draws a rectangle of given dimensions with tiles supplies by a buffer.
;;  This allows for simple drawing of a rectangular image.
;;
;;    Note that the image can not cross page boundaries.  Also, no stalling
;;  is performed, so the PPU must be off during a draw.  Also note this routine does not
;;  do any attribute updating.  Image buffer cannot consist of more than 256 tiles.
;;
;;  IN:   dest_x,  dest_y = Coords at which to draw the rectangle
;;       dest_wd, dest_ht = dims of rectangle
;;            (image_ptr) = points to a buffer containing the image to draw
;;                  tmp+2 = tile additive.  This value is added to every non-zero tile in the image
;;
;;    Such a shame this seems to only be used for drawing the shopkeeper.  Really seems like
;;  it would be a more widely used routine.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawImageRect:
    CALL CoordToNTAddr    ; convert the given destination to a usable PPU address
    LDY #0               ; zero our source index, Y

    LDA dest_ht          ; get our height
    STA tmp              ;  and store it in tmp (this will be our row loop down counter)

  @RowLoop:
    LDA PPUSTATUS            ; reset PPU toggle
    LDA ppu_dest+1       ; load up desired PPU address
    STA PPUADDR
    LDA ppu_dest
    STA PPUADDR

    LDX dest_wd          ; load width into X (column down counter)
   @ColLoop:
    LDA (image_ptr), Y  ; get a tile from the image
    BEQ :+              ; if it's nonzero....
        CLC
        ADC tmp+2         ; ...add our modifier to it
    :     
    STA PPUDATA           ; draw it
    INY                 ; inc source index
    DEX                 ; dec our col loop counter
    BNE @ColLoop        ; continue looping until X expires

    LDA ppu_dest          ; increment the PPU dest by $20 (one row)
    CLC
    ADC #$20
    STA ppu_dest

    LDA ppu_dest+1        ; include carry in the high byte
    ADC #0
    STA ppu_dest+1

    DEC tmp               ; decrement tmp, our row counter
    BNE @RowLoop          ; and loop until it expires

    RTS                   ; then exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  [$DCF4 :: 0x3DD04]
;;
;;  These LUTs are used by routines to find the NT address of the start of each row
;;    Really, they just shortcut a multiplication by $20 ($20 tiles per row)
;;

lut_NTRowStartLo:
  .byte $00,$20,$40,$60,$80,$A0,$C0,$E0
  .byte $00,$20,$40,$60,$80,$A0,$C0,$E0
  .byte $00,$20,$40,$60,$80,$A0,$C0,$E0
  .byte $00,$20,$40,$60,$80,$A0,$C0,$E0

lut_NTRowStartHi:
  .byte $20,$20,$20,$20,$20,$20,$20,$20
  .byte $21,$21,$21,$21,$21,$21,$21,$21
  .byte $22,$22,$22,$22,$22,$22,$22,$22
  .byte $23,$23,$23,$23,$23,$23,$23,$23

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  CHR Row Loading To Given Address 'A'  [$E95A :: 0x3E96A]
;;
;;  Reads a given number of CHR rows from the given buffer, and writes to the specified
;;  address in CHR-RAM.  Destination address is stored in A upon entry
;;  It is assumed the proper PRG bank is swapped in
;;
;;  The difference between CHRLoadToA and CHRLoad is that CHRLoadToA explicitly sets
;;   the PPU address first, whereas CHRLoad does not
;;
;;
;;  IN:   A     = high byte of dest address (low byte is $00)
;;        X     = number of rows to load (1 row = 16 tiles or 256 bytes)
;;        (tmp) = source pointer to graphic data.  It is assumed the proper bank is swapped in
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CHRLoadToA:
    LDY PPUSTATUS   ; reset PPU Addr toggle
    STA PPUADDR   ; write high byte of dest address
    LDA #0
    STA PPUADDR   ; write low byte:  0
    NOJUMP CHRLoad

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  CHR Row Loading    [$E965 :: 0x3E975]
;;
;;  Reads a given number of CHR rows from the given buffer, and writes them to the PPU
;;  It is assumed that the proper PRG bank is swapped in, and that the dest PPU address
;;  has already been set
;;
;;  CHRLoad       zeros Y (source index) before looping
;;  CHRLoad_Cont  does not (retains Y's original value upon call)
;;
;;
;;  IN:   X     = number of rows to load (1 row = 16 tiles or 256 bytes)
;;        (tmp) = source pointer to graphic data.  It is assumed the proper bank is swapped in
;;        Y     = additional source index   (for CHRLoad_Cont only)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CHRLoad:
    LDY #$00

CHRLoad_Cont:
    LDA (tmp), Y      ; read a byte from source pointer
    STA PPUDATA         ; and write it to CHR-RAM
    INY               ; inc our source index
    BNE CHRLoad_Cont  ; if it didn't wrap, continue looping

    INC tmp+1         ; if it did wrap, inc the high byte of our source pointer
    DEX               ; and decrement our row counter (256 bytes = a full row of tiles)
    BNE CHRLoad_Cont  ; if we've loaded all requested rows, exit.  Otherwise continue loading
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Set Battle PPU Addr  [$F233 :: 0x3F243]
;;
;;  Sets PPU addr to be whatever address is indicated by btltmp+6
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetBattlePPUAddr:
    LDA btltmp+7
    STA PPUADDR
    LDA btltmp+6
    STA PPUADDR
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Battle_WritePPUData  [$F23E :: 0x3F24E]
;;
;;    Copies a block of data to PPU memory.  Note that no more than 256 bytes can be copied at a time
;;  with this routine
;;
;;  input:
;;     btltmp+4,5 = pointer to get data from
;;     btltmp+6,7 = the PPU address to write to
;;     btltmp+8   = the number of bytes to write
;;     btltmp+9   = the bank to swap in
;;
;;  This routine will swap back to the battle_bank prior to exiting
;;  It will also reset the scroll.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Battle_WritePPUData:
    LDA btltmp+9                ; swap in the desired bank
    CALL SwapPRG
    
    CALL WaitForVBlank
    CALL SetBattlePPUAddr        ; use btltmp+6,7 to set PPU addr
    
    LDY #$00                    ; Y is loop up-counter
    LDX btltmp+8                ; X is loop down-counter
    
    @Loop:
        LDA (btltmp+4), Y         ; copy source data to PPU
        STA PPUDATA
        INY
        DEX
        BNE @Loop
          
    LDA #$00                    ; reset scroll before exiting
    STA PPUMASK
    STA PPUSCROLL
    STA PPUSCROLL
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  BattleCrossPageJump  [$F284 :: 0x3F294]
;;
;;  Called from a swappable bank to jump to a routine in a different bank.
;;
;;         A = the target bank   (also updates battle_bank)
;;  blttmp+6 = the address of the routine to jump to

BattleCrossPageJump:
    STA battle_bank
    CALL SwapPRG
    JMP (btltmp+6)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  SetPPUAddr_XA  [$F3BF :: 0x3F3CF]
;;
;;    Sets the PPU Addr to XXAA
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetPPUAddr_XA:
    STX PPUADDR   ; write X as high byte
    STA PPUADDR   ; A as low byte
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Battle_DrawMessageRow_VBlank  [$F4E5 :: 0x3F4F5]
;;  Battle_DrawMessageRow         [$F4E8 :: 0x3F4F8]
;;
;;  Draws a row of tiles in the 'message' area on the battle screen.
;;  The row consists of $19 tiles.
;;
;;  input:  btl_varI,btl_varJ = pointer to data to draw
;;          btl_tmpvar3,btl_tmpvar4 = PPU address to draw to.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Battle_DrawMessageRow_VBlank:
    FARCALL BattleWaitForVBlank
    
Battle_DrawMessageRow:
    LDA btl_tmpvar4
    STA PPUADDR           ; set provided PPU address
    LDA btl_tmpvar3
    STA PPUADDR
    LDY #$00
  @Loop:
      LDA (btl_varI), Y      ; read $19 bytes from source pointer
      STA PPUDATA         ;  and draw them
      INY
      CPY #$19
      BNE @Loop
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleBox_Row  [$F572 :: 0x3F582]
;;
;;  Draws a single row of tiles for a box
;;
;;  input:
;;               btl_varI,89 = dest pointer to draw to      (updated to point to next row after the routine exits)
;;    btl_msgdraw_width = width of the box
;;       btltmp_boxleft = tile to draw for left side
;;     btltmp_boxcenter = tile to draw for center
;;      btltmp_boxright = tile to draw for right side
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleBox_Row:
    LDY #$00
    LDA btltmp_boxleft      ; draw the left tile
    STA (btl_varI), Y
    
    LDX btl_msgdraw_width
    DEX                     ; X is the width-2 (-2 to remove the left/right sides)
    DEX                     ;  this becomes the number of center tiles to draw
    INY
    
    LDA btltmp_boxcenter
  @Loop:                    ; draw all the center tiles
      STA (btl_varI), Y
      INY
      DEX
      BNE @Loop
      
    LDA btltmp_boxright     ; lastly, draw the right tile
    STA (btl_varI), Y
    
    LDA btl_tmpvar1         ; add $20 to the dest pointer to have it point to
    CLC             ;  the next row
    ADC #$20
    STA btl_varI
    LDA btl_varJ
    ADC #$00
    STA btl_varJ
    
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleBox_NextBlock  [$F5ED :: 0x3F5FD]
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
DrawBattleBox_NextBlock:
    LDA btldraw_blockptrstart   ; just add 5 to the block pointer
    CLC
    ADC #$05
    STA btldraw_blockptrstart
    LDA btldraw_blockptrstart+1
    ADC #$00
    STA btldraw_blockptrstart+1
    RTS
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleBox_FetchBlock  [$F5FB :: 0x3F60B]
;;
;;  Fetches a block of data to draw for the battle box
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleBox_FetchBlock:
    LDY #$00                          ; copy 5 bytes of data
    : 
    LDA (btldraw_blockptrstart), Y  ;  from the $8C pointer
    STA btl_msgdraw_hdr, Y          ;  to the btl_msgdraw vars
    INY
    CPY #$05
    BNE :-
    NOJUMP DrawBattleBox_Exit

DrawBattleBox_Exit:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleBoxAndText  [$F608 :: 0x3F618]
;;
;;  Draws a box and the text contained in it.
;;
;;  input:  btldraw_blockptrstart points to the the block data
;;
;;    Block data consists of one or more 5-byte blocks.  The first block specifies the box
;;  to draw, and the following blocks specify the text to be drawn inside it.
;;
;;  First box block:
;;    byte 0 = header (0 - see below)
;;    byte 1 = X position
;;    byte 2 = Y position
;;    byte 3 = width
;;    byte 4 = height
;;
;;  Following text blocks:
;;    byte 0   = header (1 - see below)
;;    byte 1   = X position
;;    byte 2   = Y position
;;    byte 3,4 = pointer to source string
;;
;;  The header byte is tricky to explain.  Each "box" consists of 1 box block + N text blocks.
;;  Therefore the drawing routine will draw 1 block for sure, then will draw additional blocks until
;;  a 0 header byte is found.  This allows it to draw a variable number of text blocks for each box.
;;
;;  So the way it works is, 'box' blocks have a 0 header byte, and text blocks have a 1 header byte.
;;  This means you can chain multiple boxes together, and the drawing routine will know where to stop
;;  drawing because it will hit a 0 header.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleBoxAndText:
    CALL DrawBattleBox_FetchBlock        ; get the first box block
    FARCALL DrawBattleBox                   ; use it to draw the box
  @Loop:
      CALL DrawBattleBox_NextBlock       ; move to next block (text block)
      LDY #$00
      LDA (btldraw_blockptrstart), Y    ; if the header byte is zero
      BEQ DrawBattleBox_Exit            ; exit
      CALL DrawBattleBox_FetchBlock      ; otherwise, fetch the block
      CALL DrawBattleString              ; and use it to draw text
      JUMP @Loop                         ; keep going until null terminator is found

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBlockBuffer  [$F648 :: 0x3F658]
;;
;;  Draw the added blocks to the btl_msgbuffer, then draw the message buffer
;;  to the PPU, and reset the block pointer to the beginning of the buffer
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBlockBuffer:
    CALL DrawBattleBoxAndText        ; Render blocks to the msg buffer
    FARCALL BattleDrawMessageBuffer     ; Draw message buffer to the PPU
    
    INC btl_msgdraw_blockcount      ; Count the number of blocks we've drawn
    
    LDA btldraw_blockptrstart       ; reset the end pointer to point
    STA btldraw_blockptrend         ;   to the start of the buffer
    LDA btldraw_blockptrstart+1
    STA btldraw_blockptrend+1
    
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  BattleDraw_AddBlockToBuffer  [$F690 :: 0x3F6A0]
;;
;;  Adds the block stored in 'msgdraw' to the end of the block buffer
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BattleDraw_AddBlockToBuffer:
    TYA                 ; backup Y
    PHA
    
    LDY #$00
    @Loop:
        LDA btl_msgdraw_hdr, Y        ; copy 5 bytes from the msgdraw buffer
        STA (btldraw_blockptrend), Y  ; to the end of our block data
        INY
        CPY #$05
        BNE @Loop
      
    LDA btldraw_blockptrend         ; then add 5 bytes to the end pointer
    CLC                             ; to move it up
    ADC #$05
    STA btldraw_blockptrend
    LDA btldraw_blockptrend+1
    ADC #$00
    STA btldraw_blockptrend+1
    
    LDA #$00                        ; add a null terminator to the end of the
    TAY                             ; block data
    STA (btldraw_blockptrend), Y
    
    PLA                             ; retore Y, and exit
    TAY
    RTS
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  UndrawNBattleBlocks  [$F6B3 :: 0x3F6C3]
;;
;;  This progressively erases 'N' battle blocks.
;;
;;  A = 'N', the number of blocks to undraw
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

UndrawNBattleBlocks:
    AND #$FF            ; see if A==0
    BEQ @Exit           ; if zero, just exit
    
    STA tmp_6aa5           ; otherwise, store in temp to use as a downcounter
    @Loop:
        FARCALL UndrawBattleBlock ; undraw one
        DEC tmp_6aa5             ; dec
        BNE @Loop             ; loop until no more to undraw
    @Exit:
    RTS
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawCommandBox  [$F700 :: 0x3F710]
;;
;;    Draws the command box ("Fight", "Magic", "Drink", etc)
;;
;;  in:  btldraw_blockptrstart/end = pointer to a block of memory used for drawing
;;         blocks.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawCommandBox:
    LDY #$00
    LDX #$00
    @Loop:
    LDA lua_BattleCommandBoxInfo, Y           ; copy 6*5 bytes (6 blocks)
    STA btl_msgdraw_hdr, X
    INX
    CPX #$05
    BNE :+                                    ; every 5 bytes, add the block to the
        CALL BattleDraw_AddBlockToBuffer         ;  output buffer
        LDX #$00
    : 
    INY
    CPY #6*5              ; 6 blocks * 5 bytes per block
    BNE @Loop
    JUMP DrawBlockBuffer            ; then finally draw it

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  ClearUnformattedCombatBoxBuffer  [$F757 :: 0x3F767]
;;
;;  Clears it with *spaces*, not with null.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ClearUnformattedCombatBoxBuffer:
    LDY #$00                ; pretty self explanitory routine
    LDA #$FF
    : 
    STA btl_unfmtcbtbox_buffer, Y    ; fill buffer ($80 bytes) with $FF
    INY
    CPY #$80
    BNE :-  
    RTS



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  BattleMenu_DrawMagicNames  [$F844 :: 0x3F854]
;;
;;  Prints a row of spell names to the unformatted combat box buffer.  The below string is printed:
;;    __ __ __ xx xx FF xx xx FF xx xx
;;
;;  '__' bytes are skipped.  These are filled with the "L# " text in another routine
;;  'xx xx' bytes are either '0E id' to print the spell name, or '10 04' to print 4 spaces if the slot is empty
;;
;;  input:   btl_varI,89 + Y = source pointer + index to the player's spells to print
;;                    X = dest index to print to in the unformatted buffer
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BattleMenu_DrawMagicNames:
    LDA #$0E
    STA btl_unfmtcbtbox_buffer + 3, X   ; set the 3 '0E' control codes to print item names
    STA btl_unfmtcbtbox_buffer + 6, X
    STA btl_unfmtcbtbox_buffer + 9, X
    
    LDA (btl_varI), Y                        ; check slot 0
    BNE :+                              ; if it's empty (no spell)
        LDA #$10
        STA btl_unfmtcbtbox_buffer + 3, X ; replace 0E code with 10 code to print spaces
        LDA #$04
        STA btl_unfmtcbtbox_buffer + 4, X ; 04 to print 4 spaces
        JUMP @Column1
    : 
    CLC                                 ; otherwise (not empty), onvert from a 1-based magic index
    ADC #MG_START-1                     ; to a 0-based item index, and put the index after the '0E' code
    STA btl_unfmtcbtbox_buffer + 4, X

    @Column1:                             ; Then repeat the above process for each of the 3 columns
    INY
    LDA (btl_varI), Y
    BNE :+
        LDA #$10
        STA btl_unfmtcbtbox_buffer + 6, X
        LDA #$04
        STA btl_unfmtcbtbox_buffer + 7, X
        JUMP @Column2
    : 
    CLC
    ADC #MG_START-1
    STA btl_unfmtcbtbox_buffer + 7, X
    
    @Column2:
    INY
    LDA (btl_varI), Y
    BNE :+
        LDA #$10
        STA btl_unfmtcbtbox_buffer + 9, X
        LDA #$04
        STA btl_unfmtcbtbox_buffer + 10, X
        JUMP @Done
    : 
    CLC
    ADC #MG_START-1
    STA btl_unfmtcbtbox_buffer + 10, X
    
    @Done:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleString  [$F9AB :: 0x3F9BB]
;;
;;  Formats and prints a battle string (See FormatBattleString for the format of the string)
;;
;;  input:  btl_msgdraw_x,y     = dest pointer to draw the string to
;;          btl_msgdraw_srcptr  = source pointer to the string
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleString:
    LDX btl_msgdraw_x
    LDY btl_msgdraw_y
    FARCALL GetBattleMessagePtr
    STX btl_tmpvar3                 ; store target pointer in temp ram
    STY btl_tmpvar4
    
    LDX btl_msgdraw_srcptr
    LDY btl_msgdraw_srcptr+1
    CALL FormatBattleString  ; draw the battle string to the output buffer
    
    LDY #$00                ; move 'top bytes' from string output buffer to the
    LDX #$00                ;  actual draw buffer
  @TopLoop:
      LDA btl_stringoutputbuf, X
      BEQ @StartBottomLoop
      STA (btl_tmpvar3), Y
      INY
      INX                   ; INX *2 because top/bottom tiles are interleaved
      INX
      JUMP @TopLoop          ; loop until we hit the null terminator
    
  @StartBottomLoop:         ; move 'bottom bytes'
    LDY #$20
    LDX #$00
  @BottomLoop:
      LDA btl_stringoutputbuf+1, X
      BEQ @Exit
      STA (btl_tmpvar3), Y
      INY
      INX
      INX
      JUMP @BottomLoop
    
  @Exit:
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Combat Item/Magic Box lut    [$FA11 :: 0x3FA21]
;;
;;      The box that pops up for the ITEM and MAGIC menus

lut_CombatItemMagicBox:
;       hdr    X    Y   wd   ht 
  .byte $00, $02, $01, $16, $0A

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Lut for the battle command box  [$FA1B :: 0x3FA2B]

lua_BattleCommandBoxInfo:
;       hdr,  X    Y    W    H
  .byte $00, $0C, $00, $0D, $0A         ; box
;       hdr,  X    Y    ptr
  .byte $01, $0E, $01, <@txt0, >@txt0   ; text
  .byte $01, $0E, $03, <@txt1, >@txt1
  .byte $01, $0E, $05, <@txt2, >@txt2
  .byte $01, $0E, $07, <@txt3, >@txt3
  .byte $01, $14, $01, <@txt4, >@txt4
  
  
  @txt0:  .byte $EF, $F0, $F1, $F2, $00     ; "FIGHT"
  @txt1:  .byte $EB, $EC, $ED, $EE, $00     ; "MAGIC"
  @txt2:  .byte $F3, $F4, $F5, $F6, $00     ; "DRINK"
  @txt3:  .byte $92, $9D, $8E, $96, $00     ; "ITEM"
  @txt4:  .byte $9B, $9E, $97, $00          ; "RUN"
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Lut for enemy roster strings  [$FA51 :: 0x3FA61]

lut_EnemyRosterStrings:
  .byte $08, $00        ; these are just the roster control codes, followed by the null terminator
  .byte $09, $00
  .byte $0A, $00
  .byte $0B, $00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  FormatBattleString  [$FA59 :: 0x3FA69]
;;
;;  input:   XY points to the buffer containing the null terminated string to draw
;;
;;  output:  btl_stringoutputbuf - contains the formatted output string (INTERLEAVED - See below)
;;
;;    The source string can contain the following control codes:
;;
;;  00       = null terminator (marks end of string)
;;  02       = print attacker's name
;;  03       = print defender's name
;;  04       = print character 0's name
;;  05       = print character 1's name
;;  06       = print character 2's name
;;  07       = print character 3's name
;;  08       = print enemy roster entry 0
;;  09       = print enemy roster entry 1
;;  0A       = print enemy roster entry 2
;;  0B       = print enemy roster entry 3
;;  0C xx yy = yyxx is a pointer to a number to print
;;  0E xx    = print attack name.  For player attacks, 'xx' is the item index (which can also
;;             be a magic name).
;;             For enemy attacks, 'xx' is either a special enemy attack index (like "FROST", etc)
;;             or is an item index.  Whether it is special attack or not is determined by btl_attackid
;;  0F xx    = Draws a battle message.  xx = the ID to the battle message.  Note that this ID is
;;             1-based, NOT zero based like you'd expect
;;  10 xx    = print a run of spaces.  xx = the run length
;;  11 xx yy = yyxx is a number to print
;;
;;  Values >= $48 are printed as normal tiles.
;;
;;    Other values below $48 that are not control codes will either do nothing
;;  or will do a glitched version of one of the above codes.
;;
;;    Note that the output string produced by this routine is interleaved.  There are 2 bytes per
;;  character, the first being the "top" portion of the char, and the second being the "bottom"
;;  portion.  This was used in the Japanese ROM to more easily print some Hiragana, but in the US
;;  version it is totally useless and the top portion is always blank space (tile $FF).
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FormatBattleString:
    CALL SwapBtlTmpBytes     ; swap out btltmp bytes to back them up
    
    STX btldraw_src         ; store source pointer
    STY btldraw_src+1
    
    LDY #$00                ; copy the actual string data to a buffer in RAM
    :
    LDA (btldraw_src), Y  ;   (presumably so we can swap out banks without fear
    STA btl_stringbuf, Y  ;    of swapping out our source data)
    INY
    CPY #$20              ; no strings can be longer than $20 characters.
    BNE :-
      
    LDA #<btl_stringbuf     ; Change source pointer to point to our buffered
    STA btldraw_src         ;   string data
    LDA #>btl_stringbuf
    STA btldraw_src+1
    
    LDA #<btl_stringoutputbuf   ; Set our output pointer to point to
    STA btldraw_dst             ;   our string output buffer
    LDA #>btl_stringoutputbuf
    STA btldraw_dst+1
    
    ; Iterate the string and draw each character
    @Loop:
    LDX #$00
    LDA (tmp_90, X)        ; get the first char
    BEQ @Done           ; stop at the null terminator
    CMP #$48
    BCS :+
        CALL DrawBattleString_ControlCode    ; if <  #$48
        JUMP :++
    :     
    CALL DrawBattleString_ExpandChar    ; if >= #$48
    :   
    CALL DrawBattle_IncSrcPtr    ; Inc the source pointer and continue looping
    JUMP @Loop
    
    @Done:
    LDA #$00
    LDY #$00
    STA (btldraw_dst), Y            ; add null terminator
    INY
    STA (btldraw_dst), Y
    JUMP SwapBtlTmpBytes     ; swap back the original btltmp bytes, then exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleString_ExpandChar  [$FAA6 :: 0x3FAB6]
;;
;;  Takes a single character, expands it to top/bottom pair, and then draws it
;;     btldraw_dst = pointer to the output buffer
;;               A = char to draw
;;
;;  Most of this routine isn't used because the text printed in the US version
;;     does not have a top part.  Most of it is a big else/if chain to determine
;;     which top part to use.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleString_ExpandChar:
    STA btltemppointer         ; char code
    PHA             ; backup A/X/Y
    TXA
    PHA
    TYA
    PHA
    LDA btltemppointer         ; get the char code
    CMP #$7A
    BCS :+
      BCC @c01_79
      
  : LDX #$FF        ; if the character is >= $7A (normal character), no decoration
    BNE @Output     ;   use $FF (blank space) as decoration

  @c01_79:          ; code 01-79
    LDX #$C0        ; use $C0 as default decoration
    CMP #$57
    BCS @c57_79
    ADC #$47
    BNE @Output
    
  @c57_79:
    CMP #$5C
    BCS @c5C_79
    ADC #$4C
    BNE @Output
    
  @c5C_79:
    CMP #$6B
    BCS @c6B_79
    ADC #$73
    BNE @Output
  
  @c6B_79:
    CMP #$70
    BCS @c70_79
    ADC #$78
    BNE @Output
    
  @c70_79:
    LDX #$C1
    CMP #$75
    BCS @c75_79
    ADC #$33
    BNE @Output
    
  @c75_79:
    CLC
    ADC #$6E
  
  @Output:
    CALL DrawBattleString_DrawChar
    PLA
    TAY
    PLA
    TAX
    PLA             ; restore backup
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleString_DrawChar  [$FAF1 :: 0x3FB01]
;;
;;  Draws a single character to the output buffer
;; btldraw_dst = pointer to the output buffer
;;           X = top part of char
;;           A = bottom part of char
;;
;;  See DrawBattleSubString for explanation of top/bottom parts
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleString_DrawChar:
    LDY #$01
    STA (btldraw_dst), Y        ; put bottom part is position [1]
    DEY
    TXA
    STA (btldraw_dst), Y        ; and top part in position [0]
    JUMP DrawBattleString_IncDstPtr



;;  DrawBattleString_Code11  [$FB1E :: 0x3FB2E]
DrawBattleString_Code11:            ; print a number 
    CALL DrawBattle_IncSrcPtr        ;   pointer to the number to print is in the source string
    LDA btldraw_src
    STA btldraw_subsrc              ; since the number is embedded in the source string, just use
    LDA btldraw_src+1               ; the pointer to the source string as the pointer to the number
    STA btldraw_subsrc+1
    CALL DrawBattle_IncSrcPtr
    FARJUMP DrawBattle_Number

;;  DrawBattleString_Code0C  [$FB2F :: 0x3FB3F]
DrawBattleString_Code0C:            ; print a number (indirect)
    CALL DrawBattle_IncSrcPtr
    LDA (btldraw_src), Y            ; pointer to a pointer to the number to print
    STA btldraw_subsrc
    CALL DrawBattle_IncSrcPtr
    LDA (btldraw_src), Y
    STA btldraw_subsrc+1
    FARJUMP DrawBattle_Number

;;  DrawBattleString_Code11_Short  [$FB93 :: 0x3FBA3]
;;    Just jumps to the actual routine.  Only exists here because the routine is too
;;  far away to branch to.
DrawBattleString_Code11_Short:
    JUMP DrawBattleString_Code11

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleString_ControlCode  [$FB96 :: 0x3FBA6]
;;
;;    Print a control code.  See FormatBattleString for details
;;  A = the control code
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleString_ControlCode:
    CMP #$02
    BEQ @PrintAttacker          ; code:  02
    CMP #$03
    BEQ @PrintDefender          ; code:  03
    CMP #$08
    BCC @PrintCharacterName     ; codes: 04-07
    CMP #$0C
    BCC @PrintRoster            ; codes: 08-0B
    BEQ DrawBattleString_Code0C ; code:  0C
    CMP #$0E
    BEQ @PrintAttackName        ; code:  0E
    CMP #$0F
    BEQ DrawBattleMessage       ; code:  0F
    CMP #$10
    BNE :+
      JUMP DrawString_SpaceRun   ; code:  10
  : CMP #$11
    BEQ DrawBattleString_Code11_Short   ; code:  11
    
  @Exit:
    RTS

  @PrintAttacker:       ; code: 02
    LDA btl_attacker
    JUMP DrawEntityName
  @PrintDefender:       ; code: 03
    LDA btl_defender
    JUMP DrawEntityName
  
  @PrintCharacterName:  ; codes:  04-07
    SEC
    SBC #$04            ; subtract 4 to make it zero based
    ORA #$80            ; OR with $80 to make it a character entity ID
    JUMP DrawEntityName  ; then print it as an entity
    
    ; Print an entry on the enemy roster
  @PrintRoster:             ; codes: 08-0B
    SEC                     ; subtract 8 to make it zero based
    SBC #$08
    TAX
    LDA btl_enemyroster, X  ; get the roster entry
    CMP #$FF
    BEQ @Exit               ; if 'FF', that signals an empty slot, so don't print anything.
    JUMP DrawEnemyName       ; then draw that enemy's name
    
    
  @PrintAttackName:     ; code:  0E
    LDA #BANK_ITEMS
    CALL SwapPRG
    LDA btl_attacker                ; check the attacker.  If the high bit is set (it's a player).
    BMI @PrintAttackName_AsItem     ; Player special attacks are always items (or spells, which are stored with items)
    
    LDA btl_attackid                ; otherwise, this is an enemy, so get his attack
    CMP #$42                        ; if it's >= 42, then it's a special enemy attack
    BCC @PrintAttackName_AsItem     ; but less than 42, print it as an item (magic spell)
    
    LDA #>(lut_EnemyAttack - $42*2) ; subtract $42*2 from the start of the lookup table because the enemy attack
    LDX #<(lut_EnemyAttack - $42*2) ;   index starts at $42
    JUMP :+
    
  @PrintAttackName_AsItem: ; attack is less than $42
    LDA #>lut_ItemNamePtrTbl
    LDX #<lut_ItemNamePtrTbl
    
  : CALL BattleDrawLoadSubSrcPtr
    JUMP DrawBattleSubString_Max8
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  BattleDrawLoadSubSrcPtr  [$FC00 :: 0x3FC10]
;;
;;  input:       XA = 16-bit pointer to the start of a pointer table
;;
;;  output:  btldraw_subsrc
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

BattleDrawLoadSubSrcPtr:
    STA tmp_97             ; high byte of pointer table
    
    CALL DrawBattle_IncSrcPtr
    LDA (tmp_90), Y        ; get the desired index
    
    ASL A               ; multiply by 2 (2 bytes per pointer)
    PHP                 ; backup the carry
    STA tmp_96             ; use as low byte
    
    TXA                 ; get X (low byte of pointer table)
    CLC
    ADC tmp_96             ; add with low byte of index
    STA tmp_96             ; use as final low byte
    
    LDA #$00            ; add the carry from the X addition
    ADC tmp_97
    PLP                 ; also add the carry from the above *2
    ADC #$00
    STA tmp_97             ; use as final high byte
    
    LDY #$00            ; get the pointer, store in btldraw_subsrc
    LDA (tmp_96), Y
    STA btldraw_subsrc
    INY
    LDA (tmp_96), Y
    STA btldraw_subsrc+1
    
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleMessage  [$FC26 :: 0x3FC36]
;;
;;  control code $0F
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleMessage:
    LDA #BANK_BTLMESSAGES
    CALL SwapPRG
    LDA #>(data_BattleMessages - 2)     ; -2 because battle message is 1-based
    LDX #<(data_BattleMessages - 2)
    CALL BattleDrawLoadSubSrcPtr
    LDA #$3F
    STA btldraw_max
    JUMP DrawBattleSubString

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawString_SpaceRun  [$FC39 :: 0x3FC49]
;;
;;  control code $10
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawString_SpaceRun:
    CALL DrawBattle_IncSrcPtr    ; inc ptr
    LDA (btldraw_src), Y        ; get the run length
    TAX
    LDA #$FF                    ; blank space tile
    : LDY #$00
      STA (btldraw_dst), Y      ; print top/bottom portions as empty space
      INY
      STA (btldraw_dst), Y
      CALL DrawBattleString_IncDstPtr
      DEX
      BNE :-
    RTS
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawEntityName  [$FC4F :: 0x3FC5F]
;;
;;  input:
;;            A = ID of enemy slot or player whose name to draw
;;  btldraw_dst = pointer to draw to
;;
;;  If A has the high bit set, the player name is drawn
;;  Otherwise, A is the enemy slot whose name we're to draw
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawEntityName:
    BPL @Enemy                  ; if high bit is clear, it's an enemy
    
    ; otherwise, it's a player
    AND #$03                    ; mask out the low bits to get the player ID
    ASL A                       ; @2 for pointer table
    TAX
    LDA lut_CharacterNamePtr, X ; run it though a lut to get the pointer to the player's name
    STA btldraw_subsrc
    INX
    LDA lut_CharacterNamePtr, X
    STA btldraw_subsrc+1
    
    LDY #$00
    : LDA (btldraw_subsrc), Y           ; draw each character in the character's name
      CALL DrawBattleString_ExpandChar
      INY
      CPY #$04                          ; draw 4 characters
      BNE :-
    RTS
    
  @Enemy:
    ASL A           ; mulitply A by $14  ($14 bytes per entry in btl_enemystats)
    ASL A           ; first, multiply by 4
    STA temp_94     ;    store it in temp
    ASL A           ; then multiply by $10
    ASL A
    CLC
    ADC temp_94     ; add with stored *4
    TAX             ; put in X to index
    
    LDA btl_enemystats + en_enemyid, X   ; get this enemy's ID
    NOJUMP DrawEnemyName

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawEnemyName  [$FC7A :: 0x3FC8A]
;;
;;  input:
;;            A = ID of enemy whose name to draw
;;  btldraw_dst = pointer to draw to
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawEnemyName:
    PHA                     ; back up enemy ID
    LDA #BANK_ENEMYNAMES
    CALL SwapPRG           ; swap in bank with enemy names
    PLA                     ; get enemy ID
    ASL A                   ; *2 to use as index
    TAX
    
    LDA data_EnemyNames, X      ; get source pointer from pointer table
    STA btldraw_subsrc
    LDA data_EnemyNames+1, X
    STA btldraw_subsrc+1
    
    NOJUMP DrawBattleSubString_Max8

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleSubString_Max8  [$FC8D :: 0x3FC9D]
;;
;;  Same as DrawBattleSubString, but sets the maximum string length to 8 characters
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleSubString_Max8:
    LDA #$08
    STA btldraw_max
    NOJUMP DrawBattleSubString
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleSubString  [$FC94 :: 0x3FCA4]
;;
;;  btldraw_subsrc = pointer to read from
;;  btldraw_dst = pointer to draw to
;;  btldraw_max = maximum number of characters to draw
;;
;;  Note that this routine seems to be built for the Japanese game where characters
;;    could consist of 2 parts.  For example the Hiragana GU is the same as KU with an
;;    additional quote-like character drawn above it.  As such, each character is drawn
;;    with a "top part" and a "bottom part"
;;
;;  In the US version, the top part is never used, and is just a blank space.  So a good
;;    portion of DrawBattleString_ExpandChar is now worthless and could be trimmed out.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleSubString:
    LDY #$00
  @Loop:
    LDA (btldraw_subsrc), Y         ; get a byte of text
    BEQ @Exit                       ; if null terminator, exit
    CALL DrawBattleString_ExpandChar ; Draw it
    
    INY                             ; keep looping until null terminator is found
    CPY btldraw_max                 ;  or until we reach the given maximum
    BEQ @Exit
    BNE @Loop
    
  @Exit:
    LDA battle_bank                 ; swap back to battle bank
    JUMP SwapPRG                   ;   and exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Lut to get a character's name by their index  [$FCAA :: 0x3FCBA]

lut_CharacterNamePtr:
  .WORD ch_name
  .WORD ch_name+$40
  .WORD ch_name+$80
  .WORD ch_name+$C0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattle_IncSrcPtr  [$FCB2 :: 0x3FCC2]
;;
;;  Inrements the source pointer.  Also resets Y to zero so that
;;  the next source byte can be easily read.  Why this routine doesn't also
;;  read the source byte is beyond me.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattle_IncSrcPtr:
    LDY #$00
    INC btldraw_src
    BNE :+
      INC btldraw_src+1
  : RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  DrawBattleString_IncDstPtr  [$FCC2 :: 0x3FCD2]
;;
;;  Incremenets the destination pointer by 2 for the DrawBattleSubString routine(s)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

DrawBattleString_IncDstPtr:
    INC btldraw_dst
    BNE :+
      INC btldraw_dst+1
  : INC btldraw_dst
    BNE :+
      INC btldraw_dst+1
  : RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  SwapBtlTmpBytes  [$FCCF :: 0x3FCDF]
;;
;;  Backs up the btltmp bytes by swapping them into another place in memory
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SwapBtlTmpBytes:
    PHA         ; backup A,X
    TXA
    PHA
    
    LDX #$0F
  @Loop:
      LDA btltmp, X             ; swap data from btltmp with btltmp_backseat
      PHA
      LDA btltmp_backseat, X
      STA btltmp, X
      PLA
      STA btltmp_backseat, X
      DEX
      BPL @Loop
      
    PLA         ; restory A,X
    TAX
    PLA
    RTS
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Copy 256  [$CC74 :: 0x3CC84]
;;
;;    Copies 256 bytes from (tmp) to (tmp+2).  High byte of dest pointer (tmp+3)
;;  is incremented.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Copy256:
    LDY #0             ; start Y at zero
  
    @Loop:
        LDA (tmp), Y     ; copy a byte
        STA (tmp+2), Y
        INY
        BNE @Loop        ; loop until Y wraps (256 iterations)

    INC tmp+3          ; inc dest pointer
    RTS                ; and exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   NMI Vector [$FE9C :: 0x3FEAC] 
;;
;;     This is called when an NMI occurs.  FF1 has a bizarre way
;;    of doing NMIs.  It calls a Wait for VBlank routine, which enables
;;    NMIs, and does an infinite JUMP loop.  When an NMI is triggered,
;;    It does not RTI (since that would put it back in that infinite
;;    loop).  Instead, it tosses the RTI address and does an RTS, which
;;    returns to the area in code that called the Wait for Vblank routine
;;
;;     Changes to this routine can impact the timing of various raster effects,
;;    potentially breaking them.  It is recommended that you don't change this
;;    routine unless you're very careful.  Unedited, this routine exits no earlier
;;    than 37 cycles after NMI (30 cycles used in this routine, plus 7 for the NMI)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OnNMI:
    LDA soft2000
    STA PPUCTRL      ; set the PPU state
    LDA PPUSTATUS      ; clear VBlank flag and reset 2005/2006 toggle
    PLA
    PLA
    PLA            ; pull the RTI return info off the stack
    RTS            ; return to the game

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   Wait for VBlank [$FEA8 :: 0x3FEB8]
;;
;;    This does an infinite loop in wait for an NMI to be triggered
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

WaitForVBlank:
    LDA PPUSTATUS      ; check VBlank flag
    LDA soft2000   ; Load desired PPU state
    ORA #$80       ; flip on the Enable NMI bit
    STA PPUCTRL      ; and write it to PPU status reg

OnIRQ:                   ; IRQs point here, but the game doesn't use IRQs, so it's moot
    @LoopForever:
    JMP @LoopForever     ; then loop forever! (or really until the NMI is triggered)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  SwapPRG  [$FE1A :: 0x3FE2A]
;;
;;   Swaps so the desired bank of PRG ROM is visible in the $8000-$BFFF range
;;
;;  IN:   A = desired bank to swap to (00-0F)
;;
;;  OUT:  A = 0
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SwapPRG:  
    STA actual_bank ; JIGS - see LongCall 
    ASL A       ; Double the page number (MMC5 uses 8K pages, but FF1 uses 16K pages)
    ORA #$80    ; Turn on the high bit to indicate we want ROM and not RAM
    STA current_bank1
    STA MMC5_PRG_BANK1   ; Swap to the desired page
    LDA far_depth
    BEQ @noDebugger
    ;DEBUG
    @noDebugger:
    LDA #0      ; IIRC Some parts of FF1 expect A to be zero when this routine exits
    RTS

Impl_FARBYTE:
    LDA cur_bank
    ASL A       ; Double the page number (MMC5 uses 8K pages, but FF1 uses 16K pages)
    ORA #$80    ; Turn on the high bit to indicate we want ROM and not RAM
    STA MMC5_PRG_BANK1
    LDA (text_ptr), Y
    PHA
    LDA current_bank1
    STA MMC5_PRG_BANK1
    PLA
    RTS

Impl_FARBYTE2:
    STA MMC5_PRG_BANK1
    LDA (tmp), Y
    PHA
    LDA current_bank1
    STA MMC5_PRG_BANK1
    PLA
    RTS

Impl_FARPPUCOPY:
    STA MMC5_PRG_BANK1
    @loop:
            LDA (tmp), Y      ; read a byte from source pointer
            STA PPUDATA       ; and write it to CHR-RAM
            INY               ; inc our source index
        BNE @loop         ; if it didn't wrap, continue looping
        INC tmp+1         ; if it did wrap, inc the high byte of our source pointer
        DEX               ; and decrement our row counter (256 bytes = a full row of tiles)
    BNE @loop         ; if we've loaded all requested rows, exit.  Otherwise continue loading
    LDA current_bank1
    STA MMC5_PRG_BANK1
    RTS

Impl_NAKEDJUMP:
    ; Save A
    STA safecall_reg_a

    ; Save flags
    PHP
    PLA
    STA safecall_reg_flags

    ; Save Y
    STY safecall_reg_y

    ; Increment our depth counter
    INC far_depth

    ; Pull then push the stack to find the low address of our caller
    PLA
    STA trampoline_low
    CLC
    ADC #3 ; When we return we want to return right after the extra 3 byte data after the CALL instruction

    ; Pull then push the stack to find the high address of our caller
    PLA
    STA trampoline_high
    ADC #0 ; If the previous ADC caused a carry we add it here

    ; Read the low address we want to jump to and push it to the stack
    LDY #1
    LDA (trampoline_low), Y
    PHA

    ; Read the high address we want to jump to and push it to the stack
    INY
    LDA (trampoline_low), Y
    PHA

    ; Read what bank we are going to and switch to it
    INY
    LDA (trampoline_low), Y
    STA current_bank1
    STA MMC5_PRG_BANK1

        PLA
        STA trampoline_low
        PLA
        STA trampoline_high

    ; Load flags
    LDA safecall_reg_flags
    PHA
    PLP

    ; Load A
    LDA safecall_reg_a

    ; Load Y
    LDY safecall_reg_y
        
        JMP (trampoline_low)

    ; Activate the trampoline
    RTS


Impl_FARJUMP:

    ; Save A
    STA safecall_reg_a

    ; Save flags
    PHP
    PLA
    STA safecall_reg_flags

    ; Save Y
    STY safecall_reg_y

    ; Increment our depth counter
    INC far_depth

    ; Pull then push the stack to find the low address of our caller
    PLA
    STA trampoline_low
    CLC
    ADC #3 ; When we return we want to return right after the extra 3 byte data after the CALL instruction

    ; Pull then push the stack to find the high address of our caller
    PLA
    STA trampoline_high
    ADC #0 ; If the previous ADC caused a carry we add it here

    ; Save what page the bank is currently in
    LDA current_bank1
    PHA

    ; Push this address to the stack so we can return here
    CALL @jump
    ; We just got back so time to rewind

    ; Save A
    STA safecall_reg_a

    ; Pull what page our bank used to be in and switch back
    PLA
    STA current_bank1
    STA MMC5_PRG_BANK1

    PHP
    ; Decrement our depth counter
    DEC far_depth
    PLP

    ; Load A
    LDA safecall_reg_a

    ; Return to original caller
    RTS

    @jump:

    ; Read the low address we want to jump to and push it to the stack
    LDY #1
    LDA (trampoline_low), Y
    PHA

    ; Read the high address we want to jump to and push it to the stack
    INY
    LDA (trampoline_low), Y
    PHA

    ; Read what bank we are going to and switch to it
    INY
    LDA (trampoline_low), Y
    STA current_bank1
    STA MMC5_PRG_BANK1

        PLA
        STA trampoline_low
        PLA
        STA trampoline_high

    ; Load flags
    LDA safecall_reg_flags
    PHA
    PLP

    ; Load A
    LDA safecall_reg_a

    ; Load Y
    LDY safecall_reg_y
        
        JMP (trampoline_low)

    ; Activate the trampoline
    RTS

Impl_FARCALL:
    ; Save A
    STA safecall_reg_a

    ; Save flags
    PHP
    PLA
    STA safecall_reg_flags

    ; Save Y
    STY safecall_reg_y

    ; Increment our depth counter
    INC far_depth

    ; Pull then push the stack to find the low address of our caller
    PLA
    STA trampoline_low
    CLC
    ADC #3 ; When we return we want to return right after the extra 3 byte data after the CALL instruction

    ; Pull then push the stack to find the high address of our caller
    PLA
    STA trampoline_high
    ADC #0 ; If the previous ADC caused a carry we add it here

    ; Save back the high address
    PHA

    ; Load back the low address
    LDA trampoline_low
    ADC #3
    PHA

    ; Save what page the bank is currently in
    LDA current_bank1
    PHA

    ; Push this address to the stack so we can return here
    CALL @jump
    ; We just got back so time to rewind

    ; Save A
    STA safecall_reg_a

    ; Pull what page our bank used to be in and switch back
    PLA
    STA current_bank1
    STA MMC5_PRG_BANK1

    PHP
    ; Decrement our depth counter
    DEC far_depth
    PLP

    ; Load A
    LDA safecall_reg_a

    ; Return to orginal caller
    RTS

    @jump:

    ; Read the low address we want to jump to and push it to the stack
    LDY #1
    LDA (trampoline_low), Y
    PHA

    ; Read the high address we want to jump to and push it to the stack
    INY
    LDA (trampoline_low), Y
    PHA

    ; Read what bank we are going to and switch to it
    INY
    LDA (trampoline_low), Y
    STA current_bank1
    STA MMC5_PRG_BANK1

        ; temp removal of trampoline trick
        PLA
        STA trampoline_low
        PLA
        STA trampoline_high

    ; Load flags
    LDA safecall_reg_flags
    PHA
    PLP

    ; Load A
    LDA safecall_reg_a

    ; Load Y
    LDY safecall_reg_y

        ; temp non-trampoline JUMP
        JMP (trampoline_low)

    ; Activate the trampoline
    ;RTS

.segment "RESET_VECTOR"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Entry / Reset  [$FE2E :: 0x3FE3E]
;;
;;   Entry point for the program.  Does NES and mapper prepwork, and gets
;;   everything started
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OnReset:
    SEI                     ; Set Interrupt flag (prevent IRQs from occuring)
    
    ; MMC5
    LDX #0
    STX MMC5_PCM_MODE_IRQ   ; Disable MMC5 PCM and IRQs
    STX MMC5_IRQ_STATUS     ; Disable MMC5 scanline IRQs
    STX MMC5_UPPER_CHR_BANK ; Check doc on MMC5 to see what this does
    STX MMC5_RAM_BANK       ; swap battery-backed PRG RAM into $6000 page.     
    STX MMC5_SPLIT_MODE     ; disable split-screen mode
    STX MMC5_CHR_MODE       ; 8k CHR swap mode (no swapping)
    STX MMC5_CHR_BANK7      ; Swap in first CHR Page
    INX                     ; 01
    STX MMC5_PRG_MODE       ; set MMC5 to 16k PRG mode
    STX MMC5_RAM_PROTECT_2  ; Allow writing to PRG-RAM B  
    INX                     ; 02
    STX MMC5_RAM_PROTECT_1  ; Allow writing to PRG-RAM A
    STX MMC5_EXRAM_MODE     ; ExRAM mode Ex2   
    LDX #$44
    STX MMC5_MIRROR         ; Vertical mirroring
    LDX #$FF        
    STX MMC5_PRG_BANK3

    LDA #0
    STA PAPU_MODCTL         ; disble DMC IRQs
    STA PPUCTRL             ; Disable NMIs
    LDA #$C0
    STA FRAMECTR_CTL        ; set alternative pAPU frame counter method, reset the frame counter, and disable APU IRQs

    LDA #$06
    STA PPUMASK             ; disable Spr/BG rendering (shut off PPU)
    CLD                     ; clear Decimal flag (just a formality, doesn't really do anything)

    LDX #$02                ; wait for 2 vblanks to occurs (2 full frames)
    @Loop: 
        BIT PPUSTATUS         ;  This is necessary because the PPU requires some time to "warm up"
        BPL @Loop             ;  failure to do this will result in the PPU basically not working
        DEX
        BNE @Loop

    FARCALL ResetRAM

    FARCALL DisableAPU
    SWITCH GameStart
    JMP GameStart           ; jump to the start of the game!

.segment "VECTORS"

  .WORD OnNMI
  .WORD OnReset
  .WORD OnIRQ     ;IRQ vector points to an infinite loop (IRQs should never occur)
