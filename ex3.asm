#nhap 1 mang tu ban phim
#tim phan tu max
# m ->M ? s?
.data
	Message3: .asciiz "So lon nhat trong day: "
	A:	.word	#Mang A - cac so nguyn duoc nhap tu ban phim
	Message1: .asciiz "Nhap n (so ptu cua mang): "
	Message2: .asciiz "Nhap phan tu: "
	Message4: .asciiz "Nhap m: "
	Message5: .asciiz "Nhap M (M>=m): "
	Message6: .asciiz "Trong khoang m -> M co so phan tu: "
.text
Main:
Input_n: #nhap gia tri cua n - integer >0
	li	$v0, 51
	la	$a0, Message1
	syscall
	bne	$a1, $zero, Input_n 	#neu không nhap dung n la integer -> nhap lai
	slt	$t0, $zero, $a0		# If 0<n then $t0=1 else $t0=0
	beq	$t0, $zero, Input_n 	# If $t0= 0(n<0) go to Input_n
	add	$s0, $a0, $zero 	#gan gia tri n vao $s0

Input_Array: 
	la	$s1, A 			#Lay dia chi mang A
	add	$s3, $zero, $zero 	#bien dem i
Loop1:
	beq	$s3, $s0, endLoop1 	#if (i = n) goto endloop1 
InputAi:				 #nhap A[i]
	li	$v0, 51
	la	$a0, Message2
	syscall
	bne	$a1, $zero, InputAi 	#neu A[i] ko la integer -> nhap lai
	
	add	$t1, $s3, $s3
	add	$t1, $t1, $t1
	add	$t1, $t1, $s1 		#dia chi cua A[i] -> $t1
	sw	$a0, 0($t1)
	addi	$s3, $s3, 1		#i=i+1
	j	Loop1
endLoop1:
	add	$a0, $s0, $zero	#truyen n vao a0
	add	$a1, $s1, $zero	#truyen dia chi A vao a1
	jal	findMax
	#in ra max sau ctr con
	add	$s2, $v0, $zero
	add	$a1, $s2, $zero
	li	$v0, 56
	la	$a0, Message3
	syscall
#-------------------------------------------------------
Inputm: #nhap gia tri cua m - integer 
	li	$v0, 51
	la	$a0, Message4
	syscall
	bne	$a1, $zero, Inputm 	#neu không nhap dung n la integer -> nhap lai
	nop
	add	$s4, $a0, $zero 	#gan gia tri m vao $s4
	
InputM: #Nhap M if (m<=M)
	li	$v0, 51
	la	$a0, Message5
	syscall
	bne	$a1, $zero, InputM 	#neu khong nhap dung n la integer -> nhap lai
	nop
	slt	$t0, $a0, $s4		# If $a0<s4 t0=1
	bne	$t0, $zero, InputM 	# If t0!=0 (M < m) goto inputM 
	nop
	add	$s5, $a0, $zero 	#gan M vao $s5

	#tinh so cac ptu
	add	$a0, $s0, $zero	#truyen n vao a0
	add	$a1, $s1, $zero	#truyen dia chi A vao a1
	add	$a2, $s4, $zero	#truyen m vao a2
	add	$a3, $s5, $zero	#truyen M vao a3
	jal 	funCount
	add	$a1, $v0, $zero
	li	$v0, 56
	la	$a0, Message6
	syscall
	
done:	
	li	$v0, 10 #exit
	syscall
#---------------------------------------------
findMax:
	addi	$sp, $sp, -8 #can dung 2 thanh ghi
	sw	$s0, 4($sp)
	sw	$s1, 0($sp)
	
	lw	$s0, 0($a1) 		#lay ra gia tri cua A[0] -> s0
	add 	$v0, $s0, $zero 	#gan A[0] la max -> s1
	addi	$s1, $zero, 1 		#bien dem i = 1 -> s2, bat dau so sanh tu A[1]
Loop2:
	beq	$s1, $a0, endFindMax 	#If i == n goto endLoop2
	
	add	$t1, $s1, $s1
	add	$t1, $t1, $t1
	add	$t1, $t1, $a1		#dia chi cua A[i] -> $t1
	lw	$s0, 0($t1)		#lay gia tri cua A[i] gan vao $s0 ($s0=A[i])
	
	slt	$t0, $v0, $s0 		#If max < A[i]($s2<$s4) then $t0=1 else $t0=0
	beq	$t0, $zero, ok 		# if ($t0=0)(max>A[i]) goto ok
	add	$v0, $s0, $zero		#if max < A[i] then max = A[i]	
ok:
	addi	$s1, $s1, 1 		#i=i+1
	j	Loop2

endFindMax:
	lw	$s0, 4($sp)
	lw	$s1, 0($sp)
	addi	$sp, $sp, 8 #tra lai gia tri cho 2 thanh ghi
	jr	$ra
#---------------------------------------------------------
funCount:
	addi	$sp, $sp, -12 #can dung 3 thanh ghi
	sw	$s0, 8($sp)
	sw	$s1, 4($sp)
	sw	$s2, 0($sp)
Count: 
	add	$s1,$zero,$zero		#gan cout=0
	addi	$s2, $zero, 0 		#bien dem i = 0, bat dau dem tu A[0]
Loop3:
	beq	$s2, $a0, endLoop3 	#If i == n goto endLoop2
	add	$t1, $s2, $s2
	add	$t1, $t1, $t1
	add	$t1, $t1, $a1	#dia chi cua A[i] -> $t1
	lw	$s0, 0($t1)		#lay gia tri cua A[i] gan vao $s0 ($s0=A[i])
	
	slt	$t0, $s0, $a2 		#If A[i]<m then $t0=1 else $t0=0
	beq	$t0, $zero, ktraM		# if ($t0=0)(A[i]>m) goto ktraM
	nop
	j ok1	
	
ktraM: 
	slt	$t0, $a3, $s0 #if A[i]<=M
	bne	$t0, $zero, ok1	# if ($t0=0)(A[i]>M) goto ok
	addi	$s1, $s1, 1		#if m <= A[i]<=M then cout=cout+1	
	j ok1
ok1:
	addi	$s2, $s2, 1 		#i=i+1
	j	Loop3
endLoop3:	
	#tra lai gia tr cho cac thanh ghi
	add	$v0, $s1, $zero
	lw	$s0, 8($sp)
	lw	$s1, 4($sp)
	lw	$s2, 0($sp)
	addi	$sp, $sp, 12
	jr $ra
