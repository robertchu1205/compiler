%{
#include "y.tab.h"
%}
CH [a-z]([a-z]|[0-9]|'-')* 
digit [0-9]+|-[1-9][0-9]*
%%
[\t]|[\r]|\n|" "	{ /* do nothing */ }
{digit}  { yylval.ival = atoi(yytext); return(INUMBER); }
"#t"	{ yylval.str = strdup(yytext); return(bool_t); }
"#f"	{ yylval.str = strdup(yytext); return(bool_f); }
"+"     { return(plus); }
"-"     { return(minus); }
"*"     { return(mul); }
"/"	{ return(divide); }
"mod"	{ return(MOD); }
">"	{  return(greater); }
"<"	{  return(smaller); }
"=" 	{  return(equal); }
"and"	{ return(and_op); }
"or"	{ return(or_op); }
"not"	{ return(not_op); }
"define" { return(def); }
"if"	{ return(IF); }
"print-num" { return(pn); }
"print-bool" { return(pb); }
{CH}	{ yylval.str = strdup(yytext); return(ch); }
.	{ return(yytext[0]); }
%%
