%{
#include "url.hpp"
using namespace std;
#define YY_DECL extern "C" int yylex()
%}

%%
"://"	{return SCHEME_END;}
":"		{yylval.cval=yytext[0]; return PORT_START;}
"?"		{yylval.cval=yytext[0]; return QUERY_START;}
"#"		{yylval.cval=yytext[0]; return ID_START;}
(&|;)	{yylval.cval=yytext[0]; return PARAM_NEXT;}
"="		{yylval.cval=yytext[0]; return EQUAL;}
"/"		{yylval.cval=yytext[0]; return PATH_START;}
[a-zA-Z] {yylval.cval=yytext[0]; return LETTER;}
[0-9]	{yylval.cval=yytext[0]; return DIGIT;}
"-"		{yylval.cval=yytext[0]; return MINUS;}	
"+"		{yylval.cval=yytext[0]; return PLUS;} 
"_"		{yylval.cval=yytext[0]; return UNDER;} 
"."		{yylval.cval=yytext[0]; return DOT;} 
"~"		{yylval.cval=yytext[0]; return TILDE;} 
"%"		{yylval.cval=yytext[0]; return PERCENT;} 
"*"		{yylval.cval=yytext[0]; return STAR;}
"!"		{yylval.cval=yytext[0]; return EXCL;}
","		{yylval.cval=yytext[0]; return COMMA;} 
[ \t\n] {yylval.cval=yytext[0]; return WHITE;} 
['\(\)@\$\?#\[\]] {yylval.cval=yytext[0]; return SPECIAL;}

%%
/*
main(int argc, char** argv) {
	
	// open a file handle to a particular file:
	if(argc == 1)
	{
		cerr<< "Usage: " << argv[0] << " <filename>" << endl;
		return -1;
	}
	
	FILE *myfile = fopen(argv[1], "r");
	// make sure it's valid:
	if (!myfile) {
		cerr << "I can't open "<< argv[1] << "!" << endl;
		return -1;
	}
	// set lex to read from it instead of defaulting to STDIN:
	yyin = myfile;
	
	// lex through the input:
	yylex();
}
*/