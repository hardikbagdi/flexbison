%{
#include <stdio.h>
extern int yylineno; 
%}

%token TOK_SEMICOLON TOK_ADD TOK_SUB TOK_MUL TOK_DIV TOK_NUMINT TOK_NUMFLOAT TOK_PRINTVAR TOK_OPENCURL TOK_CLOSECURL TOK_MAIN TOK_INT TOK_FLOAT

%union{
        int int_val;
        float float_val;
}

/*%type <int_val> expr TOK_NUM*/
%type <int_val> expr  TOK_NUMINT
/* expr can be a float as well as an int. so it should be in both the rule? same hold for TOK_NUM*/
/*may be we need to define two seperate tokens for integer val and float val, */
%type <float_val> TOK_NUMFLOAT

%left TOK_ADD 
%left TOK_MUL 

%%

prog: TOK_MAIN TOK_OPENCURL stmts TOK_CLOSECURL
;
stmts: 
	| stmt TOK_SEMICOLON stmts
;
stmt:
	| expr  
	   | TOK_PRINTVAR expr  
		{
			//printf("%d\n",yylineno );
			fprintf(stdout, "the value is %d\n", $2);
		} 
;

expr: 	 
	expr TOK_ADD expr
	  {
		$$ = $1 + $3;
	  }
	| expr TOK_MUL expr
	  {
		$$ = $1 * $3;
	  }
	| TOK_NUMINT
	  { 	
		$$ = $1;
	  }
;


%%

int yyerror(char *s)
{
	printf("\nsyntax error on line no %d\n",yylineno);
	return 0;
}

int main()
{
   yyparse();
   return 0;
}
