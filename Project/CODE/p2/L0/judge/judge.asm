.data
    str: .space 21
    end: .ascii "\0"
    newline: .ascii "\n"
.text
start:
    lb $t7, newline

    li $v0, 5
    syscall
    
    addi $v0, $v0,1
    move $s0, $v0 
    li $s4, 1 
    

    li $t0, 1
    la $t1, str
READ:
#     li $v0, 8
#     la $a0, str
#     move $a1, $s0 
#     syscall
    bge $t0, $s0, END_READ
    li $v0, 12
    syscall
    sb $v0, 0($t1)
    addi $t1, $t1, 1
    addi $t0, $t0, 1
    j READ
END_READ:
    
    
    li $t0, 0
    addi $t1, $s0, -2
    
CHECK_LOOP:
    bge $t0, $t1, END
    
    la $t2, str
    add $t3, $t2, $t0
    add $t4, $t2, $t1
    
    lb $t5, 0($t3)

    lb $t6, 0($t4)
    
    bne $t5, $t6, NOT_PA
    
    addi $t0, $t0, 1
    addi $t1, $t1, -1
    j CHECK_LOOP
    
NOT_PA:
    li $s4, 0
    
END:
    li $v0, 1
    move $a0, $s4
    syscall
    
    li $v0, 10
    syscall
