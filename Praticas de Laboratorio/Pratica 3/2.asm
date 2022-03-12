#---------------------------------------------------------------------------------
# - Realizar a leitura de uma string
# - Verificar se e' um palindromo
#---------------------------------------------------------------------------------
# #include<stdio.h>
# #include<stdlib.h>
# #include<string.h>
# 
# #define MAX_SIZE 100
# 
# // Vetores contendo os codigos ASCII para vogais com acento
# int a[] = {131, 132, 133, 134, 142, 143, 160, 181, 182, 183, 198, 199, -1},
#     e[] = {130, 136, 137, 138, 144, 210, 211, 212, -1},
# 	i[] = {139, 140, 141, 161, 213, 214, 215, 216, 222, -1},
# 	o[] = {147, 148, 149, 153, 162, 224, 226, 227, 228, 229, -1},
# 	u[] = {129, 150, 151, 154, 163, 233, 234, 235, -1};
# 
# void ler_string(char *string) {
# 	printf("Digite uma string: ");
# 	string = fgets(string, MAX_SIZE, stdin);
# 
# 	if(string[strlen(string) - 1] == '\n') string[strlen(string) - 1] = '\0';
# }
# 
# int is_in(int value, int *vetor) {
# 	for(int i = 0; vetor[i] != -1; i++) {
# 		if(vetor[i] == value) return 1;
# 	}
# 
# 	return 0;
# }
# 
# void to_upper(char *string) {
# 	for(int j = 0; string[j] != '\0'; j++) {
# 		if(string[j] < 97) continue;
# 		else if(string[j] <= 122) string[j] -= 32;
# 		else if(is_in(string[j], a)) string[j] = 65;
# 		else if(is_in(string[j], e)) string[j] = 69;
# 		else if(is_in(string[j], i)) string[j] = 73;
# 		else if(is_in(string[j], o)) string[j] = 79;
# 		else if(is_in(string[j], u)) string[j] = 85;
# 	}
# }
# 
# int palindromo(char *string) {
# 	to_upper(string);
# 
# 	for(int i = 0; i < strlen(string)/2; i++) {
# 		if(string[i] != string[strlen(string) - i - 1]) return 0;
# 	}
# 
# 	return 1;
# }
# 
# int main() {
# 	char string[MAX_SIZE];
# 
# 	ler_string(string);
# 
# 	int is_palindromo = palindromo(string);
# 
# 	if(is_palindromo) printf("%s e' um palindromo\n", string);
# 	else printf("%s nao e' um palindromo\n", string);
# }
#---------------------------------------------------------------------------------

.data
    # Vetores auxiliares
    a: .word 131, 132, 133, 134, 142, 143, 160, 181, 182, 183, 198, 199, -1 # Codigo de a/A com acento ortografico
    e: .word 130, 136, 137, 138, 144, 210, 211, 212, -1                     # Codigo de e/E com acento ortografico
    i: .word 139, 140, 141, 161, 213, 214, 215, 216, 222, -1                # Codigo de i/I com acento ortografico
    o: .word 147, 148, 149, 153, 162, 224, 226, 227, 228, 229, -1           # Codigo de o/O com acento ortografico
    u: .word 129, 150, 151, 154, 163, 233, 234, 235, -1                     # Codigo de u/U com acento ortografico

    # Mensagem de entrada
    msg_entrada_str: .asciiz "Entre com uma string: "               # Mensagem para receber uma string

    # Mensagens de saida
    msg_saida_inicio:       .asciiz "\nA string "                   # Inicio da mensagem de saida
    msg_saida_verdadeiro:   .asciiz " e' um palindromo"             # Fim da mensagem de saida indicando que a string e' um palindromo
    msg_saida_falso:        .asciiz " nao e' um palindromo"         # Fim da mensagem de saida indicando que a string nao e' um palindromo

    # String
    string: .space 100  # String para receber no maximo 100 caracteres

.text
    main:
        la $a0, msg_entrada_str         # Carrega em $a0 o endereco de msg_entrada_str
        la $a1, string                  # Carrega em $a1 o endereco de string
        jal ler_string                  # Executa a funcao ler_string
        la $a0, string                	# $a0 recebe o endereco de string
        jal palindromo                  # Executa a funcao palindromo
        move $t0, $v0                   # $t0 recebe o retorno de palindromo
        li $v0, 4                       # Codigo syscall para imprimir string
        la $a0, msg_saida_inicio        # $a0 recebe o endereco de msg_saida_inicio
        syscall                         # Imprime msg_saida_inicio
        la $a0, string                  # $a0 recebe o endereco de string
        syscall                         # Imprime string
        beqz $t0, falso                 # Ir para falso se $t0 == 0
        la $a0, msg_saida_verdadeiro    # $a0 recebe o endereco de msg_saida_verdadeiro
        syscall                         # Imprime msg_saida_verdadeiro
        j end                           # Ir para end

        falso:
            la $a0, msg_saida_falso     # $a0 recebe o endereco de msg_saida_falso
            syscall                     # Imprime msg_saida_falso
        
        end:
            li $v0, 10                  # Codigo syscall para encerrar o programa
            syscall                     # Encerra o programa

    ##################### FUNCOES #####################

    ler_string:
        # Variaveis
        #   $a0: Mensagem para ler string
        #   $a1: String a ser lida
        #   $t0: Auxiliar
        
        # Ajustar pilha
        addi $sp, $sp, -8   # Ajusta a pilha para armazenar 2 itens
        sw $t0, 0($sp)      # Armazena o valor de $t0
        sw $ra, 4($sp)      # Armazena o valor de $ra

        li $v0, 4       # Codigo syscall para imprimir string
        syscall         # Imprime a string em $a0
        move $a0, $a1   # $a0 recebe o endereco da string a ser lida
        li $a1, 100     # Numero maximo de caracteres a serem lidos
        li $v0, 8       # Codigo syscall para leitura de string
        syscall         # Realiza a leitura de string

        jal strlen      # Executa strlen($a0)

        move $t0, $a0   # $t0 recebe endereco de string
        for_ultima_pos:
            ble $v0, 1, substituir  # Ir para substituir se $v0 <= 1
            addi $t0, $t0, 1        # Proxima posicao de string
            addi $v0, $v0, -1       # $v0--
            j for_ultima_pos        # Volta para for_ultima_pos

        substituir:
            sb $zero, ($t0)         # Substituir \n por \0

        # Restaurar pilha
        lw $t0, 0($sp)      # Restaura o valor de $t0
        lw $ra, 4($sp)      # Restaura o valor de $ra
        addi $sp, $sp, 8    # Ajusta a pilha para excluir 2 itens
        jr $ra              # Retorno

    ######################################################################################################

    strlen:
        # Variaveis:
        #   $a0: string
        #   $t0: size
        #   $t1: auxiliar

        # Ajustar pilha
        addi $sp, $sp, -12      # Ajusta a pilha para armazenar 3 itens
        sw $t0, 0($sp)          # Armazena o valor de $t0
        sw $t1, 4($sp)          # Armazena o valor de $t1
        sw $a0, 8($sp)          # Armazena o valor de $a0

        # Atribuicao de valores
        li $t0, 0               # size = 0
        
        loop_strlen:
            lb $t1, ($a0)               # $t1 = string[i]
            beqz $t1, return_strlen     # Ir para return_strlen se $t1 == 0
            addi $a0, $a0, 1            # Proxima posicao de string
            addi $t0, $t0, 1            # size++
            j loop_strlen               # Volta para loop_strlen
        
        return_strlen:
            move $v0, $t0               # $v0 = size
            # Restaurar pilha
            lw $t0, 0($sp)              # Restaura o valor de $t0
            lw $t1, 4($sp)              # Restaura o valor de $t1
            lw $a0, 8($sp)              # Restaura o valor de $a0
            addi $sp, $sp, 12           # Ajusta a pilha para excluir 3 itens
            jr $ra                      # Retorno

    ######################################################################################################

    is_in:
        # Variaveis:
        #   $a0: value
        #   $a1: vetor
        #   $t0: elemento do vetor
        #   $t1: auxiliar

        # Ajustar pilha
        addi $sp, $sp, -12  # Ajusta a pilha para armazenar 3 itens
        sw $t0, 0($sp)      # Armazena o valor de $t0
        sw $t1, 4($sp)      # Armazena o valor de $t1
        sw $a0, 8($sp)      # Armazena o valor de $a0

        # Atribuicao de valores
        li $t1, -1      # aux = -1

        loop_is_in:
            lw $t0, ($a1)                           # $t0 = vetor[i]
            beq $t0, $t1, return_is_in_falso        # Ir para return_is_in_falso se vetor[i] == -1
            beq $t0, $a0, return_is_in_verdadeiro   # Ir para return_is_in_verdadeiro se vetor[i] == value
            addi $a0, $a0, 4                        # Proxima posicao do vetor
            j loop_is_in                            # Volta para loop_is_in
        
        return_is_in_falso:
            li $v0, 0       # $v0 = 0
            j return_is_in  # Ir para return_is_in
        
        return_is_in_verdadeiro:
            li $v0, 1       # $v0 = 1
        
        return_is_in:
            # Restaurar pilha
            lw $t0, 0($sp)      # Restaura o valor de $t0
            lw $t1, 4($sp)      # Restaura o valor de $t1
            lw $a0, 8($sp)      # Restaura o valor de $a0
            addi $sp, $sp, 12   # Ajusta a pilha para excluir 3 itens
            jr $ra              # Retorno

    ######################################################################################################

    to_upper:
        # Variaveis
        #   $a0: string
        #   $t0: apontador para string
        #   $t1: elemento de string
        #   $t2: min
        #   $t3: max
        #   $t4: auxiliar

        # Ajustar pilha
        addi $sp, $sp, -32  # Ajusta a pilha para armazenar 8 itens
        sw $t0, 0($sp)      # Armazena o valor de $t0
        sw $t1, 4($sp)      # Armazena o valor de $t1
        sw $t2, 8($sp)      # Armazena o valor de $t2
        sw $t3, 12($sp)     # Armazena o valor de $t3
        sw $t4, 16($sp)     # Armazena o valor de $t4
        sw $a0, 20($sp)     # Armazena o valor de $a0
        sw $a1, 24($sp)     # Armazena o valor de $a1
        sw $ra, 28($sp)     # Armazena o valor de $ra

        # Atribuicao de valores
        move $t0, $a0       # $t0 recebe o endereco de $a0

        loop_to_upper:
            lb $t1, ($t0)                       # $t1 = string[j]
            beqz $t1, return_to_upper           # Ir para return_to_upper se $t1 == '\0'

            # Verificacao se srting[j] < 97
            li $t2, 97                          # min = 97
            blt $t1, $t2, next_loop_to_upper    # Ir para next_loop_to_upper se string[j] < 97

            # Verificacao se string[j] <= 122
            li $t3, 122                         # max = 122
            bgt $t1, $t3, is_a                  # Ir para is_a se string[j] > max
            addi $t1, $t1, -32                  # $t1 -= 32
            sb $t1, ($t0)                       # string[j] = $t1
            j next_loop_to_upper                # Ir para next_loop_to_upper

            move $a0, $t1                       # $a0 = string[j]
            is_a:
                # Verificacao is_in(string[j], a)
                la $a1, a                           # $a1 recebe o endereco de a
                jal is_in                           # Executa funcao is_in
                beqz $v0, is_e                      # Ir para is_e se $v0 == 0
                li $t1, 65                          # $t1 = 65
                sb $t1, ($t0)                       # string[j] = 65
                j next_loop_to_upper                # Ir para next_loop_to_upper

            is_e:
                # Verificacao is_in(string[j], e)
                la $a1, e                           # $a1 recebe o endereco de e
                jal is_in                           # Executa funcao is_in
                beqz $v0, is_i                      # Ir para is_i se $v0 == 0
                li $t1, 69                          # $t1 = 69
                sb $t1, ($t0)                       # string[j] = 69
                j next_loop_to_upper                # Ir para next_loop_to_upper

            is_i:
                # Verificacao is_in(string[j], i)
                la $a1, i                           # $a1 recebe o endereco de i
                jal is_in                           # Executa funcao is_in
                beqz $v0, is_o                      # Ir para is_o se $v0 == 0
                li $t1, 73                          # $t1 = 73
                sb $t1, ($t0)                       # string[j] = 73
                j next_loop_to_upper                # Ir para next_loop_to_upper

            is_o:
                # Verificacao is_in(string[j], o)
                la $a1, o                           # $a1 recebe o endereco de o
                jal is_in                           # Executa funcao is_in
                beqz $v0, is_u                      # Ir para is_u se $v0 == 0
                li $t1, 79                          # $t1 = 79
                sb $t1, ($t0)                       # string[j] = 79
                j next_loop_to_upper                # Ir para next_loop_to_upper
            
            is_u:
                # Verificacao is_in(string[j], u)
                la $a1, u                           # $a1 recebe o endereco de u
                jal is_in                           # Executa funcao is_in
                beqz $v0, next_loop_to_upper        # Ir para next_loop_to_upper se $v0 == 0
                li $t1, 85                          # $t1 = 85
                sb $t1, ($t0)                       # string[j] = 85
            
            next_loop_to_upper:
                addi $t0, $t0, 1                # Proxima posicao de string
                j loop_to_upper                 # Volta para loop_to_upper
        
        return_to_upper:
            # Restaurar a pilha
            lw $t0, 0($sp)      # Restaura o valor de $t0
            lw $t1, 4($sp)      # Restaura o valor de $t1
            lw $t2, 8($sp)      # Restaura o valor de $t2
            lw $t3, 12($sp)     # Restaura o valor de $t3
            lw $t4, 16($sp)     # Restaura o valor de $t4
            lw $a0, 20($sp)     # Restaura o valor de $a0
            lw $a1, 24($sp)     # Restaura o valor de $a1
            lw $ra, 28($sp)     # Restaura o valor de $ra
            addi $sp, $sp, 32  # Ajusta a pilha para excluir 8 itens
            jr $ra              # Retorno


    ######################################################################################################
    
    palindromo:
        # Variaveis:
        #   $a0: string
        #   $t0: posicao inicial de string
        #   $t1: elemento de string
        #   $t2: elemento de string
        #   $t3: i
        #   $t4: max
        #   $t5: strlen(string)
        #   $t6: auxiliar

        # Ajustar pilha
        addi $sp, $sp, -32  # Ajusta a pilha para armazenar 8 itens
        sw $t0, 0($sp)      # Armazena o valor de $t0
        sw $t1, 4($sp)      # Armazena o valor de $t1
        sw $t2, 8($sp)      # Armazena o valor de $t2
        sw $t3, 12($sp)     # Armazena o valor de $t3
        sw $t4, 16($sp)     # Armazena o valor de $t4
        sw $t5, 20($sp)     # Armazena o valor de $t5
        sw $t6, 24($sp)     # Armazena o valor de $t6
        sw $ra, 28($sp)     # Armazena o valor de $ra

        # Atribuicao de valores
        move $t0, $a0       # $t0 recebe o endereco de $a0
        li $t3, 0           # i = 0
        jal strlen          # Execura strlen(string)
        move $t5, $v0       # $t4 = strlen(string)
        li $t6, 2           # aux = 2
        div $t4, $t5, $t6   # max = strlen(string) / 2

        jal to_upper        # Executa to_upper

        loop_palindromo:
            bge $t3, $t4, return_palindromo_verdadeiro  # Ir para return_palindromo_verdadeiro se i >= max
            lb $t1, ($t0)                               # $t1 = string[i]
            sub $t6, $t5, $t3                           # aux = strlen(string) - i
            addi $t6, $t6, -1                           # aux--
            move $t2, $a0                               # $t2 recebe o endereco da primeira posicao do vetor
            add $t2, $t2, $t6                           # $t2 = strlen(string) - i - 1
            lb $t6, ($t2)                               # aux = string[strlen(string) - i - 1]
            bne $t1, $t6, return_palindromo_falso       # Ir para return_palindromo_falso se string[i] != string[strlen(string) - i - 1]
            addi $t0, $t0, 1                            # Proxima posicao de string
            addi $t3, $t3, 1                            # i++
            j loop_palindromo                           # Volta para loop_palindromo
        
        return_palindromo_falso:
            li $v0, 0           # $v0 = 0
            j return_palindromo # Ir para return_palindromo
        
        return_palindromo_verdadeiro:
            li $v0, 1           # $v0 = 1
        
        return_palindromo:
            # Restaurar pilha
            lw $t0, 0($sp)      # Restaura o valor de $t0
            lw $t1, 4($sp)      # Restaura o valor de $t1
            lw $t2, 8($sp)      # Restaura o valor de $t2
            lw $t3, 12($sp)     # Restaura o valor de $t3
            lw $t4, 16($sp)     # Restaura o valor de $t4
            lw $t5, 20($sp)     # Restaura o valor de $t5
            lw $t6, 24($sp)     # Restaura o valor de $t6
            lw $ra, 28($sp)     # Restaura o valor de $ra
            addi $sp, $sp, 32   # Ajusta a pilha para excluir 8 itens
            jr $ra              # Retorno
