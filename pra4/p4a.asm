;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 			SBM 2016. Practica 4 - Apartado a				;
;   Pareja 7 - Miguel Manzano y Juan Martin					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CODE SEGMENT  		;; Definición del segmento de código
ASSUME CS:CODE

ORG 100H	
INICIO:
	
    JMP MAIN

	POLIBIOTABLA DB '4', '5', '6', '7', '8', '9', 10, 'A', 'B', 'C', 'D', 'E', 'F', 10, 'G', 'H', 'I', 'J', 'K', 'L', 10, 'M', 'N', 'O', 'P', 'Q', 'R', 10, 'S', 'T', 'U', 'V', 'W', 'X', 10, 'Y', 'Z', '0', '1', '2', '3', 10, 10, '$'
	DECOD DB '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '0', '1', '2', '3'
	OFFSET_A EQU 6						;1 * 6 + 0  FILA * MAXFILA + COL
	OFFSET_0 EQU 32						;5 * 6 + 2  FILA * MAXFILA + COL
	OFFSET_C DB 0
	RES DB 0
	FIL DB 0 
	COL DB 0
	RESFIL DB 0
	RESCOL DB 0
	POLIBIO DB "333225221122320202025253$"
	
	RSI_57H PROC FAR				;Codifica y decodifica la cadena en DX 
		
		PUSH AX BX CX DX SI DI DS ES 
		
		MOV SI, DX
		
		MOV AH, 11H						;;Para codificar o decodificar 
		CMP AH, 10H						;; Para codificar	
		JE CODIFICAR
		RETCODIFICAR:
	
		CMP AH, 11H						;; Para decodificar
		JE DECODIFICAR
		RETDECODIFICAR:
		
		JMP FINAL
		
		
		;                     ************************                     ;
		;*********************Funcion para decodificar**********************;
		;                     ************************                     ;
		CODIFICAR:
		
			BUCLE:
			MOV BL, [SI]             	;Cadena almacenada en DS:DX
			CMP BL, 'A'					;Si su valos ascii es menos que A es que es un numero
			JB NUMEROS

			ADD BL, OFFSET_A			;Offset de A dentro de nuestra tabla de polibio
			MOV RES, BL					
			SUB RES, 'A'				;Le restamos el valor ascii de A para ver que letra es	
			MOV DH, RES			
			MOV OFFSET_C, DH			
			RETNUMEROS:              
			JMP PRINT					;Llamamos a la función para imprimir
			RETPRINT:
			INC SI
			CMP BYTE PTR [SI], '$'		;Comparamos con $
			JNE BUCLE					;Si es diferente saltamos al inicio del bucle, si no termina

		JMP RETCODIFICAR
		
		
		;                     *********************                     ;
		;*********************Lo leido es un numero**********************;
		;                     *********************                     ;  
		NUMEROS:
			CMP BL, '4'					;Comparamos el cacter leido con 4
			JB NUMFINAL					;Si es menor está en el final de la tabla, si no está al principio
			
			MOV RES, BL			
			SUB RES, '4'				;Calculamos su posicion en la tabla (4 es el primer num de la tabla)
			MOV DH, RES			
			MOV OFFSET_C, DH
			
			RETNUMFINAL:	
		
		JMP RETNUMEROS
		
		
		
		;                     ****************************************                     ;
		;*********************Numeros del final de la tabla de polibio**********************;
		;                     ****************************************                     ;
		NUMFINAL:
			ADD BL, OFFSET_0			;Posicion del 0 en la tabla
			MOV RES, BL			
			SUB RES, '0'				;Para convertir de su valor ascii a decimal y operar
			MOV DH, RES			
			MOV OFFSET_C, DH
		
		JMP RETNUMFINAL
		
		
		;                     ************************                     ;
		;*********************Funcion para decodificar**********************;
		;                     ************************                     ;
		DECODIFICAR:
			BUCLE2:
			MOV BL, [SI] 					;Contenido de la cadena a decodificar
			SUB BL, 48						;Lo convertimos de valor ascii a decimal
			XOR AH, AH
			MOV AL, 6						;Filas totales
			MUL BL							;En AL se queda la fila * filas totales
			INC SI
			MOV BL, [SI]					;Le sumamos el siguiente numero
			SUB BL, 48						;Lo convertimos de valor ascii a decimal
			ADD BL, AL						;fila * filstotales + columna
			XOR BH, BH						
			MOV DI, BX						;Su posicion en la tabla
			
			MOV AH, 2H						
			MOV DL, DECOD[DI]				;Imprimimos el caracter decodificado
			INT 21H
			INC SI
			
			CMP BYTE PTR [SI], '$'			;Si no es el fin de la cadena salta al inicio del bucle
			JNE BUCLE2
			
		JMP RETDECODIFICAR
	
	
		PRINT:
			MOV AL, OFFSET_C				;Movemos el caracter decimal a AL
			MOV AH, 0
			MOV BH, 6			
			DIV BH							;Dividimos el caracter decimal entre el numFilas
			MOV RESFIL, AL					;Cogemos el cociente (que es la fila)
			ADD RESFIL, '0'					;Lo convertimos a valor ascii
			MOV DH, RESFIL		
			MOV FIL, DH						
			
			MOV RESCOL, AH					;Cogemos el resto (que es la columna)
			ADD RESCOL, '0'					;Lo convertimos a valor ascii
			MOV DH, RESCOL		
			MOV COL, DH		
			
			
			MOV AH, 2H
			MOV DL, FIL						;Imprimimos la fila
			INT 21H
				
			MOV AH, 2H
			MOV DL, COL						;Imprimimos la columna
			INT 21H
			
			MOV AH, 2H
			MOV DL, 32						;Imprimimos un espacio
			INT 21H
				
		JMP RETPRINT
		
		
		FINAL:
		POP ES DS DI SI DX CX BX AX
		IRET
	RSI_57H ENDP


	
	INSTALADOR PROC						
		mov ax, 0
		mov es, ax
		mov ax, OFFSET RSI_57H
		mov bx, cs
		cli
		mov es:[ 40h*4 ], ax
		mov es:[ 40h*4+2 ], bx
		sti
		mov dx, OFFSET INSTALADOR
		int 27h 						; Acaba y deja residente
										;  PSP, variables y rutina rsi.
	INSTALADOR ENDP
	
	
	desinstalar_40h PROC       			; Desinstala RSI de INT 40h
		mov cx, 0
		mov ds, cx						; Segmento de vectores interrupción
		mov es, ds:[ 40h*4+2 ]      	; Lee segmento de RSI
		mov bx, es:[ 2Ch ]  			; Lee segmento de entorno del PSP de RSI
		mov ah, 49h 
		int 21h							; Libera segmento de RSI (es)
		mov es, bx
		int 21h 						; Libera segmento de variables de entorno de RSI
										; Pone a cero vector de interrupción 40h
		cli
		mov ds:[ 40h*4 ], cx 			; cx = 0
		mov ds:[ 40h*4+2 ], cx
		sti 
		ret 
	desinstalar_40h ENDP
	
	
	;*************************************************************************************************************************;
	;***************************************************MAIN******************************************************************;
	;*************************************************************************************************************************;
	MAIN:			;SE EJECUTA PRIMERO, MIRA LOS ARGUMENTOS Y LLAMA A LA RUTINA (POLIBIO) O AL INSTALADOR
	
		MOV AH, 9
		MOV DX, OFFSET POLIBIOTABLA
		INT 21H
		PUSHF
		MOV DX, OFFSET POLIBIO
		CALL RSI_57H
		
		
	MOV AX,4C00H			; FIN DE PROGRAMA Y VUELTA AL DOS
	INT 21H
	
; FIN DEL SEGMENTO DE CODIGO 
CODE ENDS 
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION 
END INICIO
