%name tokens

%{
#include <stdio.h>
#include "Compilation1.h"
#include "parse_methods.h"

//Defining the funcations and the vars
void CreateAndStoreToken(int type, char* lexema, int lineNumber);
FILE *FileToOpen;
FILE * yyout;
token tokenToCreate;
token token1;
int line = 1;
int yylexLoop = 1;
%}

LETTER [a-z]
DIGIT [0-9]

//our predefined tokens  
%%            
"=="                                                    { CreateAndStoreToken(EQUALS,yytext,line); return 1 ;}    
"!="                                                    { CreateAndStoreToken(NOT_EQUALS,yytext,line); return 1 ;}   
">="                                                    { CreateAndStoreToken(GREATER_EQUALS,yytext,line); return 1 ;} 
">"                                                     { CreateAndStoreToken(GREATER,yytext,line); return 1 ;} 
"<"                                                     { CreateAndStoreToken(SMALLER,yytext,line); return 1 ;} 
"<="                                                    { CreateAndStoreToken(SMALLER_EQUALS,yytext,line); return 1 ;}
"("                                                     { CreateAndStoreToken(OPEN_BRACKETS,yytext,line); return 1 ;} 	
")"                                                     { CreateAndStoreToken(CLOSING_BRACKETS,yytext,line); return 1 ;} 	
"{"                                                     { CreateAndStoreToken(OPEN_CURLY_BRACKETS,yytext,line); return 1 ;} 	
"}"                                                     { CreateAndStoreToken(CLOSING_CURLY_BRACKETS,yytext,line); return 1 ;} 
"+"                                                     { CreateAndStoreToken(ADDITION,yytext,line); return 1 ;} 	
"-"                                                     { CreateAndStoreToken(SUBTRUCTION,yytext,line); return 1 ;} 	
"*"                                                     { CreateAndStoreToken(MULTIPLICATION,yytext,line); return 1 ;} 	
"/"                                                     { CreateAndStoreToken(DIVISION,yytext,line); return 1 ;} 	 
"parbegin" 	                                            { CreateAndStoreToken(parbegin,yytext,line); return 1 ;}
"parend" 	                                            { CreateAndStoreToken(parend,yytext,line); return 1 ;}
"task"  	                                            { CreateAndStoreToken(TASK,yytext,line); return 1 ;}
"BEGIN"  	                                            { CreateAndStoreToken(BEGIN,yytext,line); return 1 ;}
"end" 	                                                { CreateAndStoreToken(END,yytext,line); return 1 ;}
"do"  	                                                { CreateAndStoreToken(DO,yytext,line); return 1 ;}
"until"  	                                            { CreateAndStoreToken(UNTIL,yytext,line); return 1 ;}
"od"    	                                            { CreateAndStoreToken(OD,yytext,line); return 1 ;}
"send"  	                                            { CreateAndStoreToken(SEND,yytext,line); return 1 ;}
"accept"  	                                            { CreateAndStoreToken(ACCEPT,yytext,line); return 1 ;}
";"  	                                                { CreateAndStoreToken(PIPE,yytext,line); return 1 ;}
"||"  	                                                { CreateAndStoreToken(SEMICOLON,yytext,line); return 1 ;}
{LETTER}|{LETTER}*|{LETTER}*({LETTER}+{DIGIT})*         { CreateAndStoreToken(LETTER,yytext,line); return 1 ;}
0|({DIGIT}*"."{DIGIT}*)|[1-9]{DIGIT}*|"-"[1-9]{DIGIT}*  { CreateAndStoreToken(NUMBER,yytext,line); return 1 ;}
" "                                                     ;
"\n"                                                    {line++;}
"\t"                                                    ;			  
.     									                { CreateAndStoreToken(UNKNOWN,yytext,line); return 1 ;}

%%



void parse_Program()
{
	yyout=fopen("c:\\temp\\test_305229494_206087439_lex.txt","w");
	fprintf(yyout,"* RULE 1 * : PROGRAM -> TASK_DEFINITIONS; parbegin TASK_LIST parend \n");
	
	Token t - next_token();
	parse_task_Definitions();
	switch(t->lex)
	{
		case SEMICOLON:
		{
			match(SEMICOLON);
			match(parbegin);
			parse_task_List();
			match(parend);
			break;
		}
		default:
		{
			fprintf(yyout,"ERROR: unknown token\n");
		}
	}
}

void parse_task_Definitions()
{
	fprintf("* Rule 2* TASK_DEFINITIONS -> TASK_DEFINITION TASK_DEFINITIONS2\n");
			parse_task_Definition();
			parse_task_Definitions2();		
	}
}

void parse_task_Definitions2(){
	fprintf("* Rule 3 * TASK_DEFINITIONS -> ;TASK_DEFINITION TASK_DEFINITIONS2 | epsilon \n");
	Token t = next_token();
	switch(t->lex)
	{
		case SEMICOLON:
		{
			parse_task_Definition;
			parse_task_Definitions2;
		}
		default:
		{
			back_token();
		}
	}
}

void parse_task_Definition()
{
	printf("* RULE 4 * TASK_DEFINITION -> task id BEGIN DECLARATIONS { COMMANDS } \n");
	Token t = next_token();
	
	switch(t->lex)
	{
		case "task":
		{
			match("id");
			match("begin");
			parse_Declaration();
			match("{");
			parse_Commands();
			match("}");
			match("end");
			match(SEMICOLON);
			
		}
		default:
		{
			fprintf(yyout,"ERROR: unknown token\n");
		}
	}
}

void parse_Declarations()
{
	printf("* RULE 5 * DECLARATIONS -> DECLARATION ; DECLARATIONS2 \n");
	parse_Declaration();
	parse_Declarations2();
	
}

void parse_Declarations2()
{
	printf("* RULE 6 * DECLARATIONS2 -> DECLARATIONS | NULL \n");
	parse_Declarations();
}

void parse_Declaration()
{
	printf("* RULE 7 * DECLARATION -> DECLARATION2 id \n");
	parse_Declaration2();
	match(id);
}

void parse_Declaration2()
{
	printf("* RULE 8 * DECLARATION -> ");
	next_token();
	switch(token.type)
	{
		case integer:
			printf("integer \n");
			////
		case real:
			printf("real \n");
			///
		default:
			///
		
	}
}

void parse_task_List()
{
	printf("* RULE 9 * TASK_LIST -> task_id\n");
	while(match(task_id)){}
	while(match(SEMICOLON)){}
	parse_task_List2();
}

void parse_task_List2()
{
	printf("* RULE 10 * TASK_LIST2 -> TASK_LIST | task_id \n");
	while(match(||)){}

	next_token();
	switch(token.type)
	{
		case task_id:{
			back_token();
			parse_task_List();
		}
		default:
			// do nothing but continue to ohter rules 
	}
}

void parse_Commands()
{
	printf("* RULE 11 * PARSE_COMMANDS -> PARSE_COMMAND ; PARSE_COMMANDS2 \n");
	parse_Command();
	parse_Commads2();
}

void parse_Commads2()
{
	printf("* RULE 12 * PARSE_COMMANDS2 -> PARSE_COMMANDS | NULL \n");
	parse_Commands();
		
}

void parse_Command()
{
	printf("* RULE 13 * PARSE_COMMAND -> \n");
	next_token();
	switch(token.type)
	{
		case id:
		{			
			parse_Expression();
		}
		case do:
		{
			parse_Commands();
			match(until);
			parse_Condition();
			match(od);
		}
		case send:
		{
			match(task_id );
			match(dot);
			match(signal_id );
			match(left_bracket );
			parse_Param_List();
			match(right_bracket );
		}
		case accept:
		{
			match(signal_id );
			match(left_bracket );
			parse_Declarations();
			match(right_bracket );
		}
		case BEGIN:
		{
			parse_Declarations();
			match(left_curly_bracket);
			parse_Commands();
			match(right_curly_bracket );
			match(end );
		}
	}
}

void parse_Param_List()
{
	parse_Expression();
	match(comma );
	parse_Param_List2();
}

void parse_Param_List2()
{
	parse_Param_List();
}

void parse_Expression()
{
	next_token();
	switch(token.type)
	{
		case int_num:
			///
		case real_num:
			///
		case id:
		{
			match(binary_ar_op);
			parse_Expression();
		}
	}	
}

void parse_Condition()
{
	match(left_bracket );
	match(id );
	match(rel_op );
	match(id );
	match(right_bracket );
}

void match(int type) {
 token t = NextToken();
 if(t.token_type != type) {
	 fprintf(yyout , "Invalid token in line %d , \"%s\", expected %d \n" , t.line_number , t.token_lexeme , type)
	 t= BackToken();	
	 }
if (type == EOF) {
	 fprintf(yyout , "EOF\n")
	 fclose(yyout);
	 return;
	}
}















// Function that inserts the information into a linked list , each node in the linked list contains the type  number and the value
//======================================================================================================================================

void CreateAndStoreToken(int type, char *lexema, int lineNumber)
{
	//Handeling errors
	//================
	if(type == UNKNOWN)
	fprintf(yyout,"The character '%s' at line: %d does not BEGIN any legal token in the language\r\n" , lexema Number); 
	//Printing the values and the lines
	//=================================
	else
    fprintf(yyout,"Token from type '%d' was found at line: %d, lexeme: %s\r\n" , type Number, lexema);
	tokenToCreate.token_type = type;
	tokenToCreate.token_lexeme = (char *)malloc(strlen(lexema) + 1);
	strcpy(tokenToCreate.token_lexeme, lexema);
	tokenToCreate.line_number = lineNumber;
	
	if (curIndex > INDEX)
	{
		if (lastNode->idx == ARRAYLENGTH)
		{
			node *newNode = (node *)malloc(sizeof(node));
			newNode->idx = INDEX;
			newNode->nextNode = NULL;
			lastNode->nextNode = newNode;
			newNode->reverseNode = lastNode;			
			lastNode = curNode = newNode;
		}
	}
	else 
	{
		initNode = (node *)malloc(sizeof(node));
		initNode->idx = INDEX;
		initNode->reverseNode = initNode->nextNode = NULL;
		lastNode = curNode = initNode;
	}
	lastNode->idx++;
	lastNode->tokens[lastNode->idx] = tokenToCreate;
	curIndex++;
	}

// Main function
//==============

void main()
{
int option = 0;
while (option!=3)
{
printf("Please choose one of the options between 1-2, enter 3 for exit:\n"); 	//Selecting option to test
scanf("%d", &option);

while(option!= 1 && option!= 2 && option !=3){                                
printf("Please choose number between 1-2, Thanks.\n");
printf("Pkjdfklsdjflkjsdlkfjss.\n");
scanf("%d", &option);
}

switch(option){																	//Chossing your file
case 1:
FileToOpen=fopen("c:\\temp\\test1.txt", "r");
break;
case 2:
FileToOpen=fopen("C:\\temp\\test2.txt", "r");
break;
case 3:
exit();
break;
}

if (FileToOpen != NULL) 																// File was successfully opened
{
yyin = FileToOpen;
yyout=fopen("c:\\temp\\test_305229494_206087439_lex.txt","w");				    //Opening a result file to print out the results



// This is for EX1
//while (yylexLoop){ 																//Repeating for every token in the file
//	yylexLoop=yylex ();
//}

// For Ex2
parse_Program();


fclose(yyin);																	//Closing the first file after finishing
}
}
}