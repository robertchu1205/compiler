space	" "
endl	\n
key	"noodles"
letter	[a-zA-Z]

%%

{letter}+{space}+{letter}+{space}+{key}+{space}+{letter}+ {
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
