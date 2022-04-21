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

        move $a0, $s0       # Arquivo
        la $a1, buffer      # Buffer para receber info do arquivo
        la $a2, 1           # Quantidade de caracteres por leitura
        
        while:
            jal numeros
            add $s1, $s1, $v0
            beq $v1, 1, print
            j while

        print:
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

    fgetc:
        # Variaveis:
        #   $a0: Arquivo
        #   $a1: Buffer
        #   $a2: Bytes por leitura
        #   $t0: temp

        # Ajustar pilha
        addi $sp, $sp, -4
        sw $t0, 0($sp)

        li $v0, 14  # Codigo syscall para leitura de arquivo
        syscall
        bnez $v0, return_cod
        j return_fgetc

        return_cod:
            lb $t0, ($a1)
            move $v0, $t0

        return_fgetc:
            # Restaurar pilha
            lw $t0, 0($sp)
            addi $sp, $sp, 4

        jr $ra

    ######################################################################################################    

    numeros:
        # Variaveis:
        #   $a0: Arquivo
        #   $a1: Buffer
        #   $a2: Bytes por leitura
        #   $t0: Valor lido
        #   $t1: Numero
        #   $t2: Flag
        #   $t3: auxiliar valor " "
        #   $t4: auxiliar valor "-"
        #   $t5: auxiliar

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
