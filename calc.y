%{
#include <stdio.h>
#include <stdlib.h>
extern int yylineno; 

typedef struct sym_node * SMT; 

SMT symbol_table_pointer_ref = NULL;

 typedef struct sym_node
    {
	SMT next;
	int type;
	char *id_name;
    int ival;
    float fval;
	/* data */
     }sm_node;
// symbol table as a linkedlist of sym_node

/*
List of functions working in symbol table:
1. lookup - to search for a given ID
2. insert - whenever int x; float x; (also calls lookup to verify if not already previously defined)
3. update - eg- x=3;x=5; so we need to update the value of x. first search if x is defined using lookup. and then update
4. print - to print the value of the respective identifier.
*/

/* Function to search values in the symbol table */
SMT lookup(SMT smt_ref, char* id){
    if(smt_ref != NULL){
        SMT lookup_node_pointer = smt_ref;
        while(lookup_node_pointer != NULL){
            if(strcmp(lookup_node_pointer->id_name,id)){
                return lookup_node_pointer;
            }else{
                lookup_node_pointer = lookup_node_pointer->next;
            }
        }
    }else{
          return NULL;
        }
}

/* Function to insert values in the symbol table */
SMT insert(SMT smt_ref,char* id,int type_of_expr,int int_val,float float_val)
{
    if((smt_ref != NULL) && (lookup(smt_ref,id) == NULL)){
        SMT new_node_pointer = (SMT)malloc(sizeof(sm_node));
        new_node_pointer->id_name = (char *) strdup(id);
        new_node_pointer->type=type_of_expr;
        new_node_pointer->ival = int_val;/*justa test case*/
        new_node_pointer->fval = float_val;
        new_node_pointer->next = smt_ref;
        return new_node_pointer;
    }else{
        return smt_ref;
    }
}

/* Function to update values of existing identifier */
SMT update(SMT smt_ref, char* id,int int_val,float float_val){
    if(smt_ref != NULL){
        SMT update_node_pointer = smt_ref;
        while(update_node_pointer != NULL){
            if(strcmp(update_node_pointer->id_name, id)){
                if(update_node_pointer->type == 0){
                    update_node_pointer->ival = int_val;
                }else if(update_node_pointer->type == 1){
                    update_node_pointer->fval = float_val;
                }
                return update_node_pointer;
            }else{
                update_node_pointer = update_node_pointer->next;
            }
        }
    }else{
        return NULL;
    }
}

/* Function to print values of existing pointer */
void print(SMT smt_ref, char* id){
    if(smt_ref != NULL){
        SMT print_node_pointer = smt_ref;
        while(print_node_pointer != NULL){
            if(strcmp(print_node_pointer->id_name, id)){
                printf(" The Value of %s is", print_node_pointer->id_name;
                if(print_node_pointer->type == 0){
                    printf(" %d \n", print_node_pointer->ival);
                }else if(print_node_pointer->type == 1){
                    printf(" %f \n", print_node_pointer->fval);
                }
                break;
            }else{
                print_node_pointer = print_node_pointer->next;
            }
        }
    }
}


%}

%token TOK_MAIN TOK_OPENCURL TOK_CLOSECURL TOK_PRINTVAR TOK_PRINTLN TOK_INT_KEYWORD TOK_FLOAT_KEYWORD TOK_NUM_INT TOK_NUM_FLOAT TOK_IDENTIFIER TOK_SEMICOLON TOK_ADD TOK_SUB TOK_MUL TOK_DIV TOK_NUM TOK_EQUAL

%union{
        int int_val;
        float float_val;
        char  *string;
        struct s_expr /*structure to store value and data type ( can be of type int of float)*/
         {               /*supposed that event a identifier will be a expr becuase, a variable might be referenced later on via the identifier */
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
      TOK_INT_KEYWORD TOK_IDENTIFIER    { fprintf(stdout,"\n\n\n\nDebugging,Tok_id in parser,\n id:\t%s\n", $2);
                                          symbol_table_pointer_ref= insert(symbol_table_pointer_ref,$2,0,NULL,NULL);
                                          fprintf(stdout, "Read from symbol table: %s\n", symbol_table_pointer_ref->id_name);
                                                fprintf(stdout, "Read from symbol table: %d\n", symbol_table_pointer_ref->ival); }
    | TOK_FLOAT_KEYWORD TOK_IDENTIFIER         { fprintf(stdout,"\n\n\n\nDebugging,Tok_id in parser%s\n", $2);
                                                 symbol_table_pointer_ref= insert(symbol_table_pointer_ref,$2,1,NULL,NULL);  }
| TOK_IDENTIFIER TOK_EQUAL expr            { fprintf(stdout,"\n\n\n\nDebugging,Tok_id in parser%s\n", $1); update(symbol_table_pointer_ref,$1,expr.ival,NULL);}
| TOK_PRINTVAR TOK_IDENTIFIER              {  fprintf(stdout, "the value is %s\n", $2); print(symbol_table_pointer_ref,$2);  }
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
