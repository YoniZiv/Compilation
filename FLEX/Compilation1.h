#define LETTER 1
#define NUMBER 2
#define DIGIT 3
#define EQUALS 4
#define NOT_EQUALS 5
#define GREATER 6
#define GREATER_EQUALS 7
#define SMALLER 8
#define SMALLER_EQUALS 9
#define OPEN_BRACKETS 10
#define CLOSING_BRACKETS 11
#define OPEN_CURLY_BRACKETS 12
#define CLOSING_CURLY_BRACKETS 13
#define PARBEGIN 14
#define PAREND 15
#define TASK 16
#define BEGIN 17 
#define END 18
#define DO 19	
#define UNTIL 20 
#define OD 21
#define SEND 22  
#define ACCEPT 23
#define ADDITION 24
#define SUBTRUCTION 25  
#define MULTIPLICATION 26
#define DIVISION 27
#define EOF 28
#define UNKNOWN 29
#define SEMICOLON 30
#define INDEX 0
#define STARTINGPOS 0
#define ARRAYLENGTH  - 1
#define ARRAYSIZE 99

//  The tokens struct 
typedef struct token {
	int token_type;
	char* token_lexeme;
	int line_number;
} token;

// The nodes struct to contain the information of the tokens
typedef struct Node
{
	struct node *reverseNode, *nextNode;
	int idx;
	token tokens[ARRAYSIZE];
}node;

extern int yylex();

int curIndex = INDEX;
int counter = STARTINGPOS;
node *initNode;
node *curNode;
node *lastNode;

token NextToken()
{
	if (counter == 0) 
	{
		yylex();
		return lastNode->tokens[lastNode->idx];
	}
	else 
	{
		counter--;
		if (curNode->idx == ARRAYLENGTH)
		{
			curNode = (node *)curNode->nextNode;
			curNode->idx = 0;
			return curNode->tokens[curNode->idx];
		}

		return curNode->tokens[++(curNode->idx)];
	}
}

token BackToken()
{
	counter++;
	if (curNode->idx == 0)
	{
		curNode = (node *)curNode->reverseNode;
		return curNode->tokens[ARRAYLENGTH];
	}

	return curNode->tokens[--(curNode->idx)];
}
