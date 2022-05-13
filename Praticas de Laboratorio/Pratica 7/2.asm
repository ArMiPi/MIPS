#----------------------------------------------------------------------------------------
# - Criar uma copia de um arquivo texto substituindo todas as vogais por *
#----------------------------------------------------------------------------------------
# #include<stdio.h>
# #include<stdlib.h>
# 
# int is_in(int *vetor, int length, int valor)
# {
# 	for(int i = 0; i < length; i++) {
# 		if(vetor[i] == valor) return 1;
# 	}
# 
# 	return 0;
# }
# 
# int main() {
# 	char *arquivo = "texto.txt";
# 	char *copia = "texto_sem_vogais.txt";
# 
# 	int vogais[] = {65, 69, 73, 79, 85, 97, 101, 105, 111, 117};
# 
# 	FILE *fptr = fopen(arquivo, "r");
# 	if(fptr == NULL) exit(EXIT_FAILURE);
# 
# 	FILE *fprtrCopy = fopen(copia, "w");
# 	if(fprtrCopy == NULL) exit(EXIT_FAILURE);
# 
# 	char c;
# 	while(!feof(fptr)) {
# 		c = fgetc(fptr);
# 		
# 		if(is_in(vogais, 10, c)) c = '*';
# 
# 		fprintf(fprtrCopy, "%c", c);
# 	}
# 
# 	fclose(fptr);
# 	fclose(fprtrCopy);
# }
#----------------------------------------------------------------------------------------
.data
    # Vetor auxiliar
    vogais: .word 65, 69, 73, 79, 85, 97, 101, 105, 111, 117, -1

    # Mensagem de entrada
    msg_entrada_file: .asciiz "Entre com o nome do arquivo: "

    # Mensagem de erro
    msg_erro_file: .asciiz "ERRO: Nao foi possivel abrir o arquivo\n"

    # String
    string: .space 100
    buffer: .asciiz " "
    copia: .asciiz "file_copia.txt"

.text
    main:
        # Leitura do nome do arquivo
        la $a0, msg_entrada_file
        la $a1, string
        jal ler_string

        # Abrir arquivo informado
        la $a0, string  # Arquivo
        li $a1, 0       # Modo de abertura (Leitura)
        li $a2, 1       # Quantidade de caracteres por leitura

        jal fopen

        move $s0, $v0   # $s0 recebe arquivo

        # Criar arquivo para copia
        la $a0, copia       # Arquivo
        li $a1, 1           # Modo de abertura (Escrita)

        jal fopen

        move $s1, $v0   # $s1 recebe arquivo criado

        # Realizar copia substituindo as vogais por *
        move $a0, $s0   # Arquivo de leitura
        la $a1, buffer  # Buffer para armazenar o valor lido
        li $a2, 1       # Quantidade de caracteres a serem lidos

        jal fgetc
        move $t0, $v0
        
        for:
            beqz $t0, encerrar

            move $a0, $t0
            la $a1, vogais
            jal is_in

            beqz $v0, next_for

            li $t0, 42

            next_for:
                la $a1, buffer
                sb $t0, ($a1)
                # Realizar copia
                move $a0, $s1
                li $a2, 1
                li $v0, 15
                syscall

                move $a0, $s0
                la $a1, buffer
                li $a2, 1

                jal fgetc
                move $t0, $v0
                j for

        encerrar:
            # Fechar arquivos
            move $a0, $s0
            jal fclose

            move $a0, $s1
            jal fclose

            # Encerrar programa
            li $v0, 10
            syscall       
    
    ##################### FUNCOES #####################

    ler_string:
        #---------------------------------------------------------------------------#
        # Realiza a leitura de uma string e substitui \n do final da leitura por \0 #
        #---------------------------------------------------------------------------#
        # Variaveis:                                                                #
        #   $a0: Mensagem para ler a string                                         #
        #   $a1: string a ser lida                                                  #
        #   $t0: auxiliar                                                           #
        #---------------------------------------------------------------------------#
        # Retorno: Retorna $v0 a string lida                                        #
        #---------------------------------------------------------------------------#
        
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
        #-------------------------------------------------#
        # Indica o tamanho de uma string                  #
        #-------------------------------------------------#
        # Variaveis:                                      #
        #   $a0: string                                   #
        #   $t0: size                                     #
        #   $t1: auxiliar                                 #
        #-------------------------------------------------#
        # Retorno: Retorna em $v0 o tamanho de uma stirng #
        #-------------------------------------------------#

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

    fopen:
        #-----------------------------------------------------------#
        # Abre um arquivo em um modo especificado                   #
        #-----------------------------------------------------------#
        # Variaveis:                                                #
        #   $a0: Nome do arquivo                                    #
        #   $a1: Modo de abertura                                   #
        #-----------------------------------------------------------#
        # Retorno: Retorna em $v0 o arquivo aberto no modo indicado #
        #-----------------------------------------------------------#
        
        li $v0, 13  # Codigo syscall para abertura de arquivo
        syscall
        bgez $v0, return_fopen
        
        # Erro ao abrir o arquivo
        la $a0, msg_erro_file
        li $v0, 4
        syscall
        li $v0, 10
        syscall

        return_fopen:
            jr $ra

    ######################################################################################################

    fclose:
        #------------------#
        # Fecha um arquivo #
        #------------------#
        # Variaveis:       #
        #   $a0: Arquivo   #
        #------------------#

        li $v0, 16
        syscall

        jr $ra

    ######################################################################################################

    fgetc:
        #------------------------------------------------#
        # Realiza a leitura de um caracter de um arquivo #
        #------------------------------------------------#
        # Variaveis:                                     #
        #   $a0: Arquivo                                 #
        #   $a1: Buffer                                  #
        #   $a2: Bytes por leitura                       #
        #------------------------------------------------#
        # Retorno: Retorna em $v0 o valor do byte lido   #
        #------------------------------------------------#

        li $v0, 14  # Codigo syscall para leitura de arquivo
        syscall
        bnez $v0, return_cod
        j return_fgetc

        return_cod:
            lb $v0, ($a1)

        return_fgetc:
            jr $ra

    ######################################################################################################

    is_in:
        #----------------------------------------------------------------------------------#
        # Verifica se um inteiro pertence a um vetor                                       #
        #----------------------------------------------------------------------------------#
        # Variaveis:                                                                       #
        #   $a0: inteiro                                                                   #
        #   $a1: vetor                                                                     #
        #   $t0: elemento do vetor                                                         #
        #   $t1: auxiliar                                                                  #
        #----------------------------------------------------------------------------------#
        # Retorno: Retorna 0 em $v0 caso o inteiro nao pertenca ao vetor, 1 caso contrario #
        #----------------------------------------------------------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -12  # Ajusta a pilha para armazenar 3 itens
        sw $t0, 0($sp)      # Armazena o valor de $t0
        sw $t1, 4($sp)      # Armazena o valor de $t1
        sw $a1, 8($sp)      # Armazena o valor de $a0

        # Atribuicao de valores
        li $t1, -1      # aux = -1

        loop_is_in:
            lw $t0, ($a1)                           # $t0 = vetor[i]
            beq $t0, $t1, return_is_in_falso        # Ir para return_is_in_falso se vetor[i] == -1
            beq $t0, $a0, return_is_in_verdadeiro   # Ir para return_is_in_verdadeiro se vetor[i] == value
            addi $a1, $a1, 4                        # Proxima posicao do vetor
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
