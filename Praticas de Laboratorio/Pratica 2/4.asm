#---------------------------------------------------------------------------------
# - Fazer a leitura de um valor n
# - Ler um vetor de n elementos (Vet)
# - Compactar o vetor, eliminando as posicoes elemento de valor igual a zero
#---------------------------------------------------------------------------------
# #include<stdio.h>
# #include<stdlib.h>
# 
# void preencheVetor(int *vetor, int tamanho) {
# 	for(int i = 0; i < tamanho; i++) {
# 		printf("vetor[%d]: ", i);
# 		scanf("%d", &vetor[i]);
# 	}
# }
# 
# int compactaVetor(int *vetor, int tamanho) {
# 	int zero = -1;
# 
# 	for(int i = 0; i < tamanho; i++) {
# 		if(vetor[i] == 0) {
# 			if(zero < 0) zero = i;
# 		}
# 		else {
# 			if(zero >= 0) {
# 				vetor[zero] = vetor[i];
# 				vetor[i] = 0;
# 				i = zero;
# 				zero = -1;
# 			}
# 		}
# 	}
# 
# 	zero = 0;
# 	while(vetor[zero] != 0) zero++;
# 
# 	return zero;
# }
# 
# void imprimeVetor(int *vetor, int tamanho) {
# 	printf("\n[ ");
# 	for(int i = 0; i < tamanho; i++) printf("%d ", vetor[i]);
# 	printf("]\n");
# }
# 
# int main() {
# 	int n;
# 	int *Vet;
# 
# 	printf("Entre com o valor de n: ");
# 	scanf("%d", &n);
# 
# 	Vet = (int *) malloc(n * sizeof(int));
# 
# 	preencheVetor(Vet, n);
# 	printf("\n");
# 
# 	int tam = compactaVetor(Vet, n);
# 
# 	printf("Vetor compactado: ");
# 	imprimeVetor(Vet, tam);
# }
#---------------------------------------------------------------------------------

.data
    # Mensagems de entrada
    msg_entrada_n:              .asciiz "Entre com o valor de n: "              	# Mensagem para receber o valor de n
    msg_entrada_Vet:           .asciiz "\nEntre com os elementos de Vet:\n"     	# Mensagem para receber os elementos de VetC
    msg_inicio_elementoVetor: 	.asciiz "vetor["				        # Inicio da mensagem para receber o valor de vetor[i]
	msg_fim_elementoVetor:		.asciiz "]: "				        # Final da mensagem para receber o valor de vetor[i]

    # Mensagem de saida
    msg_saida_resultado: .asciiz "\nVetor compactado: ["  # Mensagem para apresentar o retorno de compacta_vetor

    # Outras strings
    new_line:   .asciiz "\n"    # Comando new line
    fim_vetor:  .asciiz "]\n"   # Fim de um vetor
    espaco:     .asciiz " "     # Espaco

.text
    main:
        # Realizar leitura de n
	    li $v0, 4		        # Codigo syscall para escrita de string
	    la $a0, msg_entrada_n	# Carrega em $a0 o endereco de msg_entrada_n
	    syscall			# Imprime msg_entrada_n
	    li $v0, 5		        # Codigo syscall para leitura de inteiro
	    syscall			# Realiza a leitura de n
	    move $s0, $v0   	    	# $s0 = n
	
        # Variavel comum
	    move $a1, $s0	# $a1 = n
    
        # Alocar memoria para o Vet
	    jal aloca_vetor	# Executa aloca_vetor
            move $s1, $v0       # $s1 -> Vet

        # Preencher Vet
            li $v0, 4		        # Codigo syscall para escrita de string
	    la $a0, msg_entrada_Vet    	# Carrega em $a0 o endereco de msg_entrada_Vet
	    syscall			# Imprime msg_entrada_Vet
            move $a0, $s1               # $a0 recebe o endereco de Vet
            jal preenche_vetor          # Executa preenche_vetor

        # Vetor compactado
        jal compacta_vetor      # Executa compacta_vetor
        move $a1, $v0           # $a1 recebe o retorno de compacta_vetor

        li $v0, 4                       # Codigo syscall para imprimir string
        la $a0, msg_saida_resultado     # $a0 recebe o endereco de msg_saida_resultado
        syscall                         # Imprime msg_saida_resultado
        move $a0, $s1
        jal imprime_vetor               # Executa imprime_vetor
        li $v0, 4                       # Codigo syscall para imprimir string
        la $a0, fim_vetor               # $a0 recebe o endereco de fim_vetor
        syscall                         # Imprime fim_vetor

        li $v0, 10                      # Codigo syscall para encerrar o programa
        syscall                         # Encerra o programa
        
    ##################### FUNCOES #####################

    aloca_vetor:
        # Variaveis:
        #	$a1: tamanho do vetor
        #   $t0: tamanho da memoria para ser alocada
        
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

    preenche_vetor:
        # Variaveis:
        #   $a0: vetor
        #   $a1: tamanho do vetor
        #   $t0: endereco do vetor
        #   $t1: i

        # Ajustar pilha
        addi $sp, $sp, -16  # Ajusta a pilha para receber 4 itens
        sw $t0, 0($sp)      # Armazena o valor de $t0
        sw $t1, 4($sp)      # Armazena o valor de $t1
        sw $a0, 8($sp)      # Armazena o valor de $a0
        sw $v0, 12($sp)     # Armazena o valor de $v0

        # Atribuicao de valores
        move $t0, $a0   # $t0 recebe o endereco do vetor
        li $t1, 0       # i = 0

        loop_preenche_vetor:
            li $v0, 4					        # Codigo syscall para escrita de string
		    la $a0, msg_inicio_elementoVetor    	# Carrega em $a0 o endereco de msg_inicio_elementoVetor
		    syscall					# Imprime msg_inicio_elementoVetor
		    li $v0, 1					# Codigo syscall para imprimir inteiro
		    add $a0, $t1, $zero				# $a0 recebe a posicao atual do vetor
		    syscall					# Imprime a posicao atual a ser lida do vetor
		    la $v0, 4					# Codigo syscall para escrita de string
		    la $a0, msg_fim_elementoVetor		# Carrega em $a0 o endereco de msg_fim_elementoVetor
		    syscall					# Imprime msg_fim_elementoVetor
		    li $v0, 5					# Codigo syscall para leitura de inteiro
		    syscall					# Realiza a leitura de array[$t1]
            sw $v0, ($t0)					# array[i] = numero digitado
		    addi $t0, $t0, 4				# Proxima posicao do vetor
		    addi $t1, $t1, 1				# i++
		    blt $t1, $a1, loop_preenche_vetor		# Retorna para o inicio do loop se i < tamanho
        
        # Restaurar pilha
        lw $t0, 0($sp)      # Restaura o valor de $t0
        lw $t1, 4($sp)      # Restaura o valor de $t1
        lw $a0, 8($sp)      # Restaura o valor de $a0
        lw $v0, 12($sp)     # Restaura o valor de $sp
        addi $sp, $sp, 16   # Ajusta a pilha para excluir 4 itens
        jr $ra              # Retorno

    ######################################################################################################

    compacta_vetor:
        # Variaveis
        #   $a0: vetor
        #   $a1: tamanho do vetor
        #   $t0: i
        #   $t1: elemento do vetor
        #   $t2: limite do loop
        #   $t3: zero

        # Ajustar pilha
        addi $sp, $sp, -16  # Ajusta a pilha para armazenar 4 itens
        sw $t0, 0($sp)      # Armazena o valor de $t0
        sw $t1, 4($sp)      # Armazena o valor de $t1
        sw $t2, 8($sp)      # Armazena o valor de $t2
        sw $t3, 12($sp)     # Armazena o valor de $t3

        # Atribuicao de valores
        move $t0, $a0       # $t0 recebe endereco de vetor
        mul $t3, $a1, 4     # $t3 = tamanho * 4
        add $t2, $a0, $t3   # $t2 recebe endereco da posicao seguinte a ultima posicao do vetor
        li $t3, 0           # zero = 0

        loop_compacta_vetor:
            bge $t0, $t2, next_step_compacta_vetor  # Ir para next_step_compacta_vetor se $t0 >= $t2
            lw $t1, ($t0)                           # $t1 = vetor[i]
            bnez $t1, else_compacta_vetor           # Ir para else_compacta_vetor se vetor[i] != 0
            bnez $t3, next_loop_compacta_vetor      # Ir para next_loop_compacta_vetor se zero != 0
            move $t3, $t0                           # zero recebe endereco de vetor[i]
            j next_loop_compacta_vetor              # Volta para next_loop_compacta_vetor

            else_compacta_vetor:
                beqz $t3, next_loop_compacta_vetor  # Ir para next_loop_compacta_vetor se zero == 0
                sw $t1, ($t3)                       # vetor[zero] = vetor[i]
                sw $zero, ($t0)                     # vetor[i] = 0
                move $t0, $t3                       # i = zero
                li $t3, 0                           # zero = 0

            next_loop_compacta_vetor:
                addi $t0, $t0, 4        # Proxima posicao do vetor
                j loop_compacta_vetor   # Volta para loop_compacta_vetor

        next_step_compacta_vetor:
            move $t0, $a0   # $t0 recebe endereco de vetor

            li $t3, 0   # $t3 = 0
            while_compacta_vetor:
                lw $t1, ($t0)                       # $t1 recebe elemento do vetor
                beqz $t1, return_compacta_vetor     # Ir para return_compacta_vetor se $t1 == 0
                addi $t0, $t0, 4                    # Proxima posicao do vetor
                addi $t3, $t3, 1                    # $t3++
                bge $t0, $t2, return_compacta_vetor # Ir para return_compacta_vetor se $t0 >= $t2
                j while_compacta_vetor              # Volta para while_compacta_vetor
        
        return_compacta_vetor:
            move $v0, $t3                   # $v0 = $t3
            # Restaurar pilha
            lw $t0, 0($sp)      # Restaura o valor de $t0
            lw $t1, 4($sp)      # Restaura o valor de $t1
            lw $t2, 8($sp)      # Restaura o valor de $t2
            lw $t3, 12($sp)     # Restaura o valor de $t3
            addi $sp, $sp, 16   # Ajusta a pilha para excluir 4 itens
            jr $ra

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
