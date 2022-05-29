#---------------------------------------------------------------------------------
# - Realizar a leitura de um CPF no formato XXXXXXXXX-XX
# - Verificar se e' um CPF valido
#---------------------------------------------------------------------------------
.data
    # Mensagem de entrada
    msg_entrada_cpf: .asciiz "Entre com um CPF no formato XXXXXXXXX-XX: "

    # Mensagem de saida
    msg_saida_valido: .asciiz "O CPF e' valido\n"
    msg_saida_invalido: .asciiz "O CPF nao e' valido\n"

    # Mensagem erro
    msg_erro_cpf: .asciiz "\nERRO: Formato de CPF invalido\n\n"

    # String CPF
    cpf: .space 15

.text
    main:
        # Leitura do CPF
        la $a0, msg_entrada_cpf
        la $a1, cpf
        jal ler_string

        # Verificar formato da entrada
        la $a0, cpf
        jal verifica_entrada

        beqz $v0, erro_formato_invalido

        # Validar cpf
        la $a0, cpf
        jal valida_cpf

        beqz $v0, nao_valido
        la $a0, msg_saida_valido
        li $v0, 4
        syscall

        j encerrar

        nao_valido:
            la $a0, msg_saida_invalido
            li $v0, 4
            syscall

        # Encerrar programa
        encerrar:
            li $v0, 10
            syscall

        erro_formato_invalido:
            la $a0, msg_erro_cpf
            li $v0, 4
            syscall
            j main

    ##################### FUNCOES #####################

    ler_string:
        #---------------------------------------------------------------------------#
        # Realiza a leitura de uma string e substitui \n do final da leitura por \0 #
        #---------------------------------------------------------------------------#
        # Variaveis:                                                                #
        #   $a0: Mensagem para ler a string                                         #
        #   $a1: Endereco para a string a ser lida                                  #
        #   $t0: auxiliar                                                           #
        #---------------------------------------------------------------------------#
        # Retorno: Retorna em $a1 a string lida                                     #
        #---------------------------------------------------------------------------#
        
        # Ajustar pilha
        addi $sp, $sp, -8   # Ajusta a pilha para armazenar 2 itens
        sw $t0, 0($sp)      # Armazena o valor de $t0
        sw $ra, 4($sp)      # Armazena o valor de $ra

        li $v0, 4       # Codigo syscall para imprimir string
        syscall         # Imprime a string em $a0
        move $a0, $a1   # $a0 recebe o endereco da string a ser lida
        li $a1, 100     # Numero maximo de caracteres a serem lidos
        li $v0, 8       # Codigo syscall para leitura de string
        syscall         # Realiza a leitura de string

        jal strlen      # Executa strlen($a0)

        move $t0, $a0   # $t0 recebe endereco de string
        for_ultima_pos:
            ble $v0, 1, substituir  # Ir para substituir se $v0 <= 1
            addi $t0, $t0, 1        # Proxima posicao de string
            addi $v0, $v0, -1       # $v0--
            j for_ultima_pos        # Volta para for_ultima_pos

        substituir:
            sb $zero, ($t0)         # Substituir \n por \0

        # Restaurar pilha
        lw $t0, 0($sp)      # Restaura o valor de $t0
        lw $ra, 4($sp)      # Restaura o valor de $ra
        addi $sp, $sp, 8    # Ajusta a pilha para excluir 2 itens
        jr $ra              # Retorno

    ######################################################################################################

    strlen:
        #-------------------------------------------------#
        # Indica o tamanho de uma string                  #
        #-------------------------------------------------#
        # Variaveis:                                      #
        #   $a0: string                                   #
        #   $t0: size                                     #
        #   $t1: auxiliar                                 #
        #-------------------------------------------------#
        # Retorno: Retorna em $v0 o tamanho de uma string #
        #-------------------------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -12      # Ajusta a pilha para armazenar 3 itens
        sw $t0, 0($sp)          # Armazena o valor de $t0
        sw $t1, 4($sp)          # Armazena o valor de $t1
        sw $a0, 8($sp)          # Armazena o valor de $a0

        # Atribuicao de valores
        li $t0, 0               # size = 0
        
        loop_strlen:
            lb $t1, ($a0)               # $t1 = string[i]
            beqz $t1, return_strlen     # Ir para return_strlen se $t1 == 0
            addi $a0, $a0, 1            # Proxima posicao de string
            addi $t0, $t0, 1            # size++
            j loop_strlen               # Volta para loop_strlen
        
        return_strlen:
            move $v0, $t0               # $v0 = size
            # Restaurar pilha
            lw $t0, 0($sp)              # Restaura o valor de $t0
            lw $t1, 4($sp)              # Restaura o valor de $t1
            lw $a0, 8($sp)              # Restaura o valor de $a0
            addi $sp, $sp, 12           # Ajusta a pilha para excluir 3 itens
            jr $ra                      # Retorno

    ######################################################################################################

    verifica_entrada:
        #-------------------------------------------------------------#
        # Verifica se o cpf tem um formato valido                     #
        #-------------------------------------------------------------#
        # Variaveis:                                                  #
        #   $a0: string                                               #
        #-------------------------------------------------------------#
        # Retorno: Retorna em $v0 1 caso verdadeiro, 0 caso contrario #
        #-------------------------------------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -24
        sw $t0, 0($sp)
        sw $t1, 4($sp)
        sw $t2, 8($sp)
        sw $t4, 12($sp)
        sw $t5, 16($sp)
        sw $ra, 20($sp)

        # Verificar tamanho da entrada
        li $t0, 12
        jal strlen
        bne $v0, $t0, return_verifica_entrada_false

        # Verificar se possui - na posicao correta
        li $t0, 45  # ASCII code para "-"
        lb $t1, 9($a0)
        bne $t1, $t0, return_verifica_entrada_false

        # Verificar se a entrada possui apenas numeros e um -
        li $t1, 48  # ASCII code para "0"
        li $t2, 57  # ASCII code para "9"
        li $t3, 12  # Limite loop
        li $t4, 1   # Controlador para quantidade de -

        for_verifica_entrada:
            beqz $t3, return_verifica_entrada_true
            lb $t5, ($a0)
            beq $t5, $t0, count_separator
            blt $t5, $t1, return_verifica_entrada_false
            bgt $t5, $t2, return_verifica_entrada_false
            j next_for_verifica_entrada

            count_separator:
                addi $t4, $t4, -1
                bltz $t4, return_verifica_entrada_false
                j next_for_verifica_entrada
            
            next_for_verifica_entrada:
                addi $a0, $a0, 1
                addi $t3, $t3, -1
                j for_verifica_entrada

        j return_verifica_entrada_true
        
        return_verifica_entrada_false:
            li $v0, 0
            j return_verifica_entrada
        
        return_verifica_entrada_true:
            li $v0, 1

        return_verifica_entrada:
            # Restaurar pilha
            lw $t0, 0($sp)
            lw $t1, 4($sp)
            lw $t2, 8($sp)
            lw $t4, 12($sp)
            lw $t5, 16($sp)
            lw $ra, 20($sp)
            addi $sp, $sp, 24

            jr $ra

    ######################################################################################################

    valida_cpf:
        #-------------------------------------------------------------#
        # Verifica se o cpf e' valido                                 #
        #-------------------------------------------------------------#
        # Variaveis:                                                  #
        #   $a0: string                                               #
        #-------------------------------------------------------------#
        # Retorno: Retorna em $v0 1 caso verdadeiro, 0 caso contrario #
        #-------------------------------------------------------------#

        # Ajustar pilha


        # Atribuicao de valores
        move $t0, $a0

        # Verificar primeiro  digito verificador
        li $t1, 10
        li $t2, 1   # limite for
        li $t3, 0   # soma

        for_verifica_primeiro_digito:
            beq $t1, $t2, verifica_primeiro_digito
            lb $t4, ($t0)
            subi $t4, $t4, 48   # Converter o codigo ASCII lido para seu inteiro correspondente
            mul $t4, $t4, $t1
            add $t3, $t3, $t4

            subi $t1, $t1, 1
            addi $t0, $t0, 1
            j for_verifica_primeiro_digito
        
        verifica_primeiro_digito:
            # Obter o primeiro digito verificador esperado
            li $t0, 11
            div $t3, $t0
            mfhi $t3

            li $t1, 2
            blt $t3, $t1, primeiro_digito_zero
            subi $t3, $t3, 11
            mul $t3, $t3, -1
            j verifica_pd

            primeiro_digito_zero:
                li $t3, 0
            
            verifica_pd:
                # Armazenar o valor do primeiro digito verificador da entrada
                lb $t0, 10($a0)
                subi $t0, $t0, 48

                # Verificar se valores sao iguais
                bne $t3, $t0, return_valida_cpf_false

        # Verificar segundo digito verificador
        move $t0, $a0
        li $t1, 11
        li $t2, 1   # limite for
        li $t3, 0   # soma
        li $t5, 45  # Codigo ASCII para "-"

        for_verifica_segundo_digito:
            beq $t1, $t2, verifica_segundo_digito
            lb $t4, ($t0)
            beq $t4, $t5, ignore
            subi $t4, $t4, 48   # Converter o codigo ASCII lido para seu inteiro correspondente
            mul $t4, $t4, $t1
            add $t3, $t3, $t4

            subi $t1, $t1, 1
            addi $t0, $t0, 1
            j for_verifica_segundo_digito

            ignore:
                addi $t0, $t0, 1
                j for_verifica_segundo_digito
        
        verifica_segundo_digito:
            # Obter o segundo digito verificador esperado
            li $t0, 11
            div $t3, $t0
            mfhi $t3

            li $t1, 2
            blt $t3, $t1, segundo_digito_zero
            subi $t3, $t3, 11
            mul $t3, $t3, -1
            j verifica_sd

            segundo_digito_zero:
                li $t3, 0
            
            verifica_sd:
                # Armazenar o valor do segundo digito verificador da entrada
                lb $t0, 11($a0)
                subi $t0, $t0, 48

                # Verificar se valores sao iguais
                bne $t3, $t0, return_valida_cpf_false

        j return_valida_cpf_true

        return_valida_cpf_false:
            li $v0, 0
            j return_valida_cpf

        return_valida_cpf_true:
            li $v0, 1

        return_valida_cpf:
            # Restaurar pilha

            jr $ra 
