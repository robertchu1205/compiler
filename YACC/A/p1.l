%{
#include "p1.tab.h"
int num=0;
%}
%%

\n	{ return(0); /* EOF */ }
[ \t]+	{ num+=yyleng; /* do nothing */ } /*
[ ]+ 	{ yylval.word = strdup(yytext); return WORD;} */
[0-9]+	{ num+=yyleng; yylval.ival = atoi(yytext); return(INUMBER); }
"+"|"-" { num+=1; yylval.ival = num; return(plus); }
"*" 	{ num+=1; yylval.ival = num; return(mul); }
"^" 	{ num+=1; yylval.ival = num; return(v); }
"T" 	{ num+=1; yylval.ival = num; return(t); }
.	{ num++; return(yytext[0]); }

%%

