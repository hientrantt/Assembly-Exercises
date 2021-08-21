.data
Message1: .asciiz "Nhap chuoi: "
Message2: .asciiz "Ket qua: "
string:  .space   200
key:	.space 200
keytmp:  .space 200
.text
main:
InputStr: #nhap xau tu ban phim syscall 54
	li	$v0, 54
	la	$a0, Message1
	la	$a1, string	#xau gan vao string
	la	$a2, 200 #length max 200
	syscall  
	
	la	$s0, string	#load address cua string - bien luu dau vao
	la	$s1, key #load address cua key - luu key co length max
	#truyen cac tham so vao ham
	add	$a0, $s0, $zero	#truyen $s0 - address cua xau vao
	add	$a1, $s1, $zero	#truyen $s1 - address cua key - ket qua
	jal 	FuntCut #ham tim tu co length max
	add	$s2, $v0, $zero #v0 -> do dai max
done:	
	li	$v0, 59	#in ra tu co so chu dai nhat
	la	$a0, Message2
	la	$a1, key
	syscall
	
	li	$v0, 10 #exit
	syscall    
#----------------------------------------------------------
FuntCut:
	addi	$sp, $sp, -20 #can dung 5 bien
	sw	$s0, 16($sp) #bien dem i
	sw	$s1, 12($sp) #bien dem j
	sw	$s2, 8($sp) #max tam thoi
	sw	$s3, 4($sp)	#gia tri cua str[i]
	sw	$s4, 0($sp) #luu dia chi bien tmp
	
	la	$s4, keytmp	#load address keytmp - luu key tam tho
	add	$s2, $zero, $zero #length max -> $s2
	add	$s0, $zero, $zero #bien dem i = 0, dem str
	addi	$s3, $zero, 1 #str[i] -> gan tam =1
cut:
	add	$s1, $zero, $zero #bien dem j - dem chu cua tu
loop:
	beq	$s3, $zero, endFunt
	
	add	$t1, $a0, $s0 #lay dia chi cua string[i]
	#2, 3, 5, 7 4byte -> abc 1byte
	lb	$s3, 0($t1) #gia tri str[i]

ABC:	#check chu hoa: x<a
	slti	$t0, $s3, 65
	bne	$t0, $zero, abc
	slti	$t0, $s3, 91 
	bne	$t0, $zero, count

abc:	#check chu thuong
	slti	$t0, $s3, 97
	bne	$t0, $zero, endCut
	slti	$t0, $s3, 123
	beq	$t0, $zero, endCut
	
count:
	add	$t2, $s4, $s1 # =lay dia chi cua keytmp[j]
	sb	$s3, 0($t2)
	addi 	$s1, $s1, 1 #tang j len 1
	
endLoop: 
	addi	$s0, $s0, 1 #cong i len 1
	j	loop
endCut: #abc go
	addi	$s0, $s0, 1	#tang bien dem i len 1
	slt	$t0, $s2, $s1	#so sanh
	beq	$t0, $zero, cut
	add	$s2, $s1, $zero	#gan lai max
	#gan tu dai nhat vao key
addkey:
	add	$t0, $zero, $zero #bien i tam thoi
loopAdd:
	beq	$t0, $s2, endAdd #i tam thoi < max
#abc go -> goc -> abc
	add	$t1, $s4, $t0 #lay dia chi cua bien tmp
	lb	$s3, 0($t1) #tmp[i]
	
	add	$t2, $a1, $t0 #lay dia chi cua key
	sb	$s3, 0($t2)	#luu tmp[i] vao key
	
	addi	$t0, $t0, 1 #tang dem len 1
	j	loopAdd
endAdd:
	j	cut
	
endFunt:	
	add	$v0, $s2, $zero #luu gia tri max length vao v0
	lw	$s4, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra