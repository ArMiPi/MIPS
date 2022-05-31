#---------------------------------------------------------------------------------
# - Realizar a leitura de um natural n
# - Retornar o n-esimo termo da sequencia de Catalan
# - Sequencia de Catalan:
#   C(n) = { 
#            1, se n = 0
#            (2 * (2n - 1) / (n + 1)) * C(n - 1), se n > 0
#          }
#---------------------------------------------------------------------------------
.data
    # Mensagem de entrada
    msg_entrada_n: .asciiz "Entre com um natural n: "

    # Mensagens de saida
    msg_saida: .asciiz "O n-esimo termo da sequencia de Catalan e': "

.text
    # Leitura de n
    la $a0, msg_entrada_n
    li $v0, 4
    syscall
    li $v0, 5
    syscall

    # Calcular o n-esimo termo da sequencia
    move $a0, $v0
    li $t1, 2
    jal catalan

    # Apresentar resultado
    move $s0, $v0
    la $a0, msg_saida
    li $v0, 4
    syscall
    move $a0, $s0
    li $v0, 1
    syscall

    # Encerrar programa
    li $v0, 10
    syscall

##################### FUNCAO #####################

catalan:
    #---------------------------------------------------#
    # Calcula o $a0-esimo termo da sequencia de Catalan #
    #---------------------------------------------------#
    # Variavel:                                         #
    #   $a0: natural                                    #
    #---------------------------------------------------#
    # Retorno: Retorna em $v0 o valor calculado         #
    #---------------------------------------------------#

    # Ajustar pilha
    addi $sp, $sp, -12
    sw $a0, 0($sp)
    sw $t0, 4($sp)
    sw $ra, 8($sp)

    bnez $a0, calc_catalan
    li $v0, 1
    j return_catalan

    calc_catalan:
        mul $t0, $t1, $a0   # $t0 = 2 * n
        addi $t0, $t0, -1   # $t0 -= 1
        mul $t0, $t0, $t1   # $t0 *= 2
        addi $a0, $a0, -1
        jal catalan
        mul $v0, $v0, $t0   # $v0 = catalan(n-1) * $t0
        addi $a0, $a0, 2    # $a0 = n
        div $v0, $v0, $a0   # $v0 /= (n+1)

    return_catalan:
        # Restaurar pilha
        lw $a0, 0($sp)
        lw $t0, 4($sp)
        lw $ra, 8($sp)
        addi $sp, $sp, 12

        jr $ra
