all:
	nasm -g -f elf -l Calculator.lst Calculator.asm
	gcc -o Calculator Calculator.o
	rm Calculator.o
