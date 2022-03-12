#---------------------------------------------------------------------------------
# Elaborar um programa, em código MIPS, que dado um inteiro positivo n, verificar
# se n é um inteiro perfeito.
#---------------------------------------------------------------------------------

.data
	msg_entrada: 		.asciiz "Digite um inteiro n > 0: "	# Mensagem de entrada
	msg_erro_entrada: 	.asciiz "\nERRO: n deve ser > 0\n\n"	# Mensagem informando erro na entrada
	msg_saida_inicio:	.asciiz "\nO número "			# Início da mensagem de saída
	msg_perfeito:		.asciiz " é perfeito\n"			# Mensagem indicando que um número é perfeito
	msg_nao_perfeito:	.asciiz " não é perfeito\n"		# Mensagem indicando que um número não é perfeito

.text
	main:
		# Mostrar mensagem de entrada
		li $v0, 4			# Código syscall para escrever string
		la $a0, msg_entrada		# Carrega em $a0 o endereço de msg_entrada
		syscall				# Imprime msg_entrada
		
		# Leitura do inteiro n
		li $v0, 5			# Código syscall para leitura de inteiro
		syscall				# Leitura do inteiro n
		add $s0, $v0, $zero		# $s0 = n
		blez $s0, erro_entrada		# Se $s0 < 0 mostrar erro
		
		# Verificar se n é perfeito
		add $a0, $zero, $s0		# $a0 = $s0
		jal is_perfect			# Chama a função is_perfect
		add $s1, $zero, $v0		# $a1 = $v0
		
		li $v0, 4			# Código syscall para escrever string
		la $a0, msg_saida_inicio	# Carrega em $a0 o endereço de msg_saida_inicio
		syscall				# Imprime msg_saida_inicio
		li $v0, 1			# Código syscall para escrever inteiro
		add $a0, $s0, $zero		# $a0 = $s0
		syscall				# Imprime o valor de $s0
		
		beq $s1, 1, true		# Caso o número seja perfeito
		beqz $s1, false			# Caso contrário
		
		true:
			li $v0, 4			# Código syscall para escrever string
			la $a0, msg_perfeito		# Carrega em $a0 o endereço de msg_perfeito
			syscall				# Imprime msg_perfeito
			j fin				# Pula para o final do programa
		false:
			li $v0, 4			# Código syscall para escrever string
			la $a0, msg_nao_perfeito	# Carrega em $a0 o endereço de msg_nao_perfeito
			syscall				# Imprime msg_nao_perfeito
			j fin				# Pula para o final do programa
		fin:
			li $v0, 10			# Código syscall para finalizar o programa
			syscall				# Finaliza o programa
		
	
	is_perfect:
		# Ajuste na pilha
		addi $sp, $sp, -16		# Ajusta a pilha para armazenar quatro valores
		sw $s0, 12($sp)			# Salva o valor armazenado em $s0
		sw $t0, 8($sp)			# Salva o valor armazenado em $t0
		sw $t1, 4($sp)			# Salva o valor armazenado em $t1
		sw $t2, 0($sp)			# Salva o valor armazenado em $t2
		
		# Atribuição de valores
		add $s0, $zero, $zero		# $s0 = 0
		addi $t0, $zero, 1		# $t0 = 1
		addi $t1, $zero, 2		# $t1 = 2
		div $a0, $t1			# $a0 / 2
		mflo $t2			# $t2 = $a0 / 2
		
		# Verificar se o número é perfeito
		Loop:
			bgt $t0, $t2, return	# Se $t0 > $t2 ir para return
			div $a0, $t0		# $a0 / $t0
			mfhi $t1		# $t1 = $a0 % $t0
			bne $t1, $zero, next	# Se $t1 != 0 ir para next
			add $s0, $s0, $t0	# $s0 += $t0
			next:
				addi $t0, $t0, 1	# $t0 += 1
				j Loop			# Retorna para o início do Loop
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
		li $v0, 4			# Código syscall para escrever string
		la $a0, msg_erro_entrada	# Carrega em $a0 o endereço de msg_erro_entrada
		syscall				# Imprime msg_erro_entrada
		j main				# Retorna para o início do programa
