#!/bin/bash
bison -d parse.y
flex lex.flex
g++ lex.yy.c parse.tab.c -lfl -o parse
./parse a4.txt 
gcc assCode.s -o test 
./test
