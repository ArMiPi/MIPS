#---------------------------------------------------------------------------------
# Elaborar um programa, em c�digo MIPS, que fa�a a leitura de dois n�meros
# inteiros (A e B) fornecidos pelo usu�rio pelo teclado e que forne�a como sa�da
# todos os m�ltiplos de A no intervalo de A at� AxB.
#---------------------------------------------------------------------------------

.data
	msg_entrada1: .asciiz "Digite um inteiro: "		# Mensagem para primeira entrada
	msg_entrada2: .asciiz "\nDigite outro inteiro: "	# Mensagem para segunda entrada
	msg_saida_i:  .asciiz "\nM�ltiplos de "			# Come�o da mensagem de sa�da
	msg_saida_m:  .asciiz " ate "				# Meioda mensagem de sa�da
	msg_saida_f:  .asciiz ":\n"				# Final da mensagem de sa�da
	space:        .asciiz " "				# Comando new line


.text
	main:
		# Leitura dos valores de A e B
		li $v0, 4 		# C�digo SysCall para escrever strings
		la $a0, msg_entrada1	# Par�metro(mensagem de entrada 1)
		syscall			# Escrever msg_entrada1
		
		li $v0, 5		# C�digo SysCall para ler inteiros
		syscall			# Leitura do valor de A
		add $s0, $v0, $zero	# Armazena em $s0 o valor de A
		
		li $v0, 4		# C�digo SysCall para escrever strings
		la $a0, msg_entrada2	# Par�metro(mensagem de entrada 2)
		syscall			# Escrever msg_entrada2
		
		li $v0, 5		# C�digo SysCall para ler inteiros
		syscall			# Leitura do valor de B
		add $s1, $v0, $zero	# Armazena em $s1 o valor de B
		
		# Defini��o do valor de A * B
		mul $t1, $s0, $s1	# $t1 = A * B
		
		# Mensagem de sa�da
		li $v0, 4		# C�digo SysCall para escrever strings
		la $a0, msg_saida_i	# Par�metro(mensagem de sa�da i)
		syscall			# Escrever msg_saida_i
		
		li $v0, 1		# C�digo SysCall para escrever inteiros
		add $a0, $s0, $zero	# Par�metro(valor de A)
		syscall			# Escrever o valor de A
		
		li $v0, 4		# C�digo SysCall para escrever strings
		la $a0, msg_saida_m	# Par�metro(mensagem de sa�da m)
		syscall			# Escrever mens_saida_m
		
		li $v0, 1		# C�digo SysCall para escrever inteiros
		add $a0, $t1, $zero	# Par�metro(valor de A * B)
		syscall			# Escrever o valor de A * B
		
		li $v0, 4		# C�digo SysCall para escrever strings
		la $a0, msg_saida_f	# Par�metro(mensagem de sa�da f)
		syscall			# Escrever msg_saida_f
		
		# Encontrar e escrever os valores de sa�da
		add $t2, $s0, $zero				# $t2 = A
		loop:						# In�cio do loop para obten��o dos m�ltiplos
			div $t2, $s0 				# Divis�o de $t2 por A
			mfhi $t3				# $t3 = $t2 % A
			bnez $t3, next				# Se $t3 != 0, iniciar procedimento para atualizar t2
			
			li $v0, 1				# C�digo SysCall para escrever inteiros
			add $a0, $t2, $zero			# Par�metro(valor de $t2)
			syscall					# Escreve o valor de $t2
			
			li $v0, 4				# C�digo SysCall para escrever strings
			la $a0, space				# Par�metro(espa�o em branco)
			syscall					# Escrever space
			
			next:					# Atualizar valor de $t2 para pr�xima itera��o do loop
				beq $t2, $t1, fim		# Condi��o de parada do loop $t2 == A * B
				blt $s0, $t1, plus1		# Se A < A * B
				bgt $s0, $t1, minus1		# Se A > A * B
				
				plus1:
					addi $t2, $t2, 1	# $t2 += 1
					j loop			# Retorna para o come�o do loop
				minus1:
					addi $t2, $t2, -1	# $t2 -= 1
					j loop			# Retorna para o come�o do loop
	
		fim:
			li $v0, 10				# C�digo Syscall para finalizar o programa
			syscall					# Finaliza o programa
