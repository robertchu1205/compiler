%{
#include "matrixCalculator.tab.h"
int count=0;
%}
%%
\n	{ return(0); /* EOF */ }
[ \t]+	{count+=yyleng; /* do nothing */ }
[0-9]+	{count+=yyleng; yylval.ival = atoi(yytext);return(INUMBER); }
"+"     {count+=1;yylval.ival = count;return(plus);}
"-"     {count+=1;yylval.ival = count;return(minus);}
"*"     {count+=1;yylval.ival = count;return(mul);}
"^T"     {count+=2;yylval.ival = count;return(T);}
.	{count+=1; return(yytext[0]); }
%%
