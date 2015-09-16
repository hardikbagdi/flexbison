%{
#include <stdio.h>
extern int yylineno; 
%}

%token TOK_MAIN TOK_OPENCURL TOK_CLOSECURL TOK_PRINTVAR TOK_PRINTLN TOK_INT_KEYWORD TOK_FLOAT_KEYWORD TOK_NUM_INT TOK_NUM_FLOAT TOK_IDENTIFIER TOK_SEMICOLON TOK_ADD 
TOK_SUB TOK_MUL TOK_DIV TOK_NUM TOK_EQUAL

%union{
        int int_val;
        float float_val;
        char  *string;
}

/*%type <int_val> expr TOK_NUM*/
%type <int_val> expr  TOK_NUM_INT
/* expr can be a float as well as an int. so it should be in both the rule? same hold for TOK_NUM*/
/*may be we need to define two seperate tokens for integer val and float val, */
%type <float_val> TOK_NUM_FLOAT
%type <string> TOK_IDENTIFIER

%left TOK_ADD TOK_SUB
%left TOK_MUL TOK_DIV

%%

prog: TOK_MAIN TOK_OPENCURL stmts TOK_CLOSECURL
;

stmts: 
	| stmt TOK_SEMICOLON stmts
;

stmt:
      TOK_INT_KEYWORD TOK_IDENTIFIER           { fprintf(stdout,"\n\n\n\nDebugging,Tok_id in parser%s\n", $2);             }
    | TOK_FLOAT_KEYWORD TOK_IDENTIFIER         { fprintf(stdout,"\n\n\n\nDebugging,Tok_id in parser%s\n", $2);             }
    | TOK_IDENTIFIER TOK_EQUAL expr            { fprintf(stdout,"\n\n\n\nDebugging,Tok_id in parser%s\n", $1);             }
    | TOK_PRINTVAR TOK_IDENTIFIER              { /*printf("%d\n",yylineno );*/ fprintf(stdout, "the value is %d\n", $2);   }
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
	| TOK_NUM_INT
	  { 	
		$$ = $1;
	  }
        | TOK_NUM_FLOAT
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
