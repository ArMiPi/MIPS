#---------------------------------------------------------------------------------
# - Ler dois inteiros k e n
# - Apresentar o resultado de k^n
#---------------------------------------------------------------------------------
.data
    # Mensagens de entrada
    msg_entrada_k: .asciiz "Entre com o valor de k: "
    msg_entrada_n: .asciiz "Entre com o valor de n: "

    # Mensagem de saida
    msg_saida: .asciiz "k^n = "

.text
    main:
        # Leitura de k
        la $a0, msg_entrada_k
        li $v0, 4
        syscall
        li $v0, 5
        syscall

        move $s0, $v0

        # Leitura de n
        la $a0, msg_entrada_n
        li $v0, 4
        syscall
        li $v0, 5
        syscall

        move $a0, $s0
        move $a1, $v0

        # Calcular k^n
        jal pow

        move $s0, $v0

        la $a0, msg_saida
        li $v0, 4
        syscall
        move $a0, $s0
        li $v0, 1
        syscall

        # Encerrar programa
        li $v0, 10
        syscall

    ##################### FUNCAO #####################

    pow:
        #-------------------------------------------#
        # Calcula o valor de $a0^$a1                #
        #-------------------------------------------#
        # Variaveis:                                #
        #   $a0: base                               #
        #   $a1: expoente                           #
        #-------------------------------------------#
        # Retorno: Retorna em $v0 o valor calculado #
        #-------------------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -4
        sw $ra, 0($sp)

        bnez $a1, calc_pow
        li $v0, 1
        j return_pow

        calc_pow:
            addi $a1, $a1, -1
            jal pow

            mul $v0, $v0, $a0
        
        return_pow:
            # Restaurar pilha
            lw $ra, 0($sp)
            addi $sp, $sp, 4

            jr $ra
