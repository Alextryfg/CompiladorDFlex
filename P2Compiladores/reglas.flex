%{
#include "definiciones.h"
#include "errores.h"
#include "tablaSimbolos.h"
%}

//Caracteres

ALFA [a-zA-Z]
BARRABAJA [_]
DIGITO [0-9]
NUMERO_BINARIO [0-1]

//lexema

IDENTIFICADOR {ALFA}|{BARRABAJA}({ALFA}|{BARRABAJA}|{DIGITO})*

//ENTEROS

ENTERO_DECIMAL {DIGITO}({BARRABAJA}|{DIGITO})*
ENTERO_BINARIO 0b|0B({BARRABAJA}|{NUMERO_BINARIO})*
NUM_ENTERO {ENTERO_DECIMAL|ENTERO_BINARIO}

//FLOATS

// DEFINICION DE LA PARTE EXPONENCIAL, PUEDE SER e o E, PUEDE SER + O - (0 o una vez = ?) O NINGUNO Y DEBE TENER AL MENOS UN DIGITO

EXPONENCIAL [eE][+-]?{DIGITO}+

// SEPARADOR DE DIGITOS, PUEDE SER UN DIGITO O UN DIGITO SEGUIDO DE UN GUION BAJO

DIGITO_SEPARADO {DIGITO}([_]?{DIGITO})* 

//1_1_1.1_1_1e1_1_1 o .1_1e1

DECIMAL ({DIGITO_SEPARADO}*\.{DIGITO_SEPARADO}+({EXPONENCIAL})?|\.{DIGITO_SEPARADO}+({EXPONENCIAL})?)
ENTERO_DECIMAL_2 ({DIGITO_SEPARADO}+{EXPONENCIAL})?

NUM_FLOAT {DECIMAL}|{ENTERO_DECIMAL_2}



//COMENTARIOS

COMENTARIO_BLOQUE {\/\*(.|\n)*?\*\/}
COMENTARIO_LINEA {\/\/.*}
COMENTARIO {COMENTARIO_BLOQUE}|{COMENTARIO_LINEA}|{COMENTARIO_ANIDADO}

//CADENA DE CARACTERES

STRING {\"([^\\\n]|(\\.))*?\"}

MASIGUAL \+=
MASMAS \+\+
IGUALIGUAL ==
MENOSIGUAL -=
MENOSMENOS --
PORIGUAL \*=
DIVIGUAL /=
MODIGUAL %=
MAYORIGUAL >=
MENORIGUAL <=
ANDIGUAL &=
AND \&
ORIGUAL \|=
OROR \|\|
OR \|
ANDAND &&
MENORMENOR <<
MAYORMAYOR >>
MENOR <
MAYOR >

/* Esto es para informar de erorr en caso de que lo encontrado no coincida con nada de lo que tenemos */
%option nounput

/* En caso de que no haya entrada, el analizador se detendra en lugar de quedarse esperando por una entrada */
%option noinput

%%

/* Todo esto lo ignorara */

[ \t\n]+        /* se come los espacios en blanco */
\/\*(.|\n)*?\*\/   /* Comentario en Bloque */
\/\/.*     /* Comentario de una Linea */

{IDENTIFICADOR}     return ID; /* lexemaes y palabras reservadas */

%%


// se intenta abrir el archivo dado su nombre
void init(char *nombreArchivo){
    FILE *archivo;
    archivo = fopen(nombreArchivo, "r");
    if(archivo == NULL){
        showError(1);
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
        findElement(actual);
    }else if(actual->codigo == -1){
        //componente lexico no reconocido
        showError(8);
    }else if(actual->codigo == OPERATOR){
        //si es solo un caracter se devuekve como codigo su codigo ascii
        //de esta forma coincide por completo con los codigoes de la práctica anterior
        if(strlen(actual->lexema)==1){
            actual->codigo = actual->lexema[0];
        }
    }else if(actual->codigo == 0){
        //al llamar a yyterminate, se devuelve 0
        //se debe cambiar al codigo que tenemos definido para EOF en definiciones.h
        actual->codigo = EOFVALUE;
    }
}

void cerrarD(){
    fclose(yyin);
    yylex_destroy();
}