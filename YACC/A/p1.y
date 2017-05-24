%{

#include <stdio.h>
#include <string.h>
int yylex(void);
void yyerror(const char *message);
%}
%union {
int ival;
//char* word;
}
%token<ival> v
%token<ival> INUMBER
%token<ival> plus
%token<ival> mul
%token<ival> t
%type<ival> expr
//%token<word> WORD
//%type<word> test
%left plus 
%left mul
%left '(' ')'
%left '[' ']' ',' v t

%%

line    : expr                  { printf("Accepted\n"); }
	;
expr    : expr plus expr                  
{ if((($1/1000)==($3/1000))&&(($1%1000)==($3%1000))) 
    { $$ = $1; }
  else {printf("Semantic error on col %d\n",$2); return 0;}  
}
        | expr mul expr         
{ if(($1%1000)==($3/1000)) 
    { $$ = ($1/1000)*1000+$3%1000; }
  else {printf("Semantic error on col %d\n",$2); return 0; }  
}
	| expr v t 		{ $$ = ($1%1000)*1000+$1/1000; }
        | '(' expr ')'          { $$ = $2; }
   //     | '-' expr %prec UMINUS { $$ = -$2; }
	| '[' INUMBER ',' INUMBER ']' v t { $$ = $4*1000 + $2; }
        | '[' INUMBER ','  INUMBER ']'  { $$ = $2*1000 + $4; }
        ;

%%

void yyerror (const char *message) {
	fprintf (stderr, "%s\n", message);
}

int main(int argc, char *argv[]) {
        yyparse();
        return 0;
}
