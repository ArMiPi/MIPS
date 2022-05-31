#---------------------------------------------------------------------------------
# - Alocar dinamicamente 2 vetores de tamanho n
# - Realizar a leitura dos n elementos de um dos vetores
# - Realizar a copia dos elementos do primeiro vetor, no segundo vetor, porem
#   em ordem inversa
# - Ex: V1 = {1, 2, 3, 4, 5} -> V2 = {5, 4, 3, 2, 1}
#---------------------------------------------------------------------------------
.data
    # Mensagens de entrada
    msg_entrada_n: .asciiz "Entre com o tamanho do vetor: "
    msg_inicio_elementoVetor: 	.asciiz "vetor["
	msg_fim_elementoVetor:		.asciiz "]: "

    # Mensagens de saida
    msg_saida_v1: .asciiz "V1 = "
    msg_saida_v2: .asciiz "V2 = "
    inicio_vetor: .asciiz "[ "
    final_vetor: .asciiz "]\n"

    # Outras strings
    espaco: .asciiz " "

.text
    main:
        # Realizar a leitura de n
        la $a0, msg_entrada_n
        li $v0, 4
        syscall
        li $v0, 5
        syscall

        move $s0, $v0   # $s0 = tamanho do vetor

        # Alocar memoria para o vetor 1
        move $a0, $s0
        jal aloca_vetor

        move $s1, $v0

        # Alocar memoria para o vetor 2
        move $a0, $s0
        jal aloca_vetor

        move $s2, $v0

        # Realizar leitura dos elementos 
        move $a0, $s1
        move $a1, $s0
        jal preenche_vetor

        # Preencher vetor 2
        move $a0, $s1
        move $a1, $s2
        move $a2, $s0
        jal inverte_vetor

        # Imprimir vetor 1
        la $a0, msg_saida_v1
        li $v0, 4
        syscall
        move $a0, $s1
        move $a1, $s0
        jal imprime_vetor

        # Imprimir vetor 2
        la $a0, msg_saida_v2
        li $v0, 4
        syscall
        move $a0, $s2
        move $a1, $s0
        jal imprime_vetor

        # Encerrar programa
        li $v0, 10
        syscall

    ##################### FUNCOES #####################

	aloca_vetor:
        #-------------------------------------------#
        # Aloca um vetor para $a0 inteiros          #
        #-------------------------------------------#
        # Variaveis:                                #
        #   $a0: tamanho do vetor                   #
        #-------------------------------------------#
        # Retorno: Retorna em $v0 a memoria alocada #
        #-------------------------------------------#

        	# Atribuicao de valores
        	mul $a0, $a0, 4
        	li $v0, 9
        	syscall

        	jr $ra
    
    ######################################################################################################

    preenche_vetor:
        #-------------------------#
        # Preenche um vetor       #
        #-------------------------#
        # Variaveis:              #
        #   $a0: vetor            #
        #   $a1: tamanho do vetor #
        #-------------------------#
        # Retorno: Sem retorno    #
        #-------------------------#

        # Ajustar pilha
        addi $sp, $sp, -16
        sw $t0, 0($sp)    
        sw $t1, 4($sp)    
        sw $a0, 8($sp)    
        sw $v0, 12($sp)   

        # Atribuicao de valores
        move $t0, $a0   # $t0 recebe o endereco do vetor
        li $t1, 0       # i = 0

        loop_preenche_vetor:
            li $v0, 4					        
		    la $a0, msg_inicio_elementoVetor
		    syscall					            
		    li $v0, 1					        
		    add $a0, $t1, $zero				    
		    syscall					            
		    la $v0, 4					        
		    la $a0, msg_fim_elementoVetor
		    syscall					            
		    li $v0, 5					        
		    syscall					            
            sw $v0, ($t0)					    
		    addi $t0, $t0, 4				    
		    addi $t1, $t1, 1				    
		    blt $t1, $a1, loop_preenche_vetor	
        
        # Restaurar pilha
        lw $t0, 0($sp)      # Restaura o valor de $t0
        lw $t1, 4($sp)      # Restaura o valor de $t1
        lw $a0, 8($sp)      # Restaura o valor de $a0
        lw $v0, 12($sp)     # Restaura o valor de $sp
        addi $sp, $sp, 16   # Ajusta a pilha para excluir 4 itens
        jr $ra              # Retorno

    ######################################################################################################

	imprime_vetor:
        #----------------------------------#
        # Imprime os elementos de um vetor #
        #----------------------------------#
        # Variaveis:                       #
        #   $a0: vetor                     #
        #   $a1: tamanho do vetor          #
        #----------------------------------#
        # Retorno: Sem retorno             #
        #----------------------------------#
		
        # Ajustar pilha
        addi $sp, $sp, -4
        sw $t0, 0($sp)

        # Atribuicao de valores
        move $t0, $a0

        la $a0, inicio_vetor
        li $v0, 4
        syscall
		for_imprime_vetor:
            beqz $a1, return_imprime_vetor
            lw $a0, ($t0)
            li $v0, 1
            syscall
            la $a0, espaco
            li $v0, 4
            syscall

            addi $a1, $a1, -1
            addi $t0, $t0, 4
            j for_imprime_vetor

        return_imprime_vetor:
            la $a0, final_vetor
            li $v0, 4
            syscall
            # Restaurar pilha
            lw $t0, 0($sp)
            addi $sp, $sp, 4

            jr $ra

    ######################################################################################################

    inverte_vetor:
        #---------------------------------------------------#
        # Copia os valores de $a0 para $a1 em ordem inversa #
        #---------------------------------------------------#
        # Variaveis:                                        #
        #   $a0: vetor1                                     #
        #   $a1: vetor2                                     #
        #   $a2: tamanho do vetor                           #
        #---------------------------------------------------#
        # Retorno: Sem retorno                              #
        #---------------------------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -4
        sw $t0, 0($sp)

        # Atribuicao de valores
        move $t0, $a2
        subi $t0, $t0, 1
        mul $t0, $t0, 4
        add $a1, $a1, $t0   # $a1 = ultima posicao do vetor

        for_inverte_vetor:
            beqz $a2, return_inverte_vetor
            lb $t0, ($a0)
            sb $t0, ($a1)

            addi $a0, $a0, 4
            addi $a1, $a1, -4
            addi $a2, $a2, -1
            j for_inverte_vetor
        
        return_inverte_vetor:
            # Restaurar pilha
            lw $t0, 0($sp)
            addi $sp, $sp, 4

            jr $ra
