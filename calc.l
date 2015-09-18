%{
#include <stdio.h>
#include <stdlib.h>
#include "calc.tab.h"
%}

digit           ([0-9])
characters      ([a-z])
smallcasedigit 	([a-z0-9])
identifier      ([a-z])(a-z0-9])*

%option yylineno

%%

"main()"               {    printf(" TOK_MAIN \n"); return(TOK_MAIN);                                                   }
"{"                    {    printf(" TOK_OPENCURL \n"); return(TOK_OPENCURL);                                           }
"}"                    {    printf(" TOK_CLOSECURL  \n"); return(TOK_CLOSECURL);                                        }
"printvar"             {    printf(" TOK_PRINTVAR \n"); return(TOK_PRINTVAR);                                           }
"println"              {    printf(" TOK_PRINTLN \n");return(TOK_PRINTLN);                                              }
"int"                  {    printf(" TOK_INT_KEYWORD \n");return(TOK_INT_KEYWORD);                                      }
"float"                {	printf(" TOK_FLOAT_KEYWORD \n");return(TOK_FLOAT_KEYWORD);                                  }
{digit}+               {	yylval.int_val=atoi(yytext);
                            /* sscanf(yytext, "%d", yylval); */ printf(" TOK_NUM_INT \n"); return TOK_NUM_INT;          }

{digit}+[.]{digit}+    {    yylval.float_val=atof(yytext); /* sscanf(yytext, "%f", yylval); */
                            printf(" TOK_NUM_FLOAT \n");return TOK_NUM_FLOAT;                                           }

{identifier}            {   yylval.string=strdup(yytext);printf(" TOK_IDENTIFIER %s\n",yytext); return(TOK_IDENTIFIER); }
";"                     {   printf(" TOK_SEMICOLON \n");return(TOK_SEMICOLON);                                          }
"+"                     {	printf(" TOK_ADD \n");return(TOK_ADD);                                                      }
"-"                     {	printf(" TOK_SUB \n");return(TOK_SUB);                                                      }
"*"                     {	printf(" TOK_MUL \n");return(TOK_MUL);                                                      }
"/"                     {	printf(" TOK_DIV \n");return(TOK_DIV);                                                      }
"="                     {   printf(" TOK_EQUAL \n");return(TOK_EQUAL);                                                  }
[ \n]                   {   printf("\n");                                                                               }
.                       {   printf("Invalid character '%c', ignored\n", yytext[0]);                                     }

%%

/*int main(){ yylex();
printf(" lexical Analysisfinished ");return 0;}*/


