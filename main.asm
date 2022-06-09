beq $zero,$zero,START

FUNC0: addi $a0,$a0,0x8000
       addu $at,$at,$a0
       addiu $v0,$v0,-0x0100
       lui $v1,0x8000
       lui $a0,0x00ab
       and $a1,$at,$v0
       andi $a1,$a1,0x0f0f
       or $a2,$at,$v0
       ori $a2,$a2,0x3f4f
       xor $a3,$at,$v0
       xori $a3,$a3,0x1055
       nor $t0,$a2,$a3
       subu $t0,$v1,$a0
       sub $t0,$t0,$at
       slt $v1,$v1,$a0
       sltu $a0,$v1,$a0
       slti $v1,$at,0x7fff
       sltiu $a0,$at,0x7b00
       jr $s4
       
FUNC1: sw $at,0x00a0($zero)
       sw $v0,0x00b0($zero)
       lw $v1,0x00a0($zero)
       lh $a0,0x00b2($zero)
       lhu $a1,0x00b2($zero)
       lb $a2,0x00b3($zero)
       lbu $a3,0x00b3($zero)
       sb $v0,0x00a0($zero)
       sh $v0,0x00b0($zero)
       lw $a1,0x00a0($zero)
       lw $a2,0x00b0($zero)
       jr $ra
       
FUNC2: sll $at,$at,0x2
       srl $at,$at,0x1
       sra $v0,$v0,0x1
       lui $v1,0x0
       addi $v1,$v1,0x2
       sllv $at,$at,$v1
       srlv $at,$at,$v1
       srav $at,$at,$v1
       srav $v0,$v0,$v1
       jr $s5
      
FUNC3: mult $at,$v0
       mfhi $t0
       mflo $t1
       multu $at,$v0
       mfhi $t0
       mflo $t1
       div $a1,$v0
       mfhi $t0
       mflo $t1
       divu $a1,$v0
       mfhi $t0
       mflo $t1
       mthi $at
       mtlo $v0
       jr $ra
       
START: ori $s0,$s0,0x3004
       ori $s1,$s1,0x3088
       
       ori $s2,$zero,0x2
LOOP0: jalr $s4,$s0
       addi $s2,$s2,-0x1
       bne $s2,$zero,LOOP0
       
       ori $s2,$zero,0x3
LOOP1: jal FUNC1
       addi $s2,$s2,-0x1
       bgtz $s2,LOOP1
       
       ori $s2,$zero,0x2
LOOP2: jalr $s5,$s1
       addi $s2,$s2,-0x1
       bgez $s2,LOOP2
       
       ori $s3,$zero,-0x3
LOOP3: jal FUNC3
       addi $s3,$s3,0x1
       bltz $s3,LOOP3
       
       ori $s3,$zero,-0x2
LOOP4: jalr $s4,$s0
       addi $s3,$s3,0x1
       blez $s3,LOOP4
       
       