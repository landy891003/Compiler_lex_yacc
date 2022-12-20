all:y.tab.c lex.yy.c calculate

y.tab.c:calculate.y
	yacc -d calculate.y
lex.yy.c:calculate.l
	lex calculate.l
calculate:y.tab.c lex.yy.c
	cc y.tab.c lex.yy.c -o calculate
clean:
	rm -f y.tab.c lex.yy.c calculate y.tab.h
