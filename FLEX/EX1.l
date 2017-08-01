%{
}%
DIGIT [0-9]
%%
 0|[1-9]{DIGIT}*	{ fprintf(yyout,"\nInteger:%s",yytext);}
 0"."{DIGIT}+ | [1-9]{DIGIT}*"."{DIGIT}+   { fprintf(yyout,"\nReal:%s",yytext);}
 "+"|"/"|"="|"-"|"*"    {fprintf(yyout,"\nAn operator:%s",yytext);}		
 \n  
  .     fprintf(yyout,"\nUnrecognized character: %s",yytext);
%%
void main(int argc, char* argv[])
{
yyin=fopen(argv[1],"r");
if(argv[2])  yyout=fopen(argv[2],"w");
else yyout=stdout;
yylex();
}
