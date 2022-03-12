#---------------------------------------------------------------------------------
# #include<stdio.h>
#
# int primes[64] = {2}
#
# int is_prime(int i, int k){
#	int j = 0;
#	while (j <= k){
#		if(i % primes[j] == 0)
#			break;
#		j++;
#	}
#	return (j > k);
# }
#
# int main(){
#	int i, j, k = 0, n;
#	int prime;
#	scanf("%d", &n);
#	for(i = 2; i < n; i++)
#		if(is_prime(i, k))
#			primes[++k] = i;
#	for(i = 0; i <= k; i++)
#		printf("%d\n", primes[i]);
#	return 0;
# }
#---------------------------------------------------------------------------------

.data
	new_line: .asciiz "\n"		# Comando new line
	primes:
		.align 2		# Indica que é um array de words
		.space 256		# Reserva espaço para 64 words

.text
	addi $t0, $zero, 2		# $t0 = 2
	sw $t0, primes($zero)		# primes[0] = 2

	main:
		# Variáveis	$t0 = i; $t1 = k; $s0 = n;
		# Realizar leitura de n
		li $v0, 5		# Código syscall para leitura de inteiro
		syscall			# Realiza a leitura de n
		add $s0, $v0, $zero	# $s0 = n
		
		# Primeiro laço for
		addi $t0, $zero, 2	# i = 2
		add $t1, $zero, $zero	# k = 0
		for1:
			beq $t0, $s0, next_for	# Se i == n, ir para next_for
			add $a0, $t0, $zero	# $a0 = i
			add $a1, $t1, $zero	# $a1 = k
			jal is_prime		# Chamada da função is_prime
			beqz $v0, next		# Se $v0 == 0 ir para next
			addi $t1, $t1, 4	# k += 4
			sw $t0, primes($t1)	# primes[k/4] = i
			next:
				addi $t0, $t0, 1	# i++
				j for1			# Retorna para o início de for1
		
		# Segundo laço for
		next_for:
			add $t0, $zero, $zero	# i = 0
		for2:
			bgt $t0, $t1, end	# Se i > k ir para end
			lw $t2, primes($t0)	# $t2 = primes[i/4]
			li $v0, 1		# Código syscall para imprimir inteiro
			add $a0, $t2, $zero	# $a0 = $t2
			syscall			# Imprime o valor contido em $a0
			li $v0, 4		# Código syscall para imprimir string
			la $a0, new_line	# Carrega em $a0 o endereço de new_line
			syscall			# Imprime new_line
			addi $t0, $t0, 4	# i += 4
			j for2			# Retorna para o início de for2
		
		# Finalizar o programa
		end:
			li $v0, 10		# Código syscall para finalizar programa
			syscall			# Finaliza o programa
			
	
	is_prime:
		# Variáveis	$a0 = i, $a1 = k, $t0 = j
		# Ajustar pilha
		addi $sp, $sp, -12	# Ajusta a pilha para armazenar 3 itens
		sw $t0, 0($sp)		# Salva o valor armazenado em $t0
		sw $t1, 4($sp)		# Salva o valor armazenado em $t1
		sw $t2, 8($sp)		# Salva o valor armazenado em $t2
		
		# Atribuição de valores
		add $t0, $zero, $zero	# j = 0
		
		# Laço while
		while:
			bgt $t0, $a1, true	# Se j > k ir para true
			lw $t1, primes($t0)	# $t1 = primes[j/4]
			div $a0, $t1		# i / $t1
			mfhi $t2		# $t2 = i % $t1
			beqz $t2, false		# Se $t2 == 0 ir para false
			addi $t0, $t0, 4	# j += 4
			j while			# Retorna para o início de while
		true:
			addi $v0, $zero, 1	# $v0 = 1
			j return		# Ir para return
		false:
			add $v0, $zero, $zero	# $v0 = 0
			j return		# Ir para return
		return:
			lw $t0, 0($sp)		# Restaura o valor de $t0
			lw $t1, 4($sp)		# Restaura o valor de $t1
			lw $t2, 8($sp)		# Restaura o valor de $t2
			jr $ra			# Retorna para main
