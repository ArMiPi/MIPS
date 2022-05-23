.data
    # Mensagens de entrada
    msg_entrada_n:              .asciiz "Entre com o valor de N: "              	# Mensagem para receber o valor de n
    msg_entrada_Vet:           .asciiz "\nEntre com os elementos de Vet:\n"     	# Mensagem para receber os elementos de VetC
    msg_inicio_elementoVetor: 	.asciiz "Vet["				        # Inicio da mensagem para receber o valor de vetor[i]
	msg_fim_elementoVetor:		.asciiz "]: "				        # Final da mensagem para receber o valor de vetor[i]

    # Mesagens de saida
    msg_saida_a: .asciiz "O numero de elementos menores que a soma dos N elementos lidos e = "
    msg_saida_b: .asciiz "O numero de elementos impares e = "
    msg_saida_c: .asciiz "O produto da posicao do menor elemento par do vetor com a posicao do maior elemento impar do vetor e = "
    msg_saida_d: .asciiz "O vetor ordenado de forma crescente = "

    # Outras mensagens
    msg_saida_sem_impares: .asciiz "Nao ha elementos impares no vetor!\n"
    msg_saida_sem_pares: .asciiz "Nao ha elementos pares no vetor!\n"
    new_line: .asciiz "\n"
    espaco: .asciiz " "

.text
    main:
        # Realizar leitura de n
	    li $v0, 4		        
	    la $a0, msg_entrada_n	
	    syscall			        
	    li $v0, 5		        
	    syscall			
	    move $s0, $v0   # $s0 = n
	
        # Variavel comum
	    move $a1, $s0	# $a1 = n
    
        # Alocar memoria para o Vet
	    jal aloca_vetor	
        move $s1, $v0   # $s1 = vetor  

        # Preencher Vet
        li $v0, 4		       
	    la $a0, msg_entrada_Vet    	
	    syscall			            
        move $a0, $s1               
        jal preenche_vetor 

        # Determinar o numero de elementos menores que a soma dos N elementos lidos
        move $a0, $s1
        move $a1, $s0
        jal proc_menor_soma

        move $t0, $v0   # $t0 = retorno de proc_menor_soma

        # Apresentrar resultado
        la $a0, msg_saida_a
        li $v0, 4
        syscall
        move $a0, $t0
        li $v0, 1
        syscall
        la $a0, new_line
        li $v0, 4
        syscall

        # Definir a quantidade de elementos impares no vetor
        move $a0, $s1
        move $a1, $s0
        jal proc_num_impar

        move $t0, $v0

        # Apresentar resultado
        la $a0, msg_saida_b
        li $v0, 4
        syscall
        beqz $t0, sem_impar_b
        move $a0, $t0
        li $v0, 1
        syscall
        j add_new_line_b
        sem_impar_b:
            la $a0, msg_saida_sem_impares
            li $v0, 4
            syscall
        add_new_line_b:
            la $a0, new_line
            li $v0, 4
            syscall
        
        # Produto da posicao do menor elemento par do vetor com a posicao do maior elemento impar do vetor
        move $a0, $s1
        move $a1, $s0
        jal proc_prod_pos

        move $t0, $v0
        li $t1, -1
        li $t2, -2

        # Apresentar resultado
        la $a0, msg_saida_c
        li $v0, 4
        syscall
        beq $t0, $t1, sem_par_c
        beq $t0, $t2, sem_impar_c
        move $a0, $t0
        li $v0, 1
        syscall
        j add_new_line_c
        sem_par_c:
            la $a0, msg_saida_sem_pares
            li $v0, 4
            syscall
            j add_new_line_c
        sem_impar_c:
            la $a0, msg_saida_sem_impares
            li $v0, 4
            syscall
        
        add_new_line_c:
            la $a0, new_line
            li $v0, 4
            syscall
        
        # Ordenar vetor
        move $a0, $s1
        move $a1, $s0
        jal ordena_vetor

        # Apresentar resultado
        la $a0, msg_saida_d
        li $v0, 4
        syscall
        move $a0, $s1
        move $a1, $s0
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

    soma_vetor:
        # Variaveis:
        #   $a0: vetor
        #   $a1: tamanho do vetor
        #   $v0: soma
        #   $t0: elemento lido

        # Ajustar pilha
        addi $sp, $sp, -12
        sw $a0, 0($sp)
        sw $a1, 4($sp)
        sw $t0, 8($sp)

        # Atribuicao de valores
        li $v0, 0   # soma = 0

        for_soma_vetor:
            beqz $a1, return_soma_vetor
            lw $t0, ($a0)
            add $v0, $v0, $t0

            # Proxima iteracao
            addi $a0, $a0, 4
            subi $a1, $a1, 1
            j for_soma_vetor
        
        return_soma_vetor:
            # Restaurar pilha
            lw $a0, 0($sp)
            lw $a1, 4($sp)
            lw $t0, 8($sp)
            addi $sp, $sp, 12

            jr $ra

    ######################################################################################################

    proc_menor_soma:
        # Variaveis:
        #   $a0: vetor
        #   $a1: tamanho do vetor
        #   $v0: elementos menores que soma
        #   $s0: soma dos elementos do vetor
        #   $t0: elemento lido

        # Ajustar pilha
        addi $sp, $sp, -12
        sw $s0, 0($sp)
        sw $t0, 4($sp)
        sw $ra, 8($sp)

        # Calcular soma dos elementos do vetor
        jal soma_vetor
        move $s0, $v0   # $s0 = soma elementos vetor
        li $v0, 0

        # Definir o numero de elementos menor que a soma
        for_proc_menor_soma:
            beqz, $a1, return_proc_menor_soma
            lw $t0, ($a0)
            bge $t0, $s0, next_for_proc_menor_soma # Ir para proxima iteracao se $t1 >= soma
            addi $v0, $v0, 1

            next_for_proc_menor_soma:
                addi $a0, $a0, 4
                subi $a1, $a1, 1
                j for_proc_menor_soma
        
        return_proc_menor_soma:
            # Restaurar pilha
            lw $s0, 0($sp)
            lw $t0, 4($sp)
            lw $ra, 8($sp)
            addi $sp, $sp, 12

            jr $ra
    
    ######################################################################################################

    impar:
        # Variaveis:
        #   $a0: numero
        
        # Ajustar pilha
        addi $sp, $sp, -4
        sw $t0, 0($sp)

        # Atribuicao de valores
        li $t0, 2

        div $a0, $t0
        mfhi $t0

        beqz $t0, return_par
        li $v0, 1
        j return_impar

        return_par:
            li $v0, 0
        
        return_impar:
            # Restaurar pilha
            lw $t0, 0($sp)
            addi $sp, $sp, 4

            jr $ra

    ######################################################################################################

    proc_num_impar:
        # Variaveis:
        #   $a0: vetor
        #   $a1: tamanho do vetor
        #   $t0: ponteiro vetor
        #   $t1: elemento lido
        #   $t2: elementos impares

        # Ajustar pilha
        addi $sp, $sp, -16
        sw $t0, 0($sp)
        sw $t1, 4($sp)
        sw $t2, 8($sp)
        sw $ra, 12($sp)

        # Atribuicao de valores
        move $t0, $a0
        li $t2, 0

        for_proc_num_impar:
            beqz $a1, return_proc_num_impar
            lw $t1, ($t0)
            move $a0, $t1
            jal impar
            beqz $v0, next_for_proc_num_impar
            addi $t2, $t2, 1

            next_for_proc_num_impar:
                addi $t0, $t0, 4
                subi $a1, $a1, 1
                j for_proc_num_impar
        
        return_proc_num_impar:
            move $v0, $t2
            # Restaurar pilha
            lw $t0, 0($sp)
            lw $t1, 4($sp)
            lw $t2, 8($sp)
            lw $ra, 12($sp)
            addi $sp, $sp, 16

            jr $ra

    ######################################################################################################

    proc_prod_pos:
        # Variaveis:
        #   $a0: vetor
        #   $a1: tamanho do vetor
        #   $t0: ponteiro vetor
        #   $t1: menor par
        #   $t2: posicao menor par
        #   $t3: menor impar
        #   $t4: posicao menor impar
        #   $t5: i

        # Ajustar pilha
        addi $sp, $sp, -28
        sw $t0, 0($sp)
        sw $t1, 4($sp)
        sw $t2, 8($sp)
        sw $t3, 12($sp)
        sw $t4, 16($sp)
        sw $t5, 20($sp)
        sw $ra, 24($sp)

        # Atribuicao de valores
        move $t0, $a0
        li $t1, 0
        li $t2, -1
        li $t3, 0
        li $t4, -1
        li $t5, 0

        for_proc_prod_pos:
            beq $t5, $a1, analisar_saida_proc_prod_pos
            lw $a0, ($t0)
            jal impar
            beqz $v0, analisar_par
            bltz $t4, atribuir_menor_impar
            bgt $a0, $t3, next_for_proc_prod_pos

            atribuir_menor_impar:
                move $t3, $a0
                move $t4, $t5
                j next_for_proc_prod_pos

            analisar_par:
                bltz $t2, atribuir_menor_par
                bgt $a0, $t1, next_for_proc_prod_pos

            atribuir_menor_par:
                move $t1, $a0
                move $t2, $t5
            
            next_for_proc_prod_pos:
                addi $t0, $t0, 4
                addi $t5, $t5, 1
                j for_proc_prod_pos

        analisar_saida_proc_prod_pos:
            bltz $t2, sem_elementos_pares
            bltz $t4, sem_elementos_impares
            mul $v0, $t2, $t4
            j return_proc_prod_pos

            sem_elementos_pares:
                li $v0, -1
                j return_proc_prod_pos
            
            sem_elementos_impares:
                li $v0, -2
                j return_proc_prod_pos
            
            return_proc_prod_pos:
                # Restaurar pilha
                lw $t0, 0($sp)
                lw $t1, 4($sp)
                lw $t2, 8($sp)
                lw $t3, 12($sp)
                lw $t4, 16($sp)
                lw $t5, 20($sp)
                lw $ra, 24($sp)
                addi $sp, $sp, 28

                jr $ra
    
    ######################################################################################################
    
    ordena_vetor:
		# Variaveis
        #   $a0: vetor
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
			addi $sp, $sp, 28	# Ajusta a pilha para excluir 8 itens
		
			jr $ra		# Retorno

    ######################################################################################################
	
	imprime_vetor:
		# Variaveis 
        #   $a0: vetor	
		#	$a1: tamanho do vetor
		#	$t0: temporario para vetor
		#	$t1: i
		#	$t2: elemento para ser imprimido
		
		# Ajustar pilha
		addi $sp, $sp, -12	# Ajusta a pilha para armazenar 3 itens
		sw $t0, 0($sp)		# Salva o valor armazenado em $t0
		sw $t1, 4($sp)		# Salva o valor armazenado em $t1
		sw $t2, 8($sp)		# Salva o valor armazenado em $t2
		
		# Atribuicao de valores
		move $t0, $a0			# $t0 recebe endereco de array
		li $t1, 0			# i = 0
		
		for_imprime_vetor:
			li $v0, 1		# Codigo syscall para imprimir inteiro
			lw $t2, ($t0)		# $t2 = array[i]
			add $a0, $t2, $zero	# $a0 = $t2
			syscall			# Imprime o array[i]
			li $v0, 4		# Codigo syscall para escrita de string
			la $a0, espaco		# Carrega em $a0 o endereco de espaco
			syscall			# Imprime espaco
			addi $t0, $t0, 4	# Proxima posicao do vetor
			addi $t1, $t1, 1	# i++
			blt $t1, $a1, for_imprime_vetor	# Volta para o comeco do loop se i < tamanho
		
		# Restaurar valores da pilha
		lw $t0, 0($sp)		# Restaura o valor de $t0
		lw $t1, 4($sp)		# Restaura o valor de $t1
		lw $t2, 8($sp)		# Restaura o valor de $t2
		addi $sp, $sp, 12 	# Ajusta a pilha para excluir 3 itens
		jr $ra			# Retorno
