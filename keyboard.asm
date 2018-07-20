init:
lui $10, 0x1001
ori $10, $10, 0x30
lui $11, 0x1001


addi $22, $22, 0   # b = 0
addi $23, $23, 0
addi $24, $24, 0

query:
lw $21, 0($10)     #  while( cin >> a )
sw $22, 0($11)     #  cout << b

beq $21, $0, query # if ( a == 0) continue 
beq $21, $24,query
addi $24, $21, 0

or $21, $21, $22   
sllv $22, $21, $23   # b = (a << v)
addi $23, $23, 8  # v += 8
j query 