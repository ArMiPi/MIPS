#---------------------------------------------------------------------------------
# - Realizar a leitura de um vetor de n elementos (n deve ser par)
# - Ordenar a primeira metade do vetor em ordem crescente
# - Ordenar a segunda metade do vetor em ordem decrescente
#---------------------------------------------------------------------------------

.data
    # Mensagens de entrada
    msg_entrada_n:              .asciiz "Entre com o tamanho n do vetor (n deve ser par): "
    msg_entrada_vetor:          .asciiz "Entre com os elementos do vetor: "
    msg_inicio_elementoVetor: 	.asciiz "vetor["
	msg_fim_elementoVetor:		.asciiz "]: "

    # Mensagem de saida:
    msg_saida_vetor: .asciiz "\nVetor ordenado: "

    # Mensagem erro
    msg_erro_n: .asciiz "Erro: O valor de n deve ser par\n\n"

    # Outras strings
    new_line: .asciiz "\n"
    espaco: .asciiz " "

.text
    main:
        # Realizar leitura de um valor de n valido
        la $a0, msg_entrada_n
        li $v0, 4
        syscall
        li $v0, 5
        syscall
        li $t0, 2
        div $v0, $t0
        mfhi $t0
        beqz $t0, criar_vetor
        la $a0, msg_erro_n
        li $v0, 4
        syscall
        j main

        # Criar o vetor
        criar_vetor:
            move $s0, $v0   # $s0 = n
            
            # Alocar a memoria
            move $a1, $s0   # $a1 = n
            jal aloca_vetor
            move $s1, $v0   # $s1 recebe o endereco da memoria alocada

            # Ler os elementos do vetor
            la $a0, msg_entrada_vetor
            li $v0, 4
            move $a0, $s1
            jal preenche_vetor

            # Ordenar o vetor em ordem crescente
            jal ordena_vetor

            # Ordenar metade final do vetor em ordem decrescente
            jal reordena_vetor

            # Imprimir vetor
            jal imprime_vetor

            # Encerrar programa
            li $v0, 10
            syscall

    ##################### FUNCOES #####################

    aloca_vetor:
        # Variaveis:
        #	$a1: tamanho do vetor
        #   $t0: tamanho da memoria para ser alocada
        
        # Ajustar pilha
        addi $sp, $sp, -8   # Ajusta a pilha para armazenar 2 itens
        sw $t0, 0($sp)      # Armazena o valor de $t0
        sw $a0, 4($sp)      # Armazena o valor de $a0

        # Atribuicao de valores
        mul $t0, $a1, 4     # $t0 = tamanho * 4
        move $a0, $t0       # $a0 recebe o tamanho do vetor
        li $v0, 9           # Codigo syscall para alocar memoria
        syscall             # Aloca a memoria requisitada

        # Restaurar valores da pilha
        lw $t0, 0($sp)      # Restaura o valor de $t0
        lw $a0, 4($sp)      # Restaura o valor de $a0
        addi $sp, $sp, 8    # Ajusta a pilha para excluir 2 itens
        jr $ra              # Retorno
    
    ######################################################################################################

    preenche_vetor:
        # Variaveis:
        #   $a0: vetor
        #   $a1: tamanho do vetor
        #   $t0: endereco do vetor
        #   $t1: i

        # Ajustar pilha
        addi $sp, $sp, -16  # Ajusta a pilha para receber 4 itens
        sw $t0, 0($sp)      # Armazena o valor de $t0
        sw $t1, 4($sp)      # Armazena o valor de $t1
        sw $a0, 8($sp)      # Armazena o valor de $a0
        sw $v0, 12($sp)     # Armazena o valor de $v0

        # Atribuicao de valores
        move $t0, $a0   # $t0 recebe o endereco do vetor
        li $t1, 0       # i = 0

        loop_preenche_vetor:
            li $v0, 4					        # Codigo syscall para escrita de string
		    la $a0, msg_inicio_elementoVetor    	# Carrega em $a0 o endereco de msg_inicio_elementoVetor
		    syscall					# Imprime msg_inicio_elementoVetor
		    li $v0, 1					# Codigo syscall para imprimir inteiro
		    add $a0, $t1, $zero				# $a0 recebe a posicao atual do vetor
		    syscall					# Imprime a posicao atual a ser lida do vetor
		    la $v0, 4					# Codigo syscall para escrita de string
		    la $a0, msg_fim_elementoVetor		# Carrega em $a0 o endereco de msg_fim_elementoVetor
		    syscall					# Imprime msg_fim_elementoVetor
		    li $v0, 5					# Codigo syscall para leitura de inteiro
		    syscall					# Realiza a leitura de array[$t1]
            sw $v0, ($t0)					# array[i] = numero digitado
		    addi $t0, $t0, 4				# Proxima posicao do vetor
		    addi $t1, $t1, 1				# i++
		    blt $t1, $a1, loop_preenche_vetor		# Retorna para o inicio do loop se i < tamanho
        
        # Restaurar pilha
        lw $t0, 0($sp)      # Restaura o valor de $t0
        lw $t1, 4($sp)      # Restaura o valor de $t1
        lw $a0, 8($sp)      # Restaura o valor de $a0
        lw $v0, 12($sp)     # Restaura o valor de $sp
        addi $sp, $sp, 16   # Ajusta a pilha para excluir 4 itens
        jr $ra              # Retorno

    ######################################################################################################

    imprime_vetor:
		# Variaveis 
        	#   	$a0: vetor	
		#	$a1: tamanho do vetor
		#	$t0: endereco vetor
        	#   	$t1: elemento vetor
        	#	$t2: i
		
		# Ajustar pilha
		addi $sp, $sp, -16	# Ajusta a pilha para armazenar 4 itens
		sw $t0, 0($sp)		# Armazena o valor armazenado em $t0
		sw $t1, 4($sp)		# Armazena o valor armazenado em $t1
        	sw $t2, 8($sp)      	# Armazena o valor armazenado em $t2
        	sw $a0, 12($sp)    	# Armazena o valor armazenado em $a0
		
		# Atribuicao de valores
		move $t0, $a0	#$t0 recebe endereco do vetor
		li $t2, 0	# i = 0
		
		for_imprime_vetor:
			lw $t1, ($t0)                   # $t1 = array[i]
            		li $v0, 1                       # Codigo syscall para imprimir inteiros
            		move $a0, $t1                   # $a0 = array[i]
			syscall                         # Imrpime array[i]
            		li $v0, 4                       # Codigo syscall para imprimir string
            		la $a0, espaco                  # $a0 recebe endereco de espaco
            		syscall                         # Imprime espaco

            		addi $t0, $t0, 4                # Proxima posicao do vetor
            		addi $t2, $t2, 1                # i++
            		blt $t2, $a1, for_imprime_vetor	# Ir para for_imprime_vetor se i < tamanho

		# Restaurar valores da pilha
		lw $t0, 0($sp)		# Restaura o valor de $t0
		lw $t1, 4($sp)		# Restaura o valor de $t1
        	lw $t2, 8($sp)      	# Restaura o valor de $t2
        	lw $a0, 12($sp)     	# Restaura o valor de $a0
		addi $sp, $sp, 16	# Ajusta a pilha para excluir 4 itens
		jr $ra			# Retorno

	######################################################################################################
    
    ordena_vetor:
		# Variaveis
        #   $a0: endereco do vetor
		#	$a1: tamanho do vetor
		#	$t0: vetor
		#	$t1: posicao do vetor loop externo
		#	$t2: elemento do vetor loop externo
		#	$t3: posicao do vetor loop interno
		#	$t4; elemento do vetor loop interno
		#	$t5: i
		#	$t6: j
		#	$t7: auxiliar
		
		# Ajustar pilha
		addi $sp, $sp, -32	# Ajusta a pilha para armazenar 8 itens
		sw $t0, 0($sp)		# Armazena o valor de $t0
		sw $t1, 4($sp)		# Armazena o valor de $t1
		sw $t2, 8($sp)		# Armazena o valor de $t2
		sw $t3, 12($sp)		# Armazena o valor de $t3
		sw $t4, 16($sp)		# Armazena o valor de $t4
		sw $t5, 20($sp)		# Armazena o valor de $t5
		sw $t6, 24($sp)		# Armazena o valor de $t6
		sw $t7, 28($sp)		# Armazena o valor de $t7
		
		# Atribuicao de valores
		move $t0, $a0	# $t0 recebe o endereco de array
		li $t5, 0	# i = 0
		
		loop_externo:
			bge $t5, $a1, return_ordena	# Ir para return_ordena se i >= tamanho
			mul $t7, $t5, 4			# aux = i * 4
			add $t1, $t0, $t7		# $t1 = endereco inicial do vetor + aux
			lw $t2, ($t1)			# $t2 = array[i]
			
			addi $t6, $t5, 1		# j = i + 1
			loop_interno:
				bge $t6, $a1, next_externo	# Ir para next_interno se j >= tamanho
				mul $t7, $t6, 4			# aux = j * 4
				add $t3, $t0, $t7		# $t3 = endereco inicial do vetor + aux
				lw $t4, ($t3)			# $t4 = array[j]
				bge $t4, $t2, next_interno	# Ir para next_interno se array[j] >= array[i]
				add $t7, $t4, $zero		# aux = array[j]
				sw $t2, ($t3)			# array[j] = array[i]
				sw $t4, ($t1)			# array[i] = aux
				lw $t2, ($t1)			# Atualizar valor de $t2
			
			next_interno:
				addi $t6, $t6, 1	# j++
				j loop_interno		# Volta para loop_interno
		next_externo:
			addi $t5, $t5, 1	# i++
			j loop_externo		# Volta para loop_externo
				
		return_ordena:
			# Restaurar valores da pilha
			lw $t0, 0($sp)		# Restaura o valor de $t0
			lw $t1, 4($sp)		# Restaura o valor de $t1
			lw $t2, 8($sp)		# Restaura o valor de $t2
			lw $t3, 12($sp)		# Restaura o valor de $t3
			lw $t4, 16($sp)		# Restaura o valor de $t4
			lw $t5, 20($sp)		# Restaura o valor de $t5
			lw $t6, 24($sp)		# Restaura o valor de $t6
			lw $t7, 28($sp)		# Restaura o valor de $t7
			addi $sp, $sp, 32	# Ajusta a pilha para excluir 8 itens
		
			jr $ra		# Retorno
			
    ######################################################################################################

    reordena_vetor:
        # Variaveis:
        #   $a0: vetor
        #   $a1: tamanho do vetor
        #	$t0: vetor
		#	$t1: posicao do vetor loop externo
		#	$t2: elemento do vetor loop externo
		#	$t3: posicao do vetor loop interno
		#	$t4; elemento do vetor loop interno
		#	$t5: i
		#	$t6: j
		#	$t7: auxiliar
        #   $t8: auxiliar tamanho
        
        # Ajustar pilha
		addi $sp, $sp, -36	# Ajusta a pilha para armazenar  itens
		sw $t0, 0($sp)		# Armazena o valor de $t0
		sw $t1, 4($sp)		# Armazena o valor de $t1
		sw $t2, 8($sp)		# Armazena o valor de $t2
		sw $t3, 12($sp)		# Armazena o valor de $t3
		sw $t4, 16($sp)		# Armazena o valor de $t4
		sw $t5, 20($sp)		# Armazena o valor de $t5
		sw $t6, 24($sp)		# Armazena o valor de $t6
		sw $t7, 28($sp)		# Armazena o valor de $t7
		
        # Atribuicao de valores
		move $t0, $a0	# $t0 recebe o endereco de array
		li $t5, 0	# i = 0

        # Mover $t0 para a posicao do meio do vetor
        li $t7, 2
        div $t5, $a1, $t7
		
		loop_externo_reordena:
			bge $t5, $a1, return_reordena	# Ir para return_ordena se i >= tamanho
			mul $t7, $t5, 4			        # aux = i * 4
			add $t1, $t0, $t7		        # $t1 = endereco inicial do vetor + aux
			lw $t2, ($t1)			        # $t2 = array[i]
			
			addi $t6, $t5, 1		        # j = i + 1
			loop_interno_reordena:
				bge $t6, $a1, next_externo_reordena	# Ir para next_interno se j >= tamanho
				mul $t7, $t6, 4			            # aux = j * 4
				add $t3, $t0, $t7		            # $t3 = endereco inicial do vetor + aux
				lw $t4, ($t3)			            # $t4 = array[j]
				ble $t4, $t2, next_interno_reordena	# Ir para next_interno se array[j] <= array[i]
				add $t7, $t4, $zero		            # aux = array[j]
				sw $t2, ($t3)			            # array[j] = array[i]
				sw $t4, ($t1)			            # array[i] = aux
				lw $t2, ($t1)			            # Atualizar valor de $t2
			
			next_interno_reordena:
				addi $t6, $t6, 1	        # j++
				j loop_interno_reordena		# Volta para loop_interno
		next_externo_reordena:
			addi $t5, $t5, 1	        # i++
			j loop_externo_reordena		# Volta para loop_externo
				
		return_reordena:
			# Restaurar valores da pilha
			lw $t0, 0($sp)		# Restaura o valor de $t0
			lw $t1, 4($sp)		# Restaura o valor de $t1
			lw $t2, 8($sp)		# Restaura o valor de $t2
			lw $t3, 12($sp)		# Restaura o valor de $t3
			lw $t4, 16($sp)		# Restaura o valor de $t4
			lw $t5, 20($sp)		# Restaura o valor de $t5
			lw $t6, 24($sp)		# Restaura o valor de $t6
			lw $t7, 28($sp)		# Restaura o valor de $t7
			lw $t8, 32($sp)		# Restaura o valor de $t7
			addi $sp, $sp, 36	# Ajusta a pilha para excluir 8 itens
		
			jr $ra		# Retorno
