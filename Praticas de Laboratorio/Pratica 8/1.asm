#----------------------------------------------------------------------------------------
# - Determinar os numeros que compoem uma sequencia de numeros reais e a quantidade de
#   vezes que cada um ocorre
#----------------------------------------------------------------------------------------
.data
    # Mensagens de entrada
    msg_entrada_n:              .asciiz "Entre com o valor de n: "
    msg_entrada_vet:            .asciiz "Entre com os elementos do Vetor: \n"
    msg_inicio_elementoVetor:   .asciiz "vetor["
    msg_fim_elementoVetor:      .asciiz "]: "

    # Mensagem de saida
    msg_saida_meio: .asciiz " ocorre "
    msg_saida_final: .asciiz " vez(es)\n"

    # Outras strings
    new_line: .asciiz "\n"

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

        # Percorrer o vetor e determina os valores
        move $a0, $s1
        move $a1, $s0
        jal percorre_valores

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

    percorre_valores:
        #---------------------------------------------------------------#
        # Percorre o vetor e determina os numeros pertencentes ao vetor #
        # e o numero de vezes que cada um ocorre                        #
        #---------------------------------------------------------------#
        # Variaveis:                                                    #
        #   $a0: vetor                                                  #
        #   $a1: tamanho do vetor                                       #
        #---------------------------------------------------------------#
        # Retorno: Sem retorno                                          #
        #---------------------------------------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -20
        sw $t0, 0($sp)
        sw $t1, 4($sp)
        sw $t2, 8($sp)
        sw $t3, 12($sp)
        sw $ra, 16($sp)

        # Atribuicao de valores
        move $t0, $a0   # Auxiliar para primeira posicao do vetor
        move $t1, $a1   # Auxiliar para tamanho do vetor
        move $t2, $a0   # Auxiliar para vetor
        li  $t3, 0      # Auxiliar para posicao no vetor

        la $a0, new_line
        li $v0, 4
        syscall

        for_percorre_valores:
            beq $t3, $t1, return_percorre_valores
            # Ler numero do vetor
            l.s $f12, ($t2)
            # Verificar se e' a primeira ocorrencia do numero no vetor
            move $a0, $t0
            move $a1, $t3
            mov.s $f29, $f12
            jal busca
            beqz $v0, next_for_percorre_valores

            li $v0, 2
            syscall
            la $a0, msg_saida_meio
            li $v0, 4
            syscall

            # Determinar o numero de ocorrencias de $f12 no vetor
            move $a0, $t0
            move $a1, $t1
            move $a2, $t3
            mov.s $f29, $f12
            jal contar_ocorrencias

            move $a0, $v0
            li $v0, 1
            syscall

            la $a0, msg_saida_final
            li $v0, 4
            syscall

            next_for_percorre_valores:
                addi $t3, $t3, 1
                addi $t2, $t2, 4
                j for_percorre_valores

        return_percorre_valores:
            # Restaurar pilha
            lw $t0, 0($sp)
            lw $t1, 4($sp)
            lw $t2, 8($sp)
            lw $t3, 12($sp)
            lw $ra, 16($sp)
            addi $sp, $sp, 20

            jr $ra

    ######################################################################################################

    busca:
        #-----------------------------------------------------------------#
        # Verifica a primeira ocorrencia de $f29 e' na posicao $a1 de $a0 #
        #-----------------------------------------------------------------#
        # Variaveis:                                                      #
        #   $a0: vetor                                                    #
        #   $a1: ultima posicao a ser considerada                         #
        #   $f29: valor a ser verificado                                  #
        #-----------------------------------------------------------------#
        # Retorno: Retorna em $v0 0 se for falso, 1 caso verdadeiro       #
        #-----------------------------------------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -4
        sw $t0, 0($sp)

        # Atribuicao de valores
        li $t0, 0

        for_busca:
            bge $t0, $a1, return_busca_verdadeiro
            l.s $f30, ($a0)
            c.eq.s $f30, $f29  
            bc1t return_busca_falso # Se $f30 == $f29 ir para return_busca_falso

            # Proxima iteracao
            addi $t0, $t0, 1
            addi $a0, $a0, 4
            j for_busca

        return_busca_verdadeiro:
            li $v0, 1
            j return_busca

        return_busca_falso:
            li $v0, 0

        return_busca:
            # Restaurar pilha
            lw $t0, 0($sp)
            addi $sp, $sp, 4

            jr $ra

    ######################################################################################################

    contar_ocorrencias:
        #----------------------------------------------------------------#
        # Retorna o numero de ocorrencias de $f29 em $a0                 #
        #----------------------------------------------------------------#
        # Variaveis:                                                     #
        #   $a0: vetor                                                   #
        #   $a1: tamanho do vetor                                        #
        #   $a2: primeira posicao a ser considerada                      #
        #   $f29: valor a ser contabilizado                              #
        #----------------------------------------------------------------#
        # Retorno: Retorna em $v0 o numero de ocorrencias de $f29 em $a0 #
        #----------------------------------------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -4
        sw $t0, 0($sp)

        # Atribuicao de valores
        mul $t0, $a2, 4
        add $a0, $a0, $t0
        li $t0, 0

        for_contar_ocorrencias:
            beq $a2, $a1, return_contar_ocorrencias
            l.s $f30, ($a0)
            c.eq.s $f30, $f29
            bc1f next_for_contar_ocorrencias
            addi $t0, $t0, 1

            next_for_contar_ocorrencias:
                addi $a2, $a2, 1
                addi $a0, $a0, 4
                j for_contar_ocorrencias
        
        return_contar_ocorrencias:
            move $v0, $t0
            # Restaurar pilha
            lw $t0, 0($sp)
            addi $sp, $sp, 4

            jr $ra
