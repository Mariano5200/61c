.text

.global _start
.ent    _start 
_start:

  beq   $4,$2,_end
  bne   $4,$2,_end

_end:

.end _start
