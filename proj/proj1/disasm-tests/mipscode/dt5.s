.text

.global _start
.ent    _start 
_start:

  xori $4,$3,2
  ori  $4,$3,2
  andi $4,$3,2

_end:

.end _start
