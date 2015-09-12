%{
#include <stdio.h>
#include <stdlib.h>
#include "calc.tab.h"
%}
digit	([0-9])
smallcase ([a-z])
smallcasedigit ([a-z0-9])
%option yylineno
%%

"printvar"       {      printf(" accepted printvar(debugging)"); return(TOK_PRINTVAR);}

"float"	 {return(TOK_FLOAT);}

{digit}+	{
		yylval.int_val=atoi(yytext);
		//sscanf(yytext, "%d", yylval);
		return TOK_NUMINT;
		}
{digit}+[.]{digit}+ {
					yylval.float_val=atof(yytext);
					//sscanf(yytext, "%f", yylval);
					return TOK_NUMFLOAT;
				}

"int"	 {return(TOK_INT);}
{smallcase}+{smallcasedigit}* { 		yylval.string=strdup(yytext);

					//sscanf(yytext, "%s", &yylval);
					printf(" accepted variable(debugging) %s",yytext);
					return(TOK_ID);
						}

";"	{	return(TOK_SEMICOLON);	}
"{" {return(TOK_OPENCURL);}
"}" {return(TOK_CLOSECURL);}
"main()" {printf(" accepted main(debugging)"); return(TOK_MAIN);}
"+"	{	return(TOK_ADD);	}
"-"	{	return(TOK_SUB);	}
"*"	{	return(TOK_MUL);	}
"/"	{	return(TOK_DIV);	}

[ \n] 	{}

.	{printf("Invalid character '%c', ignored\n", 
			yytext[0]);
	}

%%

//int main(){ yylex();
// printf(" lexical Analysisfinished ");return 0;}

