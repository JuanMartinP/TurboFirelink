;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 			SBM 2016. Practica 3 - Apartado b				;
;   Pareja 7 - Miguel Manzano y Juan Martin					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_TEXT SEGMENT BYTE PUBLIC 'CODE' 		;; Definición del segmento de código
ASSUME CS:_TEXT
			

PUBLIC _createBarCode						;; Hacer visible y accesible la función desde C
_createBarCode PROC FAR 					;; En C es int unsigned long int factorial(unsigned int n)

PUSH BP 							;; Salvaguardar BP en la pila para poder modificarle sin modificar su valor
	MOV BP, SP							;; Igualar BP el contenido de SP
	MOV AX, [BP + 6]					;; Lectura parámetro pasado como valor a esta funcion
	
	
	POP BP							;; Restaurar el valor de BP antes de salir
	RET								;; Retorno de la función que nos ha llamado, devolviendo el resultado del factorial en AX



_createBarCode ENDP							;; Termina la funcion factorial
_TEXT ENDS
END