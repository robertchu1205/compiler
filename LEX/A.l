endl \n
key "cpy"
letter [a-z_]

%%

({letter})*{key}({letter})* {
       printf("%s\n",yytext);
}
{endl} {

}
.

%%

int main() {
  yylex();
  return 0;
}

int yywrap() { return 1; }
