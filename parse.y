%{
#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <fstream>
#include <queue>
#include <stack>
#include <string>
#include "asmGenerator.cpp" 
#include "ast.cpp"

using namespace std;

extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;
extern "C" void yyerror(const char *);

int isReginit[27] = {};
int lcount = 0;
int icount = 0;
int scount = 0;
queue<string> bodycode;
queue<string> initcode;
queue<string> initstring;
stack<NodeAst*> nodes;

%}

%define parse.error verbose
%union{
	int dval;
	char* strval;
	int chval;
}

%token <dval> NUM
%token <chval> ID
%token <strval> STRING 
%token SHOW INT IF LOOP ASSIGN TO END
%left '+' '-' 
%left '*' '/' '%' EQUAL
%left '(' ')'
%left '{' '}'
%type <dval> exp cond
%type <chval> var
%start result

%%
result 	:
		|	result stas 					{

											}							
		| 	result if END 					{

											}					
		| 	result loop END 				{

											}								
		;

stas 	: 
		| 	 stas sta END
		;

sta 	:
			SHOW exp 							{
													NodeAst* nodeExp = nodes.top();
													nodes.pop();	
													bodycode.push(show(nodeExp->getAddress()));
												}
		| 	SHOW str 							{
													bodycode.push(showString(scount++));
												}
		| 	var ASSIGN exp						{
													NodeAst* nodeExp = nodes.top();
													nodes.pop();
													NodeAst* nodeVar = nodes.top();
													nodes.pop();
													bodycode.push(assign(nodeExp->getAddress(),nodeVar->getAddress()));
												}
		;
str     :
			STRING								{
													initstring.push(init_string($1,scount));
												}
		;
if 		:
	 		IF '(' cond ')' '{' END stas '}'	{ 
	 												bodycode.push(asif(icount++));
	 											}
		;
conloop	:
			var NUM TO NUM						{
													bodycode.push(constn($2));
													bodycode.push(constn($4));

													NodeAst* nodeVar = nodes.top();
													nodes.pop();

													bodycode.push(asloophead(nodeVar->getAddress(),lcount));
												}
		;
loop 	: 
			LOOP conloop '{' END stas '}' 		{
													bodycode.push(loopend(lcount++));	
												}	
		;

exp		: 
			NUM									{ 	
													NodeAst* nconst = new NodeAst(-1,$1,'c',NULL,NULL);
													bodycode.push(constn($1));
													nodes.push(nconst);
												}
		| 	ID   								{	
													NodeAst* var = new NodeAst($1,-1,'v',NULL,NULL);
													if(isReginit[$1] == 0){
														initcode.push(init_var(var->getAddress()));
														isReginit[$1] = 1;
													}
													nodes.push(var);
												}
		| 	exp '-' exp							{	
													NodeAst* right = nodes.top();
													nodes.pop();
													NodeAst* left = nodes.top();
													nodes.pop();
													NodeAst* subn = new NodeAst(-1,-1,'s',left,right);
													nodes.push(subn);
													bodycode.push(sub(left->getAddress(),right->getAddress()));
												}

		| 	exp '+' exp 						{
													NodeAst* right = nodes.top();
													nodes.pop();
													NodeAst* left = nodes.top();
													nodes.pop();
													NodeAst* addn = new NodeAst(-1,-1,'a',left,right);
													nodes.push(addn);
													bodycode.push(add(left->getAddress(),right->getAddress()));
												}
		| 	exp '*' exp 						{
													NodeAst* right = nodes.top();
													nodes.pop();
													NodeAst* left = nodes.top();
													nodes.pop();
													NodeAst* muln = new NodeAst(-1,-1,'m',left,right);
													nodes.push(muln);
													bodycode.push(mul(left->getAddress(),right->getAddress()));
												}
		| 	exp '/' exp							{	
													NodeAst* right = nodes.top();
													nodes.pop();
													NodeAst* left = nodes.top();
													nodes.pop();
													NodeAst* divn = new NodeAst(-1,-1,'d',left,right);
													nodes.push(divn);
													bodycode.push(divide(left->getAddress(),right->getAddress()));
												}
		| 	exp '%' exp							{
													NodeAst* right = nodes.top();
													nodes.pop();
													NodeAst* left = nodes.top();
													nodes.pop();
													NodeAst* modn = new NodeAst(-1,-1,'M',left,right);
													nodes.push(modn);
													bodycode.push(mod(left->getAddress(),right->getAddress()));	
												}
		| 	'-' exp								{
													NodeAst* right = nodes.top();
													nodes.pop();
													NodeAst* nneg = new NodeAst(-1,-1,'n',NULL,right);
													nodes.push(nneg);
													bodycode.push(neg(right->getAddress()));
												}
		| 	'(' exp ')'							{	
													$$ = $2;
												}
		;

cond 	: 
			NUM									{	
													NodeAst* nconst = new NodeAst(-1,$1,'c',NULL,NULL);
													bodycode.push(constn($1));
													nodes.push(nconst);
												}
		| 	exp EQUAL exp 						{	
													NodeAst* right = nodes.top();
													nodes.pop();
													NodeAst* left = nodes.top();
													nodes.pop();
													bodycode.push(condition(left->getAddress(),right->getAddress(),icount));
												}
		;

var 	: 
			ID 									{	
													NodeAst* var = new NodeAst($1,-1,'v',NULL,NULL);
													if(isReginit[$1] == 0){
														initcode.push(init_var(var->getAddress()));
														isReginit[$1] = 1;
													}
													nodes.push(var);
												}   
		;     
%%

void yyerror(const char *s) {
	cout << "parse error!  Message: " << s << endl;
	exit(-1);
}
int main(void) {
  	FILE *myfile = fopen("a.txt", "r");
  	if (!myfile) {
    	cout << "I can't open file" << endl;
    	return -1;
  	}
  	yyin = myfile;
    do {
    	yyparse();
  	} while (!feof(yyin));

  	ofstream file;
  	file.open("assCode.s");
  	file<<head()<<endl;
  	while(!initcode.empty()){
  		file<<initcode.front()<<endl;
  		initcode.pop();
  	}
  	while(!bodycode.empty()){
  		file<<bodycode.front()<<endl;
  		bodycode.pop();
  	}
  	file<<foot()<<endl;
   	while(!initstring.empty()){
  		file<<initstring.front()<<endl;
  		initstring.pop();
  	}
  	file.close();
  	return 0;
}