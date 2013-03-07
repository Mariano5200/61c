# Format of list nodes:
# first 4 bytes are value, second 4 bytes are pointer to next

.data
spaceString: .asciiz " "
newlineString: .asciiz "\n"
listBeforeString: .asciiz "List before: "
listAfterString: .asciiz "List after: "

.text
main:
  jal create_default_list
  addu $s0 $v0 $0		# $v0 = $s0 is head of node list

  #print "list before: "
  la $a0 listBeforeString
  li $v0 4
  syscall

  #print the list
  addu $a0 $s0 $0
  jal print_list

  # print a newline
  jal print_newline

  #issue the map call
  addu $a0 $s0 $0 # load the address of the first node into $a0
  # load the address of the function into $a1 (check out la)
  #FIXME: YOUR_INSTRUCTION_HERE
  la  $a1, square        # load square into a1
  jal map

  # print "list after: "
  la $a0 listAfterString
  li $v0 4
  syscall

  #print the list
  addu $a0 $s0 $0
  jal print_list

  li $v0 10
  syscall

map:
  addiu $sp $sp -12
  sw $ra 0($sp)
  sw $s1 4($sp)
  sw $s0 8($sp)

  beq $a0 $0 done  # if we were given a null pointer, we're done.

  addu $s0 $a0 $0 # save address of this node in $s0
  addu $s1 $a1 $0 # save address of function in $s1

  # remember that each node is 8 bytes long: 4 for the value followed by 4 for the pointer to next
  # load the value of the current node into $a0
  # FIXME: YOUR_INSTRUCTION_HERE
  lw $a0, 0($s0)        # load only 4 bytes.
  # call the function on that value.
  # YOUR_INSTRUCTION_HERE
  jal square #jal vs jalr?
  # store the returned value back into the node
  # YOUR_INSTRUCTION_HERE
  sw $v0, 0($s0)
  # load the address of the next node into $a0
  # YOUR_INSTRUCTION_HERE
  lw $a0, 4($s0) # load only 4 bytes, 4 after s0.
  # put the address of the function back into $a1 to prepare for the recursion
  # YOUR_INSTRUCTION_HERE
  move $a1, $s1 # $a1 = $s1
  # recurse
  #YOUR_INSTRUCTION_HERE
  jal map    # jump to map and save position to $ra


 done:
  lw $s0 8($sp)
  lw $s1 4($sp)
  lw $ra 0($sp)
  addiu $sp $sp 12
  jr $ra

square:
  mul $v0 $a0 $a0
  jr $ra

create_default_list:
  addiu $sp $sp -4
  sw $ra 0($sp)
  li $s0 0  # pointer to the last node we handled
  li $s1 0  # number of nodes handled
 loop:             #do...
  li $a0 8
  jal malloc        # get memory for the next node
  sw $s1, 0($v0)    # node->value = i
  sw $s0, 4($v0)    # node->next = last
  addu $s0 $0 $v0   # last = node
  addiu $s1, $s1, 1 # i++
  bne $s1 10 loop  # ... while i!= 10
  lw $ra 0($sp)
  addiu $sp $sp 4
  jr $ra

print_list:
  bne $a0, $0, printMeAndRecurse
  jr $ra             # nothing to print
 printMeAndRecurse:
  addu $t0, $a0, $0  # t0 gets current node address
  lw $a0, 0($t0)     # a0 gets value in current node
  li $v0 1           # preparte for print integer syscall
  syscall
  la $a0 spaceString # a0 gets address of string containing space
  li $v0 4           # prepare for print string syscall
  syscall
  lw $a0 4($t0)      # a0 gets address of next node
  j print_list       # recurse. We don't have to use jal because we already have where we want to return to in $ra

print_newline:
  la $a0 newlineString
  li $v0 4
  syscall
  jr $ra

malloc:
  li $v0 9
  syscall
  jr $ra
