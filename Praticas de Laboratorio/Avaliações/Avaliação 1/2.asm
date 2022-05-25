#---------------------------------------------------------------------------------
# - Realizar a leitura de um natural de no minimo 10 digitos
# - Verificar se e' um palindromo
#---------------------------------------------------------------------------------

.data
    # Mensagem de entrada
    msg_entrada_num: .asciiz "Entre com um natural com no minimo 10 digitos: "

    # Mensagem de saida
    msg_saida_palindromo: .asciiz "O numero fornecido e' um palindromo"
    msg_saida_nao_palindromo: .asciiz "O numero fornecido nao e' um palindromo"

    # Mensagem de erro
    msg_erro_numero: .asciiz "\nERRO: O numero deve ter no minimo 10 digitos\n\n"

    # String para armazenar o numero
    numero: .space 100

.text
    main:
        # Realizar leitura do numero
        la $a0, msg_entrada_num
        la $a1, numero
        jal ler_string

        # Verificar se o numero possui uma quantidade de digitos >= 10
        li $t0, 10
        la $a0, numero
        jal strlen
        blt $v0, $t0, erro_numero
        # Verificar se o numero possui uma quantidade par de digitos
        li $t0, 2
        div $v0, $t0
        mfhi $t0
        bnez $t0, nao_palindromo
        # Verificar se o numero e' palindromo
        la $a0, numero
        jal palindromo
        beqz $v0, nao_palindromo

        la $a0, msg_saida_palindromo
        li $v0, 4
        syscall
        j encerrar        

        nao_palindromo:
            la $a0, msg_saida_nao_palindromo
            li $v0, 4
            syscall
        
        encerrar:
            li $v0, 10
            syscall

        erro_numero:
            la $a0, msg_erro_numero
            li $v0, 4
            syscall
            j main

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
        jal strlen          # Executa strlen(string)
        move $t5, $v0       # $t5 = strlen(string)
        li $t6, 2           # aux = 2
        div $t4, $t5, $t6   # max = strlen(string) / 2

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
