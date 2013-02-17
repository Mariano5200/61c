.text
.set noat

.global _start
.ent    _start 
_start:

  addu $1, $2, $3
  subu $1, $2, $3
  and  $1, $2, $3
  or   $1, $2, $3
  xor  $1, $2, $3
  nor  $1, $2, $3
  slt  $1, $2, $3
  sltu $1, $2, $3

_end:

.end _start
