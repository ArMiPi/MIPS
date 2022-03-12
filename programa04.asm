#---------------------------------------------------------------------------------
# Elaborar um programa, em código MIPS, que faça a leitura de um número inteiro
# N pelo teclado e apresente como saída: a) se N é um número primo; b) se N for
# um número primo, imprimir os números primos até N; c) imprima os N primeiro
# números primos.
#---------------------------------------------------------------------------------

.data
	msg_entrada:            .asciiz "Digite um inteiro (N >= 0): "				# Mensagem para entrada
	msg_erro: 		.asciiz "\nO valor digitado N tem que ser maior que 0.\n"	# Mensagem informando entrada inválida
	msg_nao_primo: 		.asciiz "\nO número digitado não é primo.\n"			# Mensagem informando que o número não é primo
	msg_primo: 		.asciiz "\nO número digitado é primo.\n"			# Mensagem informando que o número é primo
	msg_primos_ate_n: 	.asciiz "\nNúmeros primos até "					# Mensagem para identificar a lista com primos até N
	msg_n_primeiros_primos: .asciiz " primeiros primos:\n"					# Mensagem para identificar a lista com os N primeiros primos
	space: 			.asciiz " "							# Espaço em branco
	dotdot_new_line: 	.asciiz ":\n"							# : + New line
	new_line:		.asciiz "\n"							# New line

.text
	main:
		# Leitura do valor de N
		li $v0, 4		# Código SysCall para escrever strings
		la $a0, msg_entrada	# Parâmetro(mensagem de entrada)
		syscall			# Escreve msg_entrada
		
		li $v0, 5		# Código SysCall para leitura de inteiro
		syscall			# Leitura do valor de N
		add $s0, $v0, $zero	# $a0 = N
		blez $s0, erro		# Se $a0 <= 0
		
		# Verificar se N é primo
		add $a0, $s0, $zero	# $a0 = N
		jal is_prime		# Inicia a verificação se N é primo
		add $s1, $v0, $zero	# $s1 recebe retorno de is_prime
		beq $s1, 1, true	# Se N for primo
		beqz $s1, false		# Se N não for primo
		
		true:
			# Imprimir mensagem informando que N é primo
			li $v0, 4			# Código SysCall para escrever strings
			la $a0, msg_primo		# Parâmetro(mensagem informando que é primo)
			syscall				# Escreve msg_primo
			
			# Imprimir os primos até N
			li $v0, 4			# Código SysCall para escrever strings
			la $a0, msg_primos_ate_n	# Parâmetro(mensagem informando o início da função)
			syscall				# Escreve msg_primos_ate_n
			
			li $v0, 1			# Código SysCall para escrever inteiro
			add $a0, $s0, $zero		# Parâmetro(N)
			syscall				# Escreve o valor de N
			
			li $v0, 4			# Código SysCall para escrever strings
			la $a0, dotdot_new_line		# Parâmetro(:\n)
			syscall				# Escreve dotdot_new_line
			
			add $a0, $s0, $zero		# $a0 = N
			jal print_primes_upto		# Inicia a função para imprimir os primos até N
			
			li $v0, 4			# Código SysCall para escrever strings
			la $a0, new_line		# Parâmetro(\n)
			syscall				# Escreve new_line
			
			j end				# Salta para o fim do programa
		
		false:
			# Imprimir mensagem informando que N não é primo
			li $v0, 4			# Código SysCall para escrever strings
			la $a0, msg_nao_primo		# Parâmetro(mensagem informando que é primo)
			syscall				# Escreve msg_primo
			j end				# Salta para o fim do programa
	
		end:
			# Imprimir os N primeiros primos
			li $v0, 4			# Código SysCall para escrever strings
			la $a0, new_line		# Parâmetro(\n)
			syscall				# Escreve new_line
			
			li $v0, 1			# Código SysCall para escrever inteiro
			add $a0, $s0, $zero		# Parâmetro(N)
			syscall				# Escreve o valer de N
			
			li $v0, 4			# Código SysCall para escrever strings
			la $a0, msg_n_primeiros_primos	# Parâmetro(mensagem indicando o começo da função)
			syscall				# Escreve msg_n_primeiros_primos
			
			add $a0, $s0, $zero		# $a0 = N
			jal print_n_primeiros_primos	# Inicia a função para imprimir os N primeiros primos
			
			# Finalizar o programa
			li $v0, 10			# Código SysCall para finalizar o programa
			syscall				# Finaliza o programa
	
	is_prime:
		# Ajuste da pilha
		addi $sp, $sp, -16	# Ajusta a pilha para 4 itens
		sw $s0, 12($sp)		# Salva o registrador $s0 para usar depois
		sw $t0, 8($sp)		# Salva o registrador $t0 para usar depois
		sw $t1, 4($sp)		# Salva o registrador $t1 para usar depois
		sw $t2, 0($sp)		# Salva o registrador $t2 para usar depois
		
		# Atribuição de valores
		add $s0, $a0, $zero	# $s0 = N
		beq $s0, 1, not_prime	# Se $s0 == 1
		beq $s0, 2, prime	# Se $s0 == 1
		addi $t0, $zero, 2	# $t0 = 2
		srl $t1, $s0, 1		# $t1 = N / 2
		
		# Verificação
		# Verifica se N é par
		div $s0, $t0		# Divisão de N por 2
		mfhi $t2		# $t2 = N % 10
		beqz $t2, not_prime	# Se N % $t0 == 0
		addi $t0, $t0, 1	# $t0++
				
		loop:
			bge $t0, $t1, prime	# Se $t0 >= N / 2
			div $s0, $t0		# Divisão de N por $t0
			mfhi $t2		# $t2 = N % $t0
			beqz $t2, not_prime	# Se N % $t0 == 0
			addi $t0, $t0, 2	# $t0 += 2
			j loop			# Retorna para o começo do loop
			
		not_prime:
			li $v0, 0		# $v0 = 0
			j return		# Ir para return
			
		prime:
			li $v0, 1		# $v0 = 1
			j return		# Ir para return
		
		return:
			# Finalização e retorno da função
			lw $t2, 0($sp)		# Restaura o registrador $t2 para caller
			lw $t1, 4($sp)		# Restaura o registrador $t1 para caller
			lw $t0, 8($sp)		# Restaura o registrador $t0 para caller
			lw $s0, 12($sp) 	# Restaura o registrador $s0 para caller
			addi $sp, $sp, 16	# Ajusta a pilha para excluir 4 itens
			jr $ra			# Desvia de volta à rotina que chamou
	
	print_primes_upto:
		# Ajuste da pilha
		addi $sp, $sp, -12		# Ajusta a pilha para 3 itens
		sw $ra, 8($sp)			# Salva o endereço de retorno
		sw $t0, 4($sp)			# Salva o registrador $t0 para usar depois
		sw $s0, 0($sp)			# Salva o registrador $s0 para usar depois
		
		# Atribuição de valores
		add $s0, $a0, $zero		# $s0 = N
		addi $t0, $zero, 2		# $t0 = 2
		bgt $t0, $s0, exit_print	# Se $t0 > N
		
		li $v0, 1			# Código SysCall para escrever inteiros
		add $a0, $t0, $zero		# $a0 = $t0
		syscall				# Escreve o valor de $a0
		
		li $v0, 4			# Código SysCall para escrever strings
		la $a0, space			# Parâmetro(espaço em branco)
		syscall				# Escreve space
		
		addi $t0, $t0, 1		# $t0++
		
		# Verificação
		print_loop:
			bgt $t0, $s0, exit_print	# Se $t0 > N
			add $a0, $t0, $zero		# $a0 = $t0
			jal is_prime			# Verifica se $a0 é primo
			bne $v0, 1, next		# Se o retorno de is_prime != 1, testar com próximo número
			# Imprimir número
			syscall				# Escreve o valor de $a0
			
			li $v0, 4			# Código SysCall para escrever strings
			la $a0, space			# Parâmetro(espaço em branco)
			syscall				# Escreve space
			
			next:
				addi $t0, $t0, 2	# $t0 += 2
				j print_loop		# Retorna ao início do loop
		
		exit_print:
			# Finalização da função
			lw $s0, 0($sp)			# Restaura o registrador $s0 para caller
			lw $t0, 4($sp)			# Restaura o registrador $t0 para caller
			lw $ra, 8($sp) 			# Restaura o endereço de retorno
			addi $sp, $sp, 12 		# Ajusta a pilha para exluir 3 itens
			jr $ra				# Desvia de volta à rotina que chamou
	
	print_n_primeiros_primos:
		# Ajuste da pilha
		addi $sp, $sp, -16		# Ajusta a pilha para 4 itens
		sw $ra, 12($sp)			# Salva o endereço de retorno
		sw $t0, 8($sp)			# Salva o registrador $t0 para usar depois
		sw $t1, 4($sp)			# Salva o registrador $t1 para usar depois
		sw $s0, 0($sp)			# Salva o registrador $s0 para usar depois
		
		# Atribuição de valores
		add $s0, $a0, $zero		# $s0 = N
		addi $t0, $zero, 2		# $t0 = 2
		
		# Imprimir o primeiro número primo (2)
		li $v0, 1			# Código SysCall para escrever inteiro
		add $a0, $t0, $zero		# Parâmetro($t0)
		syscall				# Escreve o valor de $t0
		
		li $v0, 4			# Código Syscall para escrever strings
		la $a0, space			# Parâmetro(espaço em branco)
		syscall				# Escreve space
		
		# Iniciar verificação para identificar e imprimir próximos primos
		addi $t0, $t0, 1		# $t0++
		addi $t1, $zero, 2		# $t1 = 2
		prime_loop:
			bgt $t1, $s0, exit	# Se $t1 > N
			add $a0, $t0, $zero	# $a0 = $t0
			jal is_prime		# Verifica se $a0 é primo
			bne $v0, 1, nxt		# Se o retorno de is_prime != 1, testar com próximo número
			# Imprimir o número primo
			syscall			# Escreve o valor de $a0
			
			li $v0, 4		# Código Syscall para escrever strings
			la $a0, space		# Parâmetro(espaço em branco)
			syscall			# Escreve space
			
			addi $t1, $t1, 1	# $t1++
			
			nxt:
				addi $t0, $t0, 2	# $t0 += 2
				j prime_loop		# Retorna para o começo do loop
			
		
		exit:
			lw $s0, 0($sp)		# Restaura o registrador $s0 para caller
			lw $t1, 4($sp)		# Restaura o registrador $t1 para caller
			lw $t0, 8($sp)		# Restaura o registrador $t0 para caller
			lw $ra, 12($sp)		# Restaura o endereço de retorno	
			addi $sp, $sp, 16	# Desvia a pilha para excluir 4 itens
			jr $ra			# Desvia de volta à rotina que chamou
	
	erro:
		li $v0, 4		# Código SysCall para escrever strings
		la $a0, msg_erro	# Parâmetro(mensagem de erro)
		syscall			# Escreve msg_erro
		j main			# Retorna para o começo do programa
