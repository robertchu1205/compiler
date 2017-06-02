%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
char temp[100][100];
int temp_i[100];
int ind=0;
char t[50]="#t";
char f[50]="#f";
void yyerror(const char *message);

%}
%union {
int ival;
char* str;
struct {
char c[100];
int n;
}try;
}
%token <ival> MOD divide minus mul plus INUMBER pn pb def IF 
%token <str> greater smaller equal and_op or_op not_op bool_t bool_f ch
%type  <try> EXP STMTS STMT DEF_STMT PRINT_STMT IF_STMT p_top mi_top d_top mul_top mod_top gr_top sm_top eq_top and_top or_top not_top

%%

program : STMTS { return 0; };

STMTS : STMT STMTS | STMT;

STMT : EXP | DEF_STMT | PRINT_STMT | IF_STMT;

PRINT_STMT : '(' pn EXP ')' { printf("%d\n",$3.n); ind=0; }
	|
	     '(' pb EXP ')' { printf("%s\n",$3.c); };

EXP : '(' plus p_top ')' { $$.n=$3.n; }
	|
      '(' minus mi_top ')' { $$.n=$3.n; }
	|
      '(' divide d_top ')' { $$.n=$3.n; }
	|
      '(' mul mul_top ')' { $$.n=$3.n; }
	|
      '(' MOD mod_top ')' { $$.n=$3.n; }
	|
      '(' greater gr_top ')' {  strncpy($$.c,$3.c,sizeof($3.c)); }
	|
      '(' smaller sm_top ')' {  strncpy($$.c,$3.c,sizeof($3.c)); }
	|
      '(' equal eq_top ')' {  strncpy($$.c,$3.c,sizeof($3.c)); }
	|
	'(' and_op and_top ')' {  strncpy($$.c,$3.c,sizeof($3.c)); }
	|
	'(' or_op or_top ')' {  strncpy($$.c,$3.c,sizeof($3.c)); }
	|
	'(' not_op not_top ')' {  strncpy($$.c,$3.c,sizeof($3.c)); }
	| INUMBER { $$.n=$1; }	
	| bool_f  { strncpy($$.c,$1,sizeof($1)); }
	| bool_t { strncpy($$.c,$1,sizeof($1)); }
	| IF_STMT { $$.n=$1.n; }
	| ch {
	for(int i=1;i<=ind;i++) {
	   if(strcmp($1,temp[i])==0) {
		$$.n=temp_i[i]; }	} 
				};
p_top : EXP p_top { $$.n=$1.n+$2.n; }
	|
	EXP {$$.n=$1.n;};
mi_top :EXP EXP { $$.n=$1.n-$2.n; };
d_top : EXP EXP { $$.n=$1.n/$2.n; };
mul_top :EXP mul_top { $$.n=$1.n*$2.n; }
	|
	EXP {$$.n=$1.n;};
mod_top :EXP EXP { $$.n=$1.n%$2.n; };
gr_top : EXP EXP { if($1.n>$2.n) {
		strcpy($$.c,t); }
		   else{	
		strcpy($$.c,f);	} };
sm_top : EXP EXP { if($1.n<$2.n) {
		strcpy($$.c,t); }
		   else{
		strcpy($$.c,f);	} };
eq_top :EXP eq_top { if(strcmp($2.c,t)==0) {
	if($1.n==$2.n) {strcpy($$.c,t);}
	else { strcpy($$.c,f); } }
	else { strcpy($$.c,f); } }
	|
	EXP { strcpy($$.c,t); $$.n=$1.n;};
and_top :EXP and_top { if(strcmp($2.c,t)==0) {
	if(strcmp($1.c,t)==0) {strcpy($$.c,t);}
	else { strcpy($$.c,f); } }
	else { strcpy($$.c,f); } }
	|
	EXP { strncpy($$.c,$1.c,sizeof($1.c)); };
or_top :EXP or_top { if(strcmp($2.c,f)==0) {
	if(strcmp($1.c,f)==0) {strcpy($$.c,f);}
	else { strcpy($$.c,t); } }
	else { strcpy($$.c,t); } }
	|
	EXP { strncpy($$.c,$1.c,sizeof($1.c)); };
not_top : EXP { if(strcmp($1.c,f)==0) {
		strcpy($$.c,t); }
	       else if(strcmp($1.c,t)==0) {
		strcpy($$.c,f);	} };
IF_STMT: '(' IF EXP EXP EXP ')' { 
	if(strcmp($3.c,t)==0) { $$.n=$4.n; }
else if(strcmp($3.c,f)==0) { $$.n=$5.n; }  };

DEF_STMT: '(' def ch EXP ')' { 
	ind++;
	strncpy(temp[ind],$3,sizeof($3));
	temp_i[ind]=$4.n; };


%%
void yyerror (const char *message)
{
        fprintf (stderr, "%s\n",message);
}

int main(int argc, char *argv[]) {
        yyparse();
		
        return(0);
}
