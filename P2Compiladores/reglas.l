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

//IDENTIFICADOR

ID {ALFA}|{BARRABAJA}({ALFA}|{BARRABAJA}|{DIGITO})*

//ENTEROS

ENTERO_DECIMAL {DIGITO}{DIGITO}*
ENTERO_BINARIO 0b|0B({BARRABAJA}|{DIGITO})*

//FLOATS

// DEFINICION DE LA PARTE EXPONENCIAL, PUEDE SER e o E, PUEDE SER + O - (0 o una vez = ?) O NINGUNO Y DEBE TENER AL MENOS UN DIGITO

EXPONENCIAL [eE][+-]?{DIGITO}+

// SEPARADOR DE DIGITOS, PUEDE SER UN DIGITO O UN DIGITO SEGUIDO DE UN GUION BAJO

DIGITO_SEPARADO {DIGITO}([_]?{DIGITO})* 

//1_1_1.1_1_1e1_1_1 o .1_1e1

DECIMAL ({DIGITO_SEPARADO}*\.{DIGITO_SEPARADO}+({EXPONENCIAL})?|\.{DIGITO_SEPARADO}+({EXPONENCIAL})?)
ENTERO_DECIMAL_2 ({DIGITO_SEPARADO}+{EXPONENCIAL})?

FLOAT {DECIMAL}|{ENTERO_DECIMAL_2}



//COMENTARIOS

COMENTARIO_BLOQUE {\/\*(.|\n)*?\*\/}
COMENTARIO_LINEA {\/\/.*}
COMENTARIO_ANIDADO {\+(?:[^+]|\+(?!\/)|\+\/(?!\/))*\+\/}
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
\+(?:[^+]|\+(?!\/)|\+\/(?!\/))*\+\/  /* Comentario Anidado */