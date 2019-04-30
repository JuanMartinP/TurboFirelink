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
	
	RSI_57H PROC FAR				;ESTO SE VA A ENCARGAR DE CODIFICAR Y DECODIFICAR LA CADENA QUE LE PASA EL MAIN 
		
		PUSH AX BX CX DX SI DI DS ES 
		
		MOV SI, DX
		
		MOV AH, 11H						;; Por ahora sólo codifica BIEN, 
		CMP AH, 10H						;; Para codificar	
		JE CODIFICAR
		RETCODIFICAR:
	
		CMP AH, 11H						;; Para decodificar
		JE DECODIFICAR
		RETDECODIFICAR:
		
		JMP FINAL
		
		CODIFICAR:
		
			BUCLE:
			MOV BL, [SI]             ;Cadena almacenada en DS:DX
			CMP BL, 'A'
			JB NUMEROS

			ADD BL, OFFSET_A	
			MOV RES, BL			
			SUB RES, 'A'		
			MOV DH, RES			
			MOV OFFSET_C, DH
			RETNUMEROS:              ;offest_c = 4
			JMP PRINT
			RETPRINT:
			INC SI
			CMP BYTE PTR [SI], '$'
			JNE BUCLE

		JMP RETCODIFICAR
		
		
		NUMEROS:
			CMP BL, '4'
			JB NUMFINAL
			
			MOV RES, BL			
			SUB RES, '4'		
			MOV DH, RES			
			MOV OFFSET_C, DH
			
			RETNUMFINAL:	
		
		JMP RETNUMEROS
		
		
		NUMFINAL:
			ADD BL, OFFSET_0	
			MOV RES, BL			
			SUB RES, '0'		
			MOV DH, RES			
			MOV OFFSET_C, DH
		
		JMP RETNUMFINAL
			
			
		DECODIFICAR:
			BUCLE2:
			MOV BL, [SI] 
			SUB BL, 48
			XOR AH, AH
			MOV AL, 6
			MUL BL							;En AL tengo el resultado de 3 * 6 = 18
			INC SI
			MOV BL, [SI]
			SUB BL, 48			
			ADD BL, AL						
			XOR BH, BH
			MOV DI, BX
			
			MOV AH, 2H
			MOV DL, DECOD[DI]				
			INT 21H
			INC SI
			
			CMP BYTE PTR [SI], '$'
			JNE BUCLE2
			
		JMP RETDECODIFICAR
	
	
		PRINT:
			MOV AL, OFFSET_C		
			MOV AH, 0
			MOV BH, 6			
			DIV BH
			MOV RESFIL, AL				
			ADD RESFIL, '0'					
			MOV DH, RESFIL		
			MOV FIL, DH						
			
			MOV RESCOL, AH
			ADD RESCOL, '0'					
			MOV DH, RESCOL		
			MOV COL, DH		
			
			
			MOV AH, 2H
			MOV DL, FIL						
			INT 21H
				
			MOV AH, 2H
			MOV DL, COL						
			INT 21H
			
			MOV AH, 2H
			MOV DL, 32						
			INT 21H
				
		JMP RETPRINT
		
		
		FINAL:
		POP ES DS DI SI DX CX BX AX
		IRET
	RSI_57H ENDP


	
	INSTALADOR PROC			;ESTO ES ESTANDAR PARA LAS INTERRUPCIONES
		mov ax, 0
		mov es, ax
		mov ax, OFFSET RSI_57H
		mov bx, cs
		cli
		mov es:[ 40h*4 ], ax
		mov es:[ 40h*4+2 ], bx
		sti
		mov dx, OFFSET INSTALADOR
		int 27h ;  Acaba y deja residente
		;  PSP, variables y rutina rsi.
	INSTALADOR ENDP
	
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
