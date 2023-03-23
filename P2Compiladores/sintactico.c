#include <stdio.h>
#include <stdlib.h>
#include "definiciones.h"
#include "abb.h"
#include "lex.yy.h"

/*
 * Funcion que imprime el contenido del lexema dependiendo del caso
 */
void _printComp(tipoelem comp){
    printf("\n<%d,%s>", comp.codigo, comp.lexema);
}

/*
 * Funcion en cargada de ir pidiendo componentes lexicos al analizador lexico, liberando memoria e imprimiendo por pantalla el resultado
 */
void compilarD(){

    /* Inicializo el componenteLexico que le enviare a la funcion del lexico.c */
    tipoelem comp;
    comp.lexema= NULL;
    comp.codigo=-2;

    /*Invoco a siguiente_componente lexico hasta -1 que indica que llego el EOF */
    do{

        siguiente_componente_lexico(&comp);

        _printComp(comp);

        /* Se libera la memoria del lexema */
        if(comp.lexema!=NULL){
            free(comp.lexema);
            comp.lexema=NULL;
        }

    }while(comp.codigo != -1);











}