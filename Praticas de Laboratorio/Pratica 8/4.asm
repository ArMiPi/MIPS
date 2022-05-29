#---------------------------------------------------------------------------------
# - Realizar a leitura de um inteiro n
# - Realizar a leitura de n numeros reais
# - Determinar o segmento com a maior soma
#---------------------------------------------------------------------------------
.data
    # Mensagens de entrada
    msg_entrada_n: .asciiz "Entre com o numero de elementos: "
    msg_entrada_vet:            .asciiz "Entre com os elementos do Vetor: \n"
    msg_inicio_elementoVetor:   .asciiz "vetor["
    msg_fim_elementoVetor:      .asciiz "]: "

    # Mensagens de saida
    msg_saida_inicio: .asciiz "A soma do maior segmento e' "
    msg_saida_meio: .asciiz ", obtida pela soma dos numeros nas posicoes de "
    msg_saida_fim: .asciiz " ate' "

.text
    main:
        # Realizar a leitura de n
        li $v0, 4
        la $a0, msg_entrada_n
        syscall
        li $v0, 5
        syscall
        move $s0, $v0   # $s0 = tamanho do vetor

        # Alocar memoria para o vetor
        move $a0, $s0
        jal aloca_vetor

        move $s1, $v0   # $s1 = vetor

        # Preencher vetor
        la $a0, msg_entrada_vet
        li $v0, 4
        syscall
        move $a0, $s1
        move $a1, $s0
        jal preenche_vetor

        # Determinar segmento com a maior soma
        move $a0, $s1
        move $a1, $s0
        jal define_sequencia

        move $s2, $v0
        move $s3, $v1
        mov.s $f12, $f30

        la $a0, msg_saida_inicio
        li $v0, 4
        syscall
        li $v0, 2
        syscall
        la $a0, msg_saida_meio
        li $v0, 4
        syscall
        move $a0, $s2
        li $v0, 1
        syscall
        la $a0, msg_saida_fim
        li $v0, 4
        syscall
        move $a0, $s3
        li $v0, 1
        syscall

        # Encerrar programa
        li $v0, 10
        syscall

    ##################### FUNCOES #####################

    aloca_vetor:
        #----------------------------------------------------#
        # Aloca a memoria necessaria para um vetor           #
        #----------------------------------------------------#
        # Variaveis:                                         #
        #   $a0: tamanho do vetor                            #
        #----------------------------------------------------#
        # Retorno: Retorna $v0 o endereco da memoria alocada #
        #----------------------------------------------------#

        # Atribuicao de valores
        mul $a0, $a0, 4     # $a0 = tamanho * 4
        li $v0, 9           # Codigo syscall para alocar memoria
        syscall             # Aloca a memoria requisitada

        jr $ra              # Retorno
    
    ######################################################################################################

    preenche_vetor:
        #-----------------------------------#
        # Preenche os elementos de um vetor #
        #-----------------------------------#
        # Variaveis:                        #
        #   $a0: vetor                      #
        #   $a1: tamanho do vetor           #
        #   $t0: auxiliar vetor             #
        #   $t1: i                          #
        #-----------------------------------#
        # Retorno: Sem retorno              #
        #-----------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -8
        sw $t0, 0($sp)
        sw $t1, 4($sp)

        # Atribuicao de valores
        move $t0, $a0
        li $t1, 0

        loop_preenche_vetor:
            beq $t1, $a1, return_preenche_vetor
            la $a0, msg_inicio_elementoVetor
            li $v0, 4
            syscall
            move $a0, $t1
            li $v0, 1
            syscall
            la $a0, msg_fim_elementoVetor
            li $v0, 4
            syscall
            # Leitura do float
            li $v0, 6
            syscall
            s.s $f0, ($t0)

            # Proxima iteracao
            addi $t0, $t0, 4
            addi $t1, $t1, 1
            j loop_preenche_vetor        

        return_preenche_vetor:
        # Restaurar pilha
        lw $t0, 0($sp)
        lw $t1, 4($sp)
        addi $sp, $sp, 8

        jr $ra

    ######################################################################################################

    define_sequencia:
        #---------------------------------------------------------#
        # Determinar segmento com a maior soma                    #
        #---------------------------------------------------------#
        # Variaveis:                                              #
        #   $a0: vetor                                            #
        #   $a1: tamanho do vetor                                 #
        #---------------------------------------------------------#
        # Retorno: Retorna em $v0 a primeira posicao da sequencia #
        #          Retorna em $v1 a ultima posicao da sequencia   #
        #          Retorna em $f30 a soma da sequencia            #
        #---------------------------------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -32
        sw $t0, 0($sp)
        sw $t1, 4($sp)
        sw $t2, 8($sp)
        sw $t3, 12($sp)
        sw $t4, 16($sp)
        sw $t5, 20($sp)
        sw $t6, 24($sp)
        sw $t7, 28($sp)

        # Atribuicao de valores
        li $v0, 0           # Posicao inicial da maior sequencia
        li $v1, 0           # Posicao final da maior sequencia
        l.s $f30, ($a0)     # soma = vetor[0]

        li $t0, 0   # i = 0
        for_tamanho_sequencia:
            beq $t0, $a1, return_define_sequencia

            li $t1, 0           # j = 0
            subi $t2, $a1, 1    # limite proximo for
            for_inicio_sequencia:
                beq $t1, $t2, next_for_tamanho_sequencia
                
                move $t3, $t1       # k = 0
                move $t7, $t3       # copia do valor inical da sequencia
                add $t4, $t0, $t1   # limite para proximo for
                sub.s $f1, $f1, $f1 # $f1 = 0

                # Definir posicao inicial da sequencia no vetor
                move $t5, $a0
                mul $t6, $t3, 4
                add $t5, $t5, $t6  # $t5 = vetor[k]
                for_soma_sequencia:
                    bgt $t3, $t4, next_for_inicio_sequencia
                    l.s $f2, ($t5)
                    add.s $f1, $f1, $f2 # soma += vetor[k]

                    next_for_soma_sequencia:
                        addi $t3, $t3, 1
                        addi $t5, $t5, 4
                        j for_soma_sequencia
                
                next_for_inicio_sequencia:
                    # Verificacoes
                    c.lt.s $f1, $f30
                    bc1t next
                    move $v0, $t7
                    move $v1, $t4
                    mov.s $f30, $f1

                    next:
                        addi $t1, $t1, 1
                        j for_inicio_sequencia
            
            next_for_tamanho_sequencia:
                addi $t0, $t0, 1
                j for_tamanho_sequencia

        return_define_sequencia:
            # Restaurar pilha
            lw $t0, 0($sp)
            lw $t1, 4($sp)
            lw $t2, 8($sp)
            lw $t3, 12($sp)
            lw $t4, 16($sp)
            lw $t5, 20($sp)
            lw $t6, 24($sp)
            lw $t7, 28($sp)
            addi $sp, $sp, 32

            jr $ra
