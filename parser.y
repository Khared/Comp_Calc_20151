%{
#include <stdlib.h>
#include <stdio.h>

%}

%union {
	struct ast_node *ast;
	double number;
	int operator;
	struct symbol_node *symbol;
}

%token AND THEN ATRIBUI ELSE IGUAL GE MAIOR IF LE LPAREN MENOR
%token MENOS NEQ OR DIV MAIS RPAREN MULT UMINUS
%token WHILE
%token <number> NUM
%token <symbol> ID

%left <operator>IGUAL NEQ
%left GE MAIOR LE MENOR
%left MULT DIV
%left MAIS MENOS

%nonassoc ELSE
%right ATRIBUI
%left LPAREN RPAREN
%right UMINUS

%type <ast> exp exp_list statement selection_statement iteration_statement

%%

exp:	exp IGUAL exp	{ $$ = new_ast_equality_node ($2, $1, $3); }
	| exp MAIS exp	{ $$ = new_ast_node ('+', $1, $3); }
	| exp MENOS exp	{ $$ = new_ast_node ('-', $1, $3);}
	| exp MULT exp	{ $$ = new_ast_node ('*', $1, $3); }
	| exp DIV exp	{ $$ = new_ast_node ('/', $1, $3); }
	| LPAREN exp RPAREN	{ $$ = $2; }
	| '-' exp %prec UMINUS	{ $$ = new_ast_node ('M', $2, NULL); }
	| NUM	{ $$ = new_ast_number_node ($1); }
	| exp AND exp
	| exp OR exp
	| exp NEQ exp
	| exp GE exp
	| exp LE exp
	| exp MENOR exp
	| exp MAIOR exp
	| ID	{ $$ = new_ast_symbol_reference_node ($1); }
	| ID ATRIBUI exp	{ $$ = new_ast_assignment_node ($1, $3); }
	;

exp_list: exp
	| exp ',' exp_list { $$ = new_ast_node ('L', $1, $3); }
	;

statement: selection_statement
	| iteration_statement
	//| ID ATRIBUI exp	{ $$ = new_ast_assignment_node ($1, $3); }	//Adicionei Isso
	;

selection_statement: IF LPAREN exp RPAREN THEN statement	{	$$ = new_ast_if_node ($3, $6, NULL);	}
		| IF LPAREN exp RPAREN THEN statement ELSE statement	{	$$ = new_ast_if_node ($3, $6, $8);	}
		;

iteration_statement: WHILE LPAREN exp RPAREN statement { $$ = new_ast_while_node ($3, $5); }
;

%%

void yyerror(const char *s) {
	printf("syntax error: %s\n", s);
	exit(1);
}
