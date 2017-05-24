nod	"."
endl	\n
num	[0-9]
onenine	[1-9]
zerofour [0-4]

%%

([0-9]|10{num}|1?{onenine}{num}|2{zerofour}{num}|25{zerofour}|255){nod}(num|10{num}|1?{onenine}{num}|2{zerofour}{num}|25{zerofour}|255){nod}(num|10{num}|1?{onenine}{num}|2{zerofour}{num}|25{zerofour}|255){nod}([0-9]|10{num}|1?{onenine}{num}|2{zerofour}{num}|25{zerofour}|255) {
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
