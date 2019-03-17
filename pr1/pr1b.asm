;************************************************************************** 
; SBM 2019. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR 
; Miguel Manzano y Juan Martin 
; Pareja numero 7
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE DATOS 
DATOS SEGMENT 
;-- rellenar con los datos solicitados 
	CONTADOR DB ?				;inicializo los valores
	TOME DW 0CAFEH
	TABLA100 DB 100 DUP(0)
	ERROR1 DB "Atencion: Entrada de datos incorrecta."
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

	MOV AL, ERROR1[2]					;movemos el byte 3 de ERROR1 a AL
	MOV TABLA100[63H], AL				;y lo movemos a la direccion 63H de la l TABLA100 
	
	MOV CX, TOME						;movemos el contenido de TOME a CX 
	MOV WORD PTR TABLA100[23H], CX		;y lo guardamos en la direccion 23H de TABLA100
	
	MOV CX, TOME						;movemos el contenido de TOME a CX 
	MOV BYTE PTR CONTADOR, CH			;cogemos el byte mas significativo y lo guardamos en la variable CONTADOR
	
	
; FIN DEL PROGRAMA 
	MOV AX, 4C00H 
	INT 21H 
INICIO ENDP 
; FIN DEL SEGMENTO DE CODIGO 
CODE ENDS 
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION 
END INICIO 