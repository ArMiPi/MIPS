#---------------------------------------------------------------------------------
# - Realizar a leitura de 3 numeros inteiros (n, a e b)
# - Escrever em ordem crescente, os n primeiros inteiros positivos que sao
#   multiplos de a ou b ou ambos
# - Ex: n = 6; a = 2; b = 3; -> 2, 3, 4, 6, 8, 9
#---------------------------------------------------------------------------------
.data
    # Mensagens de entrada
    msg_entrada_n: .asciiz "Entre com um inteiro n: "
    msg_entrada_a: .asciiz "Entre com um inteiro a: "
    msg_entrada_b: .asciiz "Entre com um inteiro b: "

    # Mensagem de saida
    msg_saida: .asciiz "Os n primeiros multiplos de a ou b ou ambos e': \n"

    # Outras strings
    espaco: .asciiz " "

.text
    main:
        # Leitura de n
        la $a0, msg_entrada_n
        li $v0, 4
        syscall
        li $v0, 5
        syscall

        move $s0, $v0   # $s0 = n

        # Leitura de a
        la $a0, msg_entrada_a
        li $v0, 4
        syscall
        li $v0, 5
        syscall

        move $s1, $v0   # $s1 = a

        # Leitura de b
        la $a0, msg_entrada_b
        li $v0, 4
        syscall
        li $v0, 5
        syscall

        move $s2, $v0   # $s2 = b

        # Apresentar resultado
        la $a0, msg_saida
        li $v0, 4
        syscall

        move $a0, $s0
        move $a1, $s1
        move $a2, $s2
        jal multiplos

        # Encerrar programa
        li $v0, 10
        syscall

    ##################### FUNCOES #####################

    multiplos:
        #-----------------------------------------------------------#
        # Imprime em ordem crescentes os $a0 primeiros multiplos de #
        # $a1 ou $a2 ou ambos                                       #
        #-----------------------------------------------------------#
        # Variaveis:                                                #
        #   $a0: quantidade de multiplos                            #
        #   $a1: inteiro 1                                          #
        #   $a2: inteiro 2                                          #
        #-----------------------------------------------------------#
        # Retorno: Sem retorno                                      #
        #-----------------------------------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -20
        sw $t0, 0($sp)
        sw $t1, 4($sp)
        sw $t2, 8($sp)
        sw $t3, 12($sp)
        sw $t4, 16($sp)

        # Atribuicao de valores
        move $t0, $a0
        addi $t0, $t0, -2
        li $t1, 2
        li $t2, 2

        # Printar $a1 e $a2
        blt $a2, $a1, print_reverso
        move $a0, $a1
        li $v0, 1
        syscall
        la $a0, espaco
        li $v0, 4
        syscall
        move $a0, $a2
        li $v0, 1
        syscall
        la $a0, espaco
        li $v0, 4
        syscall
        j for_multiplos

        print_reverso:
            move $a0, $a2
            li $v0, 1
            syscall
            la $a0, espaco
            li $v0, 4
            syscall
            move $a0, $a1
            li $v0, 1
            syscall
            la $a0, espaco
            li $v0, 4
            syscall

        for_multiplos:
            beqz $t0, return_multiplos

            mul $t3, $a1, $t1
            mul $t4, $a2, $t2

            beq $t3, $t4, equal
            blt $t3, $t4, mul_a1

            move $a0, $t4
            li $v0, 1
            syscall
            la $a0, espaco
            li $v0, 4
            syscall

            addi $t2, $t2, 1
            j next_for_multiplos

            equal:
                mul $a0, $t1, $a1
                li $v0, 1
                syscall
                la $a0, espaco
                li $v0, 4
                syscall

                addi $t1, $t1, 1
                addi $t2, $t2, 1
                j next_for_multiplos

            mul_a1:
                move $a0, $t3
                li $v0, 1
                syscall
                la $a0, espaco
                li $v0, 4
                syscall

                addi $t1, $t1, 1
            
            next_for_multiplos:
                addi $t0, $t0, -1
                j for_multiplos
        
        return_multiplos:
            # Restaurar pilha
            lw $t0, 0($sp)
            lw $t1, 4($sp)
            lw $t2, 8($sp)
            lw $t3, 12($sp)
            lw $t4, 16($sp)
            addi $sp, $sp, 20

            jr $ra
