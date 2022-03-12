#------------------------------------------
# Programa que realiza a soma dos valores
# positivos e a soma dos valores negativos
# contidos em um vetor
#------------------------------------------

.data
	vetor: .word -2, 4, 7, -3, 0, -3, 5, 6
	resultado_positivo: .asciiz"A soma dos valores positivos = "	# Mensagem informando o resultado da soma dos n�meros positivos
	resultado_negativo: .asciiz"\nA soma dos valores negativos = "  # Mensagem informando o resultado da soma dos n�meros negativos
	
.text
	main:
		li $t0, 8	# $t0 recebe o n�mero de elementos do vetor
		la $t1, vetor	# $t1 recebe o endere�o de vetor
		li $t2, 0	# $t2 ser� usado para armazenar a soma dos n�meros positivos
		li $t3, 0	# $t3 ser� usado para armazenar a soma dos n�meros negativos
		
		loop:
			beq  $t0, $zero, exit		# Condi��o de parada do loop
			lw   $t4, 0($t1)		# $t4 recebe o elemento armazenado no endere�o armazenado em $t1
			blt  $t4, 0, soma_negativo	# Se $t4 < 0 ir para soma_negativo
			bgez $t4, soma_positivo		# Se $t4 >= 0 ir para soma_positivo
		exit:
			li $v0, 4			# C�digo SysCall para escrever strings
			la $a0, resultado_positivo	# Par�metro(mensagem da soma dos valores positivos)
			syscall				# Escreve a mensagem de resultado positivo
			li $v0, 1			# C�digo SysCall para escrever inteiro
			add $a0, $t2, $zero		# Par�metro(soma dos valores positivos)
			syscall				# Escreve a soma dos valores positivos
			li $v0, 4			# C�digo SysCall para escrever strings
			la $a0, resultado_negativo	# Par�metro(mensagem da soma dos valores negativos)
			syscall				# Escreve a mensagem de resultado negativo
			li $v0, 1			# C�digo SysCall para escrever inteiro
			add $a0, $t3, $zero		# Par�metro(soma dos valores negativos)
			syscall				# Escreve a soma dos valores negativos
			li  $v0, 10			# C�digo SysCall para finalizar o programa
			syscall				# Finaliza o programa
		soma_negativo:
			add  $t3, $t3, $t4		# $t3 += $t4
			addi $t1, $t1, 4		# $t1 recebe o endere�o do pr�ximo elemento do vetor
			addi $t0, $t0, -1		# Atualiza��o do controlador do loop
			j loop				# Retorna para o come�o do loop
		soma_positivo:
			add $t2, $t2, $t4		# $t2 += $t4
			addi $t1, $t1, 4		# $t1 recebe o endere�o do pr�ximo elemento do vetor
			addi $t0, $t0, -1		# Atualiza��o do controlador do loop
			j loop				# Retorna para o come�o do loop
