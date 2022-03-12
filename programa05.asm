#---------------------------------------------------------------------------------
# Elaborar um programa, em c�digo MIPS, que dado um inteiro positivo n, verificar
# se n � um inteiro perfeito.
#---------------------------------------------------------------------------------

.data
	msg_entrada: 		.asciiz "Digite um inteiro n > 0: "	# Mensagem de entrada
	msg_erro_entrada: 	.asciiz "\nERRO: n deve ser > 0\n\n"	# Mensagem informando erro na entrada
	msg_saida_inicio:	.asciiz "\nO n�mero "			# In�cio da mensagem de sa�da
	msg_perfeito:		.asciiz " � perfeito\n"			# Mensagem indicando que um n�mero � perfeito
	msg_nao_perfeito:	.asciiz " n�o � perfeito\n"		# Mensagem indicando que um n�mero n�o � perfeito

.text
	main:
		# Mostrar mensagem de entrada
		li $v0, 4			# C�digo syscall para escrever string
		la $a0, msg_entrada		# Carrega em $a0 o endere�o de msg_entrada
		syscall				# Imprime msg_entrada
		
		# Leitura do inteiro n
		li $v0, 5			# C�digo syscall para leitura de inteiro
		syscall				# Leitura do inteiro n
		add $s0, $v0, $zero		# $s0 = n
		blez $s0, erro_entrada		# Se $s0 < 0 mostrar erro
		
		# Verificar se n � perfeito
		add $a0, $zero, $s0		# $a0 = $s0
		jal is_perfect			# Chama a fun��o is_perfect
		add $s1, $zero, $v0		# $a1 = $v0
		
		li $v0, 4			# C�digo syscall para escrever string
		la $a0, msg_saida_inicio	# Carrega em $a0 o endere�o de msg_saida_inicio
		syscall				# Imprime msg_saida_inicio
		li $v0, 1			# C�digo syscall para escrever inteiro
		add $a0, $s0, $zero		# $a0 = $s0
		syscall				# Imprime o valor de $s0
		
		beq $s1, 1, true		# Caso o n�mero seja perfeito
		beqz $s1, false			# Caso contr�rio
		
		true:
			li $v0, 4			# C�digo syscall para escrever string
			la $a0, msg_perfeito		# Carrega em $a0 o endere�o de msg_perfeito
			syscall				# Imprime msg_perfeito
			j fin				# Pula para o final do programa
		false:
			li $v0, 4			# C�digo syscall para escrever string
			la $a0, msg_nao_perfeito	# Carrega em $a0 o endere�o de msg_nao_perfeito
			syscall				# Imprime msg_nao_perfeito
			j fin				# Pula para o final do programa
		fin:
			li $v0, 10			# C�digo syscall para finalizar o programa
			syscall				# Finaliza o programa
		
	
	is_perfect:
		# Ajuste na pilha
		addi $sp, $sp, -16		# Ajusta a pilha para armazenar quatro valores
		sw $s0, 12($sp)			# Salva o valor armazenado em $s0
		sw $t0, 8($sp)			# Salva o valor armazenado em $t0
		sw $t1, 4($sp)			# Salva o valor armazenado em $t1
		sw $t2, 0($sp)			# Salva o valor armazenado em $t2
		
		# Atribui��o de valores
		add $s0, $zero, $zero		# $s0 = 0
		addi $t0, $zero, 1		# $t0 = 1
		addi $t1, $zero, 2		# $t1 = 2
		div $a0, $t1			# $a0 / 2
		mflo $t2			# $t2 = $a0 / 2
		
		# Verificar se o n�mero � perfeito
		Loop:
			bgt $t0, $t2, return	# Se $t0 > $t2 ir para return
			div $a0, $t0		# $a0 / $t0
			mfhi $t1		# $t1 = $a0 % $t0
			bne $t1, $zero, next	# Se $t1 != 0 ir para next
			add $s0, $s0, $t0	# $s0 += $t0
			next:
				addi $t0, $t0, 1	# $t0 += 1
				j Loop			# Retorna para o in�cio do Loop
		return:
			beq $a0, $s0, equal	# Se $ao == $s0
			bne $a0, $s0, nequal	# Se $a0 != $s0
		equal:
			addi $v0, $zero, 1	# $v0 = 1
			j end
		nequal:
			add $v0, $zero, $zero	# $v0 = 0
			j end
		end:
			lw $t2, 0($sp)		# Restaura o valor de $t2
			lw $t1, 4($sp)		# Restaura o valor de $t1
			lw $t0, 8($sp)		# Restaura o valor de $t0
			lw $s0, 12($sp)		# Restaura o valor de $s0
			jr $ra			# Retorna pra main
		
				
	erro_entrada:
		# Mostrar mensagem de erro
		li $v0, 4			# C�digo syscall para escrever string
		la $a0, msg_erro_entrada	# Carrega em $a0 o endere�o de msg_erro_entrada
		syscall				# Imprime msg_erro_entrada
		j main				# Retorna para o in�cio do programa
