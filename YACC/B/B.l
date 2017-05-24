%{
#include "B.tab.h"
int len=0;
%}

num [1-9][0-9]*
ch  [A-Z][a-z]*
%%

\n		{ return(0); /* EOF */ }
[ \t]+          ;
{ch}		{ yylval.str = strdup(yytext); return(ch); }
{num}		{ yylval.num = atoi(yytext); return(inum); }
"->"		{ return(arrow); }
"("|")"		{ return(yytext[0]); }
"+"		{ return(plus); }
.		{ len++; return(yytext[0]); }

%%
