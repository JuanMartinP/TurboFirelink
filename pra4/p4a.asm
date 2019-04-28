;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 			SBM 2016. Practica 4 - Apartado a				;
;   Pareja 7 - Miguel Manzano y Juan Martin					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

CODE SEGMENT  		;; Definición del segmento de código
ASSUME CS:CODE, DS: CODE, SS:CODE

ORG 100H	
INICIO:

	POLIBIO DB '4', '5', '6', '7', '8', '9', 'A', 'B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z', '0', '1', '2', '3', '$'
	OFFSET_A DB 12						;2 * 6 + 0  FILA * MAXFILA + COL
	OFFSET_C DB 0
	RES DB 0
	FIL DB 0 
	COL DB 0
	RESFIL DB 0
	RESCOL DB 0
	
	JMP MAIN


	
	RSI_57H PROC FAR				;ESTO SE VA A ENCARGAR DE CODIFICAR Y DECODIFICAR LA CADENA QUE LE PASA EL MAIN 
		
		PUSH AX BX CX DX SI DI DS ES 
		
		CMP AH, 10H						;; Para codificar
		JE CODIFICAR
	
		CMP AH, 11H						;; Para decodificar
		JE DECODIFICAR
		
		JMP FINAL
		
		CODIFICAR:
		
			MOV SI, 0
			;BUCLE:
			MOV BL , 'C'               ;DS:[DX][SI]
			CMP BL, 'A'
			JB NUMEROS
			CMP BL, 'Z'
			JA NUMEROS
			
			ADD BL, OFFSET_A
			MOV RES, BL
			SUB RES, 'A'
			MOV DH, RES
			MOV OFFSET_C, DH
			;JMP PRINT
			;CMP DS:[DX][SI], $
			;JNE BUCLE
			
			
			
			
			
			
		RET
		
		NUMEROS:
			CMP BL, '4'
			JB NUMFINAL
				
				

				
		RET
		
		NUMFINAL:	
		RET
		
		DECODIFICAR:
		RET
	
		PRINT:
			MOV AL, OFFSET_C
			MOV AH, 0
			MOV BH, 6
			DIV BH
			MOV RESFIL, AL
			ADD RESFIL, '1'
			MOV DH, RESFIL
			MOV FIL, DH
			
			MOV AH, 2
			MOV DL, FIL
			INT 21H
			
			MOV AL, OFFSET_C
			MOV AH, 0
			MOV BH, 6
			DIV BH
			MOV RESCOL, AH
			ADD RESCOL, '1'
			MOV DH, RESCOL
			MOV COL, DH
				
			MOV AH, 2
			MOV DL, COL
			INT 21H
				
		RET
		
		
		FINAL:
		POP ES DS DI SI DX CX BX AX
		IRET
	RSI_57H ENDP


	MAIN:			;SE EJECUTA PRIMERO, MIRA LOS ARGUMENTOS Y LLAMA A LA RUTINA (POLIBIO) O AL INSTALADOR
	
		MOV DX, OFFSET POLIBIO
		MOV AH, 9
		INT 21H
		PUSHF
		CALL RSI_57H
		
		
	MOV AX,4C00H			; FIN DE PROGRAMA Y VUELTA AL DOS
	INT 21H

	
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
	RET
	INSTALADOR ENDP
	
; FIN DEL SEGMENTO DE CODIGO 
CODE ENDS 
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION 
END INICIO