%{
#include "definiciones.h"
#include "errores.h"
#include "tabladesimbolos.h"
%}

%option noyywrap

%option nounput

ALFA [a-zA-Z]
BARRABAJA [_]
DIGITO [0-9]
NUMERO_BINARIO [0-1]

IDENTIFICADOR ({ALFA}|{BARRABAJA})({ALFA}|{BARRABAJA}|{DIGITO})*

ENTERO_DECIMAL {DIGITO}({BARRABAJA}|{DIGITO})*
ENTERO_BINARIO 0b|0B({BARRABAJA}|{NUMERO_BINARIO})*
NUM_ENTERO {ENTERO_DECIMAL}|{ENTERO_BINARIO}

EXPONENCIAL [eE][+-]?{DIGITO}+
DIGITO_SEPARADO {DIGITO}([_]?{DIGITO})* 
DECIMAL ({DIGITO_SEPARADO}*\.{DIGITO_SEPARADO}+({EXPONENCIAL})?|\.{DIGITO_SEPARADO}+({EXPONENCIAL})?)
ENTERO_DECIMAL_2 ({DIGITO_SEPARADO}+{EXPONENCIAL})?

NUM_FLOAT {DECIMAL}|{ENTERO_DECIMAL_2}

STRING (\"(.*\\\")*.*\")

OPERADORES (\{|\}|\(|\)|\*\*|\=\=|\+\+|\+\=|\-\-|\-\=|\,|\.|\;|\:|\<|\>|\<\<|\>\>|\?|\=|\*|\*\=|\-|\+|\[|\]|\/|\/\=|\%)


%%

[ \t\n]+  /* Espacios y saltos de linea que tambien ignora */
\/\/(.*)  /* Comentario de una sola linea */   
("/*"([^*]|(\*+[^*/]))*\*+\/) /* Comentario en bloque */

{IDENTIFICADOR}     return ID;

{NUM_ENTERO}        return INTEGER;

{NUM_FLOAT}         return FLOATPOINT;

{STRING}            return STRING;

{OPERADORES}        return OPERADOR;

"/+" {
//Numero de comentarios anidados, al principio es minimo uno debido al /+
int num = 1;
register int c;

// Mientras sea mayor que 0 y no sea un EOF
while (num > 0 && c != EOF) {
    c = input();
    //Si es un '+/' quiere decir que cierra comentario, por lo que se resta al contador
    if (c == '+') {
        c = input();
        if (c == '/') {
            num--;
        }
    }
    //Si es '/+' quiere decir que abre y por lo tanto se suma
    else if (c == '/') {
        c = input();
        if (c == '+') {
            num++;
        }
    }
}
}

<<EOF>>         yterminate();

%%



void init(char *nombreArchivo){
    FILE *archivo;
    archivo = fopen(nombreArchivo, "r");
    if(archivo == NULL){
        errorD(1);
    }
    yyin = archivo;
}

void siguiente_componente_lexico(tipoelem *comp){

    //Recogremos el codigo del siguiente componente detectado
    comp->codigo = yylex();


    if(comp->codigo != 0){
        //Copiamos yytext en comp->lexema
        comp->lexema = strdup(yytext);
    }
    if(comp->codigo == ID){
        //Buscamos el codigo en la tabla de simbolos
        findCodigo(comp);
    }else if(comp->codigo == -2){
        //componente lexico no reconocido
        errorD(6);
    }else if(comp->codigo == OPERADOR){
        //Operador de un solo carácter, se devuelve su ASCII, de otra forma devolvemos el codigo de OPERADOR
        if(strlen(comp->lexema)==1){
            comp->codigo = comp->lexema[0];
        }
    }else if(comp->codigo == 0){
        //Con EOF, devolvemos 0 de yyterminate y lo transformamos en -1 para el sintactico acabe
        comp->codigo = -1;
        
    }
}

void cerrarD(){
    fclose(yyin);
    yylex_destroy();
}