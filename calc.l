%{
#include <stdio.h>
#include "calc.tab.h"
%}

digit	([0-9])
%option yylineno
%%

"println"       {       return(TOK_PRINTLN);}


{digit}+	{
		sscanf(yytext, "%d", &yylval);
		return TOK_NUMINT;
		}
{digit}+.{digit}+ {
		sscanf(yytext, "%f", &yylval);
		return TOK_NUMFLOAT;

				}

";"	{	return(TOK_SEMICOLON);	}
"{" {return(TOK_OPENCURL);}
"}" {return(TOK_CLOSECURL);}
"main()" {return(TOK_MAIN);}
"int" {return(TOK_INT);}
"float" {return(TOK_FLOAT);}
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

