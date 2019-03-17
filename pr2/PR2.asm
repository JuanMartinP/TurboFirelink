;************************************************************************** 
; SBM 2019. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR 
; Miguel Manzano y Juan Martin 
; Pareja numero 7
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE DATOS 
DATOS SEGMENT 
;-- rellenar con los datos solicitados
	MATRIZ9 DB 9 DUP(0)					;reservamos memoria para 9 valores de 8 bytes
	RESULTADO DB 1 DUP(2 DUP(0)) 		;reservamos memoria para el resultado de 16 bytes
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
	
	MOV MATRIZ9[0], 1
	
	MOV MATRIZ9[1], 2
	
	MOV MATRIZ9[2], 3
	
	MOV MATRIZ9[3], 4
	
	MOV MATRIZ9[4], 5
	
	MOV MATRIZ9[5], 2
	
	MOV MATRIZ9[6], 2
	
	MOV MATRIZ9[7], 4

	MOV MATRIZ9[8], 2
	
	
	;DETERMINANTE
	
	;multiplicar primer triplete de la matriz: matriz[0] * matriz[4] * matriz[8] ---> Comprobado
	MOV AL, MATRIZ9[0]
	MOV CL, MATRIZ9[4]
	IMUL CL
	
	MOV CL, MATRIZ9[8]
	IMUL CL
	
	MOV CL, AL
	
	;multiplicar segundo triplete de la matriz: matriz[3] * matriz[7] * matriz[2] ---> Comprobado
	MOV AL, MATRIZ9[3]
	MOV DL, MATRIZ9[7]
	IMUL DL
	
	MOV DL, MATRIZ9[2]
	IMUL DL
	
	MOV DL, AL
	;suma de primer y segundo triplete, se guarda en CL
	ADD CL, DL
	;Para comprobar hasta aqui: MOV AL, CL y salida
	
	;multiplicar tercer triplete de la matriz: matriz[1] * matriz[5] * matriz[6] ---> A Juan no le apetecia comprobarlo
	MOV AL, MATRIZ9[1]
	MOV DL, MATRIZ9[5]
	IMUL DL
	
	MOV DL, MATRIZ9[6]
	IMUL DL
	
	MOV DL, AL
	;suma de los dos primeros tripletes con el tercero, se guarda en CL
	ADD CL, DL
	;Para comprobar hasta aqui: MOV AL, CL y salida
	
	;;/*************************************/
	;;SEGUNDA PARTE DETERMINANTE
	;;/*************************************/
	
	
	;multiplicar primer triplete de la matriz: matriz[0] * matriz[4] * matriz[8] ---> Comprobado
	MOV AL, MATRIZ9[2]
	MOV BL, MATRIZ9[4]
	IMUL BL
	
	MOV BL, MATRIZ9[6]
	IMUL BL
	
	MOV BL, AL
	
	;multiplicar segundo triplete de la matriz: matriz[3] * matriz[7] * matriz[2] ---> Comprobado
	MOV AL, MATRIZ9[3]
	MOV DL, MATRIZ9[1]
	IMUL DL
	
	MOV DL, MATRIZ9[8]
	IMUL DL
	
	MOV DL, AL
	;suma de primer y segundo triplete
	ADD BL, DL
	;Para comprobar hasta aqui: MOV AL, CL y salida
	
	;multiplicar segundo triplete de la matriz: matriz[1] * matriz[5] * matriz[6] ---> A Juan no le apetecia comprobarlo
	MOV AL, MATRIZ9[7]
	MOV DL, MATRIZ9[5]
	IMUL DL
	
	MOV DL, MATRIZ9[0]
	IMUL DL
	
	MOV DL, AL
	ADD BL, DL
	;Para comprobar hasta aqui: MOV AL, CL y salida
	SUB CL, BL

	MOV AL, CL
	
	MOV AH, 2
	MOV DL, AL
	int 21H
	
	
; FIN DEL PROGRAMA 
	MOV AX, 4C00H 
	INT 21H 
INICIO ENDP 
; FIN DEL SEGMENTO DE CODIGO 
CODE ENDS 
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION 
END INICIO 