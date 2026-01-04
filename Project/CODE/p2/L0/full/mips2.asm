# START MACRO

.macro read_int()
	li $v0, 5
	syscall
.end_macro

.macro print_int(%int, %char)
.data
	char: .asciiz %char
.text
	li $v0, 1
	move $a0, %int
	syscall
	li $v0, 4
	la $a0, char
	syscall
.end_macro

.macro print_char(%src)
.data
	src: .asciiz %src
.text
	la 	$a0, src
	li	$v0, 4
	syscall 
.end_macro

.macro for_begin(%reg, %conditionReg, %start, %end)
	li %reg, 0
%start:
	bge %reg, %conditionReg, %end
.end_macro

.macro for_end(%reg, %start, %end)
	addi %reg, %reg, 1
	j %start
%end:
.end_macro

.macro push(%src)
    addi    $sp, $sp, -4
    sw      %src, 0($sp)
.end_macro

.macro pop(%des)
    lw      %des, 0($sp)
    addi    $sp, $sp, 4
.end_macro

.macro end_all
	li $v0, 10
	syscall
.end_macro

# END MACRO
.data
	array: .space 28	
	symbol: .space 28	
	newline: .asciiz "\n"	
.text
	read_int()
	move $s0, $v0
	
	for_begin($t0, $s0, INIT_SYMBOL, END_INIT)
		sll $t1, $t0, 2
		sw $zero, symbol($t1)
	for_end($t0, INIT_SYMBOL, END_INIT)
	
	li $a0, 0
	jal fullArray
	
	end_all
	
fullArray:
	bge $a0, $s0, PRINT_PERM
	j HERE
	
PRINT_PERM:
	for_begin($t0, $s0, START_1, END_1)
		sll $t2, $t0, 2
		lw $t1, array($t2)
		print_int($t1, " ")
	for_end($t0, START_1, END_1)
	print_char("\n")
	jr $ra	
HERE:
	for_begin($t0, $s0, START_2, END_2)
		sll $t2, $t0, 2
		lw $s1, symbol($t2)
		bne $s1, $zero, NO
		
		# array[index] = i + 1
		addi $t1, $t0, 1
		sll $t3, $a0, 2
		sw $t1, array($t3)
		
		li $t1, 1
		sw $t1, symbol($t2)
		
		push($a0)
		push($t0)
		push($t2)
		push($s1)
		push($ra)
		addi $a0, $a0, 1
		jal fullArray
		pop($ra)
		pop($s1)
		pop($t2)
		pop($t0)
		pop($a0)
		
		sw $0, symbol($t2)
	NO:
	for_end($t0, START_2, END_2)
	jr $ra