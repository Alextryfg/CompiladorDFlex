%{
#include "definiciones.h"
#include "errores.h"
#include "tabladesimbolos.h"
%}

%option noyywrap

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

COMENTARIO_BLOQUE {\/\*(.|\n)*?\*\/}
COMENTARIO_LINEA {\/\/.*}

STRING {\"(.\\\").*\"}

OPERADORES (\+\+|\-|\-\=|\<\<|\>|\>\=|\>\>|\(|\)|\{|\}|\[|\]|\,|\.|\;|\=|\&\&|\|\||\+|\+\=|\-\-|\|\\=|\/|\/\=|\<|\<\=)


%%

[ \t\n]+      
COMENTARIO_BLOQUE  
COMENTARIO_LINEA    

{IDENTIFICADOR}     return ID;

{NUM_ENTERO}         return INTEGER;

{NUM_FLOAT}         return FLOATPOINT;

{OPERADORES}        return OPERADOR;

"/+" {
//Numero de comentarios anidades, al principio es minimo uno debido al /+
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

%%


// se intenta abrir el archivo dado su nombre
void init(char *nombreArchivo){
    FILE *archivo;
    archivo = fopen(nombreArchivo, "r");
    if(archivo == NULL){
        //showError(1);
    }
    yyin = archivo;
}

void siguiente_componente_lexico(tipoelem *actual){
    actual->codigo = yylex();
    if(actual->codigo != 0){
        actual->lexema = strdup(yytext);
    }
    if(actual->codigo == ID){
        //buscar en la tabla de simbolos
        findCodigo(actual);
    }else if(actual->codigo == -1){
        //componente lexico no reconocido
        //showError(8);
    }else if(actual->codigo == OPERADOR){
        //si es solo un caracter se devuekve como codigo su codigo ascii
        //de esta forma coincide por completo con los codigos de la práctica anterior
        if(strlen(actual->lexema)==1){
            actual->codigo = actual->lexema[0];
        }
    }else if(actual->codigo == 0){
        //al llamar a yyterminate, se devuelve 0
        //se debe cambiar al codigo que tenemos definido para EOF en definiciones.h
        actual->codigo = -1;
    }
}

void cerrarD(){
    fclose(yyin);
    yylex_destroy();
}