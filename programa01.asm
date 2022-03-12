#------------------------------------------
# Programa que realiza a soma dos inteiros
# de 1 at� N, sendo N um valor de entrada
# digitado pelo usu�rio
#------------------------------------------

.data
	entrada:.asciiz"Entre com um n�mero inteiro (N > 1): "		# Mensagem para indicar qual a entrada do programa
	erro:.asciiz"O valor digitado N tem que ser maior que 1.\n"	# Mensagem indicando valor de entrada inv�lido
	resultado:.asciiz"\nA soma dos valores inteiros de 1 at� N = "	# Mensagem indicando o resultado da soma de 1 at� N

.text
	main:
		add  $t0, $zero, $zero	# Limpa o conte�do de $t0
		addi $t1, $zero, 1	# Inicia $t1 com 1
		
		soma_inteiros:
			li  $v0, 4			# C�digo SysCall para escrever strings
			la  $a0, entrada		# Par�metro(mensagem de entrada)
			syscall				# Escrever string entrada
			li  $v0, 5			# C�digo SysCall para ler inteiros
			syscall				# Leitura do inteiro fornecido pelo usu�rio
			add $s0, $v0, $zero		# Armazena em $s0 o inteiro fornecido
			blt $s0, 1, problema		# Verifica se $s0 < 1
		loop_soma:
			add  $t0, $t0, $t1		# $t0 += $t1
			addi $t1, $t1, 1		# $t1 += $t1
			ble  $t1, $s0, loop_soma	# Se $t1 <= $s0, retornar para o come�o do loop
			li   $v0, 4			# C�digo SysCall para escrever strings
			la   $a0, resultado		# Prar�metro(mensagem de resultado)
			syscall				# Escrever string resultado
			li   $v0, 1			# C�digo SysCall para escrever inteiros
			add  $a0, $t0, $zero		# Par�metro(soma dos inteiros de 1 a 100)
			syscall				# Escrever o resultado da soma
			li  $v0, 10			# C�digo SysCall para finalizar o programa
			syscall				# Finaliza o programa
		problema:
			li $v0, 4			# C�digo SysCall para escrever string
			la $a0, erro			# Par�metro(mensagem de erro)
			syscall				# Escrever a string erro
			j soma_inteiros			# Nova entrada de inteiro
