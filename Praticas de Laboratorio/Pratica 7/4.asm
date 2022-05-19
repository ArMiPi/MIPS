#----------------------------------------------------------------------------------------
# - Realizar a leitura de um arquivo que contenha as dimensoes de uma matriz
#   (linha e coluna), a quantidade de posicoes que serao anuladas e as posicoes a
#   serem anuladas (linha e coluna)
# - Produzir, em um novo arquivo, a matriz com as dimensoes fornecidas pelo arquivo, e
#   todas as posicoes especificadas no arquivo zeradas e o restante recebendo o valor 1
#----------------------------------------------------------------------------------------
.data
    # Mensagem de erro
    msg_erro_file: .asciiz "ERRO: Nao foi possivel abrir o arquivo\n\n"

    # Strings
    input_file: .asciiz "entrada.txt"
    output_file: .asciiz "saida.txt"
    buffer: " "

.text
    main:
        # Abertura do arquivo de entrada
        la $a0, input_file  # Arquivo
        li $a1, 0           # Modo de abertura (leitura)
        li $a2, 1           # Quantidade de caracteres por leitura
        jal fopen

        move $s0, $v0

        # Criacao do arquivo de saida
        la $a0, output_file # Arquivo
        li $a1, 1           # Modo de abertura (escrita)
        jal fopen

        move $s1, $v0

        # Ler e armazenar dados do arquivo de entrada
        move $a0, $s0
        la $a1, buffer
        li $a2, 1
        jal get_dim_null

        move $s2, $v0   # $s2 = numero de linhas da matriz
        move $s3, $v1   # $s3 = numero de colunas da matriz

        # Criar matriz
        move $a0, $s2
        move $a1, $s3
        jal aloca_matriz

        move $s4, $v0   # $s4 = matriz

        # Inicializar matriz
        move $a0, $s4
        move $a1, $s2
        move $a2, $s3
        jal inicializa_matriz

        # Anular as posicoes especificadas
        move $a0, $s0
        move $a1, $s4
        move $a2, $t0
        move $a3, $s3
        jal anular_posicoes

        # Salvar a matriz no arquivo de saida
        move $a0, $s1
        move $a1, $s4
        move $a2, $s2
        move $a3, $s3
        jal imprime_matriz

        # Encerrar programa
        move $a0, $s0
        jal fclose
        move $a0, $s1
        jal fclose
        
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
        la $a0, msg_erro_file
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

    fgeti:
        #-------------------------------------------------#
        # Realiza a leitura de um inteiro em um arquivo   #
        #-------------------------------------------------#
        # Variaveis:                                      #
        #   $a0: Arquivo                                  #
        #   $a1: Buffer                                   #
        #   $a2: Bytes por leitura                        #
        #   $t0: numero                                   #
        #   $t1: auxiliar " "                             #
        #   $t2: auxiliar "cr"                            #
        #-------------------------------------------------#
        # Retorno: Retorna em $v0 o valor do inteiro lido #
        #-------------------------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -16
        sw $t0, 0($sp)
        sw $t1, 4($sp)
        sw $t2, 8($sp)
        sw $ra, 12($sp)

        # Atribuicao de valores
        li $t0, 0
        li $t1, 32
        li $t2, 13

        while_int:
            jal fgetc
            beq $v0, $t1, return_fgeti
            beq $v0, $t2, found_new_line
            beqz $v0, return_fgeti
            mul $t0, $t0, 10
            subi $v0, $v0, 48
            add $t0, $t0, $v0
            j while_int
        
        found_new_line:
            jal fgetc
        
        return_fgeti:
            move $v0, $t0
            # Restaurar pilha
            lw $t0, 0($sp)
            lw $t1, 4($sp)
            lw $t2, 8($sp)
            lw $ra, 12($sp)
            addi $sp, $sp, 16

            jr $ra

    ######################################################################################################

    get_dim_null:
        #---------------------------------------------------------------------------------------------------------#
        # Realiza a leitura das dimensoes de uma matriz e a quantidade de posicoes que serao anuladas             #
        #---------------------------------------------------------------------------------------------------------#
        # Variaveis:                                                                                              #
        #   $a0: Arquivo                                                                                          #
        #   $a1: Buffer                                                                                           #
        #   $a2: Bytes por leitura                                                                                #
        #   $t0: Quantidade de posicoes a serem anuladas                                                          #
        #   $t1: Auxiliar                                                                                         #
        #   $t2: Auxiliar                                                                                         #
        #---------------------------------------------------------------------------------------------------------#
        # Retorno: Retorna em $v0 e $v1 as dimensoes da matriz e em $t0 a quantidade de posicoes a serem anuladas #
        #---------------------------------------------------------------------------------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -8
        sw $t1, 0($sp)
        sw $ra, 4($sp)

        # Realizar leitura da primeira dimensao da matriz
        jal fgeti
        move $t1, $v0

        # Realizar leitura da segunda dimensao da matriz
        jal fgeti
        move $v1, $v0

        # Realizar a leitura da quantidade de posicoes a serem anuladas
        jal fgeti
        move $t0, $v0

        # Retornar valores
        move $v0, $t1
        
        # Restaurar pilha
        lw $t1, 0($sp)
        lw $ra, 4($sp)
        addi $sp, $sp, 8

        jr $ra
    
    ######################################################################################################

    indice:
        #----------------------------------------------------------------------------------#
        # Calcula a posicao do elemento da matriz com base na posicao da linha e da coluna #
        #----------------------------------------------------------------------------------#
        # Variaveis:                                                                       #
        #   $a0: totalColunas                                                              #
        #   $a1: linha                                                                     #
        #   $a2: coluna                                                                    #
        #----------------------------------------------------------------------------------#
        # Retorno: Retorna em $v0 a posicao do especificada                                #
        #----------------------------------------------------------------------------------#

        mul $v0, $a0, $a1
        add $v0, $v0, $a2

        jr $ra

    ######################################################################################################

    aloca_matriz:
        #-------------------------------------------------------------#
        # Aloca espaco para uma matriz com as dimensoes especificadas #
        #-------------------------------------------------------------#
        # Variaveis:                                                  #
        #   $a0: linhas                                               #
        #   $a1: colunas                                              #
        #   $t0: tamanho da memoria a ser alocada                     #
        #-------------------------------------------------------------#
        # Retorno: Retorna em $v0 a matriz                            #
        #-------------------------------------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -4
        sw $t0, 0($sp)

        # Atribuicao de valores
        mul $t0, $a0, $a1
        mul $t0, $t0, 4
        move $a0, $t0
        li $v0, 9
        syscall

        # Restaurar pilha
        lw $t0, 0($sp)
        addi $sp, $sp, 4
        jr $ra

    ######################################################################################################

    inicializa_matriz:
        #----------------------------------------------------------#
        # Inicializa todas as posicoes de uma matriz com o valor 1 #
        #----------------------------------------------------------#
        # Variaveis:                                               #
        #   $a0: matriz                                            #
        #   $a1: quantidade de linhas                              #
        #   $a2: quantidade de colunas                             #
        #----------------------------------------------------------#
        #   Retorno: Sem retorno                                   #
        #----------------------------------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -12
        sw $t0, 0($sp)
        sw $t1, 4($sp)
        sw $t2, 8($sp)

        # Atribuicao de valores
        mul $t0, $a1, $a2
        mul $t0, $t0, 4
        subi $t0, $t0, 4
        li $t1, 1
        move $t2, $a0
        add $t2, $t2, $t0

        for_inicializa_matriz:
            bltz $t0, return_inicializa_matriz
            sw $t1, ($t2)

            subi $t0, $t0, 4
            subi $t2, $t2, 4
            j for_inicializa_matriz
        
        return_inicializa_matriz:
            # Restaurar pilha
            lw $t0, 0($sp)
            lw $t1, 4($sp)
            lw $t2, 8($sp)
            addi $sp, $sp, 12

            jr $ra

    ######################################################################################################

    imprime_matriz:
        #-------------------------------------------#
        # Imprime uma matriz em um arquivo de texto #
        #-------------------------------------------#
        # Variaveis:                                #
        #   $a0: arquivo                            #
        #   $a1: matriz                             #
        #   $a2: linhas                             #
        #   $a3: colunas                            #
        #   $s0: auxiliar matriz                    #
        #   $t0: quantidade de elementos da matriz  #
        #   $t1: j                                  #
        #   $t2: auxiliar                           #
        #-------------------------------------------#
        #   Retorno: Sem retorno                    #
        #-------------------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -16
        sw $s0, 0($sp)
        sw $t0, 4($sp)
        sw $t1, 8($sp)
        sw $t2, 12($sp)

        # Atribuicao de valores
        move $s0, $a1   # $s0 = matriz

        mul $t0, $a2, $a3   # $t0 = Quantidade de elementos da matriz

        li $t1, 0   # $t1 = j = 0
        
        la $a1, buffer  # $a1 = buffer para escrita no arquivo
        li $a2, 1       # Quantidade de caracteres por escrita

        # Percorrer matriz
        for_imprime_matriz:
            beqz $t0, return_imprime_matriz

            # Ler elemento da matriz
            lw $t2, ($s0)

            # "Converter" de inteiro para char
            addi $t2, $t2, 48

            # Armazenar caracter em buffer
            sb $t2, ($a1)

            # Escrever no arquivo
            li $v0, 15
            syscall

            # Atualizar contadores
            addi $s0, $s0, 4    # Proxima posicao da matriz
            subi $t0, $t0, 1    # Total de elementos restantes
            addi $t1, $t1, 1    # j++

            beq $s2, $t1, new_line

            # Imprimir " "
            li $t2, 32
            sb $t2, ($a1)
            li $v0, 15
            syscall

            j for_imprime_matriz

            new_line:
                li $t2, 13
                sb $t2, ($a1)
                li $v0, 15
                syscall

                li $t2, 10
                sb $t2, ($a1)
                li $v0, 15
                syscall

                li $t1, 0

                j for_imprime_matriz
        
        return_imprime_matriz:
            # Restaurar pilha
            lw $s0, 0($sp)
            lw $t0, 4($sp)
            lw $t1, 8($sp)
            lw $t2, 12($sp)
            addi $sp, $sp, 16

            jr $ra

    ######################################################################################################

    anular_posicoes:
        #-------------------------------------------------------------#
        # Anula as posicoes da matriz indicadas no arquivo de entrada #
        #-------------------------------------------------------------#
        # Variaveis:                                                  #
        #   $a0: arquivo                                              #
        #   $a1: matriz                                               #
        #   $a2: quantidade de posicoes a serem anuladas              #
        #   $a3: total de colunas da matriz                           #
        #-------------------------------------------------------------#
        #   Retorno: Sem retorno                                      #
        #-------------------------------------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -24
        sw $t0, 0($sp)
        sw $t1, 4($sp)
        sw $t2, 8($sp)
        sw $t3, 12($sp)
        sw $t4, 16($sp)
        sw $ra, 20($sp)

        # Atribuicao de valores
        move $t0, $a0   # $t0 = arquivo
        move $t1, $a1   # $t1 = matriz
        move $t2, $a2   # $t2 = quantidade de posicoes a serem anuladas

        la $a1, buffer
        li $a2, 1

        for_anular_posicoes:
            beqz $t2, return_anular_posicoes

            jal fgeti
            move $t3, $v0   # $t3 = linha do elemento a ser anulado

            jal fgeti
            move $t4, $v0   # $t4 = coluna do elemento a ser anulado

            move $a0, $a3
            move $a1, $t3
            move $a2, $t4
            jal indice

            # Acessar posicao da matriz
            move $t3, $v0
            mul $t3, $t3, 4
            add $t3, $t1, $t3

            # Zerar elemento da posicao
            sw $zero, ($t3)

            # Atualizar controladores
            subi $t2, $t2, 1
            move $a0, $t0
            la $a1, buffer
            li $a2, 1
            
            j for_anular_posicoes
        
        return_anular_posicoes:
            # Restaurar piha
            lw $t0, 0($sp)
            lw $t1, 4($sp)
            lw $t2, 8($sp)
            lw $t3, 12($sp)
            lw $t4, 16($sp)
            lw $ra, 20($sp)

            jr $ra
