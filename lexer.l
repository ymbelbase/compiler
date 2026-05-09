%{
#include "parser.tab.h"
#include <stdlib.h>
#include <stdio.h>
%}

%option noyywrap nounput noinput

%%

[0-9]+      { yylval.ival = atoi(yytext); return INTEGER; }

"+"         { return '+'; }
"-"         { return '-'; }
"*"         { return '*'; }
"/"         { return '/'; }
"("         { return '('; }
")"         { return ')'; }

[ \t\r]+    { }

"\n"        { return '\n'; }

.           { fprintf(stderr, "Lexer error: unknown character '%c'\n", yytext[0]); }

%%