.macro printInt(%var)
.data
    space: .asciiz " "
.text
    addi	$v0, $0, 1
    add		$a0, $0, %var
    syscall
    la $a0, space
    li $v0, 4
    syscall
.end_macro

.macro printChar(%var)
.data
    char: .asciiz %var
.text
    li $v0, 4
    la $a0, char
    li $a1, 1
    syscall
.end_macro

.macro readInt()
    addi $v0, $0, 5
    syscall
.end_macro

.macro for_begin(%reg, %regEnd, %start, %end)
    add %reg, $0, $0
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
.eqv i  $t0
.eqv jj $t1
.eqv k  $t2
.eqv l  $t3
.eqv m1 $s0
.eqv n1 $s1
.eqv m2 $s2
.eqv n2 $s3
# ==========
.data

    matrix: .space 4000
    core:   .space 4000
    out:    .space 4000

.text
    # Read m1, n1, m2, n2
    readInt()
    move $s0, $v0 # m1
    readInt()
    move $s1, $v0 # n1
    readInt()
    move $s2, $v0 # m2
    readInt()
    move $s3, $v0 # n2

    li $t4, 0
    for_begin(i, m1, READ_MATRIX, END_MATRIX)
        for_begin(jj, n1, READ_MATRIX_INNER, END_MATRIX_INNER)
            
            readInt()
            sw $v0, matrix($t4)
            addi $t4, $t4, 4
        for_end(jj, READ_MATRIX_INNER, END_MATRIX_INNER)
    for_end(i, READ_MATRIX, END_MATRIX)

    li $t4, 0
    for_begin(i, m2, READ_CORE, END_CORE)
        for_begin(jj, n2, READ_CORE_INNER, END_CORE_INNER)
            
            readInt()
            sw $v0, core($t4)
            addi $t4, $t4, 4
        for_end(jj, READ_CORE_INNER, END_CORE_INNER)
    for_end(i, READ_CORE, END_CORE)

    sub $t4, m1, m2
    addi $t4, $t4, 1

    sub $t5, n1, n2
    addi $t5, $t5, 1

    for_begin(i, $t4, L1, L1_END)
        for_begin(jj, $t5, L2, L2_END)
            li $s4, 0
            for_begin(k, m2, L3, L3_END)
                for_begin(l, n2, L4, L4_END)
                add $t6, i, k
                add $t7, jj, l
                mul $t6, $t6, n1
                add $t6, $t6, $t7
                sll $t6, $t6, 2

                mul $t7, n2, k
                add $t7, $t7, l
                sll $t7, $t7, 2

                lw $t6, matrix($t6)
                lw $t7, core($t7)

                mul $t8, $t6, $t7

                add $s4, $s4, $t8
                for_end(l, L4, L4_END)
            for_end(k, L3, L3_END)
            printInt($s4)
        for_end(jj, L2, L2_END)
        printChar("\n")
    for_end(i, L1, L1_END)

    end_all
