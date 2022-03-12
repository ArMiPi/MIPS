#---------------------------------------------------------------------------------
# - Fazer a leitura de um valor n
# - Ler dois vetores de n elementos (VetA, VetB)
# - Realizar a soma dos elementos das posicoes pares de VetA (pares)
# - Realizar a soma dos elementso das posicoes impares de VetB (impares)
# - Retornar pares - impares
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
# int somaPares(int *vetor, int tamanho) {
# 	int soma = 0;
# 	for(int i = 0; i < tamanho; i += 2) soma += vetor[i];
# 
# 	return soma;
# }
# 
# int somaImpares(int *vetor, int tamanho) {
# 	int soma = 0;
# 	for(int i = 1; i < tamanho; i += 2) soma += vetor[i];
# 
# 	return soma;
# }
# 
# int diferencaParesAImparesB(int *vetorA, int *vetorB, int tamanho) {
# 	int pares = somaPares(vetorA, tamanho);
# 	int impares = somaImpares(vetorB, tamanho);
# 
# 	return pares - impares;
# }
# 
# int main() {
# 	int n;
# 	int *VetA, *VetB;
# 
# 	printf("Entre com o valor de n: ");
# 	scanf("%d", &n);
# 
# 	VetA = (int *) malloc(n * sizeof(int));
# 	VetB = (int *) malloc(n * sizeof(int));
# 
# 	preencheVetor(VetA, n);
# 	printf("\n");
# 	preencheVetor(VetB, n);
# 
# 	printf("Somatorio elementos posicoes pares VetA - Somatorio elementos posicoes pares VetB: %d", diferencaParesAImparesB(VetA, VetB, n));
# }
#---------------------------------------------------------------------------------

.data
    # Mensagems de entrada
    msg_entrada_n:              .asciiz "Entre com o valor de n: "              	# Mensagem para receber o valor de n
    msg_entrada_VetA:           .asciiz "\nEntre com os elementos de VetA:\n"     	# Mensagem para receber os elementos de VetA
    msg_entrada_VetB:           .asciiz "\nEntre com os elementos de VetB:\n"     	# Mensagem para receber os elementos de VetB
    msg_inicio_elementoVetor: 	.asciiz "vetor["				        # Inicio da mensagem para receber o valor de vetor[i]
	msg_fim_elementoVetor:		.asciiz "]: "				        # Final da mensagem para receber o valor de vetor[i]


    # Mensagem de saida
    msg_saida_resultado: .asciiz "\nSomatorio elementos posicoes pares VetA - Somatorio elementos posicoes pares VetB: "  # Mensagem para apresentar o retorno de diferenca_paresA_imparesB

    # Outras strings
    new_line:   .asciiz "\n"    # Comando new line
    fim_vetor:  .asciiz "]\n"   # Fim de um vetor

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
    
        # Alocar memoria para o VetA
	    jal aloca_vetor	# Executa aloca_vetor
            move $s1, $v0           # $s1 -> VetA

        # Alocar memoria para o VetB
	    jal aloca_vetor	# Executa aloca_vetor
       	    move $s2, $v0   # $s2 -> VetB

        # Preencher VetA
            li $v0, 4		        # Codigo syscall para escrita de string
	    la $a0, msg_entrada_VetA    # Carrega em $a0 o endereco de msg_entrada_VetA
	    syscall			# Imprime msg_entrada_VetA
            move $a0, $s1               # $a0 recebe o endereco de VetA
            jal preenche_vetor          # Executa preenche_vetor

        # Preencher VetB
            li $v0, 4		        # Codigo syscall para escrita de string
	    la $a0, msg_entrada_VetB    # Carrega em $a0 o endereÃ§o de msg_entrada_VetB
	    syscall			# Imprime msg_entrada_VetB
            move $a0, $s2               # $a0 recebe o endereco de VetB
            jal preenche_vetor          # Executa preenche_vetor

        # Executar diferenca_paresA_imparesB
           move $a0, $s1               		# $a0 recebe endereco de VetA
           move $a1, $s2               		# $a1 recebe endereco de VetB
           move $a2, $s0               		# $a2 = n
           jal diferenca_paresA_imparesB	# Executa diferenca_paresA_imparesB

           move $t0, $v0                   # $t0 recebe o retorno de diferenca_paresA_imparesB
           li $v0, 4                       # Codigo syscall para escrita de string
           la $a0, msg_saida_resultado     # $a0 recebe endereco de msg_saida_resultado
           syscall                         # Imprime msg_saida_resultado
           li $v0, 1                       # Codigo syscall para escrita de inteiro
           move $a0, $t0                   # $a0 recebe o retorno de diferenca_paresA_imparesB
           syscall                         # Imprime o retorno de diferenca_paresA_imparesB

           li $v0, 10          # Codigo syscall para encerrar o programa
           syscall             # Encerra o programa

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

    soma_pares:
        # Variaveis
        #   $a0: vetor
        #   $a1: tamanho do vetor
        #   $t0: soma
        #   $t1: i
        #   $t2: aux

        # Ajustar pilha
        addi $sp, $sp, -16  # Ajusta a pilha para armazenar 5 itens
        sw $t0, 0($sp)      # Armazena o valor de $t0
        sw $t1, 4($sp)      # Armazena o valor de $t1
        sw $t2, 8($sp)      # Armazena o valor de $t2
        sw $a0, 12($sp)     # Armazena o valor de $a0
        
        # Atribuicao de valores
        li $t0, 0   # soma = 0
        li $t1, 0   # i = 0

        loop_soma_pares:
            bge $t1, $a1, return_soma_pares     # Ir para return_soma_pares se i >= tamanho
            lw $t2, ($a0)                       # aux = vetor[i]
            add $t0, $t0, $t2                   # soma += vetor[i]
            addi $t1, $t1, 2                    # i += 2
            addi $a0, $a0, 8                    # Proxima posicao par do vetor
            j loop_soma_pares                   # Volta para loop_soma_pares
        
        return_soma_pares:
            move $v0, $t0       # $v0 = soma
            # Restaurar pilha
            lw $t0, 0($sp)      # Restaura o valor de $t0
            lw $t1, 4($sp)      # Restaura o valor de $t1
            lw $t2, 8($sp)      # Restaura o valor de $t2
            lw $a0, 12($sp)     # Restaura o valor de $a0
            addi $sp, $sp, 16   # Ajusta a pilha para excluir 4 itens
            jr $ra              # Retorno

    ######################################################################################################

    soma_impares:
        # Variaveis
        #   $a0: vetor
        #   $a1: tamanho do vetor
        #   $t0: soma
        #   $t1: i
        #   $t2: aux

        # Ajustar pilha
        addi $sp, $sp, -16  # Ajusta a pilha para armazenar 5 itens
        sw $t0, 0($sp)      # Armazena o valor de $t0
        sw $t1, 4($sp)      # Armazena o valor de $t1
        sw $t2, 8($sp)      # Armazena o valor de $t2
        sw $a0, 12($sp)     # Armazena o valor de $a0
        
        # Atribuicao de valores
        li $t0, 0           # soma = 0
        li $t1, 1           # i = 0
        addi $a0, $a0, 4    # Proxima posicao de vetor

        loop_soma_impares:
            bge $t1, $a1, return_soma_impares   # Ir para return_soma_impares se i >= tamanho
            lw $t2, ($a0)                       # aux = vetor[i]
            add $t0, $t0, $t2                   # soma += vetor[i]
            addi $t1, $t1, 2                    # i += 2
            addi $a0, $a0, 8                    # Proxima posicao par do vetor
            j loop_soma_impares                 # Volta para loop_soma_impares
        
        return_soma_impares:
            move $v0, $t0       # $v0 = soma
            # Restaurar pilha
            lw $t0, 0($sp)      # Restaura o valor de $t0
            lw $t1, 4($sp)      # Restaura o valor de $t1
            lw $t2, 8($sp)      # Restaura o valor de $t2
            lw $a0, 12($sp)     # Restaura o valor de $a0
            addi $sp, $sp, 16   # Ajusta a pilha para excluir 4 itens
            jr $ra              # Retorno
    
    ######################################################################################################

    diferenca_paresA_imparesB:
        # Variaveis:
        #   $a0: VetA
        #   $a1: VetB
        #   $a2: tamanho dos vetores
        #   $t0: pares
        #   $t1: impares
        #   $t2: auxiliar

        # Ajustar pilha
        addi $sp, $sp, -24  # Ajusta a pilha para armazenar 6 itens
        sw $t0, 0($sp)      # Armazena o valor de $t0
        sw $t1, 4($sp)      # Armazena o valor de $t1
        sw $t2, 8($sp)      # Armazena o valor de $t2
        sw $ra, 12($sp)     # Armazena o valor de $ra
        sw $a0, 16($sp)     # Armazena o valor de $a0
        sw $a1, 20($sp)     # Armazena o valor de $a1

        # Atribuicao de valores
        move $t2, $a1   # aux recebe endereco de VetB
        move $a1, $a2   # $a1 = tamanho do vetor
        jal soma_pares  # Executa soma_pares
        move $t0, $v0   # pares = soma_pares(VetA, tamanho)

        move $a0, $t2       # $a0 recebe o endereco de VetB
        jal soma_impares    # Executa soma_impares
        move $t1, $v0       # impares = soma_impares(VetB, tamanho)

        sub $v0, $t0, $t1   # $v0 = pares - impares

        # Restaurar pilha
        lw $t0, 0($sp)      # Restaura o valor de $t0
        lw $t1, 4($sp)      # Restaura o valor de $t1
        lw $t2, 8($sp)      # Restaura o valor de $t2
        lw $ra, 12($sp)     # Restaura o valor de $ra
        lw $a0, 16($sp)     # Restaura o valor de $a0
        lw $a1, 20($sp)     # Restaura o valor de $a1
        addi $sp, $sp, 24   # Ajusta a pilha para excluir 6 itens
        jr $ra              # Retorno

    ######################################################################################################
