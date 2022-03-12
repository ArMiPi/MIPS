#---------------------------------------------------------------------------------
# - Fazer a leitura de um valor n
# - Ler um vetor de n elementos (Vet)
# - Encontrar o valor e posicao do menor elemento de Vet
# - Encontrar o valor e posicao do maior elemento de Vet
#---------------------------------------------------------------------------------
# - OBS: Primeira posicao do vetor: 1
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
# void procuraMenor(int *vetor, int tamanho) {
# 	int menor = vetor[0];
# 	int pos = 0;
# 	for(int i = 1; i < tamanho; i++) {
# 		if(vetor[i] < menor) {
# 			menor = vetor[i];
# 			pos = i + 1;
# 		}
# 	}
# 
# 	printf("\nMenor elemento: %d", menor);
# 	printf("\nPosicao: %d\n", pos);
# }
# 
# void procuraMaior(int *vetor, int tamanho) {
# 	int maior = vetor[0];
# 	int pos = 0;
# 	for(int i = 1; i < tamanho; i++) {
# 		if(vetor[i] > maior) {
# 			maior = vetor[i];
# 			pos = i + 1;
# 		}
# 	}
# 
# 	printf("\nMaior elemento: %d", maior);
# 	printf("\nPosicao: %d\n", pos);
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
# 
# 	procuraMenor(Vet, n);
# 	procuraMaior(Vet, n);
# }
#---------------------------------------------------------------------------------

.data
    # Mensagens de entrada
    msg_entrada_n:              .asciiz "Entre com o valor de n: "              	# Mensagem para receber o valor de n
    msg_entrada_Vet:            .asciiz "\nEntre com os elementos de Vet:\n"     	# Mensagem para receber os elementos de Vet
    msg_inicio_elementoVetor:   .asciiz "vetor["				        # Inicio da mensagem para receber o valor de vetor[i]
	msg_fim_elementoVetor:		.asciiz "]: "				        # Final da mensagem para receber o valor de vetor[i]

    # Mensagens de saida
    msg_saida_menor_elemento:   .asciiz "\nMenor elemento: "      # Mensagem para apresentar o menor elemento de Vet
    msg_saida_maior_elemento:   .asciiz "\nMaior elemento: "      # Mensagem para apresentar o maior elemento de Vet
    msg_saida_elemento_pos:     .asciiz "Posicao: "               # Mensagem para apresentar a posicao de um elemento de Vet

    # Outras strings
    new_line:   .asciiz "\n"    # Comando new line

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
            move $s1, $v0       # $s1 -> Vet

        # Preencher Vet
            li $v0, 4		        # Codigo syscall para escrita de string
	    la $a0, msg_entrada_Vet     # Carrega em $a0 o endereco de msg_entrada_Vet
	    syscall			# Imprime msg_entrada_Vet
            move $a0, $s1               # $a0 recebe o endereco de Vet
            jal preenche_vetor          # Executa preenche_vetor

        # Encontrar menor
        move $a0, $s1                           # $a0 recebe endereco de Vet
        jal procura_menor                       # Executa procura_menor
        move $t0, $v0                           # $v0 recebe menor elemento
        move $t1, $v1                           # $t1 recebe posicao do menor elemento
        li $v0, 4		                # Codigo syscall para escrita de string
	    la $a0, msg_saida_menor_elemento    # Carrega em $a0 o endereco de msg_saida_menor_elemento
	    syscall			        # Imprime msg_saida_menor_elemento
        li $v0, 1                               # Codigo syscall para imprimir inteiro
        move $a0, $t0                           # $a0 recebe menor elemento
        syscall                                 # Imprime menor elemento
        li $v0, 4                               # Codigo syscall para imprimir string
        la $a0, new_line                        # Carrega em $a0 o endereco de new_line
        syscall                                 # Imprime new_line
        li $v0, 4                               # Codigo syscall para imprimir string
        la $a0, msg_saida_elemento_pos          # Carrega em $a0 o endereco de msg_saida_elemento_pos
        syscall                                 # Imprime msg_saida_elemento_pos
        li $v0, 1                               # Codigo syscall para imprimir inteiro
        move $a0, $t1                           # $a0 recebe posicao do menor elemento
        syscall                                 # Imprime posicao do menor elemento
        li $v0, 4                               # Codigo syscall para imprimir string
        la $a0, new_line                        # Carrega em $a0 o endereco de new_line
        syscall                                 # Imprime new_line

        # Encontrar maior elemento
        move $a0, $s1                           # $a0 recebe endereco de Vet
        jal procura_maior                       # Executa procura_maior
        move $t0, $v0                           # $v0 recebe maior elemento
        move $t1, $v1                           # $t1 recebe posicao do maior elemento
        li $v0, 4		                # Codigo syscall para escrita de string
	    la $a0, msg_saida_maior_elemento    # Carrega em $a0 o endereco de msg_saida_maior_elemento
	    syscall			        # Imprime msg_saida_maior_elemento
        li $v0, 1                               # Codigo syscall para imprimir inteiro
        move $a0, $t0                           # $a0 recebe maior elemento
        syscall                                 # Imprime maior elemento
        li $v0, 4                               # Codigo syscall para imprimir string
        la $a0, new_line                        # Carrega em $a0 o endereco de new_line
        syscall                                 # Imprime new_line
        li $v0, 4                               # Codigo syscall para imprimir string
        la $a0, msg_saida_elemento_pos          # Carrega em $a0 o endereco de msg_saida_elemento_pos
        syscall                                 # Imprime msg_saida_elemento_pos
        li $v0, 1                               # Codigo syscall para imprimir inteiro
        move $a0, $t1                           # $a0 recebe posicao do maior elemento
        syscall                                 # Imprime posicao do maior elemento
        li $v0, 4                               # Codigo syscall para imprimir string
        la $a0, new_line                        # Carrega em $a0 o endereco de new_line
        syscall                                 # Imprime new_line

        li $v0, 10  # Codigo syscall para encerrar programa
        syscall     # Encerra programa
    

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

    procura_menor:
        # Variaveis:
        #   $a0: vetor
        #   $a1: tamanho do vetor
        #   $t0: menor
        #   $t1: pos
        #   $t2: i
        #   $t3: auxiliar

        # Ajustar pilha
        addi $sp, $sp, -20  # Ajusta a pilha para armazenar 5 itens
        sw $t0, 0($sp)      # Armazena o valor de $t0
        sw $t1, 4($sp)      # Armazena o valor de $t1
        sw $t2, 8($sp)      # Armazena o valor de $t2
        sw $t3, 12($sp)     # Armazena o valor de $t3
        sw $a0, 16($sp)     # Armazena o valor de $a0

        # Atribuicao de valores
        lw $t0, ($a0)       # $t0 = vetor[0]
        li $t1, 1           # pos = 1
        li $t2, 2           # i = 2
        addi $a0, $a0, 4    # Proxima posicao do vetor

        loop_procura_menor:
            bgt $t2, $a1, return_procura_menor      # Ir para return_procura_menor se i > tamanho
            lw $t3, ($a0)                           # $t3 = vetor[i-1]
            bge $t3, $t0, next_loop_procura_menor   # Ir para next_loop_procura_menor se vetor[i-1] >= menor
            move $t0, $t3                           # menor = vetor[i-1]
            move $t1, $t2                           # pos = i

            next_loop_procura_menor:
                addi $a0, $a0, 4        # Proxima posicao do vetor
                addi $t2, $t2, 1        # i++
                j loop_procura_menor    # Ir para loop_procura_menor
        
        return_procura_menor:
            move $v0, $t0       # $v0 = menor
            move $v1, $t1       # $v1 = pos
            # Restaurar pilha
            lw $t0, 0($sp)      # Restaura o valor de $t0
            lw $t1, 4($sp)      # Restaura o valor de $t1
            lw $t2, 8($sp)      # Restaura o valor de $t2
            lw $t3, 12($sp)     # Restaura o valor de $t3
            lw $a0, 16($sp)     # Restaura o valor de $a0
            addi $sp, $sp, 20   # Ajusta a pilha para excluir 5 itens
            jr $ra              # Retorno

    ######################################################################################################

    procura_maior:
        # Variaveis:
        #   $a0: vetor
        #   $a1: tamanho do vetor
        #   $t0: maior
        #   $t1: pos
        #   $t2: i
        #   $t3: auxiliar

        # Ajustar pilha
        addi $sp, $sp, -20  # Ajusta a pilha para armazenar 5 itens
        sw $t0, 0($sp)      # Armazena o valor de $t0
        sw $t1, 4($sp)      # Armazena o valor de $t1
        sw $t2, 8($sp)      # Armazena o valor de $t2
        sw $t3, 12($sp)     # Armazena o valor de $t3
        sw $a0, 16($sp)     # Armazena o valor de $a0

        # Atribuicao de valores
        lw $t0, ($a0)       # $t0 = vetor[0]
        li $t1, 1           # pos = 1
        li $t2, 2           # i = 2
        addi $a0, $a0, 4    # Proxima posicao do vetor

        loop_procura_maior:
            bgt $t2, $a1, return_procura_maior      # Ir para return_procura_maior se i > tamanho
            lw $t3, ($a0)                           # $t3 = vetor[i-1]
            ble $t3, $t0, next_loop_procura_maior   # Ir para next_loop_procura_maior se vetor[i-1] >= maior
            move $t0, $t3                           # maior = vetor[i-1]
            move $t1, $t2                           # pos = i

            next_loop_procura_maior:
                addi $a0, $a0, 4        # Proxima posicao do vetor
                addi $t2, $t2, 1        # i++
                j loop_procura_maior    # Ir para loop_procura_maior
        
        return_procura_maior:
            move $v0, $t0       # $v0 = maior
            move $v1, $t1       # $v1 = pos
            # Restaurar pilha
            lw $t0, 0($sp)      # Restaura o valor de $t0
            lw $t1, 4($sp)      # Restaura o valor de $t1
            lw $t2, 8($sp)      # Restaura o valor de $t2
            lw $t3, 12($sp)     # Restaura o valor de $t3
            lw $a0, 16($sp)     # Restaura o valor de $a0
            addi $sp, $sp, 20   # Ajusta a pilha para excluir 5 itens
            jr $ra              # Retorno

    ######################################################################################################
