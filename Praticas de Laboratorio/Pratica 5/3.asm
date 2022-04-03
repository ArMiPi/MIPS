#----------------------------------------------------------------------------------------
# - Realizar a leitura de uma matriz de inteiro de ordem N (N <= 8)
# - Apresentar como saida a diferenca entre a soma dos valores acima da diagonal
#   principal e da soma dos valores abaixo da diagonal principal
# - Apresentar o maior elemento acima da diagonal principal
# - Apresentar o menor elemento abaixo da diagonal principal
# - Apresentar a matriz ordenada em ordem crescente
#----------------------------------------------------------------------------------------
.data
    # Mensagens de entrada
    msg_entrada_dimensao: .asciiz "Entre com a dimensao da matriz (MAX: 8): "
    msg_entrada_elemento_matriz_inicio: .asciiz "M["
    msg_entrada_elemento_matriz_meio:   .asciiz "]["
    msg_entrada_elemento_matriz_fim:    .asciiz "]: "

    # Mensagens de saida
    msg_saida_matriz_A:             .asciiz "\nA: \n"
    msg_saida_maior_acima:          .asciiz "\nMaior elemento acima da diagonal principal: "
    msg_saida_menor_abaixo:         .asciiz "\nMenor elemento abaixo da diagonal principal: "
    msg_saida_diferenca:            .asciiz "\nDiferenca entre a soma dos valores acima da diagonal principal e a soma dos valores abaixo da diagonal principal: "
    msg_saida_matriz_ordenada:      .asciiz "\nMatriz ordenada: \n"

    # Mensagem de erro
    msg_erro_dimensao: .asciiz "Erro: 0 < dimensao <= 8\n\n"

    # Outras strings
    espaco:     .asciiz " "
    new_line:   .asciiz "\n"

.text
    main:
        # Ler tamanho da matriz
        la $a0, msg_entrada_dimensao
        li $v0, 4
        syscall
        li $v0, 5
        syscall
        blez $v0, erro_dimensao
        li $t0, 8
        bgt $v0, $t0, erro_dimensao
        move $s0, $v0   # $s0 = dim

        # Alocar matriz A
        move $a0, $s0
        move $a1, $s0
        jal aloca_matriz
        move $s1, $v0   # $s1 recebe o endereco de A

        # Ler elementos de A
        la $a0, msg_saida_matriz_A
        li $v0, 4
        syscall
        move $a0, $s1
        move $a1, $s0
        move $a2, $s0
        jal ler_matriz

        # Imprimir matriz A
        la $a0, msg_saida_matriz_A
        li $v0, 4
        syscall
        move $a0, $s1
        jal imprime_matriz

        # Executar acima_diagonal_principal
        move $a0, $s1
        move $a1, $s0
        move $a2, $s0
        jal acima_diagonal_principal

        move $s2, $v0   # $s2 = maior_acima_diagonal_principal
        move $s3, $v1   # $s3 = soma_acima_diagonal_principal
        # Imrpimir resultados
        la $a0, msg_saida_maior_acima
        li $v0, 4
        syscall
        move $a0, $s2
        li $v0, 1
        syscall
        la $a0, new_line
        li $v0, 4
        syscall

        # Executar abaixo_diagonal_principal
        move $a0, $s1
        move $a1, $s0
        move $a2, $s0
        jal abaixo_diagonal_principal

        move $s4, $v0   # $s4 = menor_abaixo_diagonal_principal
        move $s5, $v1   # $s5 = soma_abaixo_diagonal_principal
        # Imrpimir resultados
        la $a0, msg_saida_menor_abaixo
        li $v0, 4
        syscall
        move $a0, $s4
        li $v0, 1
        syscall
        la $a0, new_line
        li $v0, 4
        syscall

        # Diferenca
        la $a0, msg_saida_diferenca
        li $v0, 4
        syscall
        sub $a0, $s3, $s5
        li $v0, 1
        syscall
        la $a0, new_line
        li $v0, 4
        syscall

        # Ordenar matriz
        move $a0, $s1
        mul $a1, $s0, $s0
        jal ordena_matriz

        # Imprimir matriz ordenada
        la $a0, msg_saida_matriz_ordenada
        li $v0, 4
        syscall
        move $a0, $s1
        move $a1, $s0
        move $a2, $s0
        jal imprime_matriz

        # Encerrar programa
        li $v0, 10
        syscall

        erro_dimensao:
            la $a0, msg_erro_dimensao
            li $v0, 4
            syscall
            j main

    ##################### FUNCOES #####################

    indice:
        # Variaveis
        #  $a0: totalColunas
        #  $a1: linha
        #  $a2: coluna
        #  $t0: resultado

        # Ajustar pilha
        addi $sp, $sp, -4
        sw $t0, 0($sp)

        mul $t0, $a0, $a1
        add $t0, $t0, $a2
        move $v0, $t0

        # Restaurar pilha
        lw $t0, 0($sp)
        addi $sp, $sp, 4
        jr $ra

    ######################################################################################################

    aloca_matriz:
        # Variaveis;
        #   $a0: linhas
        #   $a1: colunas
        #   $t0: tamanho da memoria a ser alocada

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

    ler_matriz:
        # Variaveis
        #  $a0: Matriz a ser lida
        #  $a1: Linhas
        #  $a2: Colunas
        #  $t0: i
        #  $t1: j
        #  $t2: position
        #  $t3: auxiliar matriz
        #  $t4: auxiliar linha
        #  $t5: auxiliar coluna
        #  $t6: auxiliar

        # Ajustar pilha
        add $sp, $sp, -44
        sw $a0, 0($sp)
        sw $a1, 4($sp)
        sw $a2, 8($sp)
        sw $t0, 12($sp)
        sw $t1, 16($sp)
        sw $t2, 20($sp)
        sw $t3, 24($sp)
        sw $t4, 28($sp)
        sw $t5, 32($sp)
        sw $t6, 36($sp)
        sw $ra, 40($sp)

        # Atribuicao de valores
        li $t0, 0
        li $t1, 0
        move $t3, $a0     # Auxiliar recebe endereco da matriz a ser lida
        move $t4, $a1     # $t4 = Linhas
        move $t5, $a2     # $t5 = Colunas

        # Loop para leitura da matriz
        for_ler_matriz:
            bge $t0, $t4, return_ler_matriz
            for_interno_ler_matriz:
                bge $t1, $t5, next_for_ler_matriz
                # Mensagem para leitura do elemento da matriz
                la $a0, msg_entrada_elemento_matriz_inicio
                li $v0, 4
                syscall
                move $a0, $t0
                li $v0, 1
                syscall
                la $a0, msg_entrada_elemento_matriz_meio
                li $v0, 4
                syscall
                move $a0, $t1
                li $v0, 1
                syscall
                la $a0, msg_entrada_elemento_matriz_fim
                li $v0, 4
                syscall
                # Calcular indice da matriz onde o valor lido sera armazenado
                move $a0, $t5        # $a0 = totalColunas
                move $a1, $t0        # $a1 = i
                move $a2, $t1        # $a2 = j
                jal indice
                move $t6, $v0        # $t6 = indice
                mul $t6, $t6, 4
                add $t6, $t6, $t3    # $t6 recebe o endereco de M[indice]
                # Ler e armazenar o elemento a ser inserido
                li $v0, 5
                syscall
                sw $v0, ($t6)
                addi $t1, $t1, 1
                j for_interno_ler_matriz
            next_for_ler_matriz:
                li $t1, 0
                addi $t0, $t0, 1
                j for_ler_matriz
      
        return_ler_matriz:
            # Restaurar pilha
            lw $a0, 0($sp)
            lw $a1, 4($sp)
            lw $a2, 8($sp)
            lw $t0, 12($sp)
            lw $t1, 16($sp)
            lw $t2, 20($sp)
            lw $t3, 24($sp)
            lw $t4, 28($sp)
            lw $t5, 32($sp)
            lw $t6, 36($sp)
            lw $ra, 40($sp)
            addi $sp, $sp, 44
            jr $ra

    ######################################################################################################

    imprime_matriz:
        # Variaveis:
        #  $a0: matriz
        #  $a1: linhas
        #  $a2: colunas
        #  $t0: endereco da matriz
        #  $t1: total de linhas
        #  $t2: total de colunas
        #  $t3: i
        #  $t4: j
        #  $t5: indice
        #  $t6: auxiliar

        # Ajustar pilha
        addi $sp, $sp, -44
        sw $a0, 0($sp)
        sw $a1, 4($sp)
        sw $a2, 8($sp)
        sw $t0, 12($sp)
        sw $t1, 16($sp)
        sw $t2, 20($sp)
        sw $t3, 24($sp)
        sw $t4, 28($sp)
        sw $t5, 32($sp)
        sw $t6, 36($sp)
        sw $ra, 40($sp)

        # Atribuicao de valores
        move $t0, $a0     # $t0 recebe endereco de M
        move $t1, $a1     # $t1 = linhas
        move $t2, $a2     # $t2 = colunas
        li $t3, 0         # i = 0
        li $t4, 0         # j = 0

        for_imprime_matriz:
            bge $t3, $t1, return_imprime_matriz
            for_interno_imprime_matriz:
                bge $t4, $t2, next_for_imprime_matriz
                # Calcular indice
                move $a0, $t2
                move $a1, $t3
                move $a2, $t4
                jal indice
                move $t6, $v0
                mul $t6, $t6, 4
                add $t6, $t6, $t0
                lw $a0, ($t6)
                li $v0, 1
                syscall
                la $a0, espaco
                li $v0, 4
                syscall
                addi $t4, $t4, 1
                j for_interno_imprime_matriz
            next_for_imprime_matriz:
                la $a0, new_line
                li $v0, 4
                syscall
                li $t4, 0
                addi $t3, $t3, 1
                j for_imprime_matriz
         
        return_imprime_matriz:
            # Ajustar pilha
            lw $a0, 0($sp)
            lw $a1, 4($sp)
            lw $a2, 8($sp)
            lw $t0, 12($sp)
            lw $t1, 16($sp)
            lw $t2, 20($sp)
            lw $t3, 24($sp)
            lw $t4, 28($sp)
            lw $t5, 32($sp)
            lw $t6, 36($sp)
            lw $ra, 40($sp)
            addi $sp, $sp, 44
            jr $ra

    ######################################################################################################

    acima_diagonal_principal:
        # Variaveis:
        #   $a0: Matriz
        #   $a1: linhas
        #   $a2: colunas
        #   $t0: auxiliar matriz
        #   $t1: i
        #   $t2: j
        #   $t3: elemento matriz
        #   $t4: maior
        #   $t5: soma
        #   $t6: auxiliar linhas
        #   $t7: auxiliar colunas
        #   $t8: auxiliar

        # Ajustar pilha
        addi $sp, $sp, -52
        sw $a0, 0($sp)
        sw $a1, 4($sp)
        sw $a2, 8($sp)
        sw $t0, 12($sp)
        sw $t1, 16($sp)
        sw $t2, 20($sp)
        sw $t3, 24($sp)
        sw $t4, 28($sp)
        sw $t5, 32($sp)
        sw $t6, 36($sp)
        sw $t7, 40($sp)
        sw $t7, 44($sp)
        sw $ra, 48($sp)

        # Atribuicao de valores
        move $t0, $a0   # $t0 recebe endereco de Matriz
        li $t1, 0       # i = 0
        li $t5, 0       # soma = 0
        move $t6, $a1   # $t6 = linhas
        move $t7, $a2   # $t7 = colunas

        move $a0, $a2
        li $a1, 0
        li $a2, 1
        jal indice
        mul $t8, $v0, 4
        add $t8, $t8, $t0   # aux recebe endereco do elemento A[0][1]
        lw $t4, ($t8)       # maior = A[0][1]

        for_externo_acima_diagonal_principal:
            bge $t1, $t6, return_acima_diagonal_principal
            addi $t2, $t1, 1    # j = i + 1

            for_interno_acima_diagonal_principal:
                bge $t2, $t7, next_for_externo_acima_diagonal_principal
                move $a1, $t1
                move $a2, $t2
                jal indice
                mul $t8, $v0, 4
                add $t8, $t8, $t0
                lw $t3, ($t8)
                add $t5, $t5, $t3   # soma += A[i][j]
                ble $t3, $t4, next_for_interno_acima_diagonal_principal
                move $t4, $t3

                next_for_interno_acima_diagonal_principal:
                    addi $t2, $t2, 1
                    j for_interno_acima_diagonal_principal
            next_for_externo_acima_diagonal_principal:
                addi $t1, $t1, 1
                j for_externo_acima_diagonal_principal
        
        return_acima_diagonal_principal:
            move $v0, $t4   # $v0 = maior
            move $v1, $t5   # $v1 = soma

            # Restaurar pilha
            lw $a0, 0($sp)
            lw $a1, 4($sp)
            lw $a2, 8($sp)
            lw $t0, 12($sp)
            lw $t1, 16($sp)
            lw $t2, 20($sp)
            lw $t3, 24($sp)
            lw $t4, 28($sp)
            lw $t5, 32($sp)
            lw $t6, 36($sp)
            lw $t7, 40($sp)
            lw $t8, 44($sp)
            lw $ra, 48($sp)
            addi $sp, $sp, 52
            jr $ra

    ######################################################################################################        

    abaixo_diagonal_principal:
        # Variaveis:
        #   $a0: Matriz
        #   $a1: linhas
        #   $a2: colunas
        #   $t0: auxiliar matriz
        #   $t1: i
        #   $t2: j
        #   $t3: elemento matriz
        #   $t4: menor
        #   $t5: soma
        #   $t6: auxiliar linhas
        #   $t7: auxiliar colunas
        #   $t8: auxiliar

        # Ajustar pilha
        addi $sp, $sp, -52
        sw $a0, 0($sp)
        sw $a1, 4($sp)
        sw $a2, 8($sp)
        sw $t0, 12($sp)
        sw $t1, 16($sp)
        sw $t2, 20($sp)
        sw $t3, 24($sp)
        sw $t4, 28($sp)
        sw $t5, 32($sp)
        sw $t6, 36($sp)
        sw $t7, 40($sp)
        sw $t7, 44($sp)
        sw $ra, 48($sp)

        # Atribuicao de valores
        move $t0, $a0   # $t0 recebe endereco de Matriz
        li $t1, 0       # i = 0
        li $t5, 0       # soma = 0
        move $t6, $a1   # $t6 = linhas
        move $t7, $a2   # $t7 = colunas

        move $a0, $a2
        li $a1, 1
        li $a2, 0
        jal indice
        mul $t8, $v0, 4
        add $t8, $t8, $t0   # aux recebe endereco do elemento A[1][0]
        lw $t4, ($t8)       # menor = A[1][0]

        for_externo_abaixo_diagonal_principal:
            bge $t1, $t6, return_abaixo_diagonal_principal
            li $t2, 0   # j = 0

            for_interno_abaixo_diagonal_principal:
                bge $t2, $t1, next_for_externo_abaixo_diagonal_principal
                move $a1, $t1
                move $a2, $t2
                jal indice
                mul $t8, $v0, 4
                add $t8, $t8, $t0
                lw $t3, ($t8)
                add $t5, $t5, $t3   # soma += A[i][j]
                bge $t3, $t4, next_for_interno_abaixo_diagonal_principal
                move $t4, $t3

                next_for_interno_abaixo_diagonal_principal:
                    addi $t2, $t2, 1
                    j for_interno_abaixo_diagonal_principal
            next_for_externo_abaixo_diagonal_principal:
                addi $t1, $t1, 1
                j for_externo_abaixo_diagonal_principal
        
        return_abaixo_diagonal_principal:
            move $v0, $t4   # $v0 = menor
            move $v1, $t5   # $v1 = soma

            # Restaurar pilha
            lw $a0, 0($sp)
            lw $a1, 4($sp)
            lw $a2, 8($sp)
            lw $t0, 12($sp)
            lw $t1, 16($sp)
            lw $t2, 20($sp)
            lw $t3, 24($sp)
            lw $t4, 28($sp)
            lw $t5, 32($sp)
            lw $t6, 36($sp)
            lw $t7, 40($sp)
            lw $t8, 44($sp)
            lw $ra, 48($sp)
            addi $sp, $sp, 52
            jr $ra
    ######################################################################################################

    ordena_matriz:
		# Variaveis
        #   $a0: endereco da matriz
		#	$a1: tamanho da matriz
		#	$t0: matriz
		#	$t1: posicao da matriz loop externo
		#	$t2: elemento da matriz loop externo
		#	$t3: posicao da matriz loop interno
		#	$t4; elemento da matriz loop interno
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
			add $t1, $t0, $t7		# $t1 = endereco inicial do matriz + aux
			lw $t2, ($t1)			# $t2 = array[i]
			
			addi $t6, $t5, 1		# j = i + 1
			loop_interno:
				bge $t6, $a1, next_externo	# Ir para next_interno se j >= tamanho
				mul $t7, $t6, 4			# aux = j * 4
				add $t3, $t0, $t7		# $t3 = endereco inicial do matriz + aux
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
