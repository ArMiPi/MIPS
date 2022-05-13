#---------------------------------------------------------------------------------
# - Realizar a leitura de duas strings (string1 e string2) de no maximo 100 caracteres
# - Intercalar string2 em string1 e armazenar o retorno em uma string3
# - Ex: string1 = "casa", string2 = "0123", string3 = "c0a1s2a3"
#---------------------------------------------------------------------------------
# #include<stdio.h>
# #include<stdlib.h>
# #include<string.h>
# 
# #define MAX_SIZE 100
# 
# void ler_string(char *string) {
# 	printf("Digite uma string: ");
# 	string = fgets(string, MAX_SIZE, stdin);
# 
# 	if(string[strlen(string) - 1] == '\n') string[strlen(string) - 1] = '\0';
# }
# 
# void intercalar(char *string1, char *string2, char *string3) {
# 	int size = strlen(string1) + strlen(string2);
# 	int i = 0, j = 0, k = 0;
# 
# 	while(k < size) {
# 		if(string1[i] != '\0') {
# 			string3[k] = string1[i];
# 			i++;
# 			k++;
# 		}
# 		if(string2[j] != '\0') {
# 			string3[k] = string2[j];
# 			j++;
# 			k++;
# 		}
# 	}
# 
# 	string3[k] = '\0';
# }
# 
# int main() {
# 	char string1[MAX_SIZE], string2[MAX_SIZE], string3[2*MAX_SIZE];
# 
# 	ler_string(string1);
# 	ler_string(string2);
# 
# 	printf("%s\n%s\n", string1, string2);
# 
# 	intercalar(string1, string2, string3);
# 
# 	printf("%s", string3);
# }
#---------------------------------------------------------------------------------

.data
    # Mensagens de entrada
    msg_entrada1: .asciiz "Insira a string 1: "     # Mensagem de entrada para a primeira string
    msg_entrada2: .asciiz "Insira a string 2: "     # Mensagem de entrada para a segunda string

    # Mensagem de saida
    msg_saida: .asciiz "String intercalada: "       # Mensagem para apresentar o resultado de intercala

    # Strings
    string1: .space 100     # String para receber no maximo 100 characteres
    string2: .space 100     # String para receber no maximo 100 characteres
    string3: .space 200     # String para receber no maximo 200 characteres

.text
    main:
        la $a0, msg_entrada1    # Carrega em $a0 o endereco de msg_entrada1
        la $a1, string1         # Carrega em $a1 o endereco de string1
        jal ler_string          # Executa a funcao ler_string
        la $a0, msg_entrada2    # Carrega em $a0 o endereco de msg_entrada2
        la $a1, string2         # Carrega em $a1 o endereco de string2
        jal ler_string          # Executa a funcao ler_string
        la $a0, string1         # Carrega em $a0 o endereco de string1
        la $a1, string2         # Carrega em $a1 o endereco de string2
        la $a2, string3         # Carrega em $a2 o endereco de string3
        jal intercalar          # Executa intercalar
        la $a0, msg_saida       # Carrega em $a0 o endereco de msg_saida
        li $v0, 4               # Codigo syscall para imprimir string
        syscall                 # Imprime msg_saida
        la $a0, string3         # Carrega em $a0 o endereco de string3
        li $v0, 4               # Codigo syscall para escrita de string
        syscall                 # Imprime string3
        li $v0, 10              # Codigo syscall para finalizar o programa
        syscall                 # Finaliza o programa

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

    intercalar:
        # Variaveis:
        #   $a0: string1
        #   $a1: string2
        #   $a2: string3
        #   $t0: size
        #   $t1: k
        #   $t2: auxiliar

        # Ajustar pilha
        addi $sp, $sp, -28      # Ajusta a pilha para armazenar 7 itens
        sw $t0, 0($sp)          # Armazena o valor de $t0
        sw $t1, 4($sp)          # Armazena o valor de $t1
        sw $t2, 8($sp)          # Armazena o valor de $t2
        sw $a0, 12($sp)         # Armazena o valor de $a0
        sw $a1, 16($sp)         # Armazena o valor de $a1
        sw $a2, 20($sp)         # Armazena o valor de $a2
        sw $ra, 24($sp)         # Armazena o valor de $ra

        # Atribuicao de valores
        li $t0, 0               # size = 0
        li $t1, 0               # k = 0

        jal strlen              # Executa strlen para string1
        add $t0, $t0, $v0       # size += strlen(string1)
        move $t2, $a0           # $t2 recebe o endereco de string1
        move $a0, $a1           # $a0 recebe o endereco de string2
        jal strlen              # Executa strlen para string2
        add $t0, $t0, $v0       # size += strlen(string2)
        move $a0, $t2           # $a0 recebe o endereco de string1

        while_intercalar:
            bge $t1, $t0, return_intercalar     # Ir para return_intercalar se k >= size
            lb $t2, ($a0)                       # $t2 = string1[i]
            beqz $t2, add_string2               # Ir para add_string2 se string[i] == 0
            sb $t2, ($a2)                       # string3[k] = string1[i]
            addi $a0, $a0, 1                    # i++
            addi $a2, $a2, 1                    # Proxima posicao de string
            addi $t1, $t1, 1                    # k++

            add_string2:
                lb $t2, ($a1)                   # $t2 = string2[j]
                beqz $t2, while_intercalar      # Ir para while_intercalar se string2[j] == 0
                sb $t2, ($a2)                   # string3[k] = string2[j]
                addi $a1, $a1, 1                # j++
                addi $a2, $a2, 1                # Proxima posicao de string
                addi $t1, $t1, 1                # k++
            j while_intercalar                  # Volta para while_intercalar
            
        return_intercalar:
            sb $zero, ($a2)     # Adiciona 0 no final de string3
            # Restaurar valores da pilha
            lw $t0, 0($sp)      # Restaura o valor de $t0
            lw $t1, 4($sp)      # Restaura o valor de $t1
            lw $t2, 8($sp)      # Restaura o valor de $t2
            lw $a0, 12($sp)     # Restaura o valor de $a0
            lw $a1, 16($sp)     # Restaura o valor de $a1
            lw $a2, 20($sp)     # Restaura o valor de $a2
            lw $ra, 24($sp)     # Restaura o valor de $ra
            addi $sp, $sp, 28   # Ajusta a pilha para excluir 7 itens
            jr $ra              # Retorno