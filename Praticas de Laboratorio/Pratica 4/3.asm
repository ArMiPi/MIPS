#---------------------------------------------------------------------------------
# - Realizar a leitura de uma matriz Amxn de inteiros
# - imprimir o número de linhas e o numero de colunas nulas da matriz
#---------------------------------------------------------------------------------
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
# int verifica_linha(int *matriz, int linha, int colunas) {
# 	int soma = 0;
# 	int posicao;
#	
# 	for(int j = 0; j < colunas; j++) {
# 		posicao = indice(colunas, linha, j);
# 		soma += matriz[posicao];
# 	}
#
# 	return soma;
# }
#
# int verifica_coluna(int *matriz, int coluna, int linhas) {
# 	int soma = 0;
# 	int posicao;
#	
# 	for(int i = 0; i < linhas; i++) {
# 		posicao = indice(linhas, i, coluna);
# 		soma += matriz[posicao];
# 	}
#
# 	return soma;
# }
#
# void linhas_colunas_nulas(int *matriz, int linhas, int colunas) {
# 	int linhas_nulas = 0;
# 	int colunas_nulas = 0;
#
# 	for(int i = 0; i < linhas; i++) {
# 		if(verifica_linha(matriz, i, colunas) == 0) linhas_nulas++;
# 	}
#
# 	for(int j = 0; j < colunas; j++) {
# 		if(verifica_coluna(matriz, j, linhas) == 0) colunas_nulas++;
# 	}
#
# 	printf("\nEssa matriz possui %d linha(s) nula(s) e %d coluna(s) nula(s)\n", linhas_nulas, colunas_nulas);
# }
#
# int main() {
# 	int linhas, colunas;
# 	int *A;
#
# 	printf("Entre com o numero de linhas da matriz: ");
# 	scanf("%d", &linhas);
#
# 	printf("Entre com o numero de colunas da matriz: ");
# 	scanf("%d", &colunas);
#
# 	A = aloca_matriz(linhas, colunas);
# 	ler_matriz(A, linhas, colunas);
#
# 	printf("\nA: \n");
# 	imprime_matriz(A, linhas, colunas);
#
# 	linhas_colunas_nulas(A, linhas, colunas);
# }
#---------------------------------------------------------------------------------

.data:
    # Strings de entrada
    msg_entrada_linhas:                 .asciiz "Entre com o numero de linhas da matriz: "
    msg_entrada_colunas:                .asciiz "Entre com o numero de colunas da matriz: "
    msg_entrada_elemento_matriz_inicio: .asciiz "A["
    msg_entrada_elemento_matriz_meio:   .asciiz "]["
    msg_entrada_elemento_matriz_fim:    .asciiz "]: "

    # Strings de saida
    msg_saida_matriz:   .asciiz "\nA: \n"
    msg_saida_inicio:   .asciiz "\nEssa matriz possui "
    msg_saida_meio:     .asciiz " linha(s) nula(s) e "
    msg_saida_fim:      .asciiz " coluna(s) nula(s)\n"

    # Outras strings
    espaco:     .asciiz " "
    new_line:   .asciiz "\n"

.text:
    main:
    # Ler tamanho da matriz
    la $a0, msg_entrada_linhas
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    move $s0, $v0   # $s0 = linhas
    
    la $a0, msg_entrada_colunas
    li $v0, 4
    syscall
    li $v0, 5
    syscall
    move $s1, $v0   # $s1 = colunas

    # Alocar matriz
    move $a0, $s0
    move $a1, $s1
    jal aloca_matriz
    move $s2, $v0   # $s2 recebe o endereco de A

    # Ler elementos da matriz
    move $a0, $s2
    move $a1, $s0
    move $a2, $s1
    jal ler_matriz

    # Imprimir matriz lida
    la $a0, msg_saida_matriz
    li $v0, 4
    syscall
    move $a0, $s2
    move $a1, $s0
    move $a2, $s1
    jal imprime_matriz

    # Realizar verificacao
    move $a0, $s2
    move $a1, $s0
    move $a2, $s1
    jal linhas_colunas_nulas

    # Encerrar programa
    li $v0, 10
    syscall

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
                mul $t6, $v0, 4      # $t6 = indice * 4
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
                mul $t6, $v0, 4
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

    verifica_linha:
        # Variaveis:
        #   $a0: matriz
        #   $a1: linha
        #   $a2: tamanho
        #   $s0: auxiliar matriz
        #   $s1: auxiliar tamanho
        #   $t0: soma
        #   $t1: posicao
        #   $t2: j
        #   $t3: auxiliar

        # Ajustar pilha
        addi $sp, $sp, -36
        sw $a0, 0($sp)
        sw $a2, 4($sp)
        sw $t0, 8($sp)
        sw $t1, 12($sp)
        sw $t2, 16($sp)
        sw $t3, 20($sp)
        sw $s0, 24($sp)
        sw $s1, 28($sp)
        sw $ra, 32($sp)

        # Atribuicao de valores
        move $s0, $a0   # $s0 recebe o endereco da matriz
        move $s1, $a2   # $s1 = tamanho
        li $t0, 0       # soma = 0
        li $t2, 0       # j = 0

        for_verifica_linha:
            bge $t2, $s1, return_verifica_linha
            move $a0, $s1   # $a0 = tamanho
            move $a2, $t2   # $a2 = j
            jal indice
            mul $t1, $v0, 4
            add $t1, $t1, $s0
            lw $t3, ($t1)
            add $t0, $t0, $t3
            addi $t2, $t2, 1
            j for_verifica_linha
        
        return_verifica_linha:
            move $v0, $t0
            # Restaurar pilha
            lw $a0, 0($sp)
            lw $a2, 4($sp)
            lw $t0, 8($sp)
            lw $t1, 12($sp)
            lw $t2, 16($sp)
            lw $t3, 20($sp)
            lw $s0, 24($sp)
            lw $s1, 28($sp)
            lw $ra, 32($sp)
            addi $sp, $sp, 36
            jr $ra

    ######################################################################################################

    verifica_coluna:
        # Variaveis:
        #   $a0: matriz
        #   $a1: coluna
        #   $a2: tamanho
        #   $s0: auxiliar matriz
        #   $s1: auxiliar coluna
        #   $s2: auxiliar tamanho
        #   $t0: soma
        #   $t1: posicao
        #   $t2: i
        #   $t3: auxiliar

        # Ajustar pilha
        addi $sp, $sp, -40
        sw $a0, 0($sp)
        sw $a2, 4($sp)
        sw $t0, 8($sp)
        sw $t1, 12($sp)
        sw $t2, 16($sp)
        sw $t3, 20($sp)
        sw $s0, 24($sp)
        sw $s1, 28($sp)
        sw $s2, 32($sp)
        sw $ra, 36($sp)

        # Atribuicao de valores
        move $s0, $a0   # $s0 recebe o endereco da matriz
        move $s1, $a1   # $s1 = coluna
        move $s2, $a2   # $s2 = tamanho
        li $t0, 0       # soma = 0
        li $t2, 0       # i = 0

        for_verifica_coluna:
            bge $t2, $s2, return_verifica_coluna
            move $a0, $s2   # $a0 = tamanho
            move $a1, $t2   # $a1 = i
            move $a2, $s1   # $a2 = coluna
            jal indice
            mul $t1, $v0, 4
            add $t1, $t1, $s0
            lw $t3, ($t1)
            add $t0, $t0, $t3
            addi $t2, $t2, 1
            j for_verifica_coluna
        
        return_verifica_coluna:
            move $v0, $t0
            # Restaurar pilha
            lw $a0, 0($sp)
            lw $a2, 4($sp)
            lw $t0, 8($sp)
            lw $t1, 12($sp)
            lw $t2, 16($sp)
            lw $t3, 20($sp)
            lw $s0, 24($sp)
            lw $s1, 28($sp)
            lw $s1, 32($sp)
            lw $ra, 36($sp)
            addi $sp, $sp, 40
            jr $ra

    ######################################################################################################

    linhas_colunas_nulas:
        # Variaveis:
        #   $a0: matriz
        #   $a1: linhas
        #   $a2: colunas
        #   $t0: linhas_nulas
        #   $t1: colunas_nulas
        #   $t2: i/j
        #   $t3: auxiliar linhas
        #   $t4: auxiliar colunas
        
        # Ajustar pilha
        addi $sp, $sp, -36
        sw $a0, 0($sp)
        sw $a1, 4($sp)
        sw $a2, 8($sp)
        sw $t0, 12($sp)
        sw $t1, 16($sp)
        sw $t2, 20($sp)
        sw $t3, 24($sp)
        sw $t4, 28($sp)
        sw $ra, 32($sp)

        # Atribuicao de valores
        li $t0, 0       # linhas_nulas = 0
        li $t1, 0       # colunas_nulas = 0
        li $t2, 0       # i = 0
        move $t3, $a1   # $t3 = linhas
        move $t4, $a2   # $t4 = colunas

        for_linhas_nulas:
            bge $t2, $t3, preparar_proximo_loop
            move $a1, $t2
            jal verifica_linha
            bnez $v0, next_for_linhas_nulas
            addi $t0, $t0, 1
            next_for_linhas_nulas:
                addi $t2, $t2, 1
                j for_linhas_nulas
        
        preparar_proximo_loop:
            li $t2, 0       # j = 0
            move $a2, $t3   # $a2 = linhas

        for_colunas_nulas:
            bge $t2, $t4, return_linhas_colunas_nulas
            move $a1, $t2
            jal verifica_coluna
            bnez $v0, next_for_colunas_nulas
            addi $t1, $t1, 1
            next_for_colunas_nulas:
                addi $t2, $t2, 1
                j for_colunas_nulas
        
        return_linhas_colunas_nulas:
            # Imprimir mensagem de saida
            la $a0, msg_saida_inicio
            li $v0, 4
            syscall
            move $a0, $t0
            li $v0, 1
            syscall
            la $a0, msg_saida_meio
            li $v0, 4
            syscall
            move $a0, $t1
            li $v0, 1
            syscall
            la $a0, msg_saida_fim
            li $v0, 4
            syscall

            # Restaurar pilha
            lw $a0, 0($sp)
            lw $a1, 4($sp)
            lw $a2, 8($sp)
            lw $t0, 12($sp)
            lw $t1, 16($sp)
            lw $t2, 20($sp)
            lw $t3, 24($sp)
            lw $t4, 28($sp)
            lw $ra, 32($sp)
            addi $sp, $sp, 36
            jr $ra
