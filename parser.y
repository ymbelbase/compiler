/* ============================================================
 *  parser.y  –  Level 002
 *  Bison specification for a simple arithmetic expression parser.
 *
 *  Grammar (in informal BNF):
 *    input   : <empty> | input line
 *    line    : '\n' | expr '\n'
 *    expr    : expr '+' expr
 *            | expr '-' expr
 *            | expr '*' expr
 *            | expr '/' expr
 *            | '(' expr ')'
 *            | INTEGER
 *
 *  Operator precedence (lowest → highest):
 *    + -    (left-associative)
 *    * /    (left-associative)
 *    unary  (right-associative, handled via %right UMINUS)
 * ============================================================ */

%{
/* ---- C/C++ prologue ---------------------------------------- */
#include <stdio.h>
#include <stdlib.h>

/* Declarations for functions defined in the generated lexer    */
int  yylex   (void);
void yyerror (const char *s);
%}

/* ==============================================================
 * Bison declarations
 * ============================================================== */

/* %union defines the C type that yylval can hold.
 * Every token and non-terminal that carries a value must
 * declare which union member it uses.                           */
%union {
    int ival;   /* used by INTEGER tokens and expr non-terminals */
}

/* --- Token declarations ---
 * %token declares terminal symbols (tokens) produced by the lexer.
 * <ival> ties the token to the 'ival' member of the %union.    */
%token <ival> INTEGER

/* --- Precedence & associativity ---
 * Rules listed LATER have HIGHER precedence.
 * %left  → operators are left-associative  (a+b+c = (a+b)+c)
 * %right → operators are right-associative (a=b=c = a=(b=c))
 *
 * UMINUS is a fictitious token used only to assign the unary
 * minus a higher precedence than binary + and -.               */
%left  '+' '-'
%left  '*' '/'
%right UMINUS

/* --- Non-terminal type declarations ---
 * %type ties non-terminals to the 'ival' union member so the
 * parser knows how to pass values up the parse tree.           */
%type <ival> expr

%%
/* ==============================================================
 * Grammar rules section
 *
 * Each rule has the form:
 *     LHS : RHS1 { action1 }
 *           | RHS2 { action2 }
 *           ;
 *
 * $1, $2, … refer to the semantic values of the 1st, 2nd, …
 * symbol on the right-hand side.
 * $$ is the semantic value of the left-hand side non-terminal.
 * ============================================================== */

/* ---- Top-level rule -----------------------------------------
 * 'input' is the start symbol (first rule by default).
 * It matches zero or more lines, allowing the user to type
 * multiple expressions interactively.                           */
input
    : /* empty */
    | input line
    ;

/* ---- Line rule ----------------------------------------------
 * A blank newline is silently ignored.
 * An expression followed by newline is evaluated and printed.  */
line
    : '\n'
    | expr '\n'         { printf("= %d\n", $1); }
    ;

/* ---- Expression rules ---------------------------------------
 * These six rules implement the full arithmetic grammar.
 * Bison uses the %left/%right/%right declarations above to
 * resolve shift/reduce conflicts in favour of the correct
 * associativity and precedence.                                 */
expr
    : INTEGER               { $$ = $1; }

    | expr '+' expr         { $$ = $1 + $3; }
    | expr '-' expr         { $$ = $1 - $3; }
    | expr '*' expr         { $$ = $1 * $3; }
    | expr '/' expr         {
                                if ($3 == 0) {
                                    yyerror("division by zero");
                                    $$ = 0;
                                } else {
                                    $$ = $1 / $3;
                                }
                            }

    /* Parenthesised sub-expression: value is just the inner expr */
    | '(' expr ')'          { $$ = $2; }

    /* Unary minus: %prec UMINUS overrides the default precedence
     * of '-' so that the unary form binds tighter than binary +/-.
     * Example: -3 + 4  is  (-3) + 4, not -(3+4).               */
    | '-' expr  %prec UMINUS  { $$ = -$2; }
    ;

%%
/* ==============================================================
 * User code section
 * ============================================================== */

/* yyerror is called by the Bison-generated parser whenever a
 * syntax error is detected.                                     */
void yyerror(const char *s) {
    fprintf(stderr, "Parser error: %s\n", s);
}

/* main() is the program entry point.
 * yyparse() drives the parser; it calls yylex() internally
 * every time it needs the next token.                          */
int main(void) {
    printf("Arithmetic Expression Evaluator\n");
    printf("Enter an expression (e.g.  3 + 4 * 2) and press Enter.\n");
    printf("Press Ctrl-D (EOF) to exit.\n\n");
    yyparse();
    return 0;
}