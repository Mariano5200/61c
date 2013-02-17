.text

.global _start
.ent    _start 
_start:

  slti  $4,$3,2
  sltiu $4,$3,2
  addiu $4,$3,2

_end:

.end _start
