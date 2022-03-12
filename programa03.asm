#---------------------------------------------------------------------------------
# Elaborar um programa, em código MIPS, que faça a leitura de dois números
# inteiros (A e B) fornecidos pelo usuário pelo teclado e que forneça como saída
# todos os múltiplos de A no intervalo de A até AxB.
#---------------------------------------------------------------------------------

.data
	msg_entrada1: .asciiz "Digite um inteiro: "		# Mensagem para primeira entrada
	msg_entrada2: .asciiz "\nDigite outro inteiro: "	# Mensagem para segunda entrada
	msg_saida_i:  .asciiz "\nMúltiplos de "			# Começo da mensagem de saída
	msg_saida_m:  .asciiz " ate "				# Meioda mensagem de saída
	msg_saida_f:  .asciiz ":\n"				# Final da mensagem de saída
	space:        .asciiz " "				# Comando new line


.text
	main:
		# Leitura dos valores de A e B
		li $v0, 4 		# Código SysCall para escrever strings
		la $a0, msg_entrada1	# Parâmetro(mensagem de entrada 1)
		syscall			# Escrever msg_entrada1
		
		li $v0, 5		# Código SysCall para ler inteiros
		syscall			# Leitura do valor de A
		add $s0, $v0, $zero	# Armazena em $s0 o valor de A
		
		li $v0, 4		# Código SysCall para escrever strings
		la $a0, msg_entrada2	# Parâmetro(mensagem de entrada 2)
		syscall			# Escrever msg_entrada2
		
		li $v0, 5		# Código SysCall para ler inteiros
		syscall			# Leitura do valor de B
		add $s1, $v0, $zero	# Armazena em $s1 o valor de B
		
		# Definição do valor de A * B
		mul $t1, $s0, $s1	# $t1 = A * B
		
		# Mensagem de saída
		li $v0, 4		# Código SysCall para escrever strings
		la $a0, msg_saida_i	# Parâmetro(mensagem de saída i)
		syscall			# Escrever msg_saida_i
		
		li $v0, 1		# Código SysCall para escrever inteiros
		add $a0, $s0, $zero	# Parâmetro(valor de A)
		syscall			# Escrever o valor de A
		
		li $v0, 4		# Código SysCall para escrever strings
		la $a0, msg_saida_m	# Parâmetro(mensagem de saída m)
		syscall			# Escrever mens_saida_m
		
		li $v0, 1		# Código SysCall para escrever inteiros
		add $a0, $t1, $zero	# Parâmetro(valor de A * B)
		syscall			# Escrever o valor de A * B
		
		li $v0, 4		# Código SysCall para escrever strings
		la $a0, msg_saida_f	# Parâmetro(mensagem de saída f)
		syscall			# Escrever msg_saida_f
		
		# Encontrar e escrever os valores de saída
		add $t2, $s0, $zero				# $t2 = A
		loop:						# Início do loop para obtenção dos múltiplos
			div $t2, $s0 				# Divisão de $t2 por A
			mfhi $t3				# $t3 = $t2 % A
			bnez $t3, next				# Se $t3 != 0, iniciar procedimento para atualizar t2
			
			li $v0, 1				# Código SysCall para escrever inteiros
			add $a0, $t2, $zero			# Parâmetro(valor de $t2)
			syscall					# Escreve o valor de $t2
			
			li $v0, 4				# Código SysCall para escrever strings
			la $a0, space				# Parâmetro(espaço em branco)
			syscall					# Escrever space
			
			next:					# Atualizar valor de $t2 para próxima iteração do loop
				beq $t2, $t1, fim		# Condição de parada do loop $t2 == A * B
				blt $s0, $t1, plus1		# Se A < A * B
				bgt $s0, $t1, minus1		# Se A > A * B
				
				plus1:
					addi $t2, $t2, 1	# $t2 += 1
					j loop			# Retorna para o começo do loop
				minus1:
					addi $t2, $t2, -1	# $t2 -= 1
					j loop			# Retorna para o começo do loop
	
		fim:
			li $v0, 10				# Código Syscall para finalizar o programa
			syscall					# Finaliza o programa
