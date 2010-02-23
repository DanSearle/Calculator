all:
	nasm -g -f elf -l Calculator.lst Calculator.asm
	gcc -o Calculator Calculator.o
	rm Calculator.o
	rdoc --main CREADME.rdoc --op doc/
