#---------------------------------------------------------------------------------
# - Realizar a leitura de uma matriz A de inteiros de ordem 3x4
# - Realizar a leitura de um vetor V de 3 inteiros
# - Determinar o produto de A por V
#---------------------------------------------------------------------------------
# #include<stdio.h>
# #include<stdlib.h>
# 
# int indice(int totalColunas, int linha, int coluna) {
# 	return (totalColunas * linha) + coluna;
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
# void ler_vetor(int *V, int tamanho) {
# 	for(int i = 0; i < tamanho; i++) {
# 		printf("V[%d]: ", i);
# 		scanf("%d", &V[i]);
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
# void imprime_vetor(int *V, int tamanho) {
# 	for(int i = 0; i < tamanho; i++) {
# 		printf("%d ", V[i]);
# 	}
# }
# 
# void multiplica_matriz_vetor(int *M, int linhas, int colunas, int *V, int tamanho, int *R) {
# 	int position;
# 	
# 	for(int i = 0, somaColuna = 0; i < linhas; i++) {
# 		for(int j = 0; j < colunas; j++) {
# 			position = indice(colunas, i, j);
# 			
# 			somaColuna += M[position] * V[j];
# 		}
# 		R[i] = somaColuna;
# 		somaColuna = 0;
# 	}
# }
# 
# int main() {
# 	int M[12], V[3], R[4];
# 
# 	ler_matriz(M, 4, 3);
# 	printf("\n");
# 	ler_vetor(V, 3);
# 
# 	printf("\nM: \n");
# 	imprime_matriz(M, 4, 3);
# 
# 	printf("\n\nV: \n");
# 	imprime_vetor(V, 3);
# 	printf("\n");
# 
# 	multiplica_matriz_vetor(M, 4, 3, V, 3, R);
# 
# 	printf("\nR: \n");
# 	imprime_vetor(R, 4);
# 	printf("\n");
# }
#---------------------------------------------------------------------------------

.data
   # Matriz
   M: .space 48   # Vetor de inteiro com 12 posicoes
   V: .space 12   # Vetor de inteiro com 3 posicoes
   R: .space 16   # Vetor de inteiro com 4 posicoes

   # Strings de entrada
   msg_entrada_matriz:                 .asciiz "Entre com os elementos da matriz: \n"
   msg_entrada_elemento_matriz_inicio: .asciiz "M["
   msg_entrada_elemento_matriz_meio:   .asciiz "]["
   msg_entrada_elemento_matriz_fim:    .asciiz "]: "
   msg_entrada_vetor:                  .asciiz "\nEntre com os elementos do vetor: \n"
   msg_entrada_elemento_vetor_inicio:  .asciiz "V["
   msg_entrada_elemento_vetor_fim:     .asciiz "]: "

   # Strings de saida
   msg_saida_matriz:    .asciiz "\nM: \n"
   msg_saida_vetor:     .asciiz "\nV: \n"
   msg_saida_resultado: .asciiz "\n\nM.V:\n"

   # Outras strings
   espaco:     .asciiz " "
   new_line:   .asciiz "\n"

.text:
   main:
      # Ler elementos da matriz
      la $a0, msg_entrada_matriz
      li $v0, 4
      syscall
      la $a0, M
      li $a1, 4
      li $a2, 3
      jal ler_matriz
      
      # Ler elementos do vetor
      la $a0, msg_entrada_vetor
      li $v0, 4
      syscall
      la $a0, V
      li $a1, 3
      jal ler_vetor
      
      # Imprimir matriz lida
      la $a0, msg_saida_matriz
      li $v0, 4
      syscall
      la $a0, M
      li $a1, 4
      li $a2, 3
      jal imprime_matriz
      
      # Imprimir vetor lido
      la $a0, msg_saida_vetor
      li $v0, 4
      syscall
      la $a0, V
      li $a1, 3
      jal imprime_vetor

      # Gerar vetor resultante de M x V
      li $a0, 4
      li $a1, 3
      jal multiplica_matriz_vetor

      # Imprimir matriz resultante
      la $a0, msg_saida_resultado
      li $v0, 4
      syscall
      la $a0, R
      li $a1, 4
      li $a2, 1
      jal imprime_matriz

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

   ler_vetor:
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
         li $v0, 4					                  # Codigo syscall para escrita de string
         la $a0, msg_entrada_elemento_vetor_inicio # Carrega em $a0 o endereco de msg_entrada_elemento_vetor_inicio
         syscall					                     # Imprime msg_entrada_elemento_vetor_inicio
         li $v0, 1					                  # Codigo syscall para imprimir inteiro
         add $a0, $t1, $zero				            # $a0 recebe a posicao atual do vetor
         syscall					                     # Imprime a posicao atual a ser lida do vetor
         la $v0, 4					                  # Codigo syscall para escrita de string
         la $a0, msg_entrada_elemento_vetor_fim		# Carrega em $a0 o endereco de msg_entrada_elemento_vetor_fim
         syscall					                     # Imprime msg_entrada_elemento_vetor_fim
         li $v0, 5					                  # Codigo syscall para leitura de inteiro
         syscall					                     # Realiza a leitura de array[$t1]
         sw $v0, ($t0)					               # array[i] = numero digitado
         addi $t0, $t0, 4				               # Proxima posicao do vetor
         addi $t1, $t1, 1				               # i++
         blt $t1, $a1, loop_preenche_vetor	      # Retorna para o inicio do loop se i < tamanho
      
      # Restaurar pilha
      lw $t0, 0($sp)      # Restaura o valor de $t0
      lw $t1, 4($sp)      # Restaura o valor de $t1
      lw $a0, 8($sp)      # Restaura o valor de $a0
      lw $v0, 12($sp)     # Restaura o valor de $sp
      addi $sp, $sp, 16   # Ajusta a pilha para excluir 4 itens
      jr $ra              # Retorno

   ######################################################################################################

   imprime_vetor:
		# Variaveis 
      #  $a0: vetor	
		#  $a1: tamanho do vetor
		#	$t0: endereco vetor
      #  $t1: elemento vetor
      #	$t2: i
		
		# Ajustar pilha
		addi $sp, $sp, -16   # Ajusta a pilha para armazenar 4 itens
		sw $t0, 0($sp)		   # Armazena o valor armazenado em $t0
		sw $t1, 4($sp)		   # Armazena o valor armazenado em $t1
      sw $t2, 8($sp)      	# Armazena o valor armazenado em $t2
      sw $a0, 12($sp)    	# Armazena o valor armazenado em $a0
		
		# Atribuicao de valores
		move $t0, $a0  #$t0 recebe endereco do vetor
		li $t2, 0	   # i = 0
		
		for_imprime_vetor:
			lw $t1, ($t0)                    # $t1 = array[i]
         li $v0, 1                        # Codigo syscall para imprimir inteiros
         move $a0, $t1                    # $a0 = array[i]
			syscall                          # Imrpime array[i]
         li $v0, 4                        # Codigo syscall para imprimir string
         la $a0, espaco                   # $a0 recebe endereco de espaco
         syscall                          # Imprime espaco

         addi $t0, $t0, 4                 # Proxima posicao do vetor
         addi $t2, $t2, 1                 # i++
         blt $t2, $a1, for_imprime_vetor  # Ir para for_imprime_vetor se i < tamanho

		# Restaurar valores da pilha
		lw $t0, 0($sp)		# Restaura o valor de $t0
		lw $t1, 4($sp)		# Restaura o valor de $t1
      lw $t2, 8($sp)    # Restaura o valor de $t2
      lw $a0, 12($sp)   # Restaura o valor de $a0
		addi $sp, $sp, 16 # Ajusta a pilha para excluir 4 itens
		jr $ra			   # Retorno

   ######################################################################################################

   multiplica_matriz_vetor:
      # Variaveis:
      #  $a0: linhas
      #  $a1: colunas
      #  $s0: M
      #  $s1: V
      #  $s2: R
      #  $t0: i
      #  $t1: j
      #  $t2: indice
      #  $t3: somaColuna
      #  $t4: totalLinhas
      #  $t5: totalColunas
      #  $t6: auxiliar
      #  $t7: auxiliar
      #  $t8: auxiliar

      # Ajustar pilha
      addi $sp, $sp, -60
      sw $a0, 0($sp)
      sw $a1, 4($sp)
      sw $s0, 8($sp)
      sw $s1, 12($sp)
      sw $s2, 16($sp)
      sw $t0, 20($sp)
      sw $t1, 24($sp)
      sw $t2, 28($sp)
      sw $t3, 32($sp)
      sw $t4, 36($sp)
      sw $t5, 40($sp)
      sw $t6, 44($sp)
      sw $t7, 48($sp)
      sw $t8, 52($sp)
      sw $ra, 56($sp)

      # Atribuicao de valores
      la $s0, M      # $s0 recebe endereco de M
      la $s1, V      # $s1 recebe endereco de V
      la $s2, R      # $s2 recebe endereco de R
      li $t0, 0      # i = 0
      li $t1, 0      # j = 0
      move $t4, $a0  # $t4 = totalLinhas
      move $t5, $a1  # $t5 = totalColunas

      for_multiplica_matriz_vetor:
         bge $t0, $t4, return_multiplica_matriz_vetor
         li $t3, 0   # somaColuna = 0
         for_interno_multiplica_matriz_vetor:
            bge $t1, $t5, next_for_multiplica_matriz_vetor
            move $a0, $t5
            move $a1, $t0
            move $a2, $t1
            jal indice
            mul $t6, $v0, 4
            add $t6, $t6, $s0
            lw $t7, ($t6)
            mul $t6, $t1, 4
            add $t6, $t6, $s1
            lw $t8, ($t6)
            mul $t7, $t7, $t8
            add $t3, $t3, $t7
            addi $t1, $t1, 1
            j for_interno_multiplica_matriz_vetor
         next_for_multiplica_matriz_vetor:
            mul $t6, $t0, 4
            add $t6, $t6, $s2
            sw $t3, ($t6)
            addi $t0, $t0, 1
            li $t1, 0
            j for_multiplica_matriz_vetor
         
      return_multiplica_matriz_vetor:
         # Restaurar pilha
         lw $a0, 0($sp)
         lw $a1, 4($sp)
         lw $s0, 8($sp)
         lw $s1, 12($sp)
         lw $s2, 16($sp)
         lw $t0, 20($sp)
         lw $t1, 24($sp)
         lw $t2, 28($sp)
         lw $t3, 32($sp)
         lw $t4, 36($sp)
         lw $t5, 40($sp)
         lw $t6, 44($sp)
         lw $t7, 48($sp)
         lw $t8, 52($sp)
         lw $ra, 56($sp)
         addi $sp, $sp, 60
         jr $ra 
