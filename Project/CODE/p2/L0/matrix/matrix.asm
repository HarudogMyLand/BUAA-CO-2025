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
# =========
.eqv i  $t0
.eqv jj $t1
.eqv k  $t2
.eqv l  $t3
.eqv num $s0
# ==========
.data
    matrix1: .space 400
    matrix2: .space 400
.text
    readInt()
    move num, $v0 # num

    li $t4, 0
    for_begin(i, num, READ_MATRIX, END_MATRIX)
        for_begin(jj, num, READ_MATRIX_INNER, END_MATRIX_INNER)
            readInt()
            sw $v0, matrix1($t4)
            addi $t4, $t4, 4
        for_end(jj, READ_MATRIX_INNER, END_MATRIX_INNER)
    for_end(i, READ_MATRIX, END_MATRIX)

    li $t4, 0
    for_begin(i, num, READ_MATRIX1, END_MATRIX1)
        for_begin(jj, num, READ_MATRIX_INNER1, END_MATRIX_INNER1)
            readInt()
            sw $v0, matrix2($t4)
            addi $t4, $t4, 4
        for_end(jj, READ_MATRIX_INNER1, END_MATRIX_INNER1)
    for_end(i, READ_MATRIX1, END_MATRIX1)


    for_begin(i, num, L1, L1_END)
        for_begin(jj, num, L2, L2_END)
            li $s4, 0
            for_begin(l, num, L3, L3_END)
                
                mul $t4, i, num
                add $t4, $t4, l
                sll $t4, $t4, 2

                mul $t5, num, l
                add $t5, $t5, jj
                sll $t5, $t5, 2

                lw $t4, matrix1($t4)
                lw $t5, matrix2($t5)

                mul $t4, $t4, $t5

                add $s4, $s4, $t4

            for_end(l, L3, L3_END)
            printInt($s4)
        for_end(jj, L2, L2_END)
        printChar("\n")
    for_end(i, L1, L1_END)

    end_all
