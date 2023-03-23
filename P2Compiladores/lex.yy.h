#ifndef LEXX_YY_H_
#define LEXX_YY_H_
#include "abb.h"

/*
* Funcion de inicializacion del sistema de entrada donde se abrira el archivo
*/
void init(char *nombreArchivo);

/*
 * Funcion encargada de devolver el componente lexico que será procesado por el Analizador sintáctico
 */
void siguiente_componente_lexico(tipoelem *actual);

/*
 * Funcion encargada de cerrar el archivo y liberar memoria
 */
void cerrarD();

#endif /* DEFINITIONS_H_ */