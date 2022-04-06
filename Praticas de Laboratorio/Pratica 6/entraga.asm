#----------------------------------------------------------------------------------------
# - Ler um arquivo "data.txt"
# - Apresentar como saida a soma dos numeros presentes em data.txt
# - Os numeros em data.txt devem estar separados por um espaço em branco
#----------------------------------------------------------------------------------------

.data
    buffer: .asciiz " "
    file:   .asciiz "data.txt"
    erro:   .asciiz "Erro: Nao foi possivel abrir o arquivo"

.text
    main:
        # Abertura do arquivo
        la $a0, file    # Arquivo a ser aberto
        li $a1, 0       # Somente leitura
        jal fopen
        move $s0, $v0   # Arquivo
        li $s1, 0       # soma = 0

        while:
            move $a0, $s0       # Arquivo
            la $a1, buffer      # Buffer para receber info do arquivo
            la $a2, 1           # Quantidade de caracteres por leitura
            jal numeros
            beqz $v1, somar
            sub $s1, $s1, $v0   # soma -= retorno de numeros se $v1 == 1
            j next_while
            somar:
                add $s1, $s1, $v0   # soma += retorno de numeros
            next_while:
                bgtz $v0, while     # Realiza while ate que $v0 == 0

        move $a0, $s1
        li $v0, 1
        syscall

        # Encerrar programa
        li $v0, 16  # Fechar arquivo
        syscall
        li $v0, 10
        syscall
        
    ##################### FUNCOES #####################

    fopen:
        # Variaveis:
        #   $a0: Nome do arquivo
        #   $a1: Modo de abertura
        
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

    numeros:
        # Variaveis:
        #   $a0: Arquivo
        #   $t0: numero
        #   $t1: auxiliar
        #   $t2: elemento lido
        #   $t3: auxiliar negativo

        # Ajustar pilha
        addi $sp, $sp, -16
        sw $t0, 0($sp)
        sw $t1, 4($sp)
        sw $t2, 8($sp)
        sw $t3, 12($sp)

        # Atribuicao de valores
        li $t0, 0
        li $t1, 32  # Codigo ASCII para espaco
        li $t3, 45  # Codigo ASCII para -
        li $v1, 0
        
        montar_numero:
            li $v0, 14  # Codigo syscall para leitura de arquivo
            syscall
            lb $t2, ($a1)
            bne $t2, $t3, continue
            li $v1, 1
            j next_montar_numero
            continue:
                beq $t2, $t1, return_numeros
                beqz $v0, return_numeros

                subi $t2, $t2, 48
                mul $t0, $t0, 10
                add $t0, $t0, $t2

            next_montar_numero:
                j montar_numero
        
        return_numeros:
            move $v0, $t0
            # Restaurar pilha
            lw $t0, 0($sp)
            lw $t1, 4($sp)
            lw $t2, 8($sp)
            lw $t3, 12($sp)
            addi $sp, $sp, 16
            jr $ra



