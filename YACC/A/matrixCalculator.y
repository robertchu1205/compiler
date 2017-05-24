%{
#include <stdio.h>
#include <string.h>
void yyerror(const char *message);
%}
%union {
int ival;
int matrix[2];
}
%token <ival> INUMBER
%token <ival> plus
%token <ival> mul
%token <ival> minus
%token <ival> T
%type  <matrix> expr
%left plus minus
%left mul
%left T

%%
line    : expr                  { printf("Accepted"); }
		;
expr    : '[' INUMBER ',' INUMBER']' { $$[0]=$2; $$[1]=$4;}
		| expr T
		{
			$$[0]=$1[1];
			$$[1]=$1[0];
		}
		| expr plus expr         
		{ if( $1[0]==$3[0]&& $1[1]==$3[1])
			{
				$$[0]=$1[0]; 
				$$[1]=$1[1];
			}		
			else
			{
				printf("Semantic error on col %d\n",$2);
				return(0);
			}			
		}
		| expr minus expr         
		{ if( $1[0]==$3[0]&& $1[1]==$3[1])
			{
				$$[0]=$1[0]; 
				$$[1]=$1[1];
			}
				else
			{
			printf("Semantic error on col %d\n",$2);
			return(0);
			}
		}
        | expr mul expr         
		{ if( $1[1]==$3[0])
			{
				$$[0]=$1[0]; 
				$$[1]=$3[1];
			}
			else
			{
			printf("Semantic error on col %d\n",$2);
			return(0);
			}
		
		}
        | '(' expr ')'          { $$[0] = $2[0];$$[1] = $2[1]; }
        ;
        
%%
void yyerror (const char *message)
{
        fprintf (stderr, "%s\n",message);
}

int main(int argc, char *argv[]) {
        yyparse();
		
        return(0);
}
