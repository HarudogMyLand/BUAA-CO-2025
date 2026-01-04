.macro readInt(%des)
    li $v0, 5
    syscall
    move %des, $v0
.end_macro

.macro printInt(%des)
# .data
#     des: .asciiz %des
.text
    li $v0, 1
    move $a0, %des
    syscall
    # li $v0, 4
    # la $a0, des
    # syscall
.end_macro

.macro push(%var)
    sub $sp, $sp, 4
    sw %var, 0($sp)
.end_macro

.macro pop(%var)
    lw %var, 0($sp)
    addi $sp, $sp, 4
.end_macro

.macro for_begin(%reg, %regEnd, %start, %end)
    li %reg, 0
%start:
    bge %reg, %regEnd, %end
.end_macro

.macro for_end(%reg, %start, %end)
    addi %reg, %reg, 1
    j %start
%end:
.end_macro

.macro end_all
    li $v0, 10
    syscall
.end_macro

# ==========
.eqv n $s0
.eqv m $s1

.eqv sx $s2
.eqv sy $s3
.eqv ex $s4
.eqv ey $s5

.eqv count $s6

.eqv i $t0
.eqv jj $t1
# ==========
.data
    maze: .space 400
    visited: .space 400
.text
start:
    readInt(n)
    readInt(m)
    li count, 0
    li $t3, 0
    for_begin(i, n, L_READ, L_READ_END)
        for_begin(jj, m, L_READ_INNER, L_READ_INNER_END)
            readInt($t2)
            sw $t2, maze($t3)
            addi $t3, $t3, 4
        for_end(jj, L_READ_INNER, L_READ_INNER_END)
    for_end(i, L_READ, L_READ_END)

    li $t3, 0
    for_begin(i, n, L, L_END)
        for_begin(jj, m, L_INNER, L_INNER_END)
            sw $0, visited($t3)
            addi $t3, $t3, 4
        for_end(jj, L_INNER, L_INNER_END)
    for_end(i, L, L_END)


    readInt(sx)
    addi sx, sx, -1

    readInt(sy)
    addi sy, sy, -1

    readInt(ex)
    addi ex, ex, -1

    readInt(ey)
    addi ey, ey, -1

    jal count_all

    printInt(count)

    end_all

count_all:
    move $a0, sx
    move $a1, sy
    push($ra)
    jal dfs
    pop($ra)
    jr $ra

dfs:
    beq $a0, ex, CHECK_Y
    j NEXT
CHECK_Y:
    beq $a1, ey, END
    j NEXT

NEXT:
    mul $t2, $a0, m
    add $t2, $t2, $a1
    sll $t2, $t2, 2

    li $t3, 1
    sw $t3, visited($t2)

    # recurse
    addi $t2, $a0, -1
    addi $t3, $a1, 0

    bge $t2, n, NEXT_TIME
    blt $t2, 0, NEXT_TIME
    bge $t3, m, NEXT_TIME
    blt $t3, 0, NEXT_TIME

    mul $t4, $t2, m
    add $t4, $t4, $t3
    sll $t4, $t4, 2
    lw $t5, maze($t4)

    bne $t5, 0, NEXT_TIME
    lw $t5, visited($t4)

    bne $t5, 0, NEXT_TIME
    push($a0)
    push($a1)
    push($ra)
    move $a0, $t2
    move $a1, $t3
    jal dfs
    pop($ra)
    pop($a1)
    pop($a0)

NEXT_TIME:
    # recurse
    addi $t2, $a0, 1
    addi $t3, $a1, 0

    bge $t2, n, NEXT_TIME_1
    blt $t2, 0, NEXT_TIME_1
    bge $t3, m, NEXT_TIME_1
    blt $t3, 0, NEXT_TIME_1

    mul $t4, $t2, m
    add $t4, $t4, $t3
    sll $t4, $t4, 2
    lw $t5, maze($t4)

    bne $t5, 0, NEXT_TIME_1
    lw $t5, visited($t4)

    bne $t5, 0, NEXT_TIME_1
    push($a0)
    push($a1)
    push($ra)
    move $a0, $t2
    move $a1, $t3
    jal dfs
    pop($ra)
    pop($a1)
    pop($a0)
NEXT_TIME_1:
    # recurse
    addi $t2, $a0, 0
    addi $t3, $a1, -1

    bge $t2, n, NEXT_TIME2
    blt $t2, 0, NEXT_TIME2
    bge $t3, m, NEXT_TIME2
    blt $t3, 0, NEXT_TIME2

    mul $t4, $t2, m
    add $t4, $t4, $t3
    sll $t4, $t4, 2
    lw $t5, maze($t4)

    bne $t5, 0, NEXT_TIME2
    lw $t5, visited($t4)

    bne $t5, 0, NEXT_TIME2
    push($a0)
    push($a1)
    push($ra)
    move $a0, $t2
    move $a1, $t3
    jal dfs
    pop($ra)
    pop($a1)
    pop($a0)
NEXT_TIME2:
    # recurse
    addi $t2, $a0, 0
    addi $t3, $a1, 1

    bge $t2, n, NEXT_TIME3
    blt $t2, 0, NEXT_TIME3
    bge $t3, m, NEXT_TIME3
    blt $t3, 0, NEXT_TIME3

    mul $t4, $t2, m
    add $t4, $t4, $t3
    sll $t4, $t4, 2
    lw $t5, maze($t4)

    bne $t5, 0, NEXT_TIME3
    lw $t5, visited($t4)

    bne $t5, 0, NEXT_TIME3
    push($a0)
    push($a1)
    push($ra)
    move $a0, $t2
    move $a1, $t3
    jal dfs
    pop($ra)
    pop($a1)
    pop($a0)

NEXT_TIME3:
    mul $t2, $a0, m
    add $t2, $t2, $a1
    sll $t2, $t2, 2

    li $t3, 0
    sw $t3, visited($t2)
    jr $ra
END:
    addi count, count, 1
    jr $ra
