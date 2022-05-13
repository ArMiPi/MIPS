#----------------------------------------------------------------------------------------
# - Realizar a leitura de um arquivo que contenha as dimesoes de uma matriz
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

    get_dim_null:
        #---------------------------------------------------------------------------------------------------------#
        # Realiza a leitura das dimensoes de uma matriz e a quantidade de posicoes que seram anuladas             #
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


