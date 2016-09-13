%{
#include <iostream>
#include <string>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "url.hpp"  // to get the token types that we return
using namespace std;

// stuff from flex that bison needs to know about:
extern "C" int yylex();
extern "C" int yyparse();
extern "C" FILE *yyin;

int str_add(char** dst, char* add, int len);
void yyerror(const char *msg);
%}


%union{
	char* str;
	char cval;
}

%token SCHEME_END
%token <cval> PORT_START
%token <cval> QUERY_START
%token <cval> ID_START
%token <cval> PARAM_NEXT
%token <cval> EQUAL
%token <cval> PATH_START
%token <cval> LETTER
%token <cval> DIGIT
%token <cval> MINUS
%token <cval> PLUS
%token <cval> UNDER
%token <cval> DOT
%token <cval> TILDE
%token <cval> PERCENT
%token <cval> STAR
%token <cval> EXCL
%token <cval> COMMA
%token <cval> WHITE
%token <cval> SPECIAL


%type <str> scheme
%type <str> domain
%type <str> domain_name
%type <str> domain_name_rest
%type <str> hyphen
%type <str> port
%type <str> path
%type <str> path_name
%type <str> path_name_rest
%type <str> queries
%type <str> query
%type <str> field
%type <str> value
%type <str> id

%%

url: scheme SCHEME_END url_domain {cerr<< "Scheme: " << $1 << endl;}
	| url_domain

url_domain: domain url_port {cerr<< "Domain: " << $1 << endl;}

url_port: PORT_START port url_path {cerr<< "Port: " << $2 << endl;}
	| url_path

url_path: path url_query {cerr<< "Path: " << $1 << endl;}
	| url_query

url_query: QUERY_START queries url_id
	| url_id

url_id: 
	| ID_START id {cerr<< "Fragment-ID: " << $2 << endl;}



scheme: scheme LETTER {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| LETTER {$$=0; str_add(&$$, &$1, 1);}
	
	
domain: domain DOT domain_name {$$=0; str_add(&$$, $1, 0);str_add(&$$, &$2, 1);str_add(&$$, $3, 0);}
	| domain_name {$$=0; str_add(&$$, $1, 0);}
	
domain_name: domain_name hyphen domain_name_rest {$$=0; str_add(&$$, $1, 0);str_add(&$$, $2, 0);str_add(&$$, $3, 0);}
	| domain_name_rest{$$=0; str_add(&$$, $1, 0);}
	
hyphen: hyphen MINUS {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| MINUS {$$=0; str_add(&$$, &$1, 1);}
	
domain_name_rest: domain_name_rest LETTER {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| domain_name_rest DIGIT {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| DIGIT {$$=0; str_add(&$$, &$1, 1);}
	| LETTER {$$=0; str_add(&$$, &$1, 1);}

	
port: port DIGIT {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| DIGIT {$$=0; str_add(&$$, &$1, 1);}
	
	
path: PATH_START path_name path {$$=0; str_add(&$$, &$1, 1); str_add(&$$, $2, 0);str_add(&$$, $3, 0);}
	| PATH_START path_name {$$=0; str_add(&$$, &$1, 1); str_add(&$$, $2, 0)}
	| PATH_START {$$=0; str_add(&$$, &$1, 1);}
	
path_name: path_name DOT path_name_rest {$$=0; str_add(&$$, $1, 0);str_add(&$$, &$2, 1);str_add(&$$, $3, 0);}
	| path_name_rest {$$=0; str_add(&$$, $1, 0);}
	
path_name_rest: path_name_rest LETTER {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| path_name_rest DIGIT {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| path_name_rest TILDE {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| path_name_rest PERCENT {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| path_name_rest UNDER {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| path_name_rest MINUS {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| path_name_rest PLUS {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| LETTER {$$=0; str_add(&$$, &$1, 1);}
	| DIGIT {$$=0; str_add(&$$, &$1, 1);}
	| TILDE {$$=0; str_add(&$$, &$1, 1);}
	| PERCENT {$$=0; str_add(&$$, &$1, 1);}
	| UNDER {$$=0; str_add(&$$, &$1, 1);}
	| MINUS {$$=0; str_add(&$$, &$1, 1);}
	| PLUS {$$=0; str_add(&$$, &$1, 1);}

	
queries: queries PARAM_NEXT query {cerr<< "Query: " << $3 << endl;}
	| query {cerr<< "Query: " << $1 << endl;}

query: field EQUAL value {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1); str_add(&$$, $3, 0);}

field: field LETTER {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| field DIGIT {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| field TILDE {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| field PERCENT {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| field UNDER {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| field MINUS {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| field PLUS {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| field STAR {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| field DOT {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| LETTER {$$=0; str_add(&$$, &$1, 1);}
	| DIGIT {$$=0; str_add(&$$, &$1, 1);}
	| TILDE {$$=0; str_add(&$$, &$1, 1);}
	| PERCENT {$$=0; str_add(&$$, &$1, 1);}
	| UNDER {$$=0; str_add(&$$, &$1, 1);}
	| MINUS {$$=0; str_add(&$$, &$1, 1);}
	| PLUS {$$=0; str_add(&$$, &$1, 1);}
	| STAR {$$=0; str_add(&$$, &$1, 1);}
	| DOT {$$=0; str_add(&$$, &$1, 1);}
	
value: value LETTER {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| value DIGIT {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| value TILDE {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| value PERCENT {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| value UNDER {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| value MINUS {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| value PLUS {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| value STAR {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| value DOT {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| LETTER {$$=0; str_add(&$$, &$1, 1);}
	| DIGIT {$$=0; str_add(&$$, &$1, 1);}
	| TILDE {$$=0; str_add(&$$, &$1, 1);}
	| PERCENT {$$=0; str_add(&$$, &$1, 1);}
	| UNDER {$$=0; str_add(&$$, &$1, 1);}
	| MINUS {$$=0; str_add(&$$, &$1, 1);}
	| PLUS {$$=0; str_add(&$$, &$1, 1);}
	| STAR {$$=0; str_add(&$$, &$1, 1);}
	| DOT {$$=0; str_add(&$$, &$1, 1);}

	
id: id LETTER {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| id DIGIT {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| id TILDE {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| id QUERY_START {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| id PORT_START {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| id PATH_START {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| id EQUAL {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| id PERCENT {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| id UNDER {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| id MINUS {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| id PLUS {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| id STAR {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| id DOT {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| id EXCL {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| id COMMA {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| id PARAM_NEXT {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| id SPECIAL {$$=0; str_add(&$$, $1, 0); str_add(&$$, &$2, 1);}
	| LETTER {$$=0; str_add(&$$, &$1, 1);}
	| DIGIT {$$=0; str_add(&$$, &$1, 1);}
	| TILDE {$$=0; str_add(&$$, &$1, 1);}
	| QUERY_START {$$=0; str_add(&$$, &$1, 1);}
	| PORT_START {$$=0; str_add(&$$, &$1, 1);}
	| PATH_START {$$=0; str_add(&$$, &$1, 1);}
	| EQUAL {$$=0; str_add(&$$, &$1, 1);}
	| PERCENT {$$=0; str_add(&$$, &$1, 1);}
	| UNDER {$$=0; str_add(&$$, &$1, 1);}
	| MINUS {$$=0; str_add(&$$, &$1, 1);}
	| PLUS {$$=0; str_add(&$$, &$1, 1);}
	| STAR {$$=0; str_add(&$$, &$1, 1);}
	| DOT {$$=0; str_add(&$$, &$1, 1);}
	| EXCL {$$=0; str_add(&$$, &$1, 1);}
	| COMMA {$$=0; str_add(&$$, &$1, 1);}
	| PARAM_NEXT {$$=0; str_add(&$$, &$1, 1);}
	| SPECIAL {$$=0; str_add(&$$, &$1, 1);}


	
%%
main(int argc, char** argv) {
	if(argc == 1)
	{
		cerr<< "Usage: " << argv[0] << " <filename>" << endl;
		return -1;
	}
	
	FILE *file = fopen(argv[1], "r");
	if (!file) {
		cerr << "Can't open "<< argv[1] << "!" << endl;
		return -1;
	}
	yyin = file;

	do {
		yyparse();
	} while (!feof(yyin));		
	return 0;
}

void yyerror(const char *msg) {
	cerr << "Error!" <<	endl;
	exit(-1);
}


int str_add(char** dst, char* add, int len)
{
	char* result = 0;
	char *sub = 0;
	int alen = 0;
	int dlen = 0;
	
	if(!dst)
		return 0;
		
	if(add && (len != 1))
		alen = strlen(add);
	else if(add && (len == 1))
		alen = 1;
		
	if(*dst)
		dlen = strlen(*dst);
		
	if(!add)
		return 0;
		
	if((len > 0) && (len < alen))
		alen = len;
		
	sub = (char*)malloc((alen+1) * sizeof(char));
	memcpy(sub, add, alen);
	sub[alen] = 0;
	
	if(alen+dlen > 0)
	{
		result = (char*)malloc((alen+dlen+1)*sizeof(char));
		if(*dst)
			strcpy(result, *dst);
		strcpy(&result[dlen], sub);
		result[dlen+alen] = 0;
	}
	if(*dst)
		free(*dst);
	if(sub)
		free(sub);
		
	(*dst) = result;
		
	return alen + dlen;
}