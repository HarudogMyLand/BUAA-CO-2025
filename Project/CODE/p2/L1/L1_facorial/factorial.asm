.macro printInt(%var)
    li $v0, 1
    move $a0, %var
    syscall
.end_macro

.macro readInt(%des)
    li $v0, 5
    syscall

    move %des, $v0
.end_macro

.macro printChar(%char)
.data
    char: .asciiz %char
.text
    li $v0, 4
    la $a0, char
    syscall
.end_macro

# =========
.eqv n      $s0
.eqv carry  $s1
.eqv x      $s2
.eqv size   $s3

.eqv i      $t0
# ==========
.data
    res: .space 4004
.text
    
    readInt(n)

    li size, 1
    sw size, res($0)

    li x, 2

W_L1:
    bgt x, n, END_L1
        li carry, 0
        li i, 0

W_L2:
        bge i, size, END_L2
            move $t1, i
            sll $t1, $t1, 2
            lw $t2,res($t1)
            mul $t2, $t2, x
            add $t2, $t2, carry

			li $t7, 10
            div $t2, $t7
            mfhi $t2    # res
            mflo carry  # quo

            sw $t2, res($t1)
            addi i, i, 1
            j W_L2
END_L2:

W_L3:
        ble carry, $0, END_L3
            div carry, $t7
            mfhi $t1
            # res[i] = $t1

            move $t3, i
            sll $t3, $t3, 2
            sw $t1,res($t3)
            addi i, i, 1

            addi size, size, 1
            mflo carry
            j W_L3
END_L3:
    addi x, x, 1
    j W_L1
END_L1:

    subi i, size, 1
PRINT:
    blt i, 0, END_ALL
        move $t3, i
        sll $t3, $t3, 2
        lw $t1,res($t3)
        printInt($t1)
        subi i, i, 1
        j PRINT
END_ALL:
printChar("\n")

li $v0, 10
syscall
