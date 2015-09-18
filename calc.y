%{
#include <stdio.h>
#include <stdlib.h>
extern int yylineno; 
typedef struct sym_node * SMT; 
SMT symboltablestart=NULL;
 struct sym_node
{
	SMT next;
	int type;
	char *id_name;
int ival;
float fval;
	/* data */
}sm_node;
// symbol table as a linkedlist of sym_node

// need to add methods here for inserting into the symbol table and looking up in the symbol table.


//made a sample insert. don't know if it works
SMT insert(SMT smt1,char* id,int typeofEXPR)
{

// need to check if already in the symbol table. that logic goes here and then only we will insert a new symbol



  //sym_node s= (smt)malloc()
SMT newnodepointer = (SMT)malloc(sizeof(sm_node));
newnodepointer->id_name=id;
newnodepointer->ival=42;//justa test case
newnodepointer->type=typeofEXPR;
newnodepointer->next=smt1;
smt1=newnodepointer;
return smt1;
}


//function to search in a symbol table



%}

%token TOK_MAIN TOK_OPENCURL TOK_CLOSECURL TOK_PRINTVAR TOK_PRINTLN TOK_INT_KEYWORD TOK_FLOAT_KEYWORD TOK_NUM_INT TOK_NUM_FLOAT TOK_IDENTIFIER TOK_SEMICOLON TOK_ADD 
TOK_SUB TOK_MUL TOK_DIV TOK_NUM TOK_EQUAL

%union{
        int int_val;
        float float_val;
        char  *string;
   	struct s_expr //structure to store value and data type ( can be of type int of float)
   	{               //supposed that event a identifier will be a expr becuase, a variable might be referenced later on via the identifier
   		char *string; //stores name of the variable
      int type;// type=0 is means int. ival will have the value. type=1 means float. fval will hold the value.
   		int ival; //store values
   		float fval;
   		/* data */
   	}struct_expr; //this is instance of s_expr data-type which will be used to declare a token
}

/*%type <int_val> expr TOK_NUM*/
%type <int_val>   TOK_NUM_INT
/* expr can be a float as well as an int. so it should be in both the rule? same hold for TOK_NUM*/
/*may be we need to define two seperate tokens for integer val and float val, */
%type <float_val> TOK_NUM_FLOAT
%type <string> TOK_IDENTIFIER 
%type <struct_expr> expr //token of struct type defined in the above union
%left TOK_ADD TOK_SUB//remove unncessary tokens
%left TOK_MUL TOK_DIV

%%

prog: TOK_MAIN TOK_OPENCURL stmts TOK_CLOSECURL
;

stmts: 
	| stmt TOK_SEMICOLON stmts
;

stmt:
      TOK_INT_KEYWORD TOK_IDENTIFIER           { fprintf(stdout,"\n\n\n\nDebugging,Tok_id in parser,\n id:\t%s\n", $2);  
                                                //test to check symtable working
                                                symboltablestart= insert(symboltablestart,$2,0);
                                                fprintf(stdout, "Read from symbol table: %s\n", symboltablestart->id_name);
                                                fprintf(stdout, "Read from symbol table: %d\n", symboltablestart->ival);
                                               }
    | TOK_FLOAT_KEYWORD TOK_IDENTIFIER         { fprintf(stdout,"\n\n\n\nDebugging,Tok_id in parser%s\n", $2);             }
    | TOK_IDENTIFIER TOK_EQUAL expr            {
                                               fprintf(stdout,"\n\n\n\nDebugging,Tok_id in parser%s\n", $1);  
                                               insert(symboltablestart,$1,$3.ival);


                                               }
    | TOK_PRINTVAR TOK_IDENTIFIER              { /*printf("%d\n",yylineno );*/ fprintf(stdout, "the value is %s\n", $2);   }
; 

expr:    
  expr TOK_ADD expr
      {
  //  $$ = $1 + $3; // have commented out all of them to supress errors. 
    }// we will have to work out everything again to implement symbol table and structure.
  | expr TOK_MUL expr
    {
  //  $$ = $1 * $3;
    }
  | TOK_NUM_INT
    {   
    //  fprintf(stdout,"\n\n\n\e rule applied: E is num_int %d\n", $1);  
     $$.ival= $1;
    }
        | TOK_NUM_FLOAT
          {
         //      $$ = $1;
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
