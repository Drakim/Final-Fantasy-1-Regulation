.include "src/macros.inc"
.include "src/constants.inc"

BANK_THIS = $18

.segment "BANK_18"

;; unused bytes  [$BFF0 :: 0x3C000]

  .BYTE   $66,$66,$66,$66,$66,$66,$66,$66,    $66,$66,$66,$66,$66,$66,$66,$66

