all: calc.l calc.y
	flex calc.l
	bison -dv calc.y
	gcc -o calc lex.yy.c calc.tab.c -lfl

clean: rm calc calc.output lex.yy.c calc.tab.h calc.tab.c
