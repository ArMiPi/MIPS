#---------------------------------------------------------------------------------
# - Realizar a leitura de n elementos inteiros
# - Realizar a leitura de uma chave k
# - Apresentar como saida o vetor digitado deslocado k casas a direita
#---------------------------------------------------------------------------------
# include<stdio.h>
# include<stdlib.h>
#
# int *copiaVetor(int *vetor, int size) {
#   int *copia = (int *) malloc(sizeof(int));
# 
# 	for(int i = 0; i < size; i++) copia[i] = vetor[i];
# 
# 	return copia;
# }
# 
# void translocate(int *vetor, int size, int delta) {
# 	int *temp = copiaVetor(vetor, size);
# 
# 	for(int i = 0, j = (delta > size)? delta - size : delta; i < size; i++, j++) {
# 		if(j >= size) j = 0;
# 		vetor[i] = temp[j];
# 	}
# 
# 	free(temp);
# }
# 
# int main() {
# 	int *vetor;
# 	int tamanho, deslocamento;
# 
# 	printf("Entre com o tamanho do vetor: ");
# 	scanf("%d", &tamanho);
# 
# 	vetor = (int *) malloc(tamanho * sizeof(int));
# 	for(int i = 0; i < tamanho; i++) {
# 		printf("v[%d]: ", i);
# 		scanf("%d", &vetor[i]);
# 	}
# 
# 	printf("\nEntre com o valor do deslocamento: ");
# 	scanf("%d", &deslocamento);
# 
# 	printf("\nVetor inserido: [ ");
# 	for(int i = 0; i < tamanho; i++) printf("%d ", vetor[i]);
# 	printf("]\n");
# 
# 	translocate(vetor, tamanho, deslocamento);
# 
# 	printf("\nVetor deslocado: [ ");
# 	for(int i = 0; i < tamanho; i++) printf("%d ", vetor[i]);
# 	printf("]\n");
# 
# 	free(vetor);
# }
#---------------------------------------------------------------------------------

.data
    # Mensagens de entrada
    msg_entrada_n:                      .asciiz "Entre com o tamanho do vetor: "        # Mensagem para receber o valor de n
    msg_entrada_k:                      .asciiz "\nEntre com o valor da chave k: "      # Mensagem para receber o valor de k
    msg_entrada_inicio_elementoVetor: 	.asciiz "vetor["				# Inicio da mensagem para receber o valor de vetor[i]
	msg_entrada_fim_elementoVetor:		.asciiz "]: "				# Final da mensagem para receber o valor de vetor[i]

    # Mensagens de saida
    msg_saida_vetor_inicial:    .asciiz "\nVetor digitado: [ "      # Mensagem para apresentar o vetor digitado
    msg_saida_vetor_deslocado:  .asciiz "\nVetor deslocado: [ "     # Mensagem para apresentar o vetor deslocado

    # Outras strings
    fim_vetor:  .asciiz "]\n"   # Mensagem para indicar o fim de um vetor
    espaco:     .asciiz " "     # Espaco em branco
    new_line:   .asciiz "\n"    # Comando new line

.text
    main:
        # Realizar leitura de n
	li $v0, 4		        # Codigo syscall para escrita de string
	la $a0, msg_entrada_n		# Carrega em $a0 o endereço de msg_entrada_n
	syscall			        # Imprime msg_entrada_n
	li $v0, 5		        # Codigo syscall para leitura de inteiro
	syscall			        # Realiza a leitura de n
	add $s0, $v0, $zero	    	# $s0 = n
	
        # Variavel comum
	move $a1, $s0	# $a1 = n

	# Alocar memoria para o vetor
	jal aloca_vetor         # Executa aloca_vetor
        move $s1, $v0           # $s1 -> array

        # Leitura dos elementos do array
	move $t0, $s1		        # $t0 recebe endereco da primeira posicao do vetor
	li $t1, 0		        # i = 0
	move $t2, $s0            	# $t2 = n
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

        # Leitura de k
        li $v0, 4		# Codigo syscall para escrita de string
	la $a0, msg_entrada_k	# Carrega em $a0 o endereço de msg_entrada_k
	syscall			# Imprime msg_entrada_k
	li $v0, 5		# Codigo syscall para leitura de inteiro
	syscall			# Realiza a leitura de n
	add $s2, $v0, $zero	# $s2 = k

        # Imprimir vetor digitado
	li $v0, 4			    # Codigo syscall para escrita de string
	la $a0, msg_saida_vetor_inicial	    # Carrega em $a0 o endereco de msg_saida_vetor_inicial
	syscall				    # Imrpime msg_saida_vetor_inicial
        move $a0, $s1                       # $a0 recebe endereco de array_principal
	jal imprime_vetor		    # Executa a funcao imprime_vetor
	li $v0, 4			    # Codigo syscall para escrita de string
	la $a0, fim_vetor		    # Carrega em $a0 o endereco de vetor_nao_ordenado
	syscall				    # Imprime vetor_nao_ordenado

        # Deslocar vetor
        move $a2, $s2               # $a2 = k
        move $a0, $s1               # $a0 recebe endereco de array_principal
        jal translocate             # Executa translocate

        # Imprimir vetor deslocado
        li $v0, 4			        # Codigo syscall para escrita de string
	la $a0, msg_saida_vetor_deslocado	# Carrega em $a0 o endereco de msg_saida_vetor_deslocado
	syscall				        # Imrpime msg_saida_vetor_deslocado
        move $a0, $s1                       	# $a0 recebe o endereco de array
	jal imprime_vetor		       	# Executa a funcao imprime_vetor
	li $v0, 4			       	# Codigo syscall para escrita de string
	la $a0, fim_vetor		        # Carrega em $a0 o endereco de vetor_nao_ordenado
	syscall				        # Imprime vetor_nao_ordenado

        li $v0, 10
        syscall
    
    ##################### FUNCOES #####################

	aloca_vetor:
        	# Variaveis:
        	#	$a1: tamanho do vetor
        	#   	$t0: tamanho da memoria para ser alocada
        
        	# Ajustar pilha
        	addi $sp, $sp, -8   # Ajusta a pilha para armazenar 2 itens
        	sw $t0, 0($sp)      # Armazena o valor de $t0
        	sw $a0, 4($sp)      # Armazena o valor de $a0

        	# Atribuicao de valores
        	mul $t0, $a1, 4     # $t0 = tamanho * 4
        	move $a0, $t0       # $a0 recebe o tamanho do vetor
        	li $v0, 9           # Codigo syscall para alocar memoria
        	syscall             # Aloca a memoria requisitada

        	# Restaurar valores da pilha
        	lw $t0, 0($sp)      # Restaura o valor de $t0
        	lw $a0, 4($sp)      # Restaura o valor de $a0
        	addi $sp, $sp, 8    # Ajusta a pilha para excluir 2 itens
        	jr $ra              # Retorno
    
    ######################################################################################################

	imprime_vetor:
		# Variaveis 
        	#   	$a0: vetor	
		#	$a1: tamanho do vetor
		#	$t0: endereco vetor
        	#   	$t1: elemento vetor
        	#	$t2: i
		
		# Ajustar pilha
		addi $sp, $sp, -16	# Ajusta a pilha para armazenar 4 itens
		sw $t0, 0($sp)		# Armazena o valor armazenado em $t0
		sw $t1, 4($sp)		# Armazena o valor armazenado em $t1
        	sw $t2, 8($sp)      	# Armazena o valor armazenado em $t2
        	sw $a0, 12($sp)    	# Armazena o valor armazenado em $a0
		
		# Atribuicao de valores
		move $t0, $a0	#$t0 recebe endereco do vetor
		li $t2, 0	# i = 0
		
		for_imprime_vetor:
			lw $t1, ($t0)                   # $t1 = array[i]
            		li $v0, 1                       # Codigo syscall para imprimir inteiros
            		move $a0, $t1                   # $a0 = array[i]
			syscall                         # Imrpime array[i]
            		li $v0, 4                       # Codigo syscall para imprimir string
            		la $a0, espaco                  # $a0 recebe endereco de espaco
            		syscall                         # Imprime espaco

            		addi $t0, $t0, 4                # Proxima posicao do vetor
            		addi $t2, $t2, 1                # i++
            		blt $t2, $a1, for_imprime_vetor	# Ir para for_imprime_vetor se i < tamanho

		# Restaurar valores da pilha
		lw $t0, 0($sp)		# Restaura o valor de $t0
		lw $t1, 4($sp)		# Restaura o valor de $t1
        	lw $t2, 8($sp)      	# Restaura o valor de $t2
        	lw $a0, 12($sp)     	# Restaura o valor de $a0
		addi $sp, $sp, 16	# Ajusta a pilha para excluir 4 itens
		jr $ra			# Retorno

    ######################################################################################################

	copia_vetor:
    		# Variaveis:
        	#   	$a0: vetor a ser copiado
        	#   	$a1: tamanho do vetor
        	#   	$t0: ponteiro para posicao incial de vetor_auxiliar
        	#   	$t1: i
        	#   	$t2: auxiliar

        	# Ajustar pilha
        	addi $sp, $sp, -20	# Ajusta a pilha para armazenar 5 itens
        	sw $t0, 0($sp)      	# Armazena o valor de $t0
        	sw $t1, 4($sp)      	# Armazena o valor de $t1
        	sw $t2, 8($sp)      	# Armazena o valor de $t2
        	sw $ra, 12($sp)     	# Armazena o valor de $ra
        	sw $a0, 16($sp)     	# Armazena o valor de $a0

        	# Atribuicao de valores
        	jal aloca_vetor		# Executa aloca_vetor
        	move $t0, $v0           # $t0 recebe endereco do novo array (array_auxiliar)
        	li $t1, 0               # i = 0

        	loop_copia_vetor:
        		bge $t1, $a1, return_copia	# Ir para return_copia se i > tamanho
            		lw $t2, ($a0)               	# aux = array_principal[i]
            		sw $t2, ($t0)               	# array_auxiliar[i] = aux
            		addi $a0, $a0, 4           	# Proxima posicao de array_principal
            		addi $t0, $t0, 4            	# Proxima posicao de array_auxiliar
            		addi $t1, $t1, 1            	# i++
            		j loop_copia_vetor          	# Volta para loop_copia_vetor

        	return_copia:
        		# Restaurar valores da pilha
           		lw $t0, 0($sp)      	# Restaura o valor de $t0
            		lw $t1, 4($sp)      	# Restaura o valor de $t1
            		lw $t2, 8($sp)      	# Restaura o valor de $t2
            		lw $ra, 12($sp)     	# Restaura o valor de $ra
            		lw $a0, 16($sp)     	# Restaura o valor de $a0
            		addi $sp, $sp, 20	# Ajusta a pilha para excluir 5 itens
            		jr $ra             	# Retorno

    ######################################################################################################
    
	translocate:
    		# Variaveis:
        	#	$a0: vetor a ser transladado
        	#   	$a1: tamanho do vetor
        	#   	$a2: delta
        	#   	$t0: array_auxiliar
        	#   	$t1: auxiliar para array_auxiliar
        	#   	$t2: i
        	#   	$t3: j
        	#   	$t4: auxiliar

		# Ajustar pilha
        	addi $sp, $sp, -28	# Ajusta a pilha para armazenar 7 itens
      		sw $t0, 0($sp)      	# Armazena o valor de $t0
        	sw $t1, 4($sp)      	# Armazena o valor de $t1
        	sw $t2, 8($sp)      	# Armazena o valor de $t2
        	sw $t3, 12($sp)     	# Armazena o valor de $t3
        	sw $t4, 16($sp)     	# Armazena o valor de $t4
        	sw $ra, 20($sp)     	# Armazena o valor de $ra
        	sw $a0, 24($sp)     	# Armazena o valor de $a0

            	# Atribuicao de valores
            	jal copia_vetor         # Executa copia_vetor 
            	move $t0, $v0           # $t0 recebe o endereco de vetor_auxiliar
            	li $t2, 0               # i = 0
            	bgt $a2, $a1, other_j	# Ir para other_j se delta > tamanho
            	move $t3, $a2           # j = delta
            	j for_translocate       # Ir para for_translocate

            	other_j:
                	sub $t3, $a2, $a1	# j = delta - tamanho
            
            	for_translocate:
                	bge $t2, $a1, return_translocate	# Ir para return_translocate se i >= tamanho
                	bge $t3, $a1, reset_j               	# Ir para reset_j se j >= size
                	mul $t4, $t3, 4                    	# aux = j * 4
                	add $t1, $t0, $t4                   	# $t1 recebe endereco de array_auxiliar[j]
                	lw $t4, ($t1)                       	# aux = array_auxiliar[j]
                	sw $t4, ($a0)                       	# array[i] = array_auxiliar[j]
                	addi $a0, $a0, 4                    	# Proxima posicao de array
                	addi $t2, $t2, 1                    	# i++
                	addi $t3, $t3, 1                    	# j++
                	j for_translocate                   	# Volta para for_translocate

                	reset_j:
                    		li $t3, 0           	# j = 0
                    		j for_translocate	# Volta para for_translocate
            
            	return_translocate:
                	# Restaurar pilha
                	lw $t0, 0($sp)      	# Restaura o valor de $t0
                	lw $t1, 4($sp)      	# Restaura o valor de $t1
                	lw $t2, 8($sp)      	# Restaura o valor de $t2
                	lw $t3, 12($sp)     	# Restaura o valor de $t3
                	lw $t4, 16($sp)     	# Restaura o valor de $t4
                	lw $ra, 20($sp)     	# Restaura o valor de $ra
                	lw $a0, 24($sp)     	# Restaura o valor de $a0
                	addi $sp, $sp, 28	# Ajusta a pilha para excluir 7 itens
                	jr $ra              	# Retorno
