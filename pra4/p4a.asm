;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 			SBM 2016. Practica 4 - Apartado a				;
;   Pareja 7 - Miguel Manzano y Juan Martin					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CODE SEGMENT  		;; Definición del segmento de código
ASSUME CS:CODE

ORG 100H	
INICIO:
	
    JMP MAIN

	STRINGMENU DB "Pareja numero 7, Miguel Manzano y Juan Martin. Los parametros posibles son:", 10
			   DB "Sin parametros para ver la informacion", 10
			   DB "/I para instalar el driver", 10
			   DB "/D para desinstalarlo", 10, '$'
			   
	ERRPARAMETROS DB "Los parametros introducidos son incorrectos. Los parametros posibles son:", 10
				  DB "Sin parametros para ver la informacion", 10
				  DB "/I para instalar el driver", 10
				  DB "/D para desinstalarlo", 10, '$'
	INSTALADO DB "El driver esta instalado$"
	NOINSTALADO DB "El driver NO esta instalado$"
	
	
	RSI_57H PROC FAR					;Codifica y decodifica la cadena en DX 
		 
		MOV SI, DX						;Cogemos el offest de la cadena a codificar/decodificar
		
		CMP AH, 10H						;Para codificar	
		JE CODIFICAR
		RETCODIFICAR:
		
		CMP AH, 11H						;Para decodificar
		JE DECODIFICAR
		RETDECODIFICAR:
		
		JMP FINAL
		
		
		;                     **********************                     ;
		;*********************Funcion para codificar**********************;
		;                     **********************                     ;
		CODIFICAR:
		
			BUCLE:
			MOV BL, [SI]             	;Cadena almacenada en DS:DX
			CMP BL, 'A'					;Si su valor ascii es menos que A es que es un numero
			JB NUMEROS

			ADD BL, 6					;Offset de A dentro de nuestra tabla de polibio				
			SUB BL, 'A'					;Le restamos el valor ascii de A para ver que letra es	
			MOV CH, BL			
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
			CMP BL, '4'					;Comparamos el caracter leido con 4
			JB NUMFINAL					;Si es menor está en el final de la tabla, si no está al principio
			
			SUB BL, '4'					;Calculamos su posicion en la tabla (4 es el primer num de la tabla)
			MOV CH, BL
			
			RETNUMFINAL:	
		
		JMP RETNUMEROS
		
		
		
		;                     ****************************************                     ;
		;*********************Numeros del final de la tabla de polibio**********************;
		;                     ****************************************                     ;
		NUMFINAL:
			ADD BL, 32					;Posicion del 0 en la tabla
			SUB BL, '0'					;Para convertir de su valor ascii a decimal y operar	
			MOV CH, BL
		
		JMP RETNUMFINAL
		
		
		;                     ************************                     ;
		;*********************Funcion para decodificar**********************;
		;                     ************************                     ;
		DECODIFICAR:
			BUCLE2:
			MOV BL, [SI] 				;Contenido de la cadena a decodificar
			SUB BL, 48					;Lo convertimos de valor ascii a decimal
			XOR AH, AH
			MOV AL, 6					;Filas totales
			MUL BL						;En AL se queda la fila * filas totales
			INC SI
			MOV BL, [SI]				;Le sumamos el siguiente numero
			SUB BL, 48					;Lo convertimos de valor ascii a decimal
			ADD BL, AL					;fila * filstotales + columna
			XOR BH, BH
			
			MOV AH, 2H						
			MOV DL, [DI+BX]			;Imprimimos el caracter decodificado
			INT 21H
			INC SI
			
			CMP BYTE PTR [SI], '$'		;Si no es el fin de la cadena salta al inicio del bucle
			JNE BUCLE2
			
		JMP RETDECODIFICAR
	
	
		;                     *********************                     ;
		;*********************Funcion para imprimir**********************;
		;                     *********************                     ;
		PRINT:
			MOV AL, CH					;Movemos el caracter decimal a AL
			MOV AH, 0
			MOV BH, 6			
			DIV BH						;Dividimos el caracter decimal entre el numFilas
			MOV CH, AL					;Cogemos el cociente (que es la fila)
			ADD CH, '0'					;Lo convertimos a valor ascii				
			
			MOV CL, AH					;Cogemos el resto (que es la columna)
			ADD CL, '0'					;Lo convertimos a valor ascii
			
			
			MOV AH, 2H
			MOV DL, CH					;Imprimimos la fila
			INT 21H
				
			MOV AH, 2H
			MOV DL, CL					;Imprimimos la columna
			INT 21H
			
			MOV AH, 2H
			MOV DL, 32					;Imprimimos un espacio
			INT 21H
				
		JMP RETPRINT
		
		
		FINAL:

		IRET
	RSI_57H ENDP


	
	INSTALADOR PROC						
		mov ax, 0
		mov es, ax
		mov ax, OFFSET RSI_57H
		mov bx, cs
		cli
		mov es:[ 57h*4-2], 0ABBAH
		mov es:[ 57h*4 ], ax
		mov es:[ 57h*4+2 ], bx
		sti
		mov dx, OFFSET INSTALADOR
		int 27h 						; Acaba y deja residente
										;  PSP, variables y rutina rsi.
	INSTALADOR ENDP
	
	
	desinstalar_57h PROC       			; Desinstala RSI de INT 57h
		mov cx, 0
		mov ds, cx						; Segmento de vectores interrupción
		mov es, ds:[ 57h*4+2 ]      	; Lee segmento de RSI
		mov bx, es:[ 2Ch ]  			; Lee segmento de entorno del PSP de RSI
		mov ah, 49h 
		int 21h							; Libera segmento de RSI (es)
		mov es, bx
		int 21h 						; Libera segmento de variables de entorno de RSI
										; Pone a cero vector de interrupción 57h
		cli
		mov ds:[ 57h*4-2], cx
		mov ds:[ 57h*4 ], cx 			; cx = 0
		mov ds:[ 57h*4+2 ], cx

		sti 
		ret 
	desinstalar_57h ENDP
	
	
	;*************************************************************************************************************************;
	;***************************************************MAIN******************************************************************;
	;*************************************************************************************************************************;
	MAIN:			;SE EJECUTA PRIMERO, MIRA LOS ARGUMENTOS Y LLAMA A LA RUTINA (POLIBIO) O AL INSTALADOR
	
		MOV SI, 80H
		MOV BH, [SI]
		
		CMP BH, 0								;No hay parametros de entrada
		JE MENU
		
		CMP BH, 3								;Hay 3 caracteres como parametros de entrada
		JNE ERRENTRADA
	
		MOV BH, [SI+2]							;Comparamos el primer caracter de los parametros
		CMP BH, "/"
		JNE ERRENTRADA
		
		MOV BH, [SI+3]
		CMP BH, "I"
		JE INSTALAR
	
		CMP BH, "D"
		JE DESINSTALAR
		
		JMP FIN
		
		MENU:
			MOV DX, OFFSET STRINGMENU			;Imprime la cadena de caracteres que muestra las opciones
			MOV AH, 9
			INT 21h
			
			MOV AX, 0
			MOV ES, AX
			CMP ES:[ 57h*4-2], 0ABBAH
			JE MSJINST
			JMP MSJNOINST
			
		JMP FIN
		
		ERRENTRADA:
			MOV DX, OFFSET ERRPARAMETROS		;Imprime la cadena de caracteres que muestra el mensaje de error
			MOV AH, 9
			INT 21h
		JMP FIN
		
		MSJINST:
			MOV DX, OFFSET INSTALADO		;Imprime la cadena de caracteres que indica que el driver esta instalado
			MOV AH, 9
			INT 21h
		JMP FIN
				
		MSJNOINST:
			MOV DX, OFFSET NOINSTALADO		;Imprime la cadena de caracteres que indica que el driver NO esta instalado
			MOV AH, 9
			INT 21h
		JMP FIN
		
		INSTALAR:
			MOV AX, 0
			MOV ES, AX
			CMP ES:[ 57h*4-2], 0ABBAH		;Si encontramos la firma antes del driver no lo instalamos, puesto que ya lo esta
			JE FIN
			CALL INSTALADOR
		JMP FIN
		
		DESINSTALAR:
			MOV AX, 0
			MOV ES, AX
			CMP ES:[ 57h*4-2], 0ABBAH
			JNE FIN
			CALL desinstalar_57h
		JMP FIN
		
		
		FIN:
	MOV AX,4C00H			; FIN DE PROGRAMA Y VUELTA AL DOS
	INT 21H
	
; FIN DEL SEGMENTO DE CODIGO 
CODE ENDS 
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION 
END INICIO
