%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
	int yylex(void);
    void yyerror(const char *message);
    char ansC[100][100]={};
    int ansN[100]={};

%}

%union {
    int   num;
    char* str;
    struct {
        char c[100][100];
        int n[100];
        int index;
    } try;
}

%token<num> inum 
%token<str> ch arrow plus
%type<try>  expr element

%left arrow
%left plus 

%%

line : expr 		{ };
	
expr : expr arrow expr {
		for(int i=1;i<=$1.index;i++) {
			if($1.n[i]!=0) {
			for(int j=i+1;j<=$1.index;j++) {
					if(strcmp($1.c[i],$1.c[j])==0) {
						$1.n[i]+=$1.n[j];
						$1.n[j]=0;
					}
				}
			}
		}
		for(int i=1;i<=$3.index;i++) {
			if($3.n[i]!=0) {
			for(int j=i+1;j<=$3.index;j++) {
					if(strcmp($3.c[i],$3.c[j])==0) {
						$3.n[i]+=$3.n[j];
						$3.n[j]=0;
					}
				}
			}
		}
		$$.index=0;
		int test=1;
		for(int i=1;i<=$1.index;i++) {
			test=1;
			if($1.n[i]!=0) {
			for(int j=1;j<=$3.index;j++) {
				if($3.n[j]!=0) {
						if(strcmp($3.c[j],$1.c[i])==0) {
							if($1.n[i]-$3.n[j]!=0) {
							$$.index++;
							$$.n[$$.index]=$1.n[i]-$3.n[j];
							strncpy($$.c[$$.index],$1.c[i],sizeof($1.c[i])); }
							$3.n[j]=0;
							test=0;
							break; 
						}
				}
			}
			 if(test==1) {
			  $$.index++;
			  $$.n[$$.index]=$1.n[i];
			  strncpy($$.c[$$.index],$1.c[i],sizeof($1.c[i]));
			}
		 
		  }
		}
		for(int i=1;i<=$3.index;i++) {
			if($3.n[i]!=0) {
				$$.index++;
				$$.n[$$.index]=-$3.n[i];
				strncpy($$.c[$$.index],$3.c[i],sizeof($3.c[i]));
			}
		}
		for(int i=1;i<=$$.index-1;i++)
							{
								for(int j=1;j<=$$.index-i;j++)
								{
									int compare=strncmp($$.c[j],$$.c[j+1],100);
									if(compare>0)
									{
										int temp;
										temp=$$.n[j];
										$$.n[j]=$$.n[j+1];
										$$.n[j+1]=temp;
										char *t[2][100];
										memset($1.c[100],'\0', sizeof($1.c[100]));
										strncpy($1.c[100],$$.c[j],sizeof($$.c[j]));
										memset($$.c[j],'\0', sizeof($$.c[j]));
										strncpy($$.c[j],  $$.c[j+1],sizeof($$.c[j+1]));
										memset($$.c[j+1],'\0', sizeof($$.c[j+1]));
										strncpy($$.c[j+1],$1.c[100],sizeof($1.c[100]));
									}	
								}
							}
		/*int temp;
		for(int i=1;i<=$$.index-1;i++) {
			for(int j=i;j<=$$.index-1;j++) {
				if(strncmp($$.c[j],$$.c[j+1],100)>0) {
						temp=$$.n[j];
						$$.n[j]=$$.n[j+1];
						$$.n[j+1]=temp;
						strncpy($1.c[0],$$.c[j],sizeof($$.c[j]));
						strncpy($$.c[j],$$.c[j+1],sizeof($$.c[j+1]));
						strncpy($$.c[j+1],$1.c[0],sizeof($1.c[0]));
				}
			}
		}*/
		/*for(int i=1;i<=$$.index/2;i++) {
						temp=$$.n[i];
						$$.n[i]=$$.n[$$.index-i+1];
						$$.n[$$.index-i+1]=temp;
						strncpy($1.c[0],$$.c[i],sizeof($$.c[i]));
						strncpy($$.c[i],$$.c[$$.index-i+1],sizeof($$.c[$$.index-i+1]));
						strncpy($$.c[$$.index-i+1],$1.c[0],sizeof($1.c[0]));
		}*/
		/*for(int i=1;i<=$1.index;i++) {
			printf("%s %d\n",$1.c[i],$1.n[i]);
			
		}
		for(int i=1;i<=$3.index;i++) {
			printf("%s %d\n",$3.c[i],$3.n[i]);
		}
		printf("abc\n");*/
		for(int i=1;i<=$$.index;i++) {
			printf("%s %d\n",$$.c[i],$$.n[i]);
		}
}
	|  expr plus expr {
		for(int i=1;i<=$1.index;i++) {
			$3.index++;
			strncpy($3.c[$3.index],$1.c[i],sizeof($1.c[i]));
			$3.n[$3.index] = $1.n[i];
		}
		for(int i=1;i<=$3.index;i++) {
			strncpy($$.c[i],$3.c[i],sizeof($3.c[i]));
			$$.n[i] = $3.n[i];
		}
		$$.index = $3.index;
}	
	|  inum element {
		for(int i=1;i<=$2.index;i++) {
			strncpy($$.c[i],$2.c[i],sizeof($2.c[i]));
            $$.n[i] = $2.n[i] * $1;		
		}
		$$.index=$2.index;
}
	|  element {
			for(int i=1;i<=$1.index;i++) {
			strncpy($$.c[i],$1.c[i],sizeof($1.c[i]));
            $$.n[i] = $1.n[i];		
		}
		$$.index=$1.index;
	};
element : ch element {
				$2.index++;
				strncpy($2.c[$2.index],$1,sizeof($1));
				$2.n[$2.index] = 1;
				for (int i=1;i<=$2.index;i++) {
				strncpy($$.c[i],$2.c[i],sizeof($2.c[i]));
				$$.n[i] = $2.n[i];
				}
				$$.index = $2.index;
}
		|	ch inum element {
				$3.index++;
				strncpy($3.c[$3.index],$1,sizeof($1));
				$3.n[$3.index] = $2;
				for (int i=1;i<=$3.index;i++) {
				strncpy($$.c[i],$3.c[i],sizeof($3.c[i]));
				$$.n[i] = $3.n[i];
				}
				$$.index = $3.index;
}
		|	'(' element ')' element {
				for(int i=1;i<=$2.index;i++) {
					$4.index++;
					strncpy($4.c[$4.index],$2.c[i],sizeof($2.c[i]));
					$4.n[$4.index] = $2.n[i];
				}
				for(int i=1;i<=$4.index;i++) {
					strncpy($$.c[i],$4.c[i],sizeof($4.c[i]));
					$$.n[i] = $4.n[i];		
				}
				$$.index=$4.index;
}
		|	'('	element ')' inum element {
				for(int i=1;i<=$2.index;i++) {
					$5.index++;
					strncpy($5.c[$5.index],$2.c[i],sizeof($2.c[i]));
					$5.n[$5.index] = $2.n[i] * $4;
				}
				for(int i=1;i<=$5.index;i++) {
					strncpy($$.c[i],$5.c[i],sizeof($5.c[i]));
					$$.n[i] = $5.n[i];		
				}
				$$.index=$5.index;
}
		|	{$$.index=0;};
	
%%
void yyerror(const char *message) {
    printf("Invalid format\n");
}

int main(int argc, char** argv)
{
    yyparse();
    return 0;
}