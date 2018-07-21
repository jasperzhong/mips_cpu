init:
    lui $10, 0x1001
    ori $10, $10, 0x30
    lui $11, 0x1001


    addi $22, $22, 0   # b = 0
    addi $23, $23, 0


query:
    lw $21, 0($10)     #  while( cin >> a )
    beq $21, $0, query
    beq $21, $23,query  
    addi $23, $21, 0

    addi $24, $0, 0x45
    beq $21, $24, num_0

    addi $24, $0, 0x16
    beq $21, $24, num_1

    addi $24, $0, 0x1e
    beq $21, $24, num_2

    addi $24, $0, 0x26
    beq $21, $24, num_3

    addi $24, $0, 0x25
    beq $21, $24, num_4

    addi $24, $0, 0x2e
    beq $21, $24, num_5

    addi $24, $0, 0x36
    beq $21, $24, num_6

    addi $24, $0, 0x3d
    beq $21, $24, num_7

    addi $24, $0, 0x3e
    beq $21, $24, num_8

    addi $24, $0, 0x46
    beq $21, $24, num_9

    addi $24, $0, 0x5a
    beq $21, $24, enter

    j query   #unknow input

num_0:
    addi $21, $0, 0
    j num_end
num_1:
    addi $21, $0, 1
    j num_end
num_2:
    addi $21, $0, 2
    j num_end
num_3:
    addi $21, $0, 3
    j num_end
num_4:
    addi $21, $0, 4
    j num_end
num_5:
    addi $21, $0, 5
    j num_end
num_6:
    addi $21, $0, 6
    j num_end
num_7:
    addi $21, $0, 7
    j num_end
num_8:
    addi $21, $0, 8
    j num_end
num_9:
    addi $21, $0, 9
    j num_end
enter:
    j input_over


num_end:
    sll $22, $22, 4
    or $22, $22, $21
    sw $22, 0($11)     #  cout << a
    j query 


input_over:
    addi $21, $0, 1
    addi $20, $0, 0
    addi $25, $0, 10
loop1:
    beq $22, $0, is_prime
    andi $23, $22, 0xf   # the last 
    srl $22, $22, 4
    mul $23, $23, $21 
    add $20, $20, $23
    mul $21, $21, $25
    j loop1

is_prime:
    sw $20, 0($11)  # show x
    addi $21, $0, 2  # i = 2
loop2:
    slt $23, $21, $20 # if(i < x)
    beq $23, $0, true
    div $20, $21
    mfhi $23   # r
    addi $21, $21, 1   # i++
    bne $23, $0, loop2  # if(r == 0) break else continue

    addi $22, $0, 0xf
    j end
    
true:
    addi $22, $0, 1
    
end:
    sw $22, 0($11)
    
