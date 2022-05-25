#---------------------------------------------------------------------------------
# - Verificar se um inteiro n positivo e' perfeito
#---------------------------------------------------------------------------------
.data
    # Mensgem de entrada
    msg_entrada_n: .asciiz "Entre com um numero inteiro maior que 0: "

    # Mensagens de saida
    msg_saida_perfeito: .asciiz "O numero digitado e' perfeito\n"
    msg_saida_nao_perfeito: .asciiz "O numero digitado nao e' perfeito\n"

    # Mensagem de erro
    msg_erro_n: "\nERRO: n deve ser um inteiro maior que 0.\n\n"

.text
    main:
        # Leitura de n
        la $a0, msg_entrada_n
        li $v0, 4
        syscall
        li $v0, 5
        syscall
        blez $v0, erro_n
        move $a1, $v0   # $a1 = numero

        jal perfeito

        beqz $v0, nao_perfeito

        la $a0, msg_saida_perfeito
        li $v0, 4
        syscall
        j encerrar

        nao_perfeito:
            la $a0, msg_saida_nao_perfeito
            li $v0, 4
            syscall
        
        encerrar:
            li $v0, 10
            syscall

        erro_n:
            la $a0, msg_erro_n
            li $v0, 4
            syscall
            j main

    ##################### FUNCOES #####################

    perfeito:
		# Variaveis
		#	$a1: numero
		#	$t0: soma
		#	$t1: i
		#	$t2: numero/2
		#	$t3: auxiliar
		
		# Ajustar pilha
		addi $sp, $sp, -16	# Ajusta a pilha para armazenar 4 itens
		sw $t0, 0($sp)		# Armazena o valor de $t0
		sw $t1, 4($sp)		# Armazena o valor de $t1
		sw $t2, 8($sp)		# Armazena o valor de $t2
		sw $t3, 12($sp)		# Armazena o valor de $t3
		
		# Atribuicao de valores
		li $t0, 0		# soma = 0
		li $t1, 1		# i = 1
		li $t3, 2		# aux = 2
		div $t2, $a1, $t3	# $t2 = numero/2
		loop_perfeito:
			bgt $t1, $t2, return_perfeito	# Ir para return_perfeito se i > numero/2
			div $a1, $t1			# numero/i
			mfhi $t3			# aux = numero % i
			bnez $t3, next_loop_perfeito	# Ir para next_loop_perfeito se aux != 0
			add $t0, $t0, $t1		# soma += i
			
			next_loop_perfeito:
				addi $t1, $t1, 1	# i++
				j loop_perfeito		# Volta para loop_perfeito
		
		return_perfeito:
			bne $t0, $a1, return_perfeito_false	# Ir para return_false se soma != numero
			li $t3, 1				# aux = 1
			j return_answer_perfeito		# Ir para return_answer_perfeito
		
		return_perfeito_false:
			li $t3, 0				# aux = 0
			
		return_answer_perfeito:
			add $v0, $t3, $zero	# $v0 = aux
			# Restaurar valores da pilha
			lw $t0, 0($sp)		# Restaura o valor de $t0
			lw $t1, 4($sp)		# Restaura o valor de $t1
			lw $t2, 8($sp)		# Restaura o valor de $t2
			lw $t3, 12($sp)		# Restaura o valor de $t3
			addi $sp, $sp, 16	# Ajusta a pilha para excluir 4 itens
			jr $ra			# Retorno