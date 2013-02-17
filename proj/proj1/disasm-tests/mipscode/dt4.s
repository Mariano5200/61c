.text
.set noat

.global _start
.ent    _start 
_start:

  sll $4, $2, 1
  sll $4, $2, 31

  srl $4, $2, 1
  srl $4, $2, 31

  sra $4, $2, 1
  sra $4, $2, 31

_end:

.end _start
