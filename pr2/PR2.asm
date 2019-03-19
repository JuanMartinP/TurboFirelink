;************************************************************************** 
; SBM 2019. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR 
; Miguel Manzano y Juan Martin 
; Pareja numero 7
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE DATOS 
DATOS SEGMENT 
;-- rellenar con los datos solicitados
	MATRIZINI DB 1, 2, 3, 4, 5, 2, 2, 4, 2									;reservamos memoria para 9 valores de 1 byte inicializados
	
	RETORNO DB 2 DUP(0) 													;reservamos memoria para el RETORNO de 16 bytes
	
	RESULTADO DB 0
	
	OPCION DW ?
	
	MATRIZ1 DB "       |", 0,0,0, '|', 0,0,0, '|', 0,0,0, '|', 10, 13
	MATRIZ2 DB "|A|= |", 0,0,0, '|', 0,0,0, '|', 0,0,0, "| =",0,0,0, 10, 13
	MATRIZ3 DB "     |", 0,0,0, '|', 0,0,0, '|', 0,0,0, '|', 10, 13, '$'
	
	MENU DB "Elige una opcion para calcular el determinante:", 10, 13
		 DB "1) Calcular el determinante con valores introducidos por defecto.",10, 10, 13, '$'
	
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
	
	MOV DX, OFFSET MENU
	MOV AH, 9
	INT 21h
	
	MOV AH,0AH    ;Función captura de teclado 
	MOV DX,OFFSET OPCION     ;Area de memoria reservada = etiqueta NOMBRE 
	MOV OPCION[0],2    ;Lectura de caracteres máxima=60 
	INT 21H 

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CALCULA EL DETERMINANTE;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	;multiplicar primer triplete de la matriz: matriz[0] * matriz[4] * matriz[8] (BX = nfila*3)(SI = ncol)
	MOV BX, 3*0
	MOV SI, 0
	MOV AL, MATRIZINI[BX][SI]
	MOV BX, 3*1
	MOV SI, 1
	MOV CL, MATRIZINI[BX][SI]
	IMUL CL
	
	MOV BX, 3*2
	MOV SI, 2
	MOV CL, MATRIZINI[BX][SI]
	IMUL CL
	
	MOV CL, AL
	
	;multiplicar segundo triplete de la matriz: matriz[3] * matriz[7] * matriz[2] ---> Comprobado
	MOV BX, 3*1
	MOV SI, 0
	MOV AL, MATRIZINI[BX][SI]
	MOV BX, 3*2
	MOV SI, 1
	MOV DL, MATRIZINI[BX][SI]
	IMUL DL
	
	MOV BX, 3*0
	MOV SI, 2
	MOV DL, MATRIZINI[BX][SI]
	IMUL DL
	
	MOV DL, AL
	;suma de primer y segundo triplete, se guarda en CL
	ADD CL, DL
	;Para comprobar hasta aqui: MOV AL, CL y salida
	
	;multiplicar tercer triplete de la matriz: matriz[1] * matriz[5] * matriz[6] ---> A Juan no le apetecia comprobarlo
	MOV BX, 3*0
	MOV SI, 1
	MOV AL, MATRIZINI[BX][SI]
	MOV BX, 3*1
	MOV SI, 2
	MOV DL, MATRIZINI[BX][SI]
	IMUL DL
	
	MOV BX, 3*2
	MOV SI, 0
	MOV DL, MATRIZINI[BX][SI]
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
	MOV AL, MATRIZINI[BX][SI]
	MOV BX, 3*1
	MOV SI, 1
	MOV BL, MATRIZINI[BX][SI]
	IMUL BL
	
	MOV BX, 3*2
	MOV SI, 0
	MOV BL, MATRIZINI[BX][SI]
	IMUL BL
	
	MOV CH, AL
	
	;multiplicar segundo triplete de la matriz: matriz[3] * matriz[7] * matriz[2] ---> Comprobado
	MOV BX, 3*1
	MOV SI, 0
	MOV AL, MATRIZINI[BX][SI]
	MOV BX, 3*0
	MOV SI, 1
	MOV DL, MATRIZINI[BX][SI]
	IMUL DL
	
	MOV BX, 3*2
	MOV SI, 2
	MOV DL, MATRIZINI[BX][SI]
	IMUL DL
	
	MOV DL, AL
	;suma de primer y segundo triplete
	ADD CH, DL
	;Para comprobar hasta aqui: MOV AL, CL y salida
	
	;multiplicar segundo triplete de la matriz: matriz[1] * matriz[5] * matriz[6] ---> A Juan no le apetecia comprobarlo
	MOV BX, 3*2
	MOV SI, 1
	MOV AL, MATRIZINI[BX][SI]
	MOV BX, 3*1
	MOV SI, 2
	MOV DL, MATRIZINI[BX][SI]
	IMUL DL
	
	MOV BX, 3*0
	MOV SI, 0
	MOV DL, MATRIZINI[BX][SI]
	IMUL DL
	
	MOV DL, AL
	ADD CH, DL
	;Para comprobar hasta aqui: MOV AL, CL y salida
	SUB CL, CH
	
	MOV RESULTADO, CL
	
	; tenemos el determinante en CL, en este caso es 12	
	;Vamos a dividirlo entre 10 para coger cada cifra y pasarla a ascii

	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;RELLENA LA MATRIZ CON CARECTERES ASCII;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	MOV CX, 3
	MOV SI, 9
	;BUCLE1:
		MOV BH, MATRIZINI[0]
		INC DH
		CALL asciiconv
		MOV AH, RETORNO[0]
		MOV MATRIZ1[SI], AH
		INC SI
		MOV AH, RETORNO[1]
		MOV MATRIZ1[SI], AH
		ADD SI, 3
	;LOOP BUCLE1
		MOV BH, MATRIZINI[1]
		INC DH
		CALL asciiconv
		MOV AH, RETORNO[0]
		MOV MATRIZ1[SI], AH
		INC SI
		MOV AH, RETORNO[1]
		MOV MATRIZ1[SI], AH
		ADD SI, 3
		
		MOV BH, MATRIZINI[2]
		INC DH
		CALL asciiconv
		MOV AH, RETORNO[0]
		MOV MATRIZ1[SI], AH
		INC SI
		MOV AH, RETORNO[1]
		MOV MATRIZ1[SI], AH
		ADD SI, 3
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		MOV SI, 7
		MOV BH, MATRIZINI[3]
		INC DH
		CALL asciiconv
		MOV AH, RETORNO[0]
		MOV MATRIZ2[SI], AH
		INC SI
		MOV AH, RETORNO[1]
		MOV MATRIZ2[SI], AH
		ADD SI, 3
		
		MOV BH, MATRIZINI[4]
		INC DH
		CALL asciiconv
		MOV AH, RETORNO[0]
		MOV MATRIZ2[SI], AH
		INC SI
		MOV AH, RETORNO[1]
		MOV MATRIZ2[SI], AH
		ADD SI, 3
		
		MOV BH, MATRIZINI[5]
		INC DH
		CALL asciiconv
		MOV AH, RETORNO[0]
		MOV MATRIZ2[SI], AH
		INC SI
		MOV AH, RETORNO[1]
		MOV MATRIZ2[SI], AH
		ADD SI, 5
		
		MOV BH, RESULTADO
		INC DH
		CALL asciiconv
		MOV AH, RETORNO[0]
		MOV MATRIZ2[SI], AH
		INC SI
		MOV AH, RETORNO[1]
		MOV MATRIZ2[SI], AH
		ADD SI, 3
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		MOV SI, 7
		MOV BH, MATRIZINI[6]
		INC DH
		CALL asciiconv
		MOV AH, RETORNO[0]
		MOV MATRIZ3[SI], AH
		INC SI
		MOV AH, RETORNO[1]
		MOV MATRIZ3[SI], AH
		ADD SI, 3
		MOV BH, MATRIZINI[7]
		INC DH
		CALL asciiconv
		MOV AH, RETORNO[0]
		MOV MATRIZ3[SI], AH
		INC SI
		MOV AH, RETORNO[1]
		MOV MATRIZ3[SI], AH
		ADD SI, 3
		
		MOV BH, MATRIZINI[8]
		INC DH
		CALL asciiconv
		MOV AH, RETORNO[0]
		MOV MATRIZ3[SI], AH
		INC SI
		MOV AH, RETORNO[1]
		MOV MATRIZ3[SI], AH
		ADD SI, 3
		
		
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;IMPRIMIMOS LA MATRIZ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	MOV DX, OFFSET MATRIZ1
	MOV AH, 9
	INT 21h
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	JMP fin
	
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;FUNCION PARA CONVERTIR A ASCII;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asciiconv:
	MOV AL, BH
	MOV AH, 00
	MOV BL, 10
	DIV BL 			;el resto esta en AH
	ADD AH, 48
	MOV RETORNO[1], AH
	MOV AH, 00
	DIV BL 			;el resto esta en AH
	ADD AH, 48
	MOV RETORNO[0], AH
	ret
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
fin:

; FIN DEL PROGRAMA 
	MOV AX, 4C00H 
	INT 21H 
INICIO ENDP 
; FIN DEL SEGMENTO DE CODIGO 
CODE ENDS 
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION 
END INICIO 