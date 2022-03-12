#---------------------------------------------------------------------------------
# #include<stdio.h>
# 
# int squares[64];
#
# void storeValues(int n) {
# 	int i;
#	for(i = 0; i < n; i++)
#		squares[i] = i * i;
# }
# int computeSum(int n){
#	int i, sum;
#	sum = 0;
#	for(i = 0; i < n; i++)
#		sum += squares[i];
#	return sum;
# }
#
# int main() {
#	int upTo;
#	scanf("%d", &upTo);
#	storeValues(upTo);
#	printf("sum = %d\n", computeSum(upTo));
#	return 0;
# }
#---------------------------------------------------------------------------------

.data
	msg_saida: 	.asciiz "sum = "	# Início da mensagem de saída
	new_line:	.asciiz "\n"		# Comando new line
	squares:
		.align 2		# Indica que é um array de words
		.space 256		# Reserva espaço para 64 words

.text
	main:
		# Leitura do valor de upTo
		li $v0, 5		# Código syscall para leitura de inteiro
		syscall			# Leitura de upTo
		add $s0, $zero, $v0	# $s0 = upTo
		
		# Chamada de storeValues()
		add $a0, $s0, $zero	# $a0 = $s0
		jal storeValues		# Inicia a função storeValues
		
		# Chamada de computeSum
		jal computeSum		# Inicia a função computeSum
		add $s1, $zero, $v0	# $s1 = $v0
		
		# Apresentar resultado
		li $v0, 4		# Código syscall para imprimir string
		la $a0, msg_saida	# Carrega em $a0 o endereço de msg_saida
		syscall			# Imprime msg_saida
		
		li $v0, 1		# Código syscall para imprimir inteiro
		add $a0, $s1, $zero	# $a0 = $s1
		syscall			# Imprime o valor armazenado em $s1
		
		# Finalizar programa
		li $v0, 10		# Código syscall para finalizar programa
		syscall			# Finalizar programa
		
	storeValues:
		# Ajusta da pilha
		addi $sp, $sp, -12	# Ajusta a pilha para armazenar 3 valores
		sw $t0, 0($sp)		# Salva o valor armazenado em $t0
		sw $t1, 4($sp)		# Salva o valor armazenado em $t1
		sw $t2, 8($sp)		# Salva o valor armazenado em $t2
		
		# Atribuição de valores
		add $t0, $zero, $zero	# $t0 = 0
		add $t1, $zero, $zero	# $t1 = 0
		add $t2, $zero, $zero	# $t2 = 0
		
		for:
			beq $t0, $a0, return	# Se $t0 == $a0 ir para return
			mul $t2, $t0, $t0	# $t2 = $t0 * $t0
			sw $t2, squares($t1)	# squares[$t1/4] = $t2
			addi $t0, $t0, 1	# $t0 += 1
			addi $t1, $t1, 4	# $t1 += 4
			j for			# Retorna para o início de for
		return:
			lw $t0, 0($sp)		# Restaura o valor de $t0
			lw $t1, 4($sp)		# Restaura o valor de $t1
			lw $t2, 8($sp)		# Restaura o valor de $t2
			jr $ra			# Retorna para main
	
	computeSum:
		# Ajustar a pilha
		addi $sp, $sp, -16		# Ajusta a pilha para armazenar 4 valores
		sw $t0, 0($sp)			# Salva o valor armazenado em $t0
		sw $t1, 4($sp)			# Salva o valor armazenado em $t1
		sw $t2, 8($sp)			# Salva o valor armazenado em $t2
		sw $s0, 12($sp)			# Salva o valor armazenado em $s0
		
		# Atribuição de valores
		add $t0, $zero, $zero		# $t0 = 0
		add $t1, $zero, $zero		# $t1 = 0
		add $t2, $zero, $zero		# $t2 = 0
		add $s0, $zero, $zero		# $s0 = 0
		while:
			beq $t0, $a0, end	# Se $t0 == $a0 ir para return
			lw $t2, squares($t1)	# $t2 = squares[$t1]
			add $s0, $s0, $t2	# $s0 += $t2
			addi $t0, $t0, 1	# $t0 += 1
			addi $t1, $t1, 4	# $t1 += 4
			j while			# Retorna para while
		end:
			add $v0, $zero, $s0	# $v0 = $s0
			lw $t0, 0($sp)		# Restaura o valor de $t0
			lw $t1, 4($sp)		# Restaura o valor de $t1
			lw $t2, 8($sp)		# Restaura o valor de $t2
			lw $s0, 12($sp)		# Restaura o valor de $sp
			jr $ra			# Retorna para main