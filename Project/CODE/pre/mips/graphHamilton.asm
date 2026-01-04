.data
Graph_edge: .space 256 # 8x8 graph
book: .space 32       # flag array
ans: .space 4         # answer of boolean

.text
main:
    # read n(points)
    li $v0, 5
    syscall
    move $s0, $v0        # $s0 = n

    # read m(edges)
    li $v0, 5
    syscall
    move $s1, $v0        # $s1 = m

    li $t0, 0
    la $t1, Graph_edge
    li $t2, 0
init_graph:
    bge $t2, 256, init_graph_end
    sw $zero, 0($t1)
    addi $t1, $t1, 4
    addi $t2, $t2, 4
    j init_graph
    
init_graph_end:

    # read edge, matrix
    li $t0, 0            # int i = 0
LOOP_READ:
    bge $t0, $s1, LOOP_READ_END

    # x
    li $v0, 5
    syscall
    move $t1, $v0        # x

    # y
    li $v0, 5
    syscall
    move $t2, $v0        # y

    subi $t1, $t1, 1     # x = x - 1
    subi $t2, $t2, 1     # y = y - 1

    # G[x][y] = 1 G[y][x] = 1
    li $t3, 1
    mul $t4, $t1, 8      # x * 8
    add $t5, $t4, $t2    # x*8 + y
    sll $t5, $t5, 2      # *4, byte to word
    sw $t3, Graph_edge($t5)

    # G[y][x]
    mul $t4, $t2, 8      
    add $t5, $t4, $t1    
    sll $t5, $t5, 2      
    sw $t3, Graph_edge($t5)

    addi $t0, $t0, 1
    j LOOP_READ

LOOP_READ_END:
    # book => 0
    li $t0, 0
    la $t1, book

    sw $zero, ans

    # dfs entrance here
    li $a0, 0
    jal dfs

    li $v0, 1
    lw $a0, ans
    syscall

    li $v0, 10
    syscall

# --- dfs hanshu ---
dfs:
	subi $sp, $sp, 8
	sw $a0, 0($sp)
	sw $ra, 4($sp)
	
	lw $t1, 0($sp)
	sll $t1, $t1, 2
	li $t2, 1
	sw $t2, book($t1) # book[x] = 1;
	
	li $t3, 0
	li $t1, 1 # flag in $t1 !!!
LOOP_CHECK_ALLPOINTS:
	bge $t3, $s0, END_CA
	sll $t4, $t3, 2
	lw $t2, book($t4)
	and $t1, $t1, $t2
	addi $t3, $t3, 1
	j LOOP_CHECK_ALLPOINTS
END_CA:
	
	# whether a ring is formed
	lw $t2, 0($sp)
	mul $t2, $t2, 8
	add $t2, $t2, $0 # index = 8 * x + 0
	sll $t2, $t2, 2
	lw $t2, Graph_edge($t2)
	and $t1, $t1, $t2
	
	bne $t1, 1, NOT_FOUND
	
	li $t2, 1
	sw $t2, ans
	
	lw $a0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8 # restore here
	
	jr $ra
	
NOT_FOUND:
	li $t3, 0
LOOP_ITERATE:
	bge $t3, $s0, END_ITERATE
	
	# if !book[i] and G[x][i]
	sll $t4, $t3, 2 # index = i
	lw $t5, book($t4)
	bne $t5, 0, SKIP_LOOP
	
	lw $t5, 0($sp)
	mul $t6, $t5, 8
	add $t6, $t6, $t3
	sll $t6, $t6, 2
	lw $t7, Graph_edge($t6) # G[x][i]
	bne $t7, 1, SKIP_LOOP
	
	# keep $t3 the counter!
	subi $sp, $sp, 4
	sw $t3, 0($sp)
	
	move $a0, $t3
	jal dfs
	
	lw $t3, 0($sp)
	addi $sp, $sp, 4
SKIP_LOOP:
	addi $t3, $t3, 1
	j LOOP_ITERATE
END_ITERATE:
	
	lw $t1, 0($sp)
	sll $t1, $t1, 2
	li $t2, 0
	sw $t2, book($t1)
	
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra
	
	