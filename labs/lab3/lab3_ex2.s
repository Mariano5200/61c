# $t0 = $s0
# $t1 = $s1
# $t2 = $t0 + $t1
# $t3 = $t1 + $t2
# ...
# $t7 = $t5 + $t6

add $t0, $s0, $0 # $t0 <-- $s0
add $t1, $s1, $0
add $t0, $t1, $t2 # $t2 = $t0 + $t1
add $t1, $t2, $t3
add $t2, $t3, $t4
add $t3, $t4, $t5
add $t4, $t5, $t6
add $t5, $t6, $t7
