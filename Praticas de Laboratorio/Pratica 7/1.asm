#----------------------------------------------------------------------------------------
# - Determinar se um numero e' gemeo (um numero é considerado gemeo se for primo e 
#   o próximo numero primo for igual a ele mais dois)
# - Ler um inteiro N
# - Salvar em um arquivo todos os numeros gemeos de 1 a N
#----------------------------------------------------------------------------------------
# #include<stdio.h>
# #include<stdlib.h>
# 
# int isPrime(int number) {
# 	for(int i = 2; i <= number/2; i++) {
# 		if(number % i == 0) return 0;
# 	}
# 
# 	return 1;
# }
# 
# int main() {
# 	char *arquivo = "numeros_gemeos.txt";
# 
# 	FILE *fptr = fopen(arquivo, "w");
# 	if(fptr == NULL) exit(EXIT_FAILURE);
# 
# 	int n;
# 	printf("Entre com um inteiro positivo N: ");
# 	scanf("%d", &n);
# 
# 	for(int i = 2; i <= n; i++) {
# 		if(isPrime(i) && isPrime(i+2)) fprintf(fptr, "(%d, %d)\n", i, i+2);
# 	}
#
#   fclose(fptr);
# }
#----------------------------------------------------------------------------------------
.data
    buffer: .space 20
    file: .asciiz "numeros_gemos.txt"

    # Mensagem de entrada
    msg_entrada_n: .asciiz "Entre com um inteiro positivo N: "

    # Mensagem saida arquivo
    msg_saida_inicio: .asciiz "("
    msg_saida_meio: .asciiz ", "
    msg_saida_fim: .asciiz ")\r\n"

    # Mensagens de erro
    msg_erro_entrada: .asciiz "ERRO: N deve ser um inteiro positivo\n\n"
    msg_erro_file: .asciiz "ERRO: Nao foi possivel abrir o arquivo\n\n"

.text
    main:
        la $a0, file    # Arquivo
        li $a1, 1       # Somente escrita
        jal fopen
    
        move $s0, $v0   # $s0 recebe arquivo

        # Leitura de N
        while_entrada:
            la $a0, msg_entrada_n
            li $v0, 4
            syscall
            li $v0, 5
            syscall

            move $s1, $v0   # $s1 = N

            bgtz $s1, end_while

            # Erro no valor de N
            la $a0, msg_erro_entrada
            li $v0, 4
            syscall
            j while_entrada

        end_while:

        li $t0, 2   # i = 2
        for:
            bgt $t0, $s1, end
            move $a0, $t0
            jal is_prime
            beqz $v0, next_for

            addi $t1, $t0, 2    # $t1 = i + 2
            move $a0, $t1
            jal is_prime
            beqz $v0, next_for

            # Escrever numeros gemeos em file
            move $a0, $s0
            la $a1, msg_saida_inicio    # Mensagem a ser escrita
            li $a2, 1                   # Quantidade de caracteres
            li $v0, 15                  # Codigo de escrita em arquivo
            syscall
            
            move $a1, $t0       # $a1 = i
            la $a2, buffer
            jal fprintf_number

            la $a1, msg_saida_meio    # Mensagem a ser escrita
            li $a2, 2                 # Quantidade de caracteres
            li $v0, 15                # Codigo de escrita em arquivo
            syscall

            move $a1, $t1       # $a1 = i + 2
            la $a2, buffer
            jal fprintf_number

            la $a1, msg_saida_fim   # Mensagem a ser escrita
            li $a2, 2               # Quantidade de caracteres
            li $v0, 15              # Codigo de escrita em arquivo
            syscall

            next_for:
                addi $t0, $t0, 1 # i++
                j for


        end:
            move $a0, $s0
            jal fclose

            # Encerrar programa
            li $v0, 10
            syscall

    ##################### FUNCOES #####################

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

    is_prime:
        #-------------------------------------------------------------------#
        # Determina se um numero e' primo                                   #
        #-------------------------------------------------------------------#
        # Variaveis:                                                        #
        #   $a0: Numero                                                     #
        #   $t0: i                                                          #
        #   $t1: limite                                                     #
        #   $t2: resto                                                      #
        #-------------------------------------------------------------------#
        # Retorno: Retorna em $v0 1 se o numero for primo, 0 caso contrario #
        #-------------------------------------------------------------------#
		
        # Ajustar pilha
        addi $sp, $sp, -12
        sw $t0, 0($sp)
        sw $t1, 4($sp)
        sw $t2, 8($sp)

        # Atribuicao de valores
        li $t0, 2           # i = 2
        div $t1, $a0, 2     # limite = numero / 2

        for_is_prime:
            bgt $t0, $t1, return_prime
            div $t2, $a0, $t0   # number / i
            mfhi $t2            # $t2 = number % i
            beqz $t2, return_not_prime
            addi $t0, $t0, 1    # i++
            j for_is_prime
        
        return_prime:
            li $v0, 1
            j return_is_prime
        
        return_not_prime:
            li $v0, 0
        
        return_is_prime:
            # Restaurar pilha
            lw $t0, 0($sp)
            lw $t1, 4($sp)
            lw $t2, 8($sp)
            addi $sp, $sp, 12

            jr $ra

    ######################################################################################################

    fprintf_number:
        #------------------------------------#
        # Escrever um numero em um arquivo   #
        #------------------------------------#
        # Variaveis:                         #
        #   $a0: Arquivo                     #
        #   $a1: Numero                      #
        #   $a2: Buffer                      #
        #   $t0: numero                      #
        #   $t1: resto                       #
        #   $t2: count                       #
        #   $t3: i                           #
        #------------------------------------#
        # Retorno: Sem retorno               #
        #------------------------------------#

        # Ajustar pilha
        addi $sp, $sp, -20
        sw $a2, 0($sp)
        sw $t0, 4($sp)
        sw $t1, 8($sp)
        sw $t2, 12($sp)
        sw $t3, 16($sp)

        # Atribuicao de valores
        move $t0, $a1
        li $t2, 0
        li $t3, 0

        while_fprintf_number:
            beqz $t0, string_number
            div $t0, $t0, 10    # numero = numero / 10
            mfhi $t1            # $t1 = numero % 10

            # Armazenar restos
            addi $sp, $sp, -4
            sw $t1, ($sp)
            addi $t2, $t2, 1

            j while_fprintf_number        

        string_number:
            beq $t3, $t2, end_fprintf_number
            # Recuperar o resto armazenado na pilha
            lw $t0, ($sp)
            addi $sp, $sp, 4

            # Converter de int para char
            addi $t0, $t0, 48

            # Armazenar numero em buffer
            sb $t0, ($a2)

            # Incrementar endereco de buffer
            addi $a2, $a2, 1

            addi $t3, $t3, 1    # i++

            j string_number

        end_fprintf_number:
            sb $zero, ($a2) # Terminar buffer com NULL

            lw $a2, 0($sp)  # Restaurar o ponteiro do buffer
            move $a1, $a2
            move $a2, $t2
            li $v0, 15
            syscall

            # Restaurar pilha
            lw $t0, 4($sp)
            lw $t1, 8($sp)
            lw $t2, 12($sp)
            lw $t3, 16($sp)
            addi $sp, $sp, 20

            jr $ra