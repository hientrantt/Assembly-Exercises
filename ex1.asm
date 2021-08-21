# Find all prime numbers (such as 2, 3, 5, 7, ...)  in a range from the integer N to the integer M.
.data
	Message3: .asciiz "So cac so nguyen to co trong day: "
	Message1: .asciiz "Nhap so nguyen N: "
	Message2: .asciiz "Nhap so nguyen M (M>=N): "
	A:	.word	#Mang A luu cac so nguyen to
.text
Main:
InputN: 	#nhap gia tri cua n - integer
	li	$v0, 51
	la	$a0, Message1
	syscall
	bne	$a1, $zero, InputN 	#neu không nhap dung n la integer -> nhap lai
	nop
	add	$s0, $a0, $zero 	#gan gia tri n vao $s0
	
InputM: 	#Nhap m 
	li	$v0, 51
	la	$a0, Message2
	syscall
	bne	$a1, $zero, InputM 	#neu khong nhap dung n la integer -> nhap lai
	nop
	slt	$t0, $a0, $s0
	bne	$t0, $zero, InputM 	#neu m < n -> nhap lai
	nop
	add	$s1, $a0, $zero 	#gan m vao $s1

	la	$s3, A 			#$s3 -> dia chi cua mang A - chua tat ca cac so nguyen to trong day
	#truyen cac tham so vao mang
	add	$a0, $s0, $zero #n->$a0
	add	$a1, $s1, $zero #m->$a1
	add	$a2, $s3, $zero #A -> $a2
	jal	Prime 			#ham lay ra cac so nguyen to va luu vao mang A
	nop
done:
	add	$s2, $v0, $zero
	add	$a1, $s2, $zero
	li	$v0, 56
	la	$a0, Message3
	syscall
	
	li	$v0, 10 #exit
	syscall 
	
#---------------------------------------------------------------------------------
Prime:
	add	$sp, $sp, -12		#luu tru gia tri cua thanh ghi s0, s1 và ra vao sp
	sw	$s0, 8($sp)
	sw	$s1, 4($sp)
	sw	$ra, 0($sp)

	add	$s1, $zero, $zero 	#so cac so nguyen to trong day m->n = 0
	add	$s0, $s0, $zero 	#gan gia tri cua n vao $s0

Check:	 	#kiem tra xem n > 1? (cac so nguyen to > 1. be thua 1 -> khong la so nguyen to
	slti	$t0, $s0, 2
	beq	$t0, $zero, Loop
	nop
	addi	$s0, $s0, 1		#neu n < 1 ->  + 1 vào n
	j	Check
	nop
Loop: 		#lan lýot kiem tra t? n -> m
	slt 	$t0, $a1, $s0
	bne	$t0, $zero, EndPrime 	#neu n == m -> ket thúc ham Prime
	nop
	sw	$a0, -4($sp)
	add	$a0, $s0, $zero 	# truyen so dang xet vao ham test
	jal	Test 			#Test -> kiem tra xem n co la nguyen to
	nop
	lw	$a0, -4($sp)
	bne	$v0, $zero, False	#Test tra ve ket qua v1. neu v1=0 -> n la nguyen to
	nop
True:		#neu n la nguyen to thi luu gia tri cua n vao mang A
	add	$t0, $s1, $s1
	add	$t0, $t0, $t0
	add	$t0, $a2, $t0
	sw	$s0, 0($t0)
	addi	$s1, $s1, 1		#so cac so nguyen to +1 - tang do dai mang A
False:	 	#neu n khong la nguyen to (v0 >= 1)
	addi	$s0, $s0, 1		#n=n+1 -> kiem tra so tiep theo
	j	Loop
	nop
EndPrime:	#ket thuc ham Prime
	add	$v0, $s1, $zero
	lw	$ra, 0($sp) 		#tra lai cac gia tri cho thanh ghi ra va s2
	lw	$s1, 4($sp)
	lw	$s0, 8($sp)
	addi	$sp, $sp, 12
	jr	$ra
	nop

#------------------------------------------------------------------------------------
Test:	#ham kiem tra tinh nguyen to cua n
	addi	$sp, $sp, -8		#luu gia tri thanh ghi s4 vao sp
	sw	$s0, 4($sp)
	sw	$s1, 0($sp)
	add	$s1, $zero, $zero
	#chia lan lýot n cho các so tu 2 ðen n/2
	addi 	$s0, $zero, 2 		#bat ðau chia cho j = 2 -> gan j vao $s4
	addi	$t2, $zero, 2
	divu	$a0, $t2 #n/2 = ?
	mflo	$t2			#gan gia tri n/2 cho $t2

LoopTest: 	#kiem tra lan lýot tu j = 2 -> j/2
	slt 	$t0, $t2, $s0
	bne	$t0, $zero, End 	#neu j = n/2 -> dung
	nop
	divu	$a0, $s0		#chia so dang xet n cho j
	mfhi	$t1 			#lay phan du de kiem tra
	bne	$t1, $zero, TrueTest 	#neu chia het -> n khong la nguyen to -> tang v1 len 1
	nop	
	addi	$s1, $zero, 1 
TrueTest:
	addi	$s0, $s0, 1 		#tang j len 1 va tiep tuc kiem tra
	j	LoopTest
	nop

End:		#ket thuc kiem tra, tra lai gia tri cho thanh ghi s4
	add	$v0, $s1, $zero
	lw	$s1, 0($sp)
	lw	$s0, 4($sp)
	addi	$sp, $sp, 8
	jr	$ra
	nop
 
