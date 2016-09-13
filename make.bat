@echo off
bison --defines param.y -o url.cpp
rem g++ snazzle.tab.c -LC:\Toolkits\GnuWin32\lib -ly -o snazzle_parse
flex -oscanner.cpp param.l 
g++ url.cpp scanner.cpp -LC:\Toolkits\GnuWin32\lib -lfl -o url_parser.exe