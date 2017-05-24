zero	"0"
endl	\n
keyx	[xX]
digit	[0-9A-Fa-f]

%%

^{zero}{keyx}{digit}{1,8}$ {
		printf("%s\n",yytext);
}
{endl} { }

.

%%

int main() {
  yylex();
  return 0;
}

int yywrap() { return 1; }
