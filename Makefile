all:
	nasm -g -f elf -l Calculator.lst Calculator.asm
	gcc -o Calculator Calculator.o
	#ld -s -o Calculator Calculator.o
	rm Calculator.o
