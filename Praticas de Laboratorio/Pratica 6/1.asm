#----------------------------------------------------------------------------------------
# - Ler um arquivo "dados1.txt"
# - Apresentar como saida:
#       a) O maior valor;
#       b) O menor valor;
#       c) O número de elementos ímpares;
#       d) O número de elementos pares;
#       e) A soma dos valores;
#       f) O produto dos elementos;
#       g) O número de caracteres do arquivo;
# - Os numeros em dados1.txt devem estar separados por um espaço em branco
#----------------------------------------------------------------------------------------

.data
    buffer: .asciiz " "
    file:   .asciiz "dados1.txt"

    # Mensagens de saída
    msg_saida_maior_elemento: .asciiz "Maior inteiro: "
    msg_saida_menor_elemento: .asciiz "\nMenor inteiro: "
    msg_saida_qtd_impares: .asciiz "\nQuantidade de impares: "
    msg_saida_qtd_pares: .asciiz "\nQuantidade de pares: "
    msg_saida_soma_elementos: .asciiz "\nSoma dos inteiros: "
    msg_saida_produto: .asciiz "\nProduto dos inteiros: "
    msg_saida_qtd_caracteres: .asciiz "\nQuantidade de caracteres: "

    # Mensagem de erro
    erro:   .asciiz "\nErro: Nao foi possivel abrir o arquivo\n"

.text
    main:
        la $a0, file    # Arquivo
        li $a1, 0       # Modo de abertura de file
        li $a2, 1       # Quantidade de caracteres por leitura
        
        # Maior elemento do arquivo
        #jal maior_menor_numero

        move $t0, $v0   # $t0 = maior elemento do arquivo
        move $t1, $v1   # $t1 = menor elemento do arquivo
        
        la $a0, msg_saida_maior_elemento
        li $v0, 4
        syscall
        move $a0, $t0
        li $v0, 1
        syscall

        # Menor elemento do arquivo
        la $a0, msg_saida_menor_elemento
        li $v0, 4
        syscall
        move $a0, $t1
        li $v0, 1
        syscall

        la $a0, file
        # Quantidade de impares
        #jal quantidade_impares_pares

        move $t0, $v0   # $t0 = quantidade de impares
        move $t1, $v1   # $t1 = quantidade de pares

        la $a0, msg_saida_qtd_impares
        li $v0, 4
        syscall
        move $a0, $t0
        li $v0, 1
        syscall

        # Quantidade de pares
        la $a0, msg_saida_qtd_pares
        li $v0, 4
        syscall
        move $a0, $t1
        li $v0, 1
        syscall

        la $a0, file
        # Soma dos inteiros
        #jal soma_numeros

        move $t0, $v0   # $t0 = soma

        la $a0, msg_saida_soma_elementos
        li $v0, 4
        syscall
        move $a0, $t0
        li $v0, 1
        syscall

        la $a0, file
        # Produto
        #jal produto

        move $t0, $v0   # $t0 = produto

        la $a0, msg_saida_produto
        li $v0, 4
        syscall
        move $a0, $t0
        li $v0, 1
        syscall

        la $a0, file
        # Quantidade de caracteres
        jal qtd_caracteres

        move $t0, $v0   # $t0 = qtd_caracteres

        la $a0, msg_saida_qtd_caracteres
        li $v0, 4
        syscall
        move $a0, $t0
        li $v0, 1
        syscall

        # Encerrar programa
        li $v0, 10
        syscall
    
    ##################### FUNCOES #####################

    fopen:
        #-----------------------------------------------------------#
        # Abre um arquivo em um modo especificado                   #
        #-----------------------------------------------------------#
        # Variaveis:                                                #
        #   $a0: Nome do arquivo                                    #
        #   $a1: Modo de abertura                                   #
        #-----------------------------------------------------------#
        # Retorno: Retorna em $v0 o arquivo aberto no modo indicado #
        #-----------------------------------------------------------#
        
        li $v0, 13  # Codigo syscall para abertura de arquivo
        syscall
        bgez $v0, return_fopen
        
        # Erro ao abrir o arquivo
        la $a0, erro
        li $v0, 4
        syscall
        li $v0, 10
        syscall

        return_fopen:
            jr $ra

    ######################################################################################################

    fclose:
        #------------------#
        # Fecha um arquivo #
        #------------------#
        # Variaveis:       #
        #   $a0: Arquivo   #
        #------------------#

        li $v0, 16
        syscall

        jr $ra

    ######################################################################################################

    fgetc:
        #------------------------------------------------#
        # Realiza a leitura de um caracter de um arquivo #
        #------------------------------------------------#
        # Variaveis:                                     #
        #   $a0: Arquivo                                 #
        #   $a1: Buffer                                  #
        #   $a2: Bytes por leitura                       #
        #------------------------------------------------#
        # Retorno: Retorna em $v0 o valor do byte lido   #
        #------------------------------------------------#

        li $v0, 14  # Codigo syscall para leitura de arquivo
        syscall
        bnez $v0, return_cod
        j return_fgetc

        return_cod:
            lb $v0, ($a1)

        return_fgetc:
            jr $ra

    ######################################################################################################    

    numeros:
        #--------------------------------------------------------------------------------------------------#
        # Realiza a leitura de um numero em um arquivo, o final do numero e' indicado por EOL ou espaço    #
        #--------------------------------------------------------------------------------------------------#
        # Variaveis:                                                                                       #
        #   $a0: Arquivo                                                                                   #
        #   $a1: Buffer                                                                                    #
        #   $a2: Bytes por leitura                                                                         #
        #   $t0: Valor lido                                                                                #
        #   $t1: Numero                                                                                    #
        #   $t2: Flag                                                                                      #
        #   $t3: auxiliar valor " "                                                                        #
        #   $t4: auxiliar valor "-"                                                                        #
        #   $t5: auxiliar                                                                                  #
        #--------------------------------------------------------------------------------------------------#
        # Retorno:  Retorna em $v0 o numero lido, e caso seja encontrado EOF, sera retornado 1 em $v1      #
        #--------------------------------------------------------------------------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -24
        sw $t0, 0($sp)
        sw $t1, 4($sp)
        sw $t2, 8($sp)
        sw $t3, 12($sp)
        sw $t4, 16($sp)
        sw $ra, 20($sp)

        # Atribuicao de valores
        li $t1, 0
        li $t2, 0
        li $t3, 32
        li $t4, 45
        li $v1, 0

        while_numeros:
            jal fgetc
            move $t0, $v0
            blez $t0, return_numeros_eof
            beq $t0, $t3, finalizar_numero
            beq $t0, $t4, set_flag_negativo

            # Montar numero
            subi $t0, $t0, 48
            mul $t1, $t1, 10
            add $t1, $t1, $t0

            j while_numeros

            set_flag_negativo:
                li $t2, 1
                j while_numeros
        
        return_numeros_eof:
            li $v1, 1
        
        finalizar_numero:
            bne $t2, 1, return_numeros
            sub $t1, $zero, $t1

        return_numeros:
            move $v0, $t1
            
            # Restaurar pilha
            lw $t0, 0($sp)
            lw $t1, 4($sp)
            lw $t2, 8($sp)
            lw $t3, 12($sp)
            lw $t4, 16($sp)
            lw $ra, 20($sp)
            addi $sp, $sp, 24

            jr $ra

    ######################################################################################################

    maior_menor_numero:
        #--------------------------------------------------------------#
        # Retorna o maior e menor numero em um arquivo                 #
        #--------------------------------------------------------------#
        # Variaveis:                                                   #
        #   $a0: Nome do arquivo                                       #
        #   $a1: Modo de abertura                                      #
        #   $t0: Maior numero                                          #
        #   $t1: Menor numero                                          #
        #--------------------------------------------------------------#
        # Retorno: Retorna em $v0 o maior numero lido e em $v1 o menor #
        #--------------------------------------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -12
        sw $t0, 0($sp)
        sw $t1, 4($sp)
        sw $ra, 8($sp)

        # Atribuicao de valores
        jal fopen

        # Identificar menor e maior numero do arquivo
        move $a0, $v0
        la $a1, buffer  # Buffer para receber info do arquivo
        la $a2, 1       # Quantidade de caracteres por leitura
        jal numeros
        
        move $t0, $v0  # maior recebe o primeiro numero lido
        move $t1, $v0  # menor recebe o primeiro numero lido
        beq $v1, 1, return_maior_menor

        while_maior_menor:
            jal numeros
            bgt $v0, $t0, new_maior
            blt $v0, $t1, new_menor
            j next_while_maior_menor

            new_maior:
                move $t0, $v0
                j next_while_maior_menor
            
            new_menor:
                move $t1, $v0
                j next_while_maior_menor
            
            next_while_maior_menor:
                beq $v1, 1, return_maior_menor
                j while_maior_menor
        
        return_maior_menor:
            jal fclose
            move $v0, $t0
            move $v1, $t1

            # Restaurar pilha
            lw $t0, 0($sp)
            lw $t1, 4($sp)
            lw $ra, 8($sp)
            addi $sp, $sp, 12

            jr $ra
    
    ######################################################################################################

    quantidade_impares_pares:
        #--------------------------------------------------------------------------------------#
        # Retorna a quantidade de numeros impares e pares lidos                                #
        #--------------------------------------------------------------------------------------#
        # Variaveis:                                                                           #
        #   $a0: Nome do arquivo                                                               #
        #   $a1: Modo de abertura                                                              #
        #   $t0: Quantidade impares                                                            #
        #   $t1: Quantidade pares                                                              #
        #   $t2: aux                                                                           #
        #--------------------------------------------------------------------------------------#
        # Retorno: Retorna em $v0 a quantidade de impares lidos e em $v1 a quantidade de pares #
        #--------------------------------------------------------------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -16
        sw $t0, 0($sp)
        sw $t1, 4($sp)
        sw $t2, 8($sp)
        sw $ra, 12($sp)

        # Atribuicao de valores
        jal fopen
        
        # Identificar menor e maior numero do arquivo
        move $a0, $v0
        la $a1, buffer  # Buffer para receber info do arquivo
        la $a2, 1       # Quantidade de caracteres por leitura

        li $t0, 0       # Quantidade de impares
        li $t1, 0       # Quantidade de pares

        while_impares_pares:
            jal numeros
            li $t2, 2
            div $v0, $t2
            mfhi $t2
            beqz $t2, incrementa_pares
            addi $t0, $t0, 1
            j next_while_impares_pares

            incrementa_pares:
                addi $t1, $t1, 1
                j next_while_impares_pares
            
            next_while_impares_pares:
                beq $v1, 1, return_impares_impares
                j while_impares_pares
        
        return_impares_impares:
            jal fclose
            move $v0, $t0
            move $v1, $t1

            # Restaurar pilha
            lw $t0, 0($sp)
            lw $t1, 4($sp)
            lw $t2, 8($sp)
            lw $ra, 12($sp)
            addi $sp, $sp, 16

            jr $ra

    ######################################################################################################

    soma_numeros:
        #-----------------------------------------------------------------#
        # Retorna a soma dos numeros no arquivo                           #
        #-----------------------------------------------------------------#
        # Variaveis:                                                      #
        #   $a0: Nome do arquivo                                          #
        #   $a1: Modo de abertura                                         #
        #   $t0: Soma                                                     #
        #-----------------------------------------------------------------#
        # Retorno: Retorna em $v0 a soma dos numeros presentes no arquivo #
        #-----------------------------------------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -8
        sw $t0, 0($sp)
        sw $ra, 4($sp)

        # Atribuicao de valores
        jal fopen
    
        move $a0, $v0
        la $a1, buffer  # Buffer para receber info do arquivo
        la $a2, 1       # Quantidade de caracteres por leitura

        li $t0, 0       # Soma

        while_soma_numeros:
            jal numeros
            add $t0, $t0, $v0
            
            beq $v1, 1, return_soma_numeros
            j while_soma_numeros
        
        return_soma_numeros:
            jal fclose
            move $v0, $t0

            # Restaurar pilha
            lw $t0, 0($sp)
            lw $ra, 4($sp)
            addi $sp, $sp, 8

            jr $ra

    ######################################################################################################

    produto:
        #--------------------------------------------------------------------#
        # Retorna a produto dos numeros no arquivo                           #
        #--------------------------------------------------------------------#
        # Variaveis:                                                         #
        #   $a0: Nome do arquivo                                             #
        #   $a1: Modo de abertura                                            #
        #   $t0: Produto                                                     #
        #--------------------------------------------------------------------#
        # Retorno: Retorna em $v0 o produto dos numeros presentes no arquivo #
        #--------------------------------------------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -8
        sw $t0, 0($sp)
        sw $ra, 4($sp)

        # Atribuicao de valores
        jal fopen
    
        move $a0, $v0
        la $a1, buffer  # Buffer para receber info do arquivo
        la $a2, 1       # Quantidade de caracteres por leitura

        li $t0, 1       # Produto

        while_produto:
            jal numeros
            mul $t0, $t0, $v0
            
            beq $v1, 1, return_produto
            j while_produto
        
        return_produto:
            jal fclose
            move $v0, $t0

            # Restaurar pilha
            lw $t0, 0($sp)
            lw $ra, 4($sp)
            addi $sp, $sp, 8

            jr $ra

    ######################################################################################################

    qtd_caracteres:
        #-------------------------------------------------------------------------#
        # Retorna a quantidade de caracteres no arquivo                           #
        #-------------------------------------------------------------------------#
        # Variaveis:                                                              #
        #   $a0: Nome do arquivo                                                  #
        #   $a1: Modo de abertura                                                 #
        #   $t0: Quantidade                                                       #
        #-------------------------------------------------------------------------#
        # Retorno: Retorna em $v0 a quantidade de caracteres presentes no arquivo #
        #-------------------------------------------------------------------------#

         # Ajustar pilha
        addi $sp, $sp, -8
        sw $t0, 0($sp)
        sw $ra, 4($sp)

        # Atribuicao de valores
        jal fopen
    
        move $a0, $v0
        la $a1, buffer  # Buffer para receber info do arquivo
        la $a2, 1       # Quantidade de caracteres por leitura

        li $t0, 0       # Soma

        while_qtd_caracteres:
            jal fgetc
            beqz $v0, return_qtd_caracteres
            add $t0, $t0, 1
            j while_qtd_caracteres
        
        return_qtd_caracteres:
            jal fclose
            move $v0, $t0

            # Restaurar pilha
            lw $t0, 0($sp)
            lw $ra, 4($sp)
            addi $sp, $sp, 8

            jr $ra

