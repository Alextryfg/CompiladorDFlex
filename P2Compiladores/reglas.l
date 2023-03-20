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

ID {ALFA}({ALFA}|{BARRABAJA}|{DIGITO})*
ENTERO_DECIMAL {DIGITO}{DIGITO}*
ENTERO_BINARIO 0b|0B({BARRABAJA}|{DIGITO})*

