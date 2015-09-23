all: compile_flex compile_bison link_flex_bison output

compile_flex:
	flex -l calc.l

compile_bison:
	bison -dv calc.y

link_flex_bison:
	gcc -o calc calc.tab.c lex.yy.c -lfl

output:
	./calc < input

clean:
	rm calc calc.output lex.yy.c calc.tab.h calc.tab.c
