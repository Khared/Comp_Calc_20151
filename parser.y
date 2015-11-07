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

%type <node> stmts stmt while_decl if_decl attrib_decl
%type <node> expr

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

expr:	exp IGUAL exp	{ $$ = new_ast_equality_node ($2, $1, $3); }
	| exp MAIS exp	{ $$ = new_ast_node ('+', $1, $3); }
	| exp MENOS exp	{ $$ = new_ast_node ('-', $1, $3);}
	| exp VEZES exp	{ $$ = new_ast_node ('*', $1, $3); }
	| exp DIV exp	{ $$ = new_ast_node ('/', $1, $3); }
	| LPAREN exp RPAREN	{ $$ = $2; }
	| '-' exp %prec UMINUS	{ $$ = new_ast_node ('M', $2, NULL); }
	| NUM	{ $$ = new_ast_number_node ($1); }
	| ID	{ $$ = new_ast_symbol_reference_node ($1); }
	| ID ATRIBUI exp	{ $$ = new_ast_assignment_node ($1, $3); }
	;

exp_list: exp
	| exp ',' exp_list { $$ = new_ast_node ('L', $1, $3); }
	;

statement: selection_statement
	| iteration_statement
	;

selection_statement: IF LPAREN exp RPAREN statement	{	$$ = new_ast_if_node ($3, $5, NULL);	}
		| IF LPAREN exp RPAREN statement ELSE statement	{	$$ = new_ast_if_node ($3, $5, $7);	}
		;

iteration_statement: WHILE LPAREN exp RPAREN statement { $$ = new_ast_while_node ($3, $5); }
;

%%

void yyerror(const char *s) {
	printf("syntax error: %s\n", s);
	exit(1);
}
