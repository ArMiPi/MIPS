#---------------------------------------------------------------------------------
# - Realizar a leitura de n elementos inteiros
# - Ordenar o vetor em ordem crescente
# 	- apresentar o vetor ordenado
# - Somar os elementos pares do vetor
# 	- apresentar esse valor
# - Ler uma chave k (numero inteiro)
# 	- apresentar o numero de elementos x do vetor tal que: k < x < 2k
# - Ler uma chave k (numero inteiro)
# 	- apresentar o numero de inteiros iguais a k
# - Realizar
#	- soma dos numeros inteiros perfeitos
#	- soma dos numeros inteiros semiprimos
# 	- apresentar a diferenca entre esses dois valores, respectivamente
#---------------------------------------------------------------------------------
# #include<stdio.h>
# #include<stdlib.h>
# 
# void ordenaVetor(int *vetor, int tamanho) {
#   int temp;
#  	for(int i = 0; i < tamanho; i++) {
# 	    for(int j = i + 1; j < tamanho; j++) {
# 		    if(vetor[j] < vetor[i]) {
# 				temp = vetor[j];
# 				vetor[j] = vetor[i];
# 				vetor[i] = temp;
#  			}
# 		}
# 	}
# }
# 
# int somaPares(int *vetor, int tamanho) {
# 	int soma = 0;
# 	
# 	for (int i = 0; i < tamanho; i++) {
# 		if(vetor[i] % 2 == 0) {
# 			soma += vetor[i];
# 		}
# 	}
# 	
# 	return soma;
# }
# 
# int maiorKmenor2K(int *vetor, int tamanaho, int k) {
# 	int quantidade = 0;
# 
# 	for(int i = 0; i < tamanaho; i++) {
# 		if(vetor[i] <= k) continue;
# 		if(vetor[i] >= 2*k) break;
# 		quantidade++;
# 	}
# 
# 	return quantidade;
# }
# 
# int iguaisK(int *vetor, int tamanho, int k) {
# 	int iguais = 0;
# 
# 	for(int i = 0; i < tamanho; i++) {
# 		if(vetor[i] < k) continue;
# 		if(vetor[i] > k) break;
# 		iguais++;
# 	}
# 
# 	return iguais;
# }
# 
# int perfeito(int numero) {
# 	int soma = 0;
# 	for(int i = 1; i <= numero/2; i++) {
# 		if(numero % i == 0) soma += i;
# 	}
# 	
# 	if(soma == numero) return 1;
# 	return 0;
# }
# 
# int primo(int numero) {
# 	for(int i = 2; i <= numero/2; i++) {
# 		if(numero % i == 0) return 0;
# 	}
# 	
# 	return 1;
# }
# 
# int semiPrimo(int numero) {
# 	for(int i = 2; i <= numero/2; i++) {
# 		if(primo(i) == 0) continue;
# 		if(numero % i != 0) continue;
# 		if(primo(numero / i) == 1) return 1;
# 	}
# 	
# 	return 0;
# }
# 
# int diferencaPerfeitosSemiPrimos(int *vetor, int tamanho) {
# 	int somaPerfeitos = 0;
# 	int somaSemiPrimos = 0;
# 
# 	for(int i = 0; i < tamanho; i++) {
# 		if(perfeito(vetor[i]) == 1) somaPerfeitos += vetor[i];
# 		if(semiPrimo(vetor[i]) == 1) somaSemiPrimos += vetor[i];
# 	}
# 
# 	return somaPerfeitos - somaSemiPrimos;
# }
# 
# void imprimeVetor(int *vetor, int tamanho) {
# 	for(int i = 0; i < tamanho; i++) {
# 		printf("%d ", vetor[i]);
# 	}
# 
#     	printf("\n");
# }
# 
# int main() {
# 	int tamanho, k, resultado;
# 	int *vetor;
# 
# 	printf("Entre com o tamanho do vetor: ");
# 	scanf("%d", &tamanho);
# 	vetor = (int *) malloc(tamanho * sizeof(int));
# 
# 	// Preencher vetor
# 	for(int i = 0; i < tamanho; i++) {
# 		printf("vetor[%d]: ", i);
# 		scanf("%d", &vetor[i]);
# 	}
# 
# 	// Ordenar vetor
# 	ordenaVetor(vetor, tamanho);
# 	imprimeVetor(vetor, tamanho);
# 
# 	// Somar pares
# 	resultado = somaPares(vetor, tamanho);
# 	printf("Soma pares: %d\n", resultado);
#     	printf("\n");
# 
# 	// Quantidade de elementos x tal que: k < x < 2k
# 	printf("Entre com um valor de k(inteiro): ");
# 	scanf("%d", &k);
# 
# 	resultado = maiorKmenor2K(vetor, tamanho, k);
# 	printf("Quantidade de elementos x tal que k < x <2k: %d\n", resultado);
#     	printf("\n");
# 
# 	// Quantidade de elementos iguais a k
# 	printf("Entre com um valor de k(inteiro): ");
# 	scanf("%d", &k);
# 
# 	resultado = iguaisK(vetor, tamanho, k);
# 	printf("Quantidade de elementos iguais a k: %d\n", resultado);
#     	printf("\n");
# 
# 	// Soma dos numeros perfeitos - Soma dos numeros semiprimos
# 	resultado = diferencaPerfeitosSemiPrimos(vetor, tamanho);
# 	printf("Soma dos numeros perfeitos - Soma dos numeros semiprimos: %d\n", resultado);
#     	printf("\n");
# 
# 	free(vetor);
# }
#---------------------------------------------------------------------------------
# OBS: Todas as funcoes, com excecao a funcao ordenaVetor, foram implementadas
#      tendo em mente que o vetor de entrada esta ordenado em ordem crescente
#---------------------------------------------------------------------------------

.data
	# Mensagens de entrada:
	msg_entrada_n: 				.asciiz "Entre com o tamanho do vetor: "	# Mensagem para receber o valor de n
	msg_entrada_inicio_elementoVetor: 	.asciiz "vetor["				# Inicio da mensagem para receber o valor de vetor[i]
	msg_entrada_fim_elementoVetor:		.asciiz "]: "					# Final da mensagem para receber o valor de vetor[i]
	msg_entrada_k: 				.asciiz "\nEntre com um valor de k(inteiro): "	# Mensagem para receber o valor de k
	
	# Mensagens de saída:
	msg_saida_inicio_ordenaVetor: 		.asciiz "\nVetor ordenado: [ "						# Inicio da mensagem para apresentar o resultado da funcao ordenaVetor
	msg_saida_somaPares: 			.asciiz "\nSoma pares: "						# Mensagem para apresentar retorno da funcao somaPares
	msg_saida_maiorKmenor2K: 		.asciiz "\nQuantidade de elementos x tal que k < x < 2k: "		# Mensagem para apresentar o retorno da funcao maiorKmenor2K
	msg_saida_iguaisK: 			.asciiz "\nQuantidade de elementos iguais a k: "			# Mensagem para apresentar o retorno da funcao iguaisK
	msg_saida_diferencaPerfeitosSemiPrimos: .asciiz "\nSoma dos numeros perfeitos - Soma dos numeros semiprimos: "	# Mensagem para apresentar o retorno da funcao diferencaPerfeitosSemiPrimos
	
	# Mensagens de erro
	msg_erro_n: .asciiz "\nERRO: n deve ser um inteiro maior que 0\n"	# Mensagem indicando erro com o parametro n
	msg_erro_k: .asciiz "\nERRO: k deve ser um inteiro\n"			# Mensagem indicando erro com o parametro k
	
	# Outras strings
	vetor_nao_ordenado:	.asciiz "\nVetor digitado: [ "	# Mensagem para apresentar o vetor inserido pelo usuario
	msg_fim_vetor: 		.asciiz "]\n"			# Final da mensagem para apresentar o resultado da funcao ordenaVetor 
	new_line: 		.asciiz "\n"			# Comando new line
	espaco:   		.asciiz " "			# Espaco em branco
	
	# Array
	array: .word 0	# Ponteiro para um vetor no heap
	
.text
	main:
		# Realizar leitura de n
		li $v0, 4		# Codigo syscall para escrita de string
		la $a0, msg_entrada_n	# Carrega em $a0 o endereço de msg_entrada_n
		syscall			# Imprime msg_entrada_n
		li $v0, 5		# Código syscall para leitura de inteiro
		syscall			# Realiza a leitura de n
		add $s0, $v0, $zero	# $s0 = n
	
		# Alocar memoria para o vetor
		li $v0, 9		# Codigo syscall para alocar memoria
		mul $t0, $s0, 4		# $t0 = n * 4
		add $a0, $t0, $zero	# $a0 recebe tamanho do vetor
		syscall			# Aloca a memoria requisitada
		sw $v0, array		# array recebe o endereco da memoria alocada
	
		# Leitura dos elementos do array
		lw $t0, array		# $t0 recebe endereco da primeira posicao do vetor
		li $t1, 0		# i = 0
		add $t2, $s0, $zero	# $t2 = n
		for_leitura_vetor:					# for para leitura do vetor
			li $v0, 4					# Codigo syscall para escrita de string
			la $a0, msg_entrada_inicio_elementoVetor	# Carrega em $a0 o endereco de msg_entrada_inicio_elementoVetor
			syscall						# Imprime msg_entrada_inicio_elementoVetor
			li $v0, 1					# Codigo syscall para imprimir inteiro
			add $a0, $t1, $zero				# $a0 recebe a posicao atual do vetor
			syscall						# Imprime a posicao atual a ser lida do vetor
			la $v0, 4					# Codigo syscall para escrita de string
			la $a0, msg_entrada_fim_elementoVetor		# Carrega em $a0 o endereco de msg_entrada_fim_elementoVetor
			syscall						# Imprime msg_entrada_fim_elementoVetor
			li $v0, 5					# Codigo syscall para leitura de inteiro
			syscall						# Realiza a leitura de array[$t1]
			sw $v0, ($t0)					# array[i] = numero digitado
			addi $t0, $t0, 4				# Proxima posicao do vetor
			addi $t1, $t1, 1				# i++
			blt $t1, $s0, for_leitura_vetor			# Retorna para o inicio do loop se i < n
		
		# Variavel comum
		add $a1, $s0, $zero	# $a1 = n
		
		# Imprimir vetor digitado
		li $v0, 4			# Codigo syscall para escrita de string
		la $a0, vetor_nao_ordenado	# Carrega em $a0 o endereco de vetor_nao_ordenado
		syscall				# Imrpime vetor_nao_ordenado
		jal imprime_vetor		# Executa a funcao imprime_vetor
		li $v0, 4			# Codigo syscall para escrita de string
		la $a0, msg_fim_vetor		# Carrega em $a0 o endereco de vetor_nao_ordenado
		syscall				# Imprime vetor_nao_ordenado
		
		
		# Ordenar vetor
		jal ordena_vetor	# Executa a funcao ordena_vetor
		
		# Imprimir vetor ordenado
		li $v0, 4				# Codigo syscall para escrita de string
		la $a0, msg_saida_inicio_ordenaVetor	# Carrega em $a0 o endereco de msg_saida_inicio_ordenaVetor
		syscall					# Imrpime vetor_nao_ordenado
		jal imprime_vetor			# Executa a funcao imprime_vetor
		li $v0, 4				# Codigo syscall para escrita de string
		la $a0, msg_fim_vetor			# Carrega em $a0 o endereco de msg_fim_vetor
		syscall					# Imprime msg_fim_vetor
		
		
		# Soma dos pares
		jal soma_pares		# Executa a funcao soma_pares
		add $t0, $v0, $zero	# $t0 recebe retorno de soma_pares 
		
		# Imprimir retorno da funcao soma_pares
		li $v0, 4			# Codigo syscall para escrita de string
		la $a0, msg_saida_somaPares	# Carrega em $a0 o endereco de msg_saida_somaPares
		syscall				# Imprime msg_saida_somaPares
		li $v0, 1			# Codigo syscall para imprimir inteiros
		add $a0, $t0, $zero		# $a0 = $t0 = retorno da funcao soma_pares
		syscall				# Imprime o retorno da funcao soma_pares
		li $v0, 4			# Codigo syscall para escrita de string
		la $a0, new_line		# Carrega em $a0 o endereco de new_line
		syscall				# Imprime new_line
		
		
		# Maior que k e menor que 2k
		
		# Leitura do valor de k
		li $v0, 4		# Codigo syscall para escrita de string
		la $a0, msg_entrada_k	# Carrega em $a0 o endereço de msg_entrada_k
		syscall			# Imprime msg_entrada_k
		li $v0, 5		# Código syscall para leitura de inteiro
		syscall			# Realiza a leitura de k
		add $a2, $v0, $zero	# $a2 = k
		
		jal maiorKmenor2K	# Execauta a funcao maiorKmenor2k
		add $t0, $v0, $zero	# $t0 recebe o retorno de maiorK_menor2K
		
		# Imprimir retorno da funcao maiorK_menor2K
		li $v0, 4				# Codigo syscall para escrita de string
		la $a0, msg_saida_maiorKmenor2K		# Carrega em $a0 o endereco de msg_saida_maiorKmenor2K
		syscall					# Imprime msg_saida_maiorKmenor2K
		li $v0, 1				# Codigo syscall para imprimir inteiros
		add $a0, $t0, $zero			# $a0 = $t0 = retorno da funcao maiorKmenor2K
		syscall					# Imprime o retorno da funcao maiorKmenor2K
		li $v0, 4				# Codigo syscall para escrita de string
		la $a0, new_line			# Carrega em $a0 o endereco de new_line
		syscall					# Imprime new_line
		
		
		# Iguais a k
		
		# Leitura do valor de k
		li $v0, 4		# Codigo syscall para escrita de string
		la $a0, msg_entrada_k	# Carrega em $a0 o endereço de msg_entrada_k
		syscall			# Imprime msg_entrada_k
		li $v0, 5		# Código syscall para leitura de inteiro
		syscall			# Realiza a leitura de k
		add $a2, $v0, $zero	# $a2 = k
		
		jal iguaisK		# Execauta a funcao iguaisK
		add $t0, $v0, $zero	# $t0 recebe o retorno de iguaisK
		
		# Imprimir retorno da funcao iguaisK
		li $v0, 4				# Codigo syscall para escrita de string
		la $a0, msg_saida_iguaisK		# Carrega em $a0 o endereco de msg_saida_iguaisK
		syscall					# Imprime msg_saida_iguaisK
		li $v0, 1				# Codigo syscall para imprimir inteiros
		add $a0, $t0, $zero			# $a0 = $t0 = retorno da funcao iguaisK
		syscall					# Imprime o retorno da funcao iguaisK
		li $v0, 4				# Codigo syscall para escrita de string
		la $a0, new_line			# Carrega em $a0 o endereco de new_line
		syscall					# Imprime new_line
		
		
		# Diferenca Perfeitos Semiprimos
		jal diferenca_perfeitos_semiprimos		# Executa a funcao diferenca_perfeitos_semiprimos
		add $t0, $v0, $zero				# $t0 recebe o retorno de diferenca_perfeitos_semiprimos
		
		# Imprimir retorno da funcao diferenca_perfeitos_semiprimos
		li $v0, 4					# Codigo syscall para escrita de string
		la $a0, msg_saida_diferencaPerfeitosSemiPrimos	# Carrega em $a0 o endereço de msg_saida_diferencaPerfeitosSemiPrimos
		syscall						# Imprime msg_saida_diferencaPerfeitosSemiPrimos
		li $v0, 1					# Codigo syscall para escrita de string
		add $a0, $t0, $zero				# $a0 recebe o retorno de diferenca_perfeitos_semiprimos
		syscall						# Imprime o retorno de diferenca_perfeitos_semiprimos
		li $v0, 4					# Codigo syscall para escrita de string
		la $a0, new_line				# Carrega em $a0 o endereco de new_line
		syscall						# Imprime new_line
		
		li $v0, 10
		syscall
	
	##################### FUNCOES #####################
	
	ordena_vetor:
		# Variaveis
		#	$a1: tamanho do vetor
		#	$t0: vetor
		#	$t1: posicao do vetor loop externo
		#	$t2: elemento do vetor loop externo
		#	$t3: posicao do vetor loop interno
		#	$t4; elemento do vetor loop interno
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
		lw $t0, array	# $t0 recebe o endereco de array
		li $t5, 0	# i = 0
		
		loop_externo:
			bge $t5, $a1, return_ordena	# Ir para return_ordena se i >= tamanho
			mul $t7, $t5, 4			# aux = i * 4
			add $t1, $t0, $t7		# $t1 = endereco inicial do vetor + aux
			lw $t2, ($t1)			# $t2 = array[i]
			
			addi $t6, $t5, 1		# j = i + 1
			loop_interno:
				bge $t6, $a1, next_externo	# Ir para next_interno se j >= tamanho
				mul $t7, $t6, 4			# aux = j * 4
				add $t3, $t0, $t7		# $t3 = endereco inicial do vetor + aux
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
			addi $sp, $sp, 28	# Ajusta a pilha para excluir 8 itens
		
			jr $ra		# Retorno
			
	######################################################################################################
	
	soma_pares:
		# Variaveis
		#	$a1: tamanho do vetor
		#	$t0: vetor
		#	$t1: posicao do elemento do vetor
		#	$t2: elemento do vetor
		#	$t3: i
		#	$t4: soma
		#	$t5: auxiliar
		
		# Ajustar pilha
		addi $sp, $sp, -24	# Ajusta a pilha para armazenar 6 itens
		sw $t0, 0($sp)		# Armazena o valor de $t0
		sw $t1, 4($sp)		# Armazena o valor de $t1
		sw $t2, 8($sp)		# Armazena o valor de $t2
		sw $t3, 12($sp)		# Armazena o valor de $t3
		sw $t4, 16($sp)		# Armazena o valor de $t4
		sw $t5, 20($sp)		# Armazena o valor de $t5
		
		# Atribuicao de valores
		lw $t0, array	# $t0 recebe endereco de array
		li $t4, 0	# soma = 0
		li $t3, 0	# i = 0
		
		loop_pares:
			bge $t3, $a1, return_pares	# Ir para return_pares se i >= tamanho
			mul $t5, $t3, 4			# aux = i * 4
			add $t1, $t0, $t5		# $t1 = endereco inicial do vetor + aux
			lw $t2, ($t1)			# $t2 = array[i]
			addi $t5, $zero, 2		# aux = 2
			div $t2, $t5			# array[i] / 2
			mfhi $t5			# $t5 = array[i] % 2
			bnez $t5, next_loop_pares	# Ir para next_loop_pares se array[i] % 2 != 0
			add $t4, $t4, $t2		# soma += array[i]
			
			next_loop_pares:
				addi $t3, $t3, 1	# i++
				j loop_pares		# Volta para loop_pares
		
		return_pares:
			add $v0, $t4, $zero	# $v0 = soma
			# Restaurar valores da pilha
			lw $t0, 0($sp)		# Restaura o valor de $t0
			lw $t1, 4($sp)		# Restaura o valor de $t1
			lw $t2, 8($sp)		# Restaura o valor de $t2
			lw $t3, 12($sp)		# Restaura o valor de $t3
			lw $t4, 16($sp)		# Restaura o valor de $t4
			lw $t5, 20($sp)		# Restaura o valor de $t5
			addi $sp, $sp 24	# Ajusta a pilha para excluir 6 itens
			jr $ra			# Retorno
	
	######################################################################################################
	
	maiorKmenor2K:
		# Variaveis
		#	$a1: tamanho do vetor
		#	$a2: k
		#	$t0: vetor
		#	$t1: posicao do elemento do vetor
		#	$t2: elemento do vetor
		#	$t3: i
		#	$t4: quantidade
		#	$t5: auxiliar
		#	$t6: 2k
		
		# Ajustar pilha
		addi $sp, $sp, -28	# Ajusta a pilha para receber 7 itens
		sw $t0, 0($sp)		# Armazena o valor de $t0
		sw $t1, 4($sp)		# Armazena o valor de $t1
		sw $t2, 8($sp)		# Armazena o valor de $t2
		sw $t3, 12($sp)		# Armazena o valor de $t3
		sw $t4, 16($sp)		# Armazena o valor de $t4
		sw $t5, 20($sp)		# Armazena o valor de $t5
		sw $t6, 24($sp)		# Armazena o valor de $t6
		
		# Atribuicao de valores
		mul $t6, $a2, 2		# $t6 = 2k
		lw $t0, array		# $t0 recebe endereco de array
		add $t4, $zero, $zero	# quantidade = 0
		add $t3, $zero, $zero	# i = 0
		
		loop_k2k:
			bge $t3, $a1, return_k2k	# Ir para return_k2k se i >= tamanho
			mul $t5, $t3, 4			# aux = i * 4
			add $t1, $t0, $t5		# $t1 recebe endereco de array[i]
			lw $t2, ($t1)			# $t2 = array[i]
			bge $t2, $t6, return_k2k	# Ir para return_k2k se array[i] >= 2k
			ble $t2, $a2, next_loop_k2k	# Ir para next_loop_k2k se array[i] <= k
			addi $t4, $t4, 1		# quantidade++
			
			next_loop_k2k:
				addi $t3, $t3, 1	# i++
				j loop_k2k		# Volta para loop_k2k
			
		return_k2k:
			add $v0, $t4, $zero	# $v0 = quantidade
			# Restaurar valores da pilha
			lw $t0, 0($sp)		# Restaura o valor de $t0
			lw $t1, 4($sp)		# Restaura o valor de $t1
			lw $t2, 8($sp)		# Restaura o valor de $t2
			lw $t3, 12($sp)		# Restaura o valor de $t3
			lw $t4, 16($sp)		# Restaura o valor de $t4
			lw $t5, 20($sp)		# Restaura o valor de $t5
			lw $t6, 24($sp)		# Restaura o valor de $t6
			addi $sp, $sp, 28	# Ajusta a pilha para excluir 7 itens
			jr $ra			# Retorno
	
	######################################################################################################
	
	iguaisK:
		# Variaveis
		# 	$a1: tamanho do vetor
		#	$a2: k
		#	$t0: vetor
		#	$t1: posicao do elemento do vetor
		#	$t2: elemento do vetor
		#	$t3: i
		#	$t4: iguais
		#	$t5: auxiliar
		
		# Ajustar pilha
		addi $sp, $sp, -24	# Ajusta a pilha para armazenar 6 itens
		sw $t0, 0($sp)		# Armazena o valor de $t0
		sw $t1, 4($sp)		# Armazena o valor de $t1
		sw $t2, 8($sp)		# Armazena o valor de $t2
		sw $t3, 12($sp)		# Armazena o valor de $t3
		sw $t4, 16($sp)		# Armazena o valor de $t4
		sw $t5, 20($sp)		# Armazena o valor de $t5
		
		# Atribuicao de valores
		lw $t0, array 		# $t0 recebe endereco de array
		li $t4, 0		# iguais = 0
		li $t3, 0		# i = 0
		loop_iguaisK:
			bge $t3, $a1, return_iguaisK		# Ir para return_iguaisK se i >= tamanho
			mul $t5, $t3, 4				# aux = i * 4
			add $t1, $t0, $t5			# $t1 recebe o endereco de array[i]
			lw $t2, ($t1)				# $t2 = array[i]
			blt $t2, $a2, next_loop_iguaisK		# Ir para next_loop_iguaisK se array[i] < k
			bgt $t2, $a2, return_iguaisK		# Ir para return_iguaisK se array[i] > k
			addi $t4, $t4, 1			# iguais++
			
			next_loop_iguaisK:
				addi $t3, $t3, 1		# i++
				j loop_iguaisK			# Volta para loop_iguaisK
		
		return_iguaisK:
			add $v0, $t4, $zero	# $v0 = iguais
			# Restaurar valores da pilha
			lw $t0, 0($sp)		# Restaura o valor de $t0
			lw $t1, 4($sp)		# Restaura o valor de $t1
			lw $t2, 8($sp)		# Restaura o valor de $t2
			lw $t3, 12($sp)		# Restaura o valor de $t3
			lw $t4, 16($sp)		# Restaura o valor de $t4
			lw $t5, 20($sp)		# Restaura o valor de $t5
			addi $sp, $sp, 24	# Ajusta a pilha para excluir 6 itens
			jr $ra			# Retorno
	
	######################################################################################################
	
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
	
	######################################################################################################
	
	primo:
		# Variaveis
		#	$a1: numero
		#	$t0: i
		#	$t1: numero/2
		#	$t2: auxiliar
		
		# Ajustar pilha
		addi $sp, $sp, -12	# Ajusta a pilha para armazenar 4 itens
		sw $t0, 0($sp)		# Armazena o valor de $t0
		sw $t1, 4($sp)		# Armazena o valor de $t1
		sw $t2, 8($sp)		# Armazena o valor de $t2
		
		# Atribuicao de valores
		beq $a1, 1, return_primo_falso	# Retorna falso se numero == 1
		li $t0, 2			# i = 2
		li $t2, 2			# aux = 2
		div $t1, $a1, $t2		# $t1 = numero/2
		
		loop_primo:
			bgt $t0, $t1, return_primo_verdadeiro	# Ir para return_primo_verdadeiro se i > numero/2
			div $a1, $t0				# numero/i
			mfhi $t2				# $t2 = numero % i
			beqz $t2, return_primo_falso		# Ir para return_primo_falso se %t2 == 0
			addi $t0, $t0, 1			# i++
			j loop_primo				# Volta para loop_primo
		
		return_primo_verdadeiro:
			li $v0, 1	# Retorno verdadeiro
			j return_primo	# Ir para return_primo
		
		return_primo_falso:
			li $v0, 0	# Retorno falso
			
		return_primo:
			# Restaurar valores da pilha
			lw $t0, 0($sp)		# Restaura o valor de $t0
			lw $t1, 4($sp)		# Restaura o valor de $t1
			lw $t2, 8($sp)		# Restaura o valor de $t2
			addi $sp, $sp, 12	# Ajusta a pilha para remover 4 itens
			
			jr $ra			# Retorno
	
	######################################################################################################
	
	semiprimo:
		# Variaveis:
		#	$a1: numero
		#	$t0: i
		#	$t1: numer/2
		#	%t2: auxiliar1
		#	$t3: auxiliar2
		
		# Ajustar pilha
		addi $sp, $sp, -24	# Ajusta a pilha para armazenar 6 itens
		sw $t0, 0($sp)		# Armazena o valor de $t0
		sw $t1, 4($sp)		# Armazena o valor de $t1
		sw $t2, 8($sp)		# Armazena o valor de $t2
		sw $t3, 12($sp)		# Armazena o valor de $t3
		sw $a1, 16($sp)		# Armazena o valor de $a1
		sw $ra, 20($sp)		# Armazena o valor de $ra
		
		# Atribuicao de valores
		add $t2, $a1, $zero	# $t2 armazena o valor de numero
		li $t0, 2		# i = 2
		div $t1, $a1, $t0	# $t1 = numero/2
		
		loop_semiprimo:
			bgt $t0, $t1, return_semiprimo_falso	# Ir para return_semiprimo_falso se i > numer/2
			add $a1, $t0, $zero			# $a1 = i
			jal primo				# Executa primo
			beqz $v0, next_loop_semiprimo		# Ir para next_loop_semiprimo se i nao for primo
			div $t2, $t0				# numero/i
			mfhi $t3				# $t3 = numero % i
			bnez $t3, next_loop_semiprimo		# Ir para next_loop_semiprimo se numero % i != 0
			div $t3, $t2, $t0			# $t3 = numero/i
			add $a1, $t3, $zero			# $a1 = numero/i
			jal primo				# Execura primo
			beq $v0, 1, return_semiprimo_verdadeiro	# Ir para return_semiprimo_verdadeiro se $v0 = 1
			
			next_loop_semiprimo:
				addi $t0, $t0, 1		# i++
				j loop_semiprimo		# Volta para loop_semiprimo
			
		return_semiprimo_falso:
			li $v0, 0		# $v0 = 0
			j return_semiprimo	# Ir para return_semiprimo
		
		return_semiprimo_verdadeiro:
			li $v0, 1		# $v0 = 1
		
		return_semiprimo:
			# Restaurar elementos da pilha
			lw $t0, 0($sp)		# Restaura o valor de $t0
			lw $t1, 4($sp)		# Restaura o valor de $t1
			lw $t2, 8($sp)		# Restaura o valor de $t2
			lw $t3, 12($sp)		# Restaura o valor de $t3
			lw $a1, 16($sp)		# Restaura o valor de $a1
			lw $ra, 20($sp)		# Restaura o valor de $ra
			addi $sp, $sp, 24	# Ajusta a pilha para excluir 6 itens
			jr $ra			# Retorno
	
	######################################################################################################
	
	diferenca_perfeitos_semiprimos:
		# Variaveis:
		#	$a1: tamanho
		#	$t0: vetor
		#	$t1: endereco de elemento do vetor
		#	$t2: elemento do vetor
		#	$t3: i
		#	$t4: soma_perfeitos
		#	$t5: soma_semiprimos
		#	$t6: auxiliar
		#	$t7: auxiliar2
		
		# Ajustar pilha
		addi $sp, $sp, -36	# Ajusta a pilha para armazenar 9 itens
		sw $t0, 0($sp)		# Armazena o valor de $t0
		sw $t1, 4($sp)		# Armazena o valor de $t1
		sw $t2, 8($sp)		# Armazena o valor de $t2
		sw $t3, 12($sp)		# Armazena o valor de $t3
		sw $t4, 16($sp)		# Armazena o valor de $t4
		sw $t5, 20($sp)		# Armazena o valor de $t5
		sw $t6, 24($sp)		# Armazena o valor de $t6
		sw $t7, 28($sp)		# Armazena o valor de $t7
		sw $ra, 32($sp)		# Armazena o valor de $ra
		
		# Atribuicao de valores
		add $t7, $a1, $zero	# $t7 = tamanho
		lw $t0, array		# $t0 recebe o endereco de array
		li $t3, 0		# i = 0
		li $t4, 0		# soma_perfeitos = 0
		li $t5, 0		# soma_semiprimos = 0
		
		loop_perfeitos_semiprimos:
			bge $t3, $t7, return_diferenca_perfeitos_semiprimos	# Ir para return_diferenca_perfeitos_semiprimos se i > tamanho
			mul $t6, $t3, 4						# $t6 = i * 4
			add $t1, $t0, $t6					# $t1 recebe o endereco de array[i]
			lw $t2, ($t1)						# $t2 = array[i]
			add $a1, $t2, $zero					# $a1 = array[i]
			jal perfeito						# Executa perfeito
			bne $v0, 1, sp						# Ir sp: se o retorno de perfeito != 1
			add $t4, $t4, $t2					# soma_perfeitos += array[i]
			sp:
				jal semiprimo						# Executa semiprimo
				bne $v0, 1, next_loop_perfeitos_semiprimos		# Ir para loop_perfeitos_semiprimos se o retorno de semiprimo != 1
				add $t5, $t5, $t2					# soma_semiprimos += array[i]
			next_loop_perfeitos_semiprimos:
				addi $t3, $t3, 1					# i++
				j loop_perfeitos_semiprimos				# Volta para loop_perfeitos_semiprimos
			
		
		return_diferenca_perfeitos_semiprimos:
			sub $t6, $t4, $t5	# $t6 = soma_perfeitos - soma_semiprimos
			add $v0, $t6, $zero	# $v0 = soma_perfeitos - soma_semiprimos
			# Restaurar elementos da pilha
			add $a1, $t7, $zero	# $a1 = tamanho
			lw $t0, 0($sp)		# Restaura o valor de $t0
			lw $t1, 4($sp)		# Restaura o valor de $t1
			lw $t2, 8($sp)		# Restaura o valor de $t2
			lw $t3, 12($sp)		# Restaura o valor de $t3
			lw $t4, 16($sp)		# Restaura o valor de $t4
			lw $t5, 20($sp)		# Restaura o valor de $t5
			lw $t6, 24($sp)		# Restaura o valor de $t6
			lw $t7, 28($sp)		# Restaura o valor de $t7
			lw $ra, 32($sp)		# Restaura o valor de $ra
			add $sp, $sp, 36	# Ajusta a pilha para excluir 9 itens
			jr $ra			# Retorno
			
	######################################################################################################
	
	imprime_vetor:
		# Variaveis 	
		#	$a1: tamanho do vetor
		#	$t0: temporario para vetor
		#	$t1: i
		#	$t2: elemento para ser imprimido
		
		# Ajustar pilha
		addi $sp, $sp, -12	# Ajusta a pilha para armazenar 3 itens
		sw $t0, 0($sp)		# Salva o valor armazenado em $t0
		sw $t1, 4($sp)		# Salva o valor armazenado em $t1
		sw $t2, 8($sp)		# Salva o valor armazenado em $t2
		
		# Atribuicao de valores
		lw $t0, array			# $t0 recebe endereco de array
		li $t1, 0			# i = 0
		
		for_imprime_vetor:
			li $v0, 1		# Codigo syscall para imprimir inteiro
			lw $t2, ($t0)		# $t2 = array[i]
			add $a0, $t2, $zero	# $a0 = $t2
			syscall			# Imprime o array[i]
			li $v0, 4		# Codigo syscall para escrita de string
			la $a0, espaco		# Carrega em $a0 o endereco de espaco
			syscall			# Imprime espaco
			addi $t0, $t0, 4	# Proxima posicao do vetor
			addi $t1, $t1, 1	# i++
			blt $t1, $a1, for_imprime_vetor	# Volta para o comeco do loop se i < tamanho
		
		# Restaurar valores da pilha
		lw $t0, 0($sp)		# Restaura o valor de $t0
		lw $t1, 4($sp)		# Restaura o valor de $t1
		lw $t2, 8($sp)		# Restaura o valor de $t2
		addi $sp, $sp, 12 	# Ajusta a pilha para excluir 3 itens
		jr $ra			# Retorno
