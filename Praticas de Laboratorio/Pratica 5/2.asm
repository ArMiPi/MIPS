#----------------------------------------------------------------------------------------
# - Realizar a leitura de duas matrizes de inteiro de ordem N (N <= 6)
# - Apresentar como saida quantos valores estao na mesma posicao em ambas as matrizes
# - Apresentar a soma das posicoes (linha+coluna) de todos os elementos da saida anterior
#----------------------------------------------------------------------------------------
# #include<stdio.h>
# #include<stdlib.h>
# 
# int indice(int totalColunas, int linha, int coluna) {
# 	return (totalColunas * linha) + coluna;
# }
# 
# int *aloca_matriz(int linhas, int colunas) {
# 	int *matriz = (int *) malloc((linhas * colunas) * sizeof(int));
# 
# 	return matriz;
# }
# 
# void ler_matriz(int *M, int linhas, int colunas) {
# 	int position;
# 
# 	for(int i = 0; i < linhas; i++) {
# 		for(int j = 0; j < colunas; j++) {
# 			position = indice(colunas, i, j);
# 			printf("M[%d][%d]: ", i, j);
# 			scanf("%d", &M[position]);
# 		}
# 	}
# }
# 
# void imprime_matriz(int *M, int linhas, int colunas) {
# 	int position;
# 	
# 	for(int i = 0; i < linhas; i++) {
# 		for(int j = 0; j < colunas; j++) {
# 			position = indice(colunas, i, j);
# 			printf("%d ", M[position]);
# 		}
# 		printf("\n");
# 	}
# }
# 
# void iguais(int *A, int *B, int *R, int linhas, int colunas) {
# 	int position;
# 	for(int i = 0; i < linhas; i++) {
# 		for(int j = 0; j < colunas; j++) {
# 			position = indice(colunas, i, j);
# 			if(A[position] == B[position]) {
# 				R[0]++;
# 				R[1] += i + j;
# 			}
# 		}
# 	}
# }
# 
# int main() {
# 	int dim;
# 	int *A, *B;
# 	int R[] = {0, 0};
# 
# 	printf("Entre com a dimensao da matriz: ");
# 	scanf("%d", &dim);
# 
# 	A = aloca_matriz(dim, dim);
# 	ler_matriz(A, dim, dim);
# 	printf("\n");
# 	B = aloca_matriz(dim, dim);
# 	ler_matriz(B, dim, dim);
# 
# 	printf("\nA: \n");
# 	imprime_matriz(A, dim, dim);
# 
# 	printf("\nB: \n");
# 	imprime_matriz(B, dim, dim);
# 
# 	iguais(A, B, R, dim, dim);
# 	printf("Quantidade de elementos em posicoes iguais: %d\n", R[0]);
# 	printf("Soma das posicoes dos elementos em posicoes iguais: %d\n", R[1]);
# }
#----------------------------------------------------------------------------------------
.data
    # Mensagens de entrada
    msg_entrada_dimensao: .asciiz "Entre com a dimensao da matriz (MAX: 6): "
    msg_entrada_elemento_matriz_inicio: .asciiz "M["
    msg_entrada_elemento_matriz_meio:   .asciiz "]["
    msg_entrada_elemento_matriz_fim:    .asciiz "]: "

    # Mensagens de saida
    msg_saida_matriz_A:             .asciiz "\nA: \n"
    msg_saida_matriz_B:             .asciiz "\nB: \n"
    msg_saida_quantidade_iguais:    .asciiz "\nQuantidade de elementos iguais em posicoes iguais: "
    msg_saida_soma_posicoes_iguais: .asciiz "\nSoma das posicoes dos elementos iguais em posicoes iguais: "

    # Mensagem de erro
    msg_erro_dimensao: .asciiz "Erro: 0 < dimensao <= 6\n\n"
    
    # Outras strings
    espaco:     .asciiz " "
    new_line:   .asciiz "\n"

.text
    main:
        # Ler tamanho da matriz
        la $a0, msg_entrada_dimensao
        li $v0, 4
        syscall
        li $v0, 5
        syscall
        blez $v0, erro_dimensao
        li $t0, 6
        bgt $v0, $t0, erro_dimensao
        move $s0, $v0   # $s0 = dim

        # Alocar matriz A
        move $a0, $s0
        move $a1, $s0
        jal aloca_matriz
        move $s1, $v0   # $s1 recebe o endereco de A

        # Alocar matriz B
        move $a0, $s0
        jal aloca_matriz
        move $s2, $v0   # $s2 recebe o endereco de B

        # Ler elementos de A
        la $a0, msg_saida_matriz_A
        li $v0, 4
        syscall
        move $a0, $s1
        move $a1, $s0
        move $a2, $s0
        jal ler_matriz

        # Ler elementos de B
        la $a0, msg_saida_matriz_B
        syscall
        move $a0, $s2
        jal ler_matriz

        # Imprimir matriz A
        la $a0, msg_saida_matriz_A
        li $v0, 4
        syscall
        move $a0, $s1
        jal imprime_matriz

        # Imprimir matriz B
        la $a0, msg_saida_matriz_B
        syscall
        move $a0, $s2
        jal imprime_matriz

        # Executar iguais
        move $a0, $s1
        move $a1, $s2
        move $a2, $s0
        move $a3, $s0
        jal iguais

        move $s3, $v0   # $s3 = quantidade de elementos iguais em posicoes iguais
        move $s4, $v1   # $s4 = soma das posicoes dos elementos iguais em posicoes iguais
        
        # Exibir resultados
        la $a0, msg_saida_quantidade_iguais
        li $v0, 4
        syscall
        move $a0, $s3
        li $v0, 1
        syscall
        la $a0, new_line
        li $v0, 4
        syscall

        la $a0, msg_saida_soma_posicoes_iguais
        li $v0, 4
        syscall
        move $a0, $s4
        li $v0, 1
        syscall
        la $a0, new_line
        li $v0, 4
        syscall

        # Encerrar programa
        li $v0, 10
        syscall

        erro_dimensao:
            la $a0, msg_erro_dimensao
            li $v0, 4
            syscall
            j main

    ##################### FUNCOES #####################

    indice:
        # Variaveis
        #  $a0: totalColunas
        #  $a1: linha
        #  $a2: coluna
        #  $t0: resultado

        # Ajustar pilha
        addi $sp, $sp, -4
        sw $t0, 0($sp)

        mul $t0, $a0, $a1
        add $t0, $t0, $a2
        move $v0, $t0

        # Restaurar pilha
        lw $t0, 0($sp)
        addi $sp, $sp, 4
        jr $ra

    ######################################################################################################

    aloca_matriz:
        # Variaveis;
        #   $a0: linhas
        #   $a1: colunas
        #   $t0: tamanho da memoria a ser alocada

        # Ajustar pilha
        addi $sp, $sp, -4
        sw $t0, 0($sp)

        # Atribuicao de valores
        mul $t0, $a0, $a1
        mul $t0, $t0, 4
        move $a0, $t0
        li $v0, 9
        syscall

        # Restaurar pilha
        lw $t0, 0($sp)
        addi $sp, $sp, 4
        jr $ra

    ######################################################################################################

    ler_matriz:
        # Variaveis
        #  $a0: Matriz a ser lida
        #  $a1: Linhas
        #  $a2: Colunas
        #  $t0: i
        #  $t1: j
        #  $t2: position
        #  $t3: auxiliar matriz
        #  $t4: auxiliar linha
        #  $t5: auxiliar coluna
        #  $t6: auxiliar

        # Ajustar pilha
        add $sp, $sp, -44
        sw $a0, 0($sp)
        sw $a1, 4($sp)
        sw $a2, 8($sp)
        sw $t0, 12($sp)
        sw $t1, 16($sp)
        sw $t2, 20($sp)
        sw $t3, 24($sp)
        sw $t4, 28($sp)
        sw $t5, 32($sp)
        sw $t6, 36($sp)
        sw $ra, 40($sp)

        # Atribuicao de valores
        li $t0, 0
        li $t1, 0
        move $t3, $a0     # Auxiliar recebe endereco da matriz a ser lida
        move $t4, $a1     # $t4 = Linhas
        move $t5, $a2     # $t5 = Colunas

        # Loop para leitura da matriz
        for_ler_matriz:
            bge $t0, $t4, return_ler_matriz
            for_interno_ler_matriz:
                bge $t1, $t5, next_for_ler_matriz
                # Mensagem para leitura do elemento da matriz
                la $a0, msg_entrada_elemento_matriz_inicio
                li $v0, 4
                syscall
                move $a0, $t0
                li $v0, 1
                syscall
                la $a0, msg_entrada_elemento_matriz_meio
                li $v0, 4
                syscall
                move $a0, $t1
                li $v0, 1
                syscall
                la $a0, msg_entrada_elemento_matriz_fim
                li $v0, 4
                syscall
                # Calcular indice da matriz onde o valor lido sera armazenado
                move $a0, $t5        # $a0 = totalColunas
                move $a1, $t0        # $a1 = i
                move $a2, $t1        # $a2 = j
                jal indice
                move $t6, $v0        # $t6 = indice
                mul $t6, $t6, 4
                add $t6, $t6, $t3    # $t6 recebe o endereco de M[indice]
                # Ler e armazenar o elemento a ser inserido
                li $v0, 5
                syscall
                sw $v0, ($t6)
                addi $t1, $t1, 1
                j for_interno_ler_matriz
            next_for_ler_matriz:
                li $t1, 0
                addi $t0, $t0, 1
                j for_ler_matriz
      
        return_ler_matriz:
            # Restaurar pilha
            lw $a0, 0($sp)
            lw $a1, 4($sp)
            lw $a2, 8($sp)
            lw $t0, 12($sp)
            lw $t1, 16($sp)
            lw $t2, 20($sp)
            lw $t3, 24($sp)
            lw $t4, 28($sp)
            lw $t5, 32($sp)
            lw $t6, 36($sp)
            lw $ra, 40($sp)
            addi $sp, $sp, 44
            jr $ra

    ######################################################################################################

    imprime_matriz:
        # Variaveis:
        #  $a0: matriz
        #  $a1: linhas
        #  $a2: colunas
        #  $t0: endereco da matriz
        #  $t1: total de linhas
        #  $t2: total de colunas
        #  $t3: i
        #  $t4: j
        #  $t5: indice
        #  $t6: auxiliar

        # Ajustar pilha
        addi $sp, $sp, -44
        sw $a0, 0($sp)
        sw $a1, 4($sp)
        sw $a2, 8($sp)
        sw $t0, 12($sp)
        sw $t1, 16($sp)
        sw $t2, 20($sp)
        sw $t3, 24($sp)
        sw $t4, 28($sp)
        sw $t5, 32($sp)
        sw $t6, 36($sp)
        sw $ra, 40($sp)

        # Atribuicao de valores
        move $t0, $a0     # $t0 recebe endereco de M
        move $t1, $a1     # $t1 = linhas
        move $t2, $a2     # $t2 = colunas
        li $t3, 0         # i = 0
        li $t4, 0         # j = 0

        for_imprime_matriz:
            bge $t3, $t1, return_imprime_matriz
            for_interno_imprime_matriz:
                bge $t4, $t2, next_for_imprime_matriz
                # Calcular indice
                move $a0, $t2
                move $a1, $t3
                move $a2, $t4
                jal indice
                move $t6, $v0
                mul $t6, $t6, 4
                add $t6, $t6, $t0
                lw $a0, ($t6)
                li $v0, 1
                syscall
                la $a0, espaco
                li $v0, 4
                syscall
                addi $t4, $t4, 1
                j for_interno_imprime_matriz
            next_for_imprime_matriz:
                la $a0, new_line
                li $v0, 4
                syscall
                li $t4, 0
                addi $t3, $t3, 1
                j for_imprime_matriz
         
        return_imprime_matriz:
            # Ajustar pilha
            lw $a0, 0($sp)
            lw $a1, 4($sp)
            lw $a2, 8($sp)
            lw $t0, 12($sp)
            lw $t1, 16($sp)
            lw $t2, 20($sp)
            lw $t3, 24($sp)
            lw $t4, 28($sp)
            lw $t5, 32($sp)
            lw $t6, 36($sp)
            lw $ra, 40($sp)
            addi $sp, $sp, 44
            jr $ra

    ######################################################################################################

    iguais:
        # Variaveis:
        #   $a0: Matriz A
        #   $a1: Matriz B
        #   $a2: linhas
        #   $a3: colunas
        #   $t0: elemento de A
        #   $t1: elemento de B
        #   $t2: i
        #   $t3: j

        # Ajustar pilha
        addi $sp, $sp, -24
        sw $a0, 0($sp)
        sw $a1, 4($sp)
        sw $t0, 8($sp)
        sw $t1, 12($sp)
        sw $t2, 16($sp)
        sw $t3, 20($sp)

        # Atribuicao de valores
        li $v0, 0   # quantidade de elementos iguais em posicoes iguais
        li $v1, 0   # soma das posicoes dos elementos em posicoes iguais
        li $t3, 0   # i = 0
        li $t4, 0   # j = 0

        for_externo_iguais:
            bge $t3, $a2, return_iguais
            li $t4, 0

            for_interno_iguais:
                bge $t4, $a3, next_loop_iguais
                lw $t0, ($a0)
                lw $t1, ($a1)
                bne $t0, $t1, next_loop_interno_iguais
                addi $v0, $v0, 1
                add $v1, $v1, $t3
                add $v1, $v1, $t4

                next_loop_interno_iguais:
                    addi $a0, $a0, 4
                    addi $a1, $a1, 4
                    addi $t4, $t4, 1
                    j for_interno_iguais
            next_loop_iguais:
                addi $t3, $t3, 1
                j for_externo_iguais
        
        return_iguais:
            # Restaurar pilha
            lw $a0, 0($sp)
            lw $a1, 4($sp)
            lw $t0, 8($sp)
            lw $t1, 12($sp)
            lw $t2, 16($sp)
            lw $t3, 20($sp)
            addi $sp, $sp, 24
            jr $ra
