#----------------------------------------------------------------------------------------
# - Realizar a leitura de um x real e um n natural
# - Calcular uma aproximacao de cos(x) utilizando os n primeiros termos da serie:
#   cos(x) = 1 - (x^2 / 2!) + (x^4 / 4!) - (x^6 / 6!) + ... + (-1)^n (x^2n / (2n)!
#----------------------------------------------------------------------------------------
.data
    # Mensagens de entrada
    msg_entrada_x: .asciiz "Entre com um valor real x: "
    msg_entrada_n: .asciiz "Entre com um valor natural n: "

    # Mensagem saida
    msg_saida_inicio: .asciiz "cos("
    msg_saida_final: .asciiz ") = "

    # Mensagem de erro
    msg_erro_n: .asciiz "\nERRO: n deve ser um numero natural.\n\n"

    # Outras strings
    espaco: .asciiz " "

.text
    main:
        # Realizar leitura de x
        la $a0, msg_entrada_x
        li $v0, 4
        syscall
        li $v0, 6
        syscall

        mov.s $f1, $f0  # $f1 = x

        # Realizar a leitura de n
        ler_n:
            la $a0, msg_entrada_n
            li $v0, 4
            syscall
            li $v0, 5
            syscall

            bltz $v0, erro_n

        move $s0, $v0   # $s0 = n

        # Realizar o calculo aproximado de cosseno
        move $a0, $s0
        jal cos_approx

        la $a0, msg_saida_inicio
        li $v0, 4
        syscall
        mov.s $f12, $f1
        li $v0, 2
        syscall
        la $a0, msg_saida_final
        li $v0, 4
        syscall
        mov.s $f12, $f10
        li $v0, 2
        syscall

        # Encerrar programa
        li $v0, 10
        syscall


        # Erro com a entrada n
        erro_n:
            la $a0, msg_erro_n
            li $v0, 4
            syscall

            j ler_n

    ##################### FUNCOES #####################

    int_to_float:
        #---------------------------------------------#
        # Converte um inteior em um float             #
        #---------------------------------------------#
        # Variaveis:                                  #
        #   $a0: inteiro                              #
        #---------------------------------------------#
        # Retorno: Retorna em $f30 o valor convertido #
        #---------------------------------------------#

        mtc1 $a0, $f30
        cvt.s.w $f30, $f30
        jr $ra


    ######################################################################################################

    cos_approx:
        #---------------------------------------------------------------------------------#
        # Calcula o valor aproximado do cos de $f1 atraves da serie:                      #
        # cos(x) = 1 - (x^2 / 2!) + (x^4 / 4!) - (x^6 / 6!) + ... + (-1)^n (x^2n / (2n)!) #
        #---------------------------------------------------------------------------------#
        # Variaveis:                                                                      #
        #   $a0: n                                                                        #
        #   $f1: x                                                                        #
        #---------------------------------------------------------------------------------#
        # Retorno: Retorna em $f10 o valor calculado                                      #
        #---------------------------------------------------------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -12
        sw $t0, 0($sp)
        sw $t1, 4($sp)
        sw $ra, 8($sp)

        # Atribuicao de valores
        move $t0, $a0   # $t0 = n

        li $a0, 1
        jal int_to_float
        mov.s $f2, $f30 # $f2 = 1 = cos

        li $a0, -1
        jal int_to_float
        mov.s $f3, $f30 # $f3 = -1

        li $t1, 1   # i = 1
        for_cos_approx:
            bgt $t1, $t0, return_cos_approx

            # Calcular (-1)^i
            mov.s $f11, $f3
            move $a0, $t1
            jal pow

            mov.s $f4, $f30     # $f4 = (-1)^i

            # Calcular x^(2i)
            mov.s $f11, $f1
            add $a0, $t1, $t1
            jal pow

            mov.s $f5, $f30     # $f5 = x^(2i)

            # Calcular (2i)!
            add $a0, $t1, $t1
            jal fat

            move $a0, $v0
            jal int_to_float

            mov.s $f6, $f30     # $f6 = float(2i!)

            # Calcular valor de cos
            mul.s $f4, $f4, $f5     # $f4 = (-1)^i * x^(2i)
            div.s $f4, $f4, $f6     # $f4 = $f4 / (2i)!

            add.s $f2, $f2, $f4

            # Proxima iteracao
            addi $t1, $t1, 1
            j for_cos_approx
        
        return_cos_approx:
            mov.s $f10, $f2
            # Restaurar pilha
            lw $t0, 0($sp)
            lw $t1, 4($sp)
            lw $ra, 8($sp)
            addi $sp, $sp, 12

            jr $ra

    ######################################################################################################

    pow:
        #-----------------------------------------------#
        # Calcula a potencia $f11^$a0                   #
        #-----------------------------------------------#
        # Variaveis:                                    #
        #   $f11: base                                  #
        #   $a0: expoente                               #
        #-----------------------------------------------#
        # Retorno: Retorna em $f30 o valor de $f11^$a0  #
        #-----------------------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -12
        sw $t0, 0($sp)
        sw $t1, 4($sp)
        sw $ra, 8($sp)

        # Atribuicao de valores
        move $t0, $a0   # $t0 = expoente

        li $a0, 0
        jal int_to_float
        mov.s $f20, $f30    # $f20 = 0.0

        li $a0, 1
        jal int_to_float
        mov.s $f21, $f30    # $f21 = 1.0

        # Caso o expoente seja 0
        beqz $a0, return_pow_one

        mov.s $f30, $f11    # $f30 = base
        li $t1, 1
        for_pow:
            beq $t1, $t0, return_pow
            mul.s $f30, $f30, $f30

            addi $t1, $t1, 1
            j for_pow

        return_pow_one:
            mov.s $f30, $f14
        
        return_pow:
            # Restaurar pilha
            lw $t0, 0($sp)
            lw $t1, 4($sp)
            lw $ra, 8($sp)
            addi $sp, $sp, 12
            
            jr $ra
    
    ######################################################################################################

    fat:
        #-------------------------------------------#
        # Calcula o fatorial de $a0                 #
        #-------------------------------------------#
        # Variaveis:                                #
        #   $a0: inteiro                            #
        #-------------------------------------------#
        # Retorno: Retorna em $v0 o fatorial de $a0 #
        #-------------------------------------------#

        li $v0, 1

        for_fat:
            beqz $a0, return_fat
            mul $v0, $v0, $a0

            addi $a0, $a0, -1
            j for_fat
        
        return_fat:
            jr $ra
