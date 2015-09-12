all: calc.l calc.y
	flex calc.l
	bison -dv calc.y
	gcc -o calc lex.yy.c calc.tab.c -lfl
