.segment "PRG_034"

.include "src/global-import.inc"

.export FindEmptyWeaponSlot, FindEmptyArmorSlot, OpenTreasureChest, AddGPToParty, LoadPrice, SortEquipmentList

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Find Empty Weapon Slot  [$DD34 :: 0x3DD44]
;;
;;    Finds the first available weapon slot in the party.
;;
;;  OUT:  C = clear if there is an empty slot, set if there are no empty slots
;;        X = index (from ch_stats) of the available slot (if any available)
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FindEmptyWeaponSlot:
    LDY #0             ; Y is our loop counter
   @Loop:
     LDX lut_WeaponSlots, Y ; load up the index to the next weapon slot
     LDA ch_stats, X        ; then get the weapon in that slot
     BEQ @FoundSlot         ; if zero (empty slot), we found our empty slot

     INY               ; otherwise slot is occupied -- increase loop counter
     CPY #16           ; and loop until all 16 slots checked
     BCC @Loop

    RTS                ; if all 16 slots checked, and no empty slot found, return (C is set
                       ;  here because above BCC would have failed -- so no need for SEC)

  @FoundSlot:
    CLC                ; CLC to indicate a slot is found
    RTS                ; and exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Find Empty Armor Slot  [$DD46 :: 0x3DD56]
;;
;;    Finds first available armor slot.  Identical to above FindEmptyWeaponSlot 
;;  routine, except it is for armor instead of weapons.  See that routine for comments
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

FindEmptyArmorSlot:
    LDY #0
  @Loop:
      LDX lut_ArmorSlots, Y
      LDA ch_stats, X
      BEQ @FoundSlot
      INY
      CPY #16
      BCC @Loop

    RTS

  @FoundSlot:
    CLC
    RTS

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  LUTs of Weapon/Armor slots by index  [$DD58 :: 0x3DD68]
;;
;;    Used by above routines to find all weapon/armor slots quickly
;;  with a zero based index

lut_WeaponSlots:
  .byte <ch_weapons+$00, <ch_weapons+$01, <ch_weapons+$02, <ch_weapons+$03
  .byte <ch_weapons+$40, <ch_weapons+$41, <ch_weapons+$42, <ch_weapons+$43
  .byte <ch_weapons+$80, <ch_weapons+$81, <ch_weapons+$82, <ch_weapons+$83
  .byte <ch_weapons+$C0, <ch_weapons+$C1, <ch_weapons+$C2, <ch_weapons+$C3

lut_ArmorSlots:
  .byte <ch_armor+$00, <ch_armor+$01, <ch_armor+$02, <ch_armor+$03
  .byte <ch_armor+$40, <ch_armor+$41, <ch_armor+$42, <ch_armor+$43
  .byte <ch_armor+$80, <ch_armor+$81, <ch_armor+$82, <ch_armor+$83
  .byte <ch_armor+$C0, <ch_armor+$C1, <ch_armor+$C2, <ch_armor+$C3



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Open Treasure Chest  [$DD78 :: 0x3DD88]
;;
;;    Opens a treasure chest, gives the item to the party (if possible), marks
;;  the chest as open, and sets 'dlgsfx' appropriately (for TC jingle or key item
;;  fanfare)
;;
;;  IN:  tileprop+1 = ID of the chest (2nd byte of tile properties)
;;           dlgsfx = assumed to be zero
;;
;;  OUT:          A = dialogue text ID to print
;;           dlgsfx = sound effect to play 1=key item fanfare, 2=tc jingle
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

OpenTreasureChest:
    LDX tileprop+1           ; put chest index in X
    LDA LUTChestItems, X      ; use it to get the contents of the chest
    STA dlg_itemid           ; record that as the item id so it can be printed in the dialogue box

    CMP #TCITYPE_WEPSTART    ; see if the ID is >= weapon_ids
    BCS @NotItem             ; if it is, it's not an item -- branch ahead

  ;;
  ;; Chest contains an item
  ;;

    TAX                      ; put item ID in X
    LDA items, X             ; see how many of this item the player has
    CMP #99                  ; see if they have >= 99
    BCS :+
      INC items, X           ; give them one of this item -- but only if they have < 99

:   LDX tileprop+1           ; re-get the chest index
    LDA game_flags, X        ; set the game flag for this chest to mark it as opened
    ORA #GMFLG_TCOPEN        ;  note that the chest is opened even if you didn't get the item because you had
    STA game_flags, X        ;  too many.  That is arguably BUGGED.

    LDA dlg_itemid               ; get the item ID again
    CMP #item_qty_start - items  ; see if it's a qty item (normal item -- not key item)
    BCC :+
      INC dlgsfx                 ; if >= qty_start, this is not a key item.  set dlgsfx to 2 (normal TC jingle)
:   INC dlgsfx                   ;  otherwise only set it to 1 (key item fanfare)

    LDA #DLGID_TCGET             ; put the treasure chest dialogue ID in A before exiting!
    RTS

  ;; jumps here if chest doesn't have a normal item
  @NotItem:                  ; if not a normal item....
    CMP #TCITYPE_ARMSTART    ; see if item is a weapon by seeing if it's < armor start
    BCS @NotWeapon           ; if not... jump ahead

  ;; 
  ;; Chest contains a weapon
  ;;

    SEC                      ; subtract to convert the item ID to a 1-based weapon index
    SBC #TCITYPE_WEPSTART-1  ;  don't make it zero based because zero is an empty slot
    STA tmp                  ; store the equip index in temp RAM

    CALL FindEmptyWeaponSlot  ; Find an available slot to place this weapon in
    BCS @TooFull             ;  if there are no available slots, jump to 'Too Full' message
                             ; otherwise, equipment get

  ;;
  ;; General stuff for all non-normal items
  ;;

  @EquipmentGet:
    LDA tmp                  ; get previously tmp'd equipment ID
    STA ch_stats, X          ; add it to the previously found empty slot
                             ;  then continue on to mark the chest as open

  @OpenChest:
    LDX tileprop+1           ; get the ID of this chest
    LDA game_flags, X        ; flip on the TCOPEN flag to mark this TC as open
    ORA #GMFLG_TCOPEN
    STA game_flags, X

    INC dlgsfx               ; set dlgsfx to 2 to play the TC jingle
    INC dlgsfx

    LDA #DLGID_TCGET         ; and select "In This chest you found..." text
    RTS

  @TooFull:                  ; If too full...
    LDA #DLGID_CANTCARRY     ; select "You can't carry any more" text
    RTS

  ;; jumps here if chest doesn't have a normal item or a weapon
  @NotWeapon:
    CMP #TCITYPE_GPSTART     ; see if item is armor by seeing if it's < gp start
    BCS @Gold                ; if not... jump ahead

  ;;
  ;; Chest contains armor
  ;;

    SEC                      ; subtract to convert the item ID to a 1-based armor index
    SBC #TCITYPE_ARMSTART-1
    STA tmp                  ; tmp it for @EquipmentGet

    CALL FindEmptyArmorSlot   ; Find an empty slot to put this armor
    BCS @TooFull             ; if there isn't one, @TooFull
    BCC @EquipmentGet        ; otherwise, @EquipmentGet  (always branches)

  ;;
  ;; jumps here if chest doesn't have normal item / weapon / armor
  ;; only thing left that can be in a chest is gold
  ;;

  @Gold:
    CALL LoadPrice            ; get the price of the item (the amount of gold in the chest)
    CALL AddGPToParty         ; add that price to the party's GP
    JUMP @OpenChest           ; then mark the chest as open, and exit

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Add GP To Party  [$DDEA :: 0x3DDFA]
;;
;;  IN:  tmp - tmp+2 = GP to give to party
;;
;;  BUGGED -- theoretically, it is possible for this routine to allow
;;   you to go over the maximum ammount of gold if you add a large enough number.
;;
;;     After CMPing the high byte of your gold against the maximum, it
;;  only does a BCC (which is only a less than check).  It proceeds to check the middle
;;  bytes EVEN IF the high byte of gold is GREATER than the high byte of the max.  This
;;  means that numbers such as 1065535 will not appear to be over the maximum when, in
;;  fact, they are.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;

AddGPToParty:
    LDA gold        ; Add the 3 bytes of GP to the
    CLC             ;  party's gold total
    ADC tmp
    STA gold
    LDA gold+1
    ADC tmp+1
    STA gold+1
    LDA gold+2
    ADC tmp+2
    STA gold+2

    CMP #^1000000   ; see if high byte is over maximum
    BCC @Exit       ; if gold_high < max_high, exit

    LDA gold+1
    CMP #>1000000   ; check middle bytes
    BCC @Exit       ; if gold < max, exit
    BEQ @CheckLow   ; if gold = max, check low bytes
    BCS @Max        ; if gold > max, over maximum

  @CheckLow:
    LDA gold
    CMP #<1000000   ; check low bytes
    BCC @Exit       ; if gold < max, exit

  @Max:
    LDA #<999999    ; replace gold with maximum
    STA gold
    LDA #>999999
    STA gold+1
    LDA #^999999
    STA gold+2

  @Exit:
    RTS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Sort Equipment List  [$EFFC :: 0x3F00C]
;;
;;    Rearranges an equipment list (weapons/armor) so that gaps in between character
;;  inventory are removed.  Personally I always hated this "feature".. it prevents you from
;;  ordering your inventory list the way you want it.  However, it is required for the game
;;  because the equipment shops are coded poorly and can only sell equipment if the inventory
;;  list has no gaps (see EquipMenu_BuildSellBox).
;;
;;  IN:   equipoffset = offset from ch_stats to the start of the equipment list
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SortEquipmentList:
    LDY #$04         ; Y will be our down counter for the loop (loop 4 times, once for each char)
    LDX equipoffset  ; put the equip offset in X for indexing

   @Loop:
      CALL @SortOne   ; sort one char's inventory

      TXA            ; move the index to A
      CLC
      ADC #$40       ; so we can add $40 (look at next character)
      AND #$FC       ; snap back to start of this character's inventory
      TAX            ; then move back to X for indexing

      DEY            ; decrement our loop counter
      BNE @Loop      ; and keep looping until it expires

    RTS              ; once it does... exit

  @SortOne:
    LDA ch_stats, X     ; copy all this char's equipment over to temp ram
    STA tmp
    LDA ch_stats+1, X
    STA tmp+1
    LDA ch_stats+2, X
    STA tmp+2
    LDA ch_stats+3, X
    STA tmp+3

    LDA #0              ; then erase all their equipment
    STA ch_stats, X
    STA ch_stats+1, X
    STA ch_stats+2, X
    STA ch_stats+3, X

    LDA tmp             ; now step through each temp byte, and place them back into inventory
    BEQ :+              ;  only if they're nonzero (not blank).  If they're zero, simply skip over them
      STA ch_stats, X
      INX

:   LDA tmp+1
    BEQ :+
      STA ch_stats, X
      INX

:   LDA tmp+2
    BEQ :+
      STA ch_stats, X
      INX

:   LDA tmp+3
    BEQ :+
      STA ch_stats, X  ; do not INX a 4th time

:   RTS                ; exit once all the gaps are removed



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  Load Price   [$ECB9 :: 0x3ECC9]
;;
;;   Loads the price of a desired item and stores it at $10-12
;;
;;  IN:   A            = ID of item to fetch price of
;;
;;  OUT:  tmp to tmp+2 = price of item
;;        *            = BANK_MENUS swapped in
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


LoadPrice:
    ASL A        ; double item index (2 bytes per price)
    STA tmp+2    ; store low byte in $12

    LDA #>(LUTItemPrices>>1)  ; high byte of pointer, but load it right-shifted by 1
    ROL A                      ; and rotate it left by 1 in order to catch carry from above shifting
    STA tmp+3                  ; store as high byte of pointer at tmp+3

    LDY #0         ; zero Y (our source index)
    LDA (tmp+2), Y ; get low byte of price
    STA tmp
    INY
    LDA (tmp+2), Y ; and high byte
    STA tmp+1

    LDA #0
    STA tmp+2       ; 3rd byte is always 0 (no item costs more that 65535)

    RTS

.align $100

LUTItemPrices:
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $c350
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $004b
    .word $00fa
    .word $0bb8
    .word $003c
    .word $004b
    .word $0320
    .word $000a
    .word $0005
    .word $0005
    .word $000a
    .word $000a
    .word $0226
    .word $0226
    .word $00c8
    .word $00c8
    .word $00af
    .word $00c8
    .word $01c2
    .word $05dc
    .word $07d0
    .word $01c2
    .word $0320
    .word $0fa0
    .word $09c4
    .word $1194
    .word $2710
    .word $3a98
    .word $1f40
    .word $1f40
    .word $4e20
    .word $1f40
    .word $1770
    .word $1388
    .word $3039
    .word $2710
    .word $61a8
    .word $61a8
    .word $9c40
    .word $c350
    .word $7530
    .word $fde8
    .word $9c40
    .word $ea60
    .word $ea60
    .word $ea60
    .word $ea60
    .word $000a
    .word $0032
    .word $0050
    .word $0320
    .word $afc8
    .word $1d4c
    .word $7530
    .word $7530
    .word $ea60
    .word $ea60
    .word $03e8
    .word $1388
    .word $c350
    .word $fde8
    .word $0002
    .word $0002
    .word $000f
    .word $0064
    .word $09c4
    .word $2710
    .word $2710
    .word $3a98
    .word $9c40
    .word $09c4
    .word $4e20
    .word $0050
    .word $0064
    .word $01c2
    .word $09c4
    .word $2710
    .word $4e20
    .word $0002
    .word $003c
    .word $00c8
    .word $02ee
    .word $09c4
    .word $3a98
    .word $2710
    .word $4e20
    .word $4e20
    .word $000a
    .word $0014
    .word $0019
    .word $001e
    .word $0037
    .word $0046
    .word $0055
    .word $006e
    .word $0087
    .word $009b
    .word $00a0
    .word $00b4
    .word $00f0
    .word $00ff
    .word $0104
    .word $0127
    .word $012c
    .word $013b
    .word $014a
    .word $015e
    .word $0181
    .word $0190
    .word $01c2
    .word $01f4
    .word $0212
    .word $023f
    .word $026c
    .word $02a8
    .word $02ee
    .word $031b
    .word $0370
    .word $03fc
    .word $04e2
    .word $05af
    .word $05f0
    .word $06e0
    .word $07b7
    .word $07d0
    .word $0abe
    .word $0d48
    .word $1036
    .word $1388
    .word $154a
    .word $1900
    .word $1a40
    .word $1cac
    .word $1e0a
    .word $1edc
    .word $1fc7
    .word $2328
    .word $2454
    .word $251c
    .word $26ac
    .word $2710
    .word $303e
    .word $32c8
    .word $348a
    .word $36e2
    .word $3980
    .word $3a98
    .word $4452
    .word $465a
    .word $4e16
    .word $4e20
    .word $4e2a
    .word $6590
    .word $afc8
    .word $fde8
    .word $0064
    .word $0064
    .word $0064
    .word $0064
    .word $0064
    .word $0064
    .word $0064
    .word $0064
    .word $0190
    .word $0190
    .word $0190
    .word $0190
    .word $0190
    .word $0190
    .word $0190
    .word $0190
    .word $05dc
    .word $05dc
    .word $05dc
    .word $05dc
    .word $05dc
    .word $05dc
    .word $05dc
    .word $05dc
    .word $0fa0
    .word $0fa0
    .word $0fa0
    .word $0fa0
    .word $0fa0
    .word $0fa0
    .word $0fa0
    .word $0fa0
    .word $1f40
    .word $1f40
    .word $1f40
    .word $1f40
    .word $1f40
    .word $1f40
    .word $1f40
    .word $1f40
    .word $4e20
    .word $4e20
    .word $4e20
    .word $4e20
    .word $4e20
    .word $4e20
    .word $4e20
    .word $4e20
    .word $afc8
    .word $afc8
    .word $afc8
    .word $afc8
    .word $afc8
    .word $afc8
    .word $afc8
    .word $afc8
    .word $ea60
    .word $ea60
    .word $ea60
    .word $ea60
    .word $ea60
    .word $ea60
    .word $ea60
    .word $ea60
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000
    .word $0000 


; I don't know if there are actuall 256 chests in the game
LUTChestItems:
    .byte $00, $47, $55, $06, $26, $27, $2b, $17, $19, $5d, $36, $35, $1b, $2d, $81, $7e
    .byte $65, $37, $66, $2a, $7b, $4e, $18, $80, $86, $21, $87, $25, $02, $47, $4f, $2b
    .byte $8b, $82, $85, $17, $5f, $5e, $31, $2b, $49, $85, $18, $19, $1a, $19, $8a, $19
    .byte $1a, $89, $90, $34, $17, $7e, $95, $54, $85, $8b, $93, $16, $19, $09, $8c, $56
    .byte $17, $96, $8e, $1e, $93, $8d, $60, $82, $86, $29, $19, $17, $90, $1a, $19, $8d
    .byte $56, $8e, $60, $67, $8f, $2e, $89, $88, $32, $94, $8e, $60, $1b, $92, $8f, $1e
    .byte $8c, $6c, $75, $18, $91, $30, $8a, $1a, $57, $99, $4a, $19, $a1, $9f, $16, $58
    .byte $44, $2f, $0b, $9b, $96, $a0, $95, $77, $a2, $67, $4b, $68, $18, $8d, $99, $50
    .byte $30, $66, $39, $0d, $8d, $91, $92, $92, $8e, $6c, $83, $18, $85, $1b, $17, $9f
    .byte $76, $84, $1d, $5d, $68, $63, $a0, $99, $92, $9a, $9c, $96, $80, $69, $38, $a0
    .byte $91, $82, $73, $38, $4c, $6d, $3a, $a2, $9d, $8f, $51, $92, $a1, $6c, $94, $95
    .byte $1a, $59, $61, $6a, $08, $3c, $63, $a4, $97, $95, $3b, $19, $19, $19, $19, $19
    .byte $19, $19, $19, $19, $5a, $92, $93, $a9, $17, $62, $8a, $3d, $18, $9a, $33, $a1
    .byte $4d, $9c, $9b, $3f, $a2, $a3, $a0, $19, $94, $9b, $95, $6b, $98, $62, $77, $40
    .byte $52, $53, $63, $6a, $59, $60, $18, $8a, $a3, $07, $94, $1b, $93, $41, $5c, $44
    .byte $9f, $1b, $97, $9c, $9d, $19, $6b, $96, $43, $ad, $41, $6b, $5c, $ae, $af, $00
