mfc0 $fp,$13
ori $fp,$fp,0x0400
mtc0 $fp,$13
lw $fp,0x7f04($zero)
sw $fp,0x7f08($zero)
andi $fp,$zero,0xfbff
mtc0 $fp,$13
ori $fp,$zero,0x9
sw $fp,0x7f00($zero)
ori $fp,$zero,0xfc03
mtc0 $fp,$12
eret
