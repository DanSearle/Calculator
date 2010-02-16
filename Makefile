all:
	nasm -f elf -l Calculator.lst Calculator.asm
	gcc -o CalculatorASM Calculator.o
	rm Calculator.o
