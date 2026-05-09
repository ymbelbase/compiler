# ============================================================
#  Makefile – build the Flex/Bison arithmetic evaluator
#
#  Usage:
#    make          – build the 'calc' binary
#    make clean    – remove all generated files
#    make run      – build then launch the evaluator
# ============================================================

CXX      = g++
CXXFLAGS = -Wall -Wextra -std=c++17

TARGET   = calc

all: $(TARGET)

# Step 1 – Run Bison to produce parser.tab.c + parser.tab.h
#   -d  : write the header file (token definitions for the lexer)
#   -v  : write parser.output (human-readable automaton report)
parser.tab.c parser.tab.h: parser.y
	bison -d -v parser.y

# Step 2 – Run Flex to produce lex.yy.c
lex.yy.c: lexer.l parser.tab.h
	flex lexer.l

# Step 3 – Compile and link everything
$(TARGET): parser.tab.c lex.yy.c
	$(CXX) $(CXXFLAGS) -o $@ parser.tab.c lex.yy.c -lfl

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(TARGET) parser.tab.c parser.tab.h lex.yy.c parser.output

.PHONY: all run clean