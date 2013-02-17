.text

.global _start
.ent    _start 
_start:

  xori $4,$3,0xfffd
  ori  $4,$3,0xfffd
  andi $4,$3,0xfffd

_end:

.end _start
