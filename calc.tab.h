/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_CALC_TAB_H_INCLUDED
# define YY_YY_CALC_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    TOK_MAIN = 258,
    TOK_OPENCURL = 259,
    TOK_CLOSECURL = 260,
    TOK_PRINTVAR = 261,
    TOK_PRINTLN = 262,
    TOK_INT_KEYWORD = 263,
    TOK_FLOAT_KEYWORD = 264,
    TOK_NUM_INT = 265,
    TOK_NUM_FLOAT = 266,
    TOK_IDENTIFIER = 267,
    TOK_SEMICOLON = 268,
    TOK_ADD = 269,
    TOK_MUL = 270,
    TOK_EQUAL = 271
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE YYSTYPE;
union YYSTYPE
{
#line 142 "calc.y" /* yacc.c:1909  */

        int int_val;
        float float_val;
        char *string;
        int data_type;
         /* Structure to store identifiers, their respective values and datatypes */
         struct s_expr
         {               /*supposed that event a identifier will be a expr becuase, a variable might be referenced later on via the identifier */
             char *id_name; /* stores name of the identifiers */
             int type; /* type=0 symbolize int and type = 1 symbolize float*/
             int ival; /* Store int values */
             float fval; /* store float values */
   		/* data */
         }struct_expr; /* this is instance of s_expr data-type which will be used to declare a token */
    

#line 88 "calc.tab.h" /* yacc.c:1909  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_CALC_TAB_H_INCLUDED  */
