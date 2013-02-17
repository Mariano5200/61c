.text

.global _start
.ent    _start 
_start:

  beq   $4,$2,_start
  bne   $4,$2,_start

_end:

.end _start
