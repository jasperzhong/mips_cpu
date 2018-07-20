init:
lui $10, 0x1001
ori $10, $10, 0x30
lui $11, 0x1001


addi $22, $22, 0   # b = 0
query:
lb $21, 0($10)     #  while( cin >> a )
beq $21, $22, query # if (a == b) continue 

sw $21, 0($11)     # cout << a
sll $21, $21, 4    # a = (a << 4)
add $22, $21, $0   # b = a
j query 