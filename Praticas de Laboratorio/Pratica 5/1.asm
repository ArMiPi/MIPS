#---------------------------------------------------------------------------------
# - Realizar a leitura de uma matriz de caracteres de ordem N (N <= 8)
# - Apresentar como saida a matriz codificada pelo codigo de Cesar de ordem 3
#---------------------------------------------------------------------------------
# #include<stdio.h>
# #include<stdlib.h>
# 
# int indice(int totalColunas, int linha, int coluna) {
# 	return (totalColunas * linha) + coluna;
# }
# 
# char *aloca_matriz(int linhas, int colunas) {
# 	char *matriz = (char *) malloc((linhas * colunas) * sizeof(char));
# 
# 	return matriz;
# }
# 
# void ler_matriz(char *M, int linhas, int colunas) {
# 	int position;
# 
# 	for(int i = 0; i < linhas; i++) {
# 		for(int j = 0; j < colunas; j++) {
# 			position = indice(colunas, i, j);
# 			printf("M[%d][%d]: ", i, j);
# 			scanf(" %c", &M[position]);
# 		}
# 	}
# }
# 
# void imprime_matriz(char *M, int linhas, int colunas) {
# 	int position;
# 	
# 	for(int i = 0; i < linhas; i++) {
# 		for(int j = 0; j < colunas; j++) {
# 			position = indice(colunas, i, j);
# 			printf("%c ", M[position]);
# 		}
# 		printf("\n");
# 	}
# }
# 
# void to_upper(char *A, int linhas, int colunas) {
# 	for(int i = 0; i < linhas * colunas; i++) if(A[i] >= 97 && A[i] <= 122) A[i] -= 32;
# }
# 
# void cifra_cesar(char *A, int linhas, int colunas, int deslocamento) {
# 	if(deslocamento == 0) return;
# 	
# 	int ascii;
# 	for(int i = 0; i < linhas * colunas; i++) {
# 		ascii = A[i];
#		ascii += deslocamento;
#		if(ascii > 90) ascii = 65 + (ascii - 91);
#		A[i] = ascii;
# 	}
# }
# 
# int main() {
# 	int dim;
# 	char *A;
# 
# 	printf("Entre com a dimensao da matriz: ");
# 	scanf("%d", &dim);
# 
# 	A = aloca_matriz(dim, dim);
# 	ler_matriz(A, dim, dim);
# 	to_upper(A, dim, dim);
# 
# 	printf("\nA: \n");
# 	imprime_matriz(A, dim, dim);
# 
# 	printf("\nMatriz cifrada: \n");
# 	cifra_cesar(A, dim, dim, 3);
# 	imprime_matriz(A, dim, dim);
# }
#---------------------------------------------------------------------------------
.data
    # Mensagem de entrada
    msg_entrada_dimensao:               .asciiz "Entre com a dimensao da matriz (MAX: 8): "
    msg_entrada_elemento_matriz_inicio: .asciiz "A["
    msg_entrada_elemento_matriz_meio:   .asciiz "]["
    msg_entrada_elemento_matriz_fim:    .asciiz "]: "

    # Mensagem de saida
    msg_saida_matriz:           .asciiz "\nA: \n"
    msg_saida_matriz_cifrada:   .asciiz "\nMatriz cifrada: \n"

    # Mensagem de erro
    msg_erro_dimensao: .asciiz "Erro: 0 < dimensao <= 8\n\n"

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
        li $t0, 8
        bgt $v0, $t0, erro_dimensao
        move $s0, $v0   # $s0 = dim

        # Alocar matriz
        move $a0, $s0
        move $a1, $s0
        jal aloca_matriz
        move $s1, $v0   # $a1 recebe o endereco de A

        # Ler elementos de A
        move $a0, $s1
        move $a1, $s0
        move $a2, $s0
        jal ler_matriz

        # Imprimir matriz lida
        la $a0, msg_saida_matriz
        li $v0, 4
        syscall
        move $a0, $s1
        jal imprime_matriz

        # Executar to_upper
        jal to_upper

        # Imprimir matriz
        la $a0, msg_saida_matriz
        li $v0, 4
        syscall
        move $a0, $s1
        jal imprime_matriz

        # Executar cifra_cesar
        move $a0, $s1
        li $a3, 3
        jal cifra_cesar

        # Imprimir matriz cifrada
        la $a0, msg_saida_matriz_cifrada
        li $v0, 4
        syscall
        move $a0, $s1
        jal imprime_matriz

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
        addi $t0, $t0, 1
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
                add $t6, $t6, $t3    # $t6 recebe o endereco de M[indice]
                # Ler e armazenar o elemento a ser inserido
                li $v0, 12
                syscall
                sb $v0, ($t6)
                la $a0, new_line
                li $v0, 4
                syscall
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
                add $t6, $t6, $t0
                lb $a0, ($t6)
                li $v0, 11
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

    to_upper:
        # Variaveis
        #   $a0: matriz
        #   $a1: linhas
        #   $a2: colunas
        #   $t0: apontador para string
        #   $t1: elemento de string
        #   $t2: min
        #   $t3: max
        #   $t4: tamanho

        # Ajustar pilha
        addi $sp, $sp, -20
        sw $t0, 0($sp)
        sw $t1, 4($sp)
        sw $t2, 8($sp)
        sw $t3, 12($sp)
        sw $t4, 16($sp)

        # Atribuicao de valores
        move $t0, $a0       # $a0 recebe endereco de matriz
        li $t2, 97          # min = 97
        li $t3, 122         # max = 122
        mul $t4, $a1, $a2   # tamanho = linhas * colunas

        for_to_upper:
            beqz $t4, return_to_upper
            lb $t1, ($t0)
            blt $t1, $t2, next_for_to_upper
            bgt $t1, $t3, next_for_to_upper
            addi $t1, $t1, -32
            sb $t1, ($t0)

            next_for_to_upper:
                addi $t0, $t0, 1
                addi $t4, $t4, -1
                j for_to_upper
        
        return_to_upper:
            # Restaurar pilha
            lw $t0, 0($sp)
            lw $t1, 4($sp)
            lw $t2, 8($sp)
            lw $t3, 12($sp)
            lw $t4, 16($sp)
            addi $sp, $sp, 20
            jr $ra

    ######################################################################################################

    cifra_cesar:
        # Variaveis:
        #   $a0: matriz
        #   $a1: linhas
        #   $a2: colunas
        #   $a3: deslocamento
        #   $t0: ascii
        #   $t1: tamanho
        #   $t2: max
        
        # Ajustar pilha
        addi $sp, $sp, -16
        sw $a0, 0($sp)
        sw $t0, 4($sp)
        sw $t1, 8($sp)
        sw $t2, 12($sp)

        beqz $a3, return_cifra_cesar

        # Atribuicao de valores
        mul $t1, $a1, $a2   # $t1 = linhas * colunas
        li $t2, 90          # $t2 = 90

        for_cifra_cesar:
            blez $t1, return_cifra_cesar
            lb $t0, ($a0)
            add $t0, $t0, $a3
            ble $t0, $t2, next_for_cifra_cesar
            addi $t0, $t0, -91
            add $t0, $t0, 65

            next_for_cifra_cesar:
                sb $t0, ($a0)
                addi $a0, $a0, 1
                addi $t1, $t1, -1
                j for_cifra_cesar
        
        return_cifra_cesar:
            # Restaurar pilha
            lw $a0, 0($sp)
            lw $t0, 4($sp)
            lw $t1, 8($sp)
            lw $t2, 12($sp)
            addi $sp, $sp, 16
            jr $ra
