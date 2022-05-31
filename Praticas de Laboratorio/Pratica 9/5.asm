#---------------------------------------------------------------------------------
# - Realizar a leitura de um natural n
# - Calcular o hiperfatorial de n
#---------------------------------------------------------------------------------
.data
    # Mensagem de entrada
    msg_entrada_n: .asciiz "Entre com um natural n: "

    # Mensagem de saida
    msg_saida: .asciiz "O hiperfatorial de n e': "

.text
    main:
        # Leitura de n
        la $a0, msg_entrada_n
        li $v0, 4
        syscall
        li $v0, 5
        syscall

        # Calcular hiperfatorial de n
        move $a0, $v0
        jal hiperfatorial

        # Apresentar resultado
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

    ######################################################################################################

    hiperfatorial:
        #-------------------------------------------#
        # Calcula o valor do hiperfatoria de $a0    #
        #-------------------------------------------#
        # Variavel:                                 #
        #   $a0: natural                            #
        #-------------------------------------------#
        # Retorno: Retorna em $v0 o valor calculado #
        #-------------------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -8
        sw $t0, 0($sp)
        sw $ra, 4($sp)

        bnez $a0, calc_hiperfatorial
        li $v0, 1
        j return_hiperfatorial

        calc_hiperfatorial:
            move $a1, $a0
            jal pow
            move $t0, $v0

            addi $a0, $a0, -1
            jal hiperfatorial

            mul $v0, $v0, $t0

        return_hiperfatorial:
            # Restaurar pilha
            lw $t0, 0($sp)
            lw $ra, 4($sp)
            addi $sp, $sp, 8

            jr $ra
