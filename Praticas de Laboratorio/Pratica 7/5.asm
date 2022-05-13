#----------------------------------------------------------------------------------------
# - Realizar a leitura de dois arquivos
# - Determinar se existe pelo menos uma mesma sequencia de palavras de tamanho >= 5 em
#   ambos os arquivos
#----------------------------------------------------------------------------------------
.data
    # Mensagens de entrada
    msg_entrada_file1: .asciiz "Entre com o nome do primeiro arquivo: "
    msg_entrada_file2: .asciiz "Entre com o nome do segundo arquivo: "

    # Mensagem de erro
    msg_erro_file: .asciiz "ERRO: Nao foi possivel abrir o arquivo\n\n"

    # Mensagem de saida
    msg_saida_verdadeiro: .asciiz "Existe sequencia de palavras de tamanho <= 5 presente em ambos os arquivos"
    msg_saida_falso: .asciiz "Nao existe sequencia de palavras de tamanho <= 5 presente em ambos os arquivos"

    # Strings
    file1: .space 100
    file2: .space 100
    buffer: " "

.text
    main:
        # Leitura do nome do primeiro arquivo
        la $a0, msg_entrada_file1
        la $a1, file1
        jal ler_string

        # Abrir arquivo informado
        la $a0, file1   # Arquivo
        li $a1, 0       # Modo de abertura (leitura)
        li $a2, 1       # Quantidade de caracteres por leitura
        jal fopen

        move $s0, $v0

        # Leitura do nome do segundo arquivo
        la $a0, msg_entrada_file2
        la $a1, file2
        jal ler_string

        # Abrir arquivo informado
        la $a0, file2   # Arquivo
        li $a1, 0       # Modo de abertura (leitura)
        li $a2, 1       # Quantidade de caracteres por leitura
        jal fopen

        move $s1, $v0

        # Variáveis
        #   $t0 -> Caracter lido de file1
        #   $t1 -> Caracter lido de file2
        #   $t2 -> Contador
        #   $t3 -> Condicao de parada

        li $t2, 0
        li $t3, 5
        # Procurar por cadeias de no minimo 5 caracteres presentes em ambos os arquivos
        while:
            # Ler caracter de file1
            move $a0, $s0
            la $a1, buffer
            li $a2, 1
            jal fgetc

            beqz $v0, end_false
            move $t0, $v0

            # Ler caracter de file2
            move $a0, $s1
            la $a1, buffer
            li $a2, 1
            jal fgetc

            beqz $v0, end_false
            move $t1, $v0

            # Comparar valores lidos
            beq $t0, $t1, add_count
            li $t2, 0
            j while

            add_count:
                addi $t2, $t2, 1
                beq $t2, $t3, end_true
                j while

        
        end_false:
            la $a0, msg_saida_falso
            j end
        
        end_true:
            la $a0, msg_saida_verdadeiro
        
        end:
            li $v0, 4
            syscall

            # Fechar arquivos
            move $a0, $s0
            jal fclose

            move $a0, $s1
            jal fclose

            # Encerrar programa
            li $v0, 10
            syscall
    
    ##################### FUNCOES #####################

    ler_string:
        #---------------------------------------------------------------------------#
        # Realiza a leitura de uma string e substitui \n do final da leitura por \0 #
        #---------------------------------------------------------------------------#
        # Variaveis:                                                                #
        #   $a0: Mensagem para ler a string                                         #
        #   $a1: string a ser lida                                                  #
        #   $t0: auxiliar                                                           #
        #---------------------------------------------------------------------------#
        # Retorno: Retorna $v0 a string lida                                        #
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
        # Retorno: Retorna em $v0 o tamanho de uma stirng #
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