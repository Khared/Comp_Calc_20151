%{

#include <stdio.h>
#include <string.h>

%}

id [_a-zA-Z][a-zA-Z0-9_]*
digito	[0-9]
numero	{digito}+

%%

[\n]	//Ignora o ENTER

[\t ]+	//Ignora o TAB

"if"		return IF;
"then"		return THEN;
"else"		return ELSE;
"while"		return WHILE;
"+"		return MAIS;
"-"		return MENOS;
"*"		return MULT;
"/"		return DIV;
"and"		return AND;
"or"		return OR;
"=="		return IGUAL;
"~="		return NEQ;
"<="		return LE;
">="		return GE;
"<"		return MENOR;
">"		return MAIOR;
"="		return ATRIBUI;
"("		return LPAREN;
")"		return RPAREN;
{id}		return ID;
{numero}	{ yylval = atoi(yytext); return NUM;}

.	printf("Erro lexico!\nCaractere nao reconhecido: %s", yytext);

%%
