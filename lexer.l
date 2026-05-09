%{
/* llvm_includes.h MUST come before parser.tab.h so that
 * llvm::Value is a complete type when the %union is seen.   */
#include "llvm_includes.h"
#include "parser.tab.h"
#include "codegen.h"
#include <stdlib.h>
#include <stdio.h>
%}

%option noyywrap nounput noinput

%%

[0-9]+      { yylval.val = makeInt(atoi(yytext)); return INTEGER; }

"+"         { return '+'; }
"-"         { return '-'; }
"*"         { return '*'; }
"/"         { return '/'; }
"("         { return '('; }
")"         { return ')'; }

[ \t\r]+    { }

"\n"        { return NEWLINE; }

.           { fprintf(stderr, "Lexer error: unknown char '%c'\n", yytext[0]); }

%%