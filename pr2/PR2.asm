;************************************************************************** 
; SBM 2019. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR 
; Miguel Manzano y Juan Martin 
; Pareja numero 7
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE DATOS 
DATOS SEGMENT 
;-- rellenar con los datos solicitados
	MATRIZ9 DB 1, 2, 3, 4, 5, 2, 2, 4, 2									;reservamos memoria para 9 valores de 1 byte inicializados
	RESULTADO DB 5 DUP(0) 													;reservamos memoria para el resultado de 16 bytes
	MATRIZGR DB "     |", 0,0,0, '|', 0,0,0, '|', 0,0,0, '|', 10, 13, '$'
			 DB "|A|= |", 0,0,0, '|', 0,0,0, '|', 0,0,0, "| =",0,0,0, 10, 13, '$'
			 DB "     |", 0,0,0, '|', 0,0,0, '|', 0,0,0, '|', 10, 13, '$'		 
	
DATOS ENDS 
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE PILA 
PILA SEGMENT STACK "STACK" 
DB 40H DUP (0) ;ejemplo de inicialización, 64 bytes inicializados a 0 
PILA ENDS 
;************************************************************************** 
; DEFINICION DEL SEGMENTO EXTRA 
EXTRA SEGMENT 
RESULT DW 0,0 ;ejemplo de inicialización. 2 PALABRAS (4 BYTES) 
EXTRA ENDS 
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE CODIGO 
CODE SEGMENT 
ASSUME CS: CODE, DS: DATOS, ES: EXTRA, SS: PILA 
; COMIENZO DEL PROCEDIMIENTO PRINCIPAL 
INICIO PROC 
	; INICIALIZA LOS REGISTROS DE SEGMENTO CON SU VALOR
	MOV AX, DATOS 
	MOV DS, AX 
	MOV AX, PILA 
	MOV SS, AX 
	MOV AX, EXTRA 
	MOV ES, AX 
	MOV SP, 64 ; CARGA EL PUNTERO DE PILA CON EL VALOR MAS ALTO 
	; FIN DE LAS INICIALIZACIONES 
	; COMIENZO DEL PROGRAMA 
	; -- rellenar con las instrucciones solicitadas

	;MOV AH, 2   			para más adelante, imprime
	;MOV DL, MATRIZ9[0]
	;int 21H
	
	;DETERMINANTE
	
	;multiplicar primer triplete de la matriz: matriz[0] * matriz[4] * matriz[8] (BX = nfila*3)(SI = ncol)
	MOV BX, 3*0
	MOV SI, 0
	MOV AL, MATRIZ9[BX][SI]
	MOV BX, 3*1
	MOV SI, 1
	MOV CL, MATRIZ9[BX][SI]
	IMUL CL
	
	MOV BX, 3*2
	MOV SI, 2
	MOV CL, MATRIZ9[BX][SI]
	IMUL CL
	
	MOV CL, AL
	
	;multiplicar segundo triplete de la matriz: matriz[3] * matriz[7] * matriz[2] ---> Comprobado
	MOV BX, 3*1
	MOV SI, 0
	MOV AL, MATRIZ9[BX][SI]
	MOV BX, 3*2
	MOV SI, 1
	MOV DL, MATRIZ9[BX][SI]
	IMUL DL
	
	MOV BX, 3*0
	MOV SI, 2
	MOV DL, MATRIZ9[BX][SI]
	IMUL DL
	
	MOV DL, AL
	;suma de primer y segundo triplete, se guarda en CL
	ADD CL, DL
	;Para comprobar hasta aqui: MOV AL, CL y salida
	
	;multiplicar tercer triplete de la matriz: matriz[1] * matriz[5] * matriz[6] ---> A Juan no le apetecia comprobarlo
	MOV BX, 3*0
	MOV SI, 1
	MOV AL, MATRIZ9[BX][SI]
	MOV BX, 3*1
	MOV SI, 2
	MOV DL, MATRIZ9[BX][SI]
	IMUL DL
	
	MOV BX, 3*2
	MOV SI, 0
	MOV DL, MATRIZ9[BX][SI]
	IMUL DL
	
	MOV DL, AL
	;suma de los dos primeros tripletes con el tercero, se guarda en CL
	ADD CL, DL
	
	;;/*************************************/
	;;SEGUNDA PARTE DETERMINANTE
	;;/*************************************/
	
	
	;multiplicar primer triplete de la matriz: matriz[0] * matriz[4] * matriz[8] ---> Comprobado
	MOV BX, 3*0
	MOV SI, 2
	MOV AL, MATRIZ9[BX][SI]
	MOV BX, 3*1
	MOV SI, 1
	MOV BL, MATRIZ9[BX][SI]
	IMUL BL
	
	MOV BX, 3*2
	MOV SI, 0
	MOV BL, MATRIZ9[BX][SI]
	IMUL BL
	
	MOV CH, AL
	
	;multiplicar segundo triplete de la matriz: matriz[3] * matriz[7] * matriz[2] ---> Comprobado
	MOV BX, 3*1
	MOV SI, 0
	MOV AL, MATRIZ9[BX][SI]
	MOV BX, 3*0
	MOV SI, 1
	MOV DL, MATRIZ9[BX][SI]
	IMUL DL
	
	MOV BX, 3*2
	MOV SI, 2
	MOV DL, MATRIZ9[BX][SI]
	IMUL DL
	
	MOV DL, AL
	;suma de primer y segundo triplete
	ADD CH, DL
	;Para comprobar hasta aqui: MOV AL, CL y salida
	
	;multiplicar segundo triplete de la matriz: matriz[1] * matriz[5] * matriz[6] ---> A Juan no le apetecia comprobarlo
	MOV BX, 3*2
	MOV SI, 1
	MOV AL, MATRIZ9[BX][SI]
	MOV BX, 3*1
	MOV SI, 2
	MOV DL, MATRIZ9[BX][SI]
	IMUL DL
	
	MOV BX, 3*0
	MOV SI, 0
	MOV DL, MATRIZ9[BX][SI]
	IMUL DL
	
	MOV DL, AL
	ADD CH, DL
	;Para comprobar hasta aqui: MOV AL, CL y salida
	SUB CL, CH
	
	; tenemos el determinante en CL y lo vamos a pasar a ascii para imprimir el valor correcto
	
	
	;MOV DX, OFFSET RESULTADO
	;MOV AH, 9
	;INT 21h

	;MOV AH, 2 					;Impresion de 1 caracter
	;MOV DL, AL
	;int 21H
	
	;tenemos un 12 de resultado
	
	MOV AL, CL
	MOV AH, 00
	MOV BL, 10
	DIV BL 			;el resto esta en AH
	ADD AH, 48
	MOV RESULTADO[1], AH
	MOV AH, 00
	DIV BL 			;el resto esta en AH
	ADD AH, 48
	MOV RESULTADO[0], AH
	
	MOV AL, RESULTADO[0]
	MOV AH, 2 			
	MOV DL, AL
	int 21H
	
	MOV AL, RESULTADO[1]
	MOV AH, 2 			
	MOV DL, AL
	int 21H
	
	;MOV CH, 13
	;MOV RESULTADO[2], CH
	;MOV CH, 10
	;MOV RESULTADO[3], CH
	;MOV CH, '$'
	;MOV RESULTADO[4], CH

	
	
	
	
; FIN DEL PROGRAMA 
	MOV AX, 4C00H 
	INT 21H 
INICIO ENDP 
; FIN DEL SEGMENTO DE CODIGO 
CODE ENDS 
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION 
END INICIO 