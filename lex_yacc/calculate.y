%{
void yyerror (char *s);
int yylex();

#include <stdio.h>     
#include <stdlib.h>
#include <ctype.h>


int symbols[52];
int SymbolValue(char symbol);
void updateSymbolValue(char symbol, int val);

%}

%union {int num; char id;}         
%start line
%token print
%token exit_command
%token <num> number
%token <id> identifier
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS
%type <num> line exp term 
%type <id> assignment

%%



line    : assignment ';'		{;}
	| exit_command ';'		{exit(EXIT_SUCCESS);}
	| print exp ';'			{printf("The answer is %d\n", $2);}
	| line assignment ';'		{;}
	| line print exp ';'		{printf("The answer is %d\n", $3);}
	| line exit_command ';'		{exit(EXIT_SUCCESS);}
	
        ;

assignment : identifier '=' exp  { updateSymbolValue($1,$3); }
			;
exp    	: term                  {$$ = $1;}
	| exp '+'  exp          {$$ = $1 + $3;}
       	| exp '-'  exp          {$$ = $1 - $3;}
	| exp '*'  exp          {$$ = $1 * $3;}
	| exp '/'  exp          {$$ = $1 / $3;}
	| '-'exp %prec UMINUS	{$$ = -$2;}
	| '(' exp ')' 		{$$ = $2;}
       	;
term   	: number                {$$ = $1;}
	| identifier		{$$ = SymbolValue($1);} 
        ;

%%                     

int TransferSymbolIdx(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
} 

int SymbolValue(char symbol)
{
	int bucket = TransferSymbolIdx(symbol);
	return symbols[bucket];
}

void updateSymbolValue(char symbol, int val)
{
	int bucket = TransferSymbolIdx(symbol);
	symbols[bucket] = val;
}
int main (void) {

	int i;
	for(i=0; i<52; i++) {
		symbols[i] = 0;
	}

	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 

