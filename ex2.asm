.data
#cau lenh mips gom opcode va 3 toan hang. 
register: .asciiz "$zero-$at-$v0-$v1-$a0-$a1-$a2-$a3-$t0-$t1-$t2-$t3-$t4-$t5-$t6-$t7-$t8-$t9-$s1-$s2-$s3-$s4-$s5-$s6-$s7-$k0-$k1-$gp-$sp-$fp-$ra-$0-$1-$2-$3-$4-$5-$6-$7-$8-$9-$10-$11-$12-$13-$14-$15-$16-$17-$18-$19-$20-$21-$22-$23-$24-$25-$26-$27-$28-$29-$30-$31-"
#ma opcode hop le:
opcode: .asciiz "lw-lb-sw-sb-addi-add-addiu-addu-and-andi-beq-bne-div-divu-j-jal-lui-mfhi-mflo-mul-nop-nor-or-ori-sll-slt-slti-sub-subu-syscall-xor-xori-"
#quy uoc toan hang: 1 - thanh ghi, 2 - so, 3 - Label, 4 - offset(base): number(register), 0 - null
#toan hang tuong ung voi cac opcode tren:
operand: .asciiz "140-140-140-140-112-111-112-111-111-112-113-113-110-110-300-300-120-100-100-111-000-111-111-112-112-111-112-111-111-000-111-112-"

msg1: .asciiz "Nhap lenh can kiem tra: "
msg2: .asciiz "\nopcode: "
msg21: .asciiz ": hop le!\n"
msg22: .asciiz ": khong hop le!\n"
msg3: .asciiz "\nToan hang: "
msg4: .asciiz "\nCau lenh"
msg5: .asciiz "\kiem tra them 1 lenh nua? 1(yes)|0(no): "
input: .space 200 # chuoi dau vao
tmp: .space 20 #bien tmp luu thanh phan cat duoc
tmp2: .space 20 # luu khuon dang code
tmp3:	.space 20 # thanh phan cat duoc o offset(base)
.text
main:
Input: # lay dau vao
	li	$v0, 4
	la	$a0, msg1
	syscall
	li	$v0, 8
	la	$a0, input 
	li	$a1, 200
	syscall
	#tach chu va so sanh
	la	$s0, input #dia chi input
	add	$s1, $zero, $zero # i -> dem tung ky tu trong tmp
readOpcode: 
	add	$a0, $s0, $zero # truyen tham so vao cutComponent
	add	$a1, $s1, $zero #
	la	$a2, tmp
	jal	cutComponent
	add	$s1, $v0, $zero #
	add	$s7, $v1, $zero #so ky tu co trong opcode
checkOpcode:	
	la	$a0, tmp
	add	$a1, $s7, $zero
	la	$a2, opcode
	jal 	compareOpcode
	add	$s2, $v0, $zero #check opcode
	add	$s3, $v1, $zero #count matching voi khuon dang toan hang
	li	$v0, 4
	la	$a0, msg2
	syscall
	li	$v0, 4
	la	$a0, tmp
	syscall
	bne	$s2, $zero, validOpcode # neu opcode hop le -> valid
invalidOpcode: #opcode ko hop le
	li	$v0, 4
	la	$a0, msg22
	syscall
	j	exit
validOpcode:	
	li	$v0, 4
	la	$a0, msg21
	syscall
	#-------lay khuon dang tuong ung voi opcode
	la	$a0, operand
	add	$a1, $s3, $zero #truyen vao count
	jal	getOperand #tra ve tmp2 - khuon dang
	
	li	$v0, 4
	la	$a0, tmp2
	syscall
	
	la	$s4, tmp2	#khuon dang
	add	$s5, $zero, $zero #toan hang 1 2 3  - dem
	add	$t9, $zero, 48 #0
	addi	$t8, $zero, 49 #1
	addi	$t7, $zero, 50 #2
	addi	$t6, $zero, 51 #3
	addi	$t5, $zero, 52 #4
Cmp: # kiem tra dang cua tung toan hang và check
	slti	$t0, $s5, 3
	beq	$t0, $zero, end
	#-----------lay toan hang 1
	add	$a0, $s0, $zero
	add	$a1, $s1, $zero
	la	$a2, tmp
	jal	cutComponent
	add	$s1, $v0, $zero
	add	$s7, $v1, $zero #so ky tu co trong tmp
	#--so sanh toan hang 1
	add	$t0, $s5, $s4
	lb	$s6, 0($t0) #dang cua toan hang i
	beq	$s6, $t8, reg
	beq	$s6, $t7, number
	beq	$s6, $t6, label
	beq	$s6, $t5, offsetbase
	beq	$s6, $t9, null
reg:
	la	$a0, tmp
	add	$a1, $s7, $zero
	la	$a2, register
	#tra ve 0 -> error, 1 -> ok
	jal	compareOpcode
	j	checkValid
number:
	la	$a0, tmp
	add	$a1, $s7, $zero
	jal 	checkNumber
	j	checkValid
label:
	la	$a0, tmp
	add	$a1, $s7, $zero
	jal	checkLabel
	j	checkValid
offsetbase:
	la	$a0, tmp
	add	$a1, $s7, $zero
	jal	checkOffsetBase
	j 	checkValid
null:
	j	print	
checkValid:
	add	$s2, $v0, $zero
	li	$v0, 4
	la	$a0, msg3
	syscall
	li	$v0, 4
	la	$a0, tmp
	syscall
	beq	$s2, $zero, error
	j	ok
updateCheck:	#buoc lap
	addi	$s5, $s5, 1
	j	Cmp

error:
	li	$v0, 4
	la	$a0, msg22
	syscall
	j	exit
ok:
	li	$v0, 4
	la	$a0, msg21
	syscall
	j	updateCheck
end:
	add	$a0, $s0, $zero
	add	$a1, $s1, $zero
	jal	cutComponent
	add	$s1, $v0, $zero #i hien tai
	add	$s7, $v1, $zero #so ky tu co trong tmp
print:	
	li	$v0, 4
	la	$a0, msg4
	syscall
	bne	$s7, $zero, error
	li	$v0, 4
	la	$a0, msg21
	syscall
exit:
	repaetMain:
		li	$v0, 4
		la	$a0, msg5
		syscall
		li	$v0, 8
		la	$a0, input
		li	$a1, 100
		syscall
		checkRepeat:
			addi	$t2, $zero, 48
			addi	$t3, $zero, 49
			add	$t0, $a0, $zero #ki tu dau tien
			lb	$t0, 0($t0)
			beq	$t0, $t2, out# =0
			beq	$t0, $t3, main
			j	repaetMain 
	out:
		li $v0, 10 #exit
		syscall
#--------------------------------------------------------	
# tach toan hang,, opcode tu chuoi dau vao
# a0 address input, a1 i-> dem tmp. a2 address tmp
# v0 i = i+ strlen(tmp), v1 strlen(tmp)
#--------------------------------------------------------
cutComponent:
	addi	$sp, $sp, -20
	sw	$ra, 16($sp)
	sw	$s0, 12($sp) # space
	sw	$s2, 8($sp)	#j
	sw	$s3, 4($sp) #input[i]
	sw	$s4, 0($sp) #dau phay = 44
	
	addi	$s0, $zero, 32 #space
	addi	$t2, $zero, 10 #\n
	addi	$s4, $zero, 44 #dau phay = 44
	addi	$t3, $zero, 9 #\t
checkSpace: #bo qua , \t space
	add	$t0, $a0, $a1 #dia chi input[i]
	lb	$s3, 0($t0) #input[i]
	beq	$s3, $s0 cutSpace #
	beq	$s3, $t3 cutSpace
	beq	$s3, $s4 cutSpace #
	j	cut
cutSpace:
	addi	$a1, $a1, 1
	j	checkSpace
cut:
	add	$s2, $zero, $zero #j = 0
loopCut:
	beq	$s3, $s0 endCut
	beq	$s3, $s4, endCut 
	beq	$s3, $zero, endCut
	beq	$s3, $t2, endCut
	beq	$s3, $t3 endCut
	add	$t0, $a2, $s2 #dia chi tmp[j]
	sb	$s3, 0($t0) #luu tmp[j]
	addi	$a1, $a1, 1
	add	$t0, $a0, $a1 #dia chi input[i]
	lb	$s3, 0($t0) #input[i]
	
	addi	$s2, $s2, 1
	j	loopCut
endCut:
	add	$t0, $a2, $s2 #dia chi tmp[j]
	sb	$zero, 0($t0) #luu tmp[j] = '\0'
	add	$v0, $a1, $zero
	add	$v1, $s2, $zero
	lw	$ra, 16($sp)
	lw	$s0, 12($sp)
	lw	$s2, 8($sp)
	lw	$s3, 4($sp)
	lw	$s4, 0($sp)
	addi	$sp, $sp, 20
	jr	$ra
	
#--------------------------------------------------------
# so sanh toan hang, opcode voi toan hang, opcode chuan
# a0 address tmp, a1 strlen(tmp), a2 adress cua chuoi opcode, register chu?n
# v0 0|1, v1 count vi tri cua opcode
#--------------------------------------------------------
compareOpcode:
	addi	$sp, $sp, -24
	sw	$ra, 20($sp)
	sw	$s1, 16($sp) #i -> opcode
	sw	$s2, 12($sp) #j -> tmp
	sw	$s3, 8($sp) #tmp[j]
	sw	$s4, 4($sp)	#luu opcode[i]
	sw	$s5, 0($sp) # - 45
	
	beq	$a1, $zero, endCmp

	add	$s1, $zero, $zero
	add	$s2, $zero, $zero
	addi	$s5, $zero, 45
	addi	$v0, $zero, 1
	addi	$v1, $zero, 1
loopCmp:
	add	$t0, $a2, $s1 #dia chi opcode[i]
	lb	$s4, 0($t0) #luu opcode[i]
	beq	$s4, $s5, checkCmp
	beq	$s4, $zero, endCmp
	add	$t0, $a0, $s2 #dia chi tmp[j]
	lb	$s3, 0($t0) #luu tmp[j]
	bne	$s3, $s4, falseCmp
	
	addi	$s1, $s1, 1
	addi	$s2, $s2, 1
	j	loopCmp
checkCmp:
	bne	$a1, $s2, falseCmp
trueCmp:
	addi	$v0, $zero, 1
	j	endF

falseCmp:
	addi	$v0, $zero, 0
	addi	$s2, $zero, 0
	loopXspace:
		beq	$s4, $s5, Xspace
		addi	$s1, $s1, 1
		add	$t0, $a2, $s1 #dia chi opcode[i]
		lb	$s4, 0($t0) #luu opcode[i]
		j	loopXspace
		Xspace:
			add	$v1, $v1, 1
			addi	$s1, $s1, 1
			j	loopCmp
endCmp:
	addi	$v0, $zero, 0
endF:	
	addi	$v1, $v1, -1
	lw	$ra, 20($sp)
	lw	$s1, 16($sp)
	lw	$s2, 12($sp)
	lw	$s3, 8($sp) 
	lw	$s4, 4($sp)	
	lw	$s5, 0($sp)
	addi	$sp, $sp, 24
	jr	$ra
#--------------------------------------------------------
# lay khuon dang toan hang ung voi opcode
# a0 address chuoi operand - vi tri tuong ung voi opcode, a1 count
# tra ve chuoi opcode tuong ung õ tmp2 =
#--------------------------------------------------------
getOperand: 
	addi	$sp, $sp, -20
	sw	$s0, 16($sp) #i
	sw	$s1, 12($sp) #op[i]
	sw	$s2, 8($sp) # 45
	sw	$s3, 4($sp) # address tmp2
	sw	$s4, 0($sp)	# j

	addi	$t0, $zero, 4 #moi khuon dang chiem 4 byte
	mul	$s0, $a1, $t0 # i hien tai
	addi	$s2, $zero, 45 # -
	la	$s3, tmp2 
	add	$s4, $zero, $zero #j
loopGet:	
	add	$t0, $a0, $s0 #dia chi op
	lb	$s1, 0($t0)
	beq	$s1, $s2, endGet #gap - -> out
	add	$t0, $s3, $s4 #dia chi tmp[i]
	sb	$s1, 0($t0)
	
	addi	$s0, $s0, 1
	addi	$s4, $s4, 1
	j	loopGet
endGet:
	add	$t0, $s3, $s4 #dia chi tmp[i]
	sb	$zero, 0($t0)
	lw	$s0, 16($sp) #i
	lw	$s1, 12($sp) #op[i]
	lw	$s2, 8($sp) #
	lw	$s3, 4($sp) #
	lw	$s4, 0($sp)	#
	addi	$sp, $sp, 20
	jr $ra
#--------------------------------------------------------
# kiem tra chuoi tmp co la so hay ko -> 0 -> sai, 1-> dung
# a0 address tmp, a1 strlen(tmp)
# v0 0|1
#--------------------------------------------------------
checkNumber:
	add	$sp, $sp, -24
	sw	$ra, 20($sp)
	sw	$s4, 16($sp) #+
	sw	$s3, 12($sp) #-
	sw	$s0, 8($sp)
	sw	$s1, 4($sp)
	sw	$s2, 0($sp) #1
	add	$v0, $zero, 0
	add	$s0, $zero, $zero #dem i
	
	beq	$a1, $zero, endCheckN
checkFirstN:
	addi 	$s3, $zero, 45 # -
	addi	$s4, $zero, 43 # +
	addi	$s2, $zero, 1
	add	$t0, $a0, $s0 #toanhang[i]
	lb	$s1, 0($t0)
	#check - +  -> 123
checkMinus: 
	bne	$s1, $s3, checkPlus
	beq	$a1, $s2, endCheckN
	j	update
checkPlus:
	bne	$s1, $s4, _123
	beq	$a1, $s2, endCheckN
	j	update
#lb	$t2, 0($s1)
	
checkI:
	slt	$t0, $s0, $a1
	beq	$t0, $zero, trueN
	add	$t0, $a0, $s0 #toanhang[i]
	lb	$s1, 0($t0)
_123: #48 -> 57
	slti	$t0, $s1, 48
	bne	$t0, $zero, endCheckN
	slti	$t0, $s1, 58
	beq	$t0, $zero, endCheckN
update:
	addi	$s0, $s0, 1
	j	checkI
trueN:
	addi	$v0, $v0, 1
endCheckN:
	lw	$ra, 20($sp)
	lw	$s4, 16($sp) #+
	lw	$s3, 12($sp) #-
	lw	$s0, 8($sp)
	lw	$s1, 4($sp)
	lw	$s2, 0($sp)
	add	$sp, $sp, 24
	jr	$ra
#--------------------------------------------------------
# kiem tra chuoi tmp co la Label hay ko, ki tu dau tien: _ | A -> _ | A | 1 
# a0 -> address tmp, a1 strlen(tmp)
# v0 0|1 
#--------------------------------------------------------
checkLabel:
	add	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	add	$v0, $zero, 0
	add	$s0, $zero, $zero #dem i
	
	beq	$a1, $zero, endCheckL

checkFirstChar:
	add	$t0, $a0, $s0 #toanhang[i]
	lb	$s1, 0($t0)
	j	ABC	

checkIL:
	slt	$t0, $s0, $a1
	beq	$t0, $zero, trueL
	add	$t0, $a0, $s0 #toanhang[i]
	lb	$s1, 0($t0)
_123L: #48 -> 57
	slti	$t0, $s1, 48
	bne	$t0, $zero, endCheckL
	slti	$t0, $s1, 58
	beq	$t0, $zero, ABC
	addi	$s0, $s0, 1
	j	checkIL
ABC: #65 -> 90
	slti	$t0, $s1, 65
	bne	$t0, $zero, endCheckL
	slti	$t0, $s1, 91
	beq	$t0, $zero, _
	addi	$s0, $s0, 1
	j	checkIL
_:
	add	$t0, $zero, 95
	bne	$s1, $t0, abc
	addi	$s0, $s0, 1
	j	checkIL
abc: #97  -> 122
	slti	$t0, $s1, 97
	bne	$t0, $zero, endCheckL
	slti	$t0, $s1, 123
	beq	$t0, $zero, endCheckL
	addi	$s0, $s0, 1
	j	checkIL
trueL:
	addi	$v0, $v0, 1
endCheckL:
	sw	$ra, 8($sp)
	lw	$s1, 4($sp)
	lw	$s0, 0($sp)
	add	$sp, $sp, 12
	jr	$ra
#--------------------------------------------------------
# kiem tra chuoi tmp co dung cau truc offset(base) hay khong 
# a0 -> address tmp, a1 strlen(tmp)
# v0 0|1 
#--------------------------------------------------------
#a0, tmp a1 strlen
checkOffsetBase: 
#0($s1) -> 0_$s1_	
	add	$sp, $sp, -28
	sw	$ra, 24($sp)
	sw	$s5, 20($sp) #so ki cut dk
	sw	$s4, 16($sp) # )
	sw	$s3, 12($sp) # (
	sw	$s2, 8($sp) #check
	sw	$s1, 4($sp)# tmp[i]
	sw	$s0, 0($sp) # dem i
checkO:
	slti	$t0, $a1, 5 #it nhat 5 kis tu, vd: 0($s1)
	bne	$t0, $zero, falseCheck
	addi	$s3, $zero, 40
	addi	$s4, $zero, 41
	add	$s0, $zero, $zero #i
	add	$s2, $zero, $zero #check
	addi	$t2, $zero, 1
loopCheck:
	add	$t0, $a0, $s0 #dia chi tmp[i]
	lb	$s1, 0($t0)
	beq	$s1, $zero, endLoopO
	beq	$s1, $s3, open_
	beq	$s1, $s4, close_
	j	updateO
open_:
	bne	$s2, $zero, falseCheck
	addi	$s2, $s2, 1
	addi	$t1, $zero, 32
	sb	$t1, 0($t0)
	j	updateO
close_:
	bne	$s2, $t2, falseCheck
	addi	$s2, $s2, 1
	sb	$zero, 0($t0)
	
	addi	$s0, $s0, 1
	bne	$s0, $a1, falseCheck
	
updateO:
	addi	$s0, $s0, 1
	j	loopCheck
endLoopO:
	addi	$t2, $t2, 1 # =2
	bne	$s2, $t2, falseCheck
#----
trueCheck:
	add	$s0, $zero, $zero #i
	#cut
	sw	$a0, -8($sp)
	sw	$a1, -4($sp)
	
	la	$a0, tmp
	add	$a1, $s0, $zero
	la	$a2, tmp3
	jal	cutComponent
	add	$s0, $v0, $zero
	add	$s5, $v1, $zero #so ky tu co trong cutword
	
	lw	$a0, -8($sp)
	lw	$a1, -4($sp)
	#check number
	sw	$a0, -8($sp)
	sw	$a1, -4($sp)
	la	$a0, tmp3
	add	$a1, $s5, $zero
	jal 	checkNumber
	add	$s2, $v0, $zero
	lw	$a0, -8($sp)
	lw	$a1, -4($sp)
	beq	$s2, $zero, falseCheck
	#cut
	sw	$a0, -8($sp)
	sw	$a1, -4($sp)
	
	la	$a0, tmp
	add	$a1, $s0, $zero
	la	$a2, tmp3
	jal	cutComponent
	add	$s0, $v0, $zero
	add	$s5, $v1, $zero #so ky tu co trong cutword
	
	lw	$a0, -8($sp)
	lw	$a1, -4($sp)
	#checkReg
	sw	$a0, -8($sp)
	sw	$a1, -4($sp)
	sw	$a2, -16($sp)
	la	$a0, tmp3
	add	$a1, $s5, $zero
	la	$a2, register
	#tra ve 0 -> error, 1 -> ok
	jal	compareOpcode
	add	$s2, $v0, $zero
	lw	$a0, -8($sp)
	lw	$a1, -4($sp)
	lw	$a2, -12($sp)
	beq	$s2, $zero, falseCheck
	#->ket luan
	addi	$v0, $zero, 1
	j	endO
falseCheck:
	add	$v0, $zero, $zero
	j	endO
endO:
	lw	$ra, 24($sp)
	lw	$s5, 20($sp) #so ki cut dk
	lw	$s4, 16($sp) 
	lw	$s3, 12($sp) 
	lw	$s2, 8($sp)
	lw	$s1, 4($sp)
	lw	$s0, 0($sp) 
	add	$sp, $sp, 28
	jr	$ra
