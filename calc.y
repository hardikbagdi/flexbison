%{
#include <stdio.h>
extern int yylineno; 
%}

%token TOK_SEMICOLON TOK_ADD TOK_SUB TOK_MUL TOK_DIV TOK_NUMINT TOK_NUMFLOAT TOK_PRINTLN TOK_OPENCURL TOK_CLOSECURL TOK_MAIN TOK_INT TOK_FLOAT

%union{
        int int_val;
        float float_val;
}

/*%type <int_val> expr TOK_NUM*/
%type <int_val> expr TOK_NUM TOK_INT
/* expr can be a float as well as an int. so it should be in both the rule? same hold for TOK_NUM*/
/*may be we need to define two seperate tokens for integer val and float val, */
%type <float_val> TOK_FLOAT

%left TOK_ADD 
%left TOK_MUL 

%%

prog: TOK_MAIN TOK_OPENCURL stmts TOK_CLOSECURL
;
stmts: 
	| stmt  stmts
;
stmt:
	| expr TOK_SEMICOLON stmt
	   | TOK_PRINTLN expr TOK_SEMICOLON 
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
	| expr TOK_SUB expr
	  {
		$$ = $1 - $3;
	  }
	| expr TOK_MUL expr
	  {
		$$ = $1 * $3;
	  }
	| expr TOK_DIV expr
	  {
		$$ = $1 / $3; 
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
