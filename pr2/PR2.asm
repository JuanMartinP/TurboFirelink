;************************************************************************** 
; SBM 2019. Juego de instrucciones 
; Miguel Manzano y Juan Martin 
; Pareja numero 7
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE DATOS 
DATOS SEGMENT 
;-- rellenar con los datos solicitados
	MATRIZINI DB 1, 2, 3, 4, 5, 2, 2, 4, 2									;reservamos memoria para 9 valores de 1 byte inicializados
	
	RETORNO DB 2 DUP(0) 													;reservamos memoria para el RETORNO de 16 bytes
	
	RESULTADO DB 0
	
	OPCION DB 0,0,0,0,0,0
	
	MATRIZ1 DB "     |", 0,0,0, '|', 0,0,0, '|', 0,0,0, '|', 10, 13
	MATRIZ2 DB "|A|= |", 0,0,0, '|', 0,0,0, '|', 0,0,0, "| =",0,0,0, 10, 13
	MATRIZ3 DB "     |", 0,0,0, '|', 0,0,0, '|', 0,0,0, '|', 10, 13, '$'
	
	MENU DB "Elige una opcion para calcular el determinante:", 10, 13
		 DB "1) Calcular el determinante con valores introducidos por defecto.",10, 10, 13, '$'
		
	MSJERROR DB "Esa opcion no es correcta, lo siento.", 10, 13, '$'
	
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
	
	
	MOV DX, OFFSET MENU			;Imprime el la cadena de caracteres que contiene el menu de opciones
	MOV AH, 9
	INT 21h
	
	MOV AH,0AH    				;Lee del teclado y almacena en OPCION 
	MOV DX,OFFSET OPCION  
	MOV OPCION[0], 2 
	INT 21H 
	
	CMP OPCION[2], 31H			;Comprueba la opcion elegida y actua en consecuencia
	JE opcion1
	
	MOV DX, OFFSET MSJERROR		;Imprime el mensaje de error
	MOV AH, 9
	INT 21h
	JMP fin
	
	opcion1:					;Si se ha elegido la opcion 1
	CALL determinante
	CALL rellena
	CALL imprimir
	JMP fin


	;____________________________________________________________________________________;
	;																					 ;
	;									DETERMINANTE									 ;
	; Calcula el determinante de la matriz guardada en MATRIZINI			 			 ;
	; Guarda en resultado el valor del determinante de la matriz															 ;
	;____________________________________________________________________________________;
	
	determinante:
		;multiplica el primer triplete de la matriz: matriz[0] * matriz[4] * matriz[8]   (BX = nfila*3)(SI = ncol)
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
		
		;multiplica el segundo triplete de la matriz: matriz[3] * matriz[7] * matriz[2]	 (BX = nfila*3)(SI = ncol)
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
		
		;multiplica el tercer triplete de la matriz: matriz[1] * matriz[5] * matriz[6] 	(BX = nfila*3)(SI = ncol)
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
		
		;;SEGUNDA PARTE DETERMINANTE	
		
		;multiplica el primer triplete de la matriz: matriz[0] * matriz[4] * matriz[8]   (BX = nfila*3)(SI = ncol)
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
		
		;multiplica el segundo triplete de la matriz: matriz[3] * matriz[7] * matriz[2]  (BX = nfila*3)(SI = ncol)
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
		;suma del primer y segundo triplete
		ADD CH, DL
		
		;multiplica el tercer triplete de la matriz: matriz[1] * matriz[5] * matriz[6]  (BX = nfila*3)(SI = ncol)
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
		;suma de los dos primeros tripletes con el tercero, se guarda en CH
		ADD CH, DL
		;resta de las dos partes de la matriz para el determinante
		SUB CL, CH
		
		MOV RESULTADO, CL
	ret 
	
	
	;____________________________________________________________________________________;
	;																					 ;
	;									RELLENA											 ;
	; Guarda los valores en decimal en la interfaz grafica de la matriz					 ;
	; No tiene valor de retorno															 ;
	;____________________________________________________________________________________;
	
	rellena:
		MOV CX, 3
		MOV DI, 0
		MOV SI, 7
		BUCLE1:
			MOV BH, MATRIZINI[DI]
			CALL asciiconv
			MOV AH, RETORNO[0]
			MOV MATRIZ1[SI], AH
			INC SI
			MOV AH, RETORNO[1]
			MOV MATRIZ1[SI], AH
			ADD SI, 3
			INC DI
		LOOP BUCLE1
		
		MOV CX, 3
		MOV SI, 7
		BUCLE2:
			MOV BH, MATRIZINI[DI]
			CALL asciiconv
			MOV AH, RETORNO[0]
			MOV MATRIZ2[SI], AH
			INC SI
			MOV AH, RETORNO[1]
			MOV MATRIZ2[SI], AH
			ADD SI, 3
			INC DI
		LOOP BUCLE2
		
		ADD SI, 2	
		MOV BH, RESULTADO
		CALL asciiconv
		MOV AH, RETORNO[0]
		MOV MATRIZ2[SI], AH
		INC SI
		MOV AH, RETORNO[1]
		MOV MATRIZ2[SI], AH
		
		MOV CX, 3
		MOV SI, 7
		BUCLE3:
			MOV BH, MATRIZINI[DI]
			CALL asciiconv
			MOV AH, RETORNO[0]
			MOV MATRIZ3[SI], AH
			INC SI
			MOV AH, RETORNO[1]
			MOV MATRIZ3[SI], AH
			ADD SI, 3
			INC DI
		LOOP BUCLE3
	ret
	
	;____________________________________________________________________________________;
	;																					 ;
	;									IMPRIMIR										 ;
	; Muestra por pantalla la interfaz grafica de la matriz								 ;
	; No tiene valor de retorno															 ;
	;____________________________________________________________________________________;
		
	imprimir:
		MOV DX, OFFSET MATRIZ1
		MOV AH, 9
		INT 21h
	ret

	
	;____________________________________________________________________________________;
	;																					 ;
	;									ASCIICONV										 ;
	; Transforma el valor de BH a su equivalente en ASCII para representarlo			 ;
	; Utiliza la variable RETORNO para guardar las dos cifras que se van a imprimir		 ;
	;____________________________________________________________________________________;
	
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
	
fin:

; FIN DEL PROGRAMA 
	MOV AX, 4C00H 
	INT 21H 
INICIO ENDP 
; FIN DEL SEGMENTO DE CODIGO 
CODE ENDS 
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION 
END INICIO 