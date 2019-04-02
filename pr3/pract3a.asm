;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 			SBM 2016. Practica 3 - Apartado a				;
;   Pareja 7 - Miguel Manzano y Juan Martin					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_TEXT SEGMENT BYTE PUBLIC 'CODE' 		;; Definición del segmento de código
ASSUME CS:_TEXT
			
	
	PUBLIC _computeControlDigit					
	_computeControlDigit PROC FAR
	
		PUSH BP							;guardar el valor de BP para el final de la funcion
		MOV BP, SP						;Movemos sp a la parte final de la pila
		PUSH BX CX DX SI DI DS ES
	
		LES BX, [BP+6]					;offset de la cadena de caracteres en BX y segmento en ES
	
		MOV SI, 0						;SI sera nuestro contador para ir recorriendo el bucle de impares
		MOV AX, 0						;AX sera la variable donde iremos guardando lo que leamos en cada posicion del bucle
		MOV DX, 0						;DX guardaremos la suma de los AX
	
		BUCLE1:							;Etiqueta bucle1
		MOV AL, ES:[BX][SI]				
		SUB AL, 48						;Conversion de ASCII de decimal
		ADD DX, AX
		ADD SI, 2						;Avanzamos posiciones en el bucle
		CMP SI, 12						;Realizamos la comparacion para comprobar que no llegamos al final de la cadena de impares
		JNE BUCLE1
	
		PUSH DX							;guardamos en la pila el resultado de los impares
	
		MOV SI, 1						;Ahora SI ira inicializado a 1 para asi ir recorriendo el bucle de pares
		MOV AX, 0
		MOV DX, 0
	
		BUCLE2:
		MOV AL, ES:[BX][SI]
		SUB AL, 48
		MOV AH, 3
		MUL AH							;multiplicamos por 3 y guardamos el resultado en AL
		ADD DX, AX
		ADD SI, 2
		CMP SI, 13						;ahora comparamos si llegamos al final de la cadena de pares
		JNE BUCLE2
	
	
		POP AX							;Guardo en AX el resultado del bucle1 que habiamos metido em la pila
		ADD DX, AX						;DX ahora contendra la suma del resultado de ambos bucles
	
	
	
	;;CALCULO DE LA DECENA MAS PROXIMA: 10 - (RESULTADO OBTENIDO % 10)
	
	
	
		MOV AX, DX						;muevo a AX el resultado anterior para poder realizar divisiones con ese valor
		MOV BH, 10
		DIV BH							;divido AX entre BH y guardo el resultado en AX, de forma que en AL se guarda el cociente y en AH el resto
		MOV CH, AH						;guardo el resto obtenido anteriormente en CH
	
		MOV AX, 10						;Por ultimo muevo a AX un 10 para asi restarlo con el resto obtenido anteriormente
		SUB AL, CH						;Realizamos la resta y dejamos el resultado guardado en AX
	
	
		POP ES DS DI SI DX CX BX
		POP BP
		RET								;; Retorno de la función que nos ha llamado, devolviendo el digito de control calculado en AX
	_computeControlDigit ENDP							

	
	
	
	PUBLIC _decodeBarCode						
	_decodeBarCode PROC FAR
	
		PUSH BP 							;Salvaguardar BP en la pila para poder modificarle sin modificar su valor
		MOV BP, SP							;Igualar BP el contenido de SP
		PUSH BX CX DX SI DI DS ES AX
		LES BX, [BP+6]					    ;Offset de la cadena de caracteres original en BX y segmento en ES
		
	
		MOV CX, 10							;Tres digitos de pais
		MOV AX, 100
		XOR SI, SI							
		XOR DI, DI
	CODPAIS:
		XOR DX, DX
		MOV DL, ES:[BX][SI]					;En DX tenemos el primer caracter ASCII de pais
		SUB DL, 48							;Convertimos a decimal
		
		
		PUSH AX
		MUL DX 								;Lo multiplicamos por AX para ponerle los 0 apropiados
		MOV DX, AX
		ADD DI, DX							;Lo guardamos en DI
	
		MOV DX, 0
		INC SI
		POP AX								;Control de variables de bucle
		DIV CX
		CMP AX, 0
	JNE CODPAIS
	
		LES BX, [BP+10]
		MOV WORD PTR ES:[BX], DI
	
	
		MOV SI, 3
		LES BX, [BP+6]
		
		MOV CX, 10							;Cuatro digitos de pais
		MOV AX, 1000							
		XOR DI, DI
	CODEMPRESA:
		XOR DX, DX
		MOV DL, ES:[BX][SI]					;En DX tenemos el primer caracter ASCII de pais
		SUB DL, 48							;Convertimos a decimal
		
		
		PUSH AX
		MUL DX 								;Lo multiplicamos por AX para ponerle los 0 apropiados
		MOV DX, AX
		ADD DI, DX							;Lo guardamos en DI
	
		MOV DX, 0
		INC SI
		POP AX								;Control de variables de bucle
		DIV CX
		CMP AX, 0
	JNE CODEMPRESA
	
		LES BX, [BP+14]
		MOV WORD PTR ES:[BX], DI

		XOR DI,DI
; PRODUCT
				
		XOR DX,DX
		LES BX, [BP+6]
		MOV SI, 11
		MOV CL, ES:[BX][SI]
		MOV CH, CH
		SUB CX, 48
		
		DEC SI
		XOR AH,AH
		MOV AL, ES:[BX][SI]
		SUB AX, 48
		MOV DI, 10
		MUL DI
		ADD CX, AX
		
		DEC SI
		XOR AH,AH
		MOV AL, ES:[BX][SI]
		SUB AX, 48
		MOV DI, 100
		MUL DI
		ADD CX, AX
		
		DEC SI
		XOR AH,AH
		MOV AL, ES:[BX][SI]
		SUB AX, 48
		MOV DI, 1000
		MUL DI
		ADD CX, AX
		
		DEC SI
		XOR AH,AH
		MOV AL, ES:[BX][SI]
		SUB AX, 48
		MOV DI, 10000
		MUL DI
		ADD CX, AX
		
		LES BX, [BP+18]
		MOV WORD PTR ES:[BX], CX
		MOV SI, 2
		MOV WORD PTR ES:[BX][SI], DX
		
		; FIN DE PRODUCT
	
		MOV DI, 1
		LES BX, [BP+22]
		MOV WORD PTR ES:[BX], DI
	
		POP AX ES DS DI SI DX CX BX
		POP BP
		RET 
	_decodeBarCode ENDP							




; FIN DEL SEGMENTO DE CODIGO 
_TEXT ENDS 
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION 
END  