#---------------------------------------------------------------------------------
# - Fazer a leitura de um valor n
# - Ler dois vetores de n elementos (VetC, VetD)
# - Apresentar como saida um vetor (VetE) de tamanho 2n onde nas posicoes pares
#   estao os elementos de VetC e nas impares os de VetD
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
# void preencherUnion(int *vetor, int *vetorA, int*vetorB, int tamanho) {
# 	for(int i = 0, j = 0, k = 0; i < tamanho; i++) {
# 		if(i % 2 == 0) {
# 			vetor[i] = vetorA[j];
# 			j++;
# 		}
# 		else {
# 			vetor[i] = vetorB[k];
# 			k++;
# 		}
# 	}
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
# 	int *VetC, *VetD, *VetE;
# 
# 	printf("Entre com o valor de n: ");
# 	scanf("%d", &n);
# 
# 	VetC = (int *) malloc(n * sizeof(int));
# 	VetD = (int *) malloc(n * sizeof(int));
# 	VetE = (int *) malloc((2 * n) * sizeof(int));
# 
# 	preencheVetor(VetC, n);
# 	printf("\n");
# 	preencheVetor(VetD, n);
# 	printf("\n");
# 	
# 	preencherUnion(VetE, VetC, VetD, 2*n);
# 
# 	imprimeVetor(VetE, 2*n);
# }
#---------------------------------------------------------------------------------

.data
    # Mensagems de entrada
    msg_entrada_n:              .asciiz "Entre com o valor de n: "              	# Mensagem para receber o valor de n
    msg_entrada_VetC:           .asciiz "\nEntre com os elementos de VetC:\n"     	# Mensagem para receber os elementos de VetC
    msg_entrada_VetD:           .asciiz "\nEntre com os elementos de VetD:\n"     	# Mensagem para receber os elementos de VetD
    msg_inicio_elementoVetor: 	.asciiz "vetor["				        # Inicio da mensagem para receber o valor de vetor[i]
	msg_fim_elementoVetor:		.asciiz "]: "				        # Final da mensagem para receber o valor de vetor[i]


    # Mensagem de saida
    msg_saida_resultado: .asciiz "\nVetE: ["  # Mensagem para apresentar o retorno de preencher_union

    # Outras strings
    new_line:   .asciiz "\n"    # Comando new line
    fim_vetor:  .asciiz "]\n"   # Fim de um vetor
    espaco:     .asciiz " "     # Espaco

.text
    main:
        # Realizar leitura de n
	    li $v0, 4		        # Codigo syscall para escrita de string
	    la $a0, msg_entrada_n	# Carrega em $a0 o endereÃ§o de msg_entrada_n
	    syscall			# Imprime msg_entrada_n
	    li $v0, 5		        # Codigo syscall para leitura de inteiro
	    syscall			# Realiza a leitura de n
	    move $s0, $v0   	    	# $s0 = n
	
        # Variavel comum
	    move $a1, $s0	# $a1 = n
    
        # Alocar memoria para o VetC
	    jal aloca_vetor	# Executa aloca_vetor
            move $s1, $v0       # $s1 -> VetC

        # Alocar memoria para o VetD
	    jal aloca_vetor	# Executa aloca_vetor
       	    move $s2, $v0   	# $s2 -> VetD

        # Preencher VetC
            li $v0, 4		        # Codigo syscall para escrita de string
	    la $a0, msg_entrada_VetC    # Carrega em $a0 o endereco de msg_entrada_VetC
	    syscall			# Imprime msg_entrada_VetC
            move $a0, $s1               # $a0 recebe o endereco de VetC
            jal preenche_vetor          # Executa preenche_vetor

        # Preencher VetD
            li $v0, 4		        # Codigo syscall para escrita de string
	    la $a0, msg_entrada_VetD    # Carrega em $a0 o endereco de msg_entrada_VetD
	    syscall			# Imprime msg_entrada_VetD
            move $a0, $s2               # $a0 recebe o endereco de VetD
            jal preenche_vetor          # Executa preenche_vetor

        # Alocar memoria para o VetE
            mul $a1, $a1, 2 # $a1 = 2n
	    jal aloca_vetor	# Executa aloca_vetor
       	    move $s3, $v0   	# $s3 -> VetE

        # Preencher VetE
            move $a0, $s3       # $a0 recebe endereo de VetE
            move $a1, $s1       # $a1 recebe endereco de VetC
            move $a2, $s2       # $a2 recebe endereco de VetD
            mul $a3, $s0, 2     # $a3 = 2n
            jal preencher_union # Execute preencher_union
            move $t0, $v0

            li $v0, 4		        # Codigo syscall para escrita de string
	    la $a0, msg_saida_resultado	# Carrega em $a0 o endereÃ§o de msg_saida_resultado
	    syscall			# Imprime msg_saida_resultado
            move $a0, $t0       	# $a0 recebe o retorno de preencher_union
            move $a1, $a3       	# $a1 = 2n
            jal imprime_vetor   	# Executa imprime_vetor
            li $v0, 4		        # Codigo syscall para escrita de string
	    la $a0, fim_vetor		# Carrega em $a0 o endereÃ§o de fim_vetor
	    syscall			# Imprime fim_vetor

            li $v0, 10          # Codigo syscall para encerrar programa
            syscall             # Encerrar programa

    ##################### FUNCOES #####################

    aloca_vetor:
        # Variaveis:
        #   $a1: tamanho do vetor
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

    preencher_union:
        # Variaveis:
        #   $a0: VetE
        #   $a1: VetC
        #   $a2: VetD
        #   $a3: tamanho (VetC + VetD)
        #   $t0: i
        #   $t1: auxiliar

        # Ajustar pilha
        addi $sp, $sp, -20  # Ajusta a pilha para armazenar 5 itens
        sw $t0, 0($sp)      # Armazena o valor de $t0
        sw $t1, 4($sp)      # Armazena o valor de $t1
        sw $a0, 8($sp)      # Armazena o valor de $a0
        sw $a1, 12($sp)     # Armazena o valor de $a1
        sw $a2, 16($sp)     # Armazena o valor de $a2

        # Atribuicao de valores
        li $t0, 0   # i = 0

        loop_preencher_union:
            bge $t0, $a3, return_preencher_union    # Ir para return_preencher_union se i >= tamanho
            li $t1, 2                               # aux = 2
            div $t0, $t1                            # i / 2
            mfhi $t1                                # aux = i % 2
            bnez $t1, impar_pos                     # Ir para impar_pos se aux != 0
            lw $t1, ($a1)                           # aux = VetC[j]
            sw $t1, ($a0)                           # VectE[i] = aux
            addi $a1, $a1, 4                        # Proxima posicao de VetC
            j next_loop_preencher_union             # Ir para next_loop_preencher_union

            impar_pos:
                lw $t1, ($a2)                       # aux = VetD[k]
                sw $t1, ($a0)                       # VectE[i] = aux
                addi $a2, $a2, 4                    # Proxima posicao de VetD
                j next_loop_preencher_union         # Ir para next_loop_preencher_union
            
            next_loop_preencher_union:
                addi $t0, $t0, 1                    # i++
                addi $a0, $a0, 4                    # Proxima posicao de VetE
                j loop_preencher_union              # Ir para loop_preencher_union
            
            return_preencher_union:
                # Restaurar a pilha
                lw $t0, 0($sp)      # Restaura o valor de $t0
                lw $t1, 4($sp)      # Restaura o valor de $t1
                lw $a0, 8($sp)      # Restaura o valor de $a0
                lw $a1, 12($sp)     # Restaura o valor de $a1
                lw $a2, 16($sp)     # Restaura o valor de $a2
                addi $sp, $sp, 20   # Ajusta a pilha para excluir 5 itens
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
