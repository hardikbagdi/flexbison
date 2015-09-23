%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
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

/*
 Function to search values in the symbol table
 
 IF respective identifer is present in symbol table then return pointer to that value
 ELSE return null.
*/
SMT lookup(SMT smt_ref, char* id){
    printf(" Fetching values from symbol table \n");
    if(smt_ref != NULL){
        printf("pointer value is not null \n");
        SMT lookup_node_pointer = smt_ref;
        while(lookup_node_pointer != NULL){
            if(strcmp(lookup_node_pointer->id_name,id)==0){
                printf("Identifier found %s ", lookup_node_pointer->id_name);
                return lookup_node_pointer;
            }else{
                lookup_node_pointer = lookup_node_pointer->next;
            }
        }
    }else{
        printf("Identifier missing in symbol table \n");
        return NULL;
    }
}

/* 
 Function to insert values in the symbol table */
SMT insert(SMT smt_ref,char* id,int type_of_expr,int int_val,float float_val){
    printf(" Entered insert function \n");
    if(lookup(smt_ref,id) == NULL){
         printf("Going to insert values \n");
         SMT new_node_pointer = (SMT)malloc(sizeof(sm_node));
         new_node_pointer->id_name = (char *) strdup(id);
         new_node_pointer->type=type_of_expr;
         new_node_pointer->ival = int_val;
         new_node_pointer->fval = float_val;
         new_node_pointer->next = smt_ref;
         return new_node_pointer;
    }else{
       printf("error in insertion \n");
       yyerror();
    }
}

/* Function to update values of existing identifier */
void update(SMT smt_ref, char* id,int int_val,float float_val){
        printf(" Entered update function \n");
        if(lookup(smt_ref,id) == NULL){
            printf("Error in update \n");
            yyerror();
        }else{
            printf("Going to update identifier value");
            SMT update_node_pointer = smt_ref;
            while(update_node_pointer != NULL){
            printf("point name : %s and Identifier value : %s and type value : %d and ival : %d\n",update_node_pointer->id_name,id, update_node_pointer->type, update_node_pointer->ival = int_val);
                if(strcmp(update_node_pointer->id_name, id) == 0){
                    printf("inside if loop of update function \n");
                    if(update_node_pointer->type == 0){
                        update_node_pointer->ival = int_val;
                        printf("value of int_val updated : %d \n", update_node_pointer->ival);
                    }else if(update_node_pointer->type == 1){
                        update_node_pointer->fval = float_val;
                        printf("value of float_val updated : %f \n", update_node_pointer->fval);
                    }
                    break;
                }else{
                    update_node_pointer = update_node_pointer->next;
                }
            }
        }
}

/* Function to print values of existing pointer */
void print(SMT smt_ref, char* id){
        printf(" Entered print function \n");
        SMT print_node_pointer = smt_ref;
        printf("going to enter execute while loop \n");
        while(print_node_pointer != NULL){
            printf("executing while loop \n");
            if(strcmp(print_node_pointer->id_name, id) == 0){
                printf(" The Value of %s is", print_node_pointer->id_name);
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

int type_check(SMT smt_ref, char* id){
    printf(" Type check \n");
    printf("Input for type checking %s \n", id);
    int type_check;
    SMT type_check_node_pointer;
    type_check_node_pointer = smt_ref;
    /*if(type_check_node_pointer != NULL){*/
       type_check_node_pointer = lookup(smt_ref, id);
       type_check = type_check_node_pointer->type;
   /* } */
    printf("\nType_checking output ====  %d\n", type_check);
    return type_check;
}


%}

%token TOK_MAIN TOK_OPENCURL TOK_CLOSECURL TOK_PRINTVAR TOK_PRINTLN TOK_INT_KEYWORD TOK_FLOAT_KEYWORD TOK_NUM_INT TOK_NUM_FLOAT TOK_IDENTIFIER TOK_SEMICOLON TOK_ADD TOK_MUL TOK_EQUAL

%union{
        int int_val;
        float float_val;
        char *string;
        int data_type;
         /* Structure to store identifiers, their respective values and datatypes */
         struct s_expr
         {               /*supposed that event a identifier will be a expr becuase, a variable might be referenced later on via the identifier */
             char *string; /* stores name of the identifiers */
             int type; /* type=0 symbolize int and type = 1 symbolize float*/
             int ival; /* Store int values */
             float fval; /* store float values */
   		/* data */
         }struct_expr; /* this is instance of s_expr data-type which will be used to declare a token */
    }

%type <int_val> TOK_NUM_INT
%type <float_val> TOK_NUM_FLOAT
%type <string> TOK_IDENTIFIER 
%type <struct_expr> expr //token of struct type defined in the above union
%left TOK_ADD
%left TOK_MUL

%%

prog: TOK_MAIN TOK_OPENCURL stmts TOK_CLOSECURL
;

stmts:
	| stmt TOK_SEMICOLON stmts
;

stmt: TOK_INT_KEYWORD TOK_IDENTIFIER    {
                                           fprintf(stdout,"\n\n\n\nDebugging,TOK_INT_KEYWORD in parser,\n id:\t%s\n", $2);
                                          symbol_table_pointer_ref= insert(symbol_table_pointer_ref,$2,0,9999,9999.99);
                                          fprintf(stdout, "Read from symbol table: %s\n", symbol_table_pointer_ref->id_name);
                                          fprintf(stdout, "Read from symbol table: %d\n", symbol_table_pointer_ref->ival);
                                        }
    | TOK_FLOAT_KEYWORD TOK_IDENTIFIER  {
                                         fprintf(stdout,"\n\n\n\nDebugging,TOK_FLOAT_KEYWORD in parser %s\n", $2);
                                          symbol_table_pointer_ref= insert(symbol_table_pointer_ref,$2,1,9999,9999.99);
                                        }
    | TOK_IDENTIFIER TOK_EQUAL expr     {
                                          fprintf(stdout,"\n\n\n\nDebugging,TOK_IDENTIFIER %s and %d \n", $1, $3.ival);
                                          update(symbol_table_pointer_ref,$1,$3.ival,$3.fval);
                                           fprintf(stdout, "Read after update; value of %s = %d\n", symbol_table_pointer_ref->id_name, symbol_table_pointer_ref->ival);
                                        }

    | TOK_PRINTVAR TOK_IDENTIFIER       {
                                    fprintf(stdout, "TOK_PRINTVAR the value is %s\n", $2); print(symbol_table_pointer_ref,$2);
                                        }
;

expr:
    expr TOK_ADD expr {
        fprintf(stdout," expr value in TOK_ADD before addition %s and %d = %d ---\n",$1.string,$3.ival);
        $$.ival = $1.ival + $3.ival;
    fprintf(stdout," expr value in TOK_ADD addition %d + %d = %d ---\n",$1.ival,$3.ival, $$.ival);
    
    }
    | expr TOK_MUL expr {
                             $$.fval = $1.fval * $3.fval;
                        }
    | TOK_NUM_INT {
                fprintf(stdout,"\n\n\n\e rule applied: E is num_int %d\n", $1);
                $$.ival = $1;
              }
    | TOK_NUM_FLOAT { fprintf(stdout,"\n\n\n\e rule applied: E is float_int %f\n", $1); $$.fval = $1; }
    | TOK_IDENTIFIER
                {
                    $$.string = $1;
                    fprintf(stdout,"---TOK_IDENTIFIER----\n");
                    fprintf(stdout,"%%%%%% %s ^^^^^^ \n",$1);
                    
                }
;


%%

int yyerror(char *s)
{
	printf("\n %s on line no %d\n",s, yylineno);
	return 0;
}

int main()
{
   yyparse();
   return 0;
}
