;************************************************************************** 
; SBM 2019. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR 
; Miguel Manzano y Juan Martin 
; Pareja numero 7
;************************************************************************** 
; DEFINICION DEL SEGMENTO DE DATOS 
DATOS SEGMENT 
;-- rellenar con los datos solicitados 
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

	MOV DX, 0535H				;declaramos un auxiliar para poder pasar el valor 0535H a DS
	MOV DS, DX					;DS=0535H
	MOV BX, 0210H				;BX=0210H
	MOV DI, 1011H				;DI=1011H
	
	
	MOV DH, 033H				;para ver claramente el primer MOV inicializo
	MOV DS:[1234H], DH 			;DS[1234h]=033H
	
	MOV CX, 2221H				;para ver claramente el segundo MOV inicializo 
	MOV WORD PTR DS:[BX], CX 	;DS[BX]=2221H
	
	
	MOV AL, DS:[1234H]			;movemos el contenido de la direccion 1234H a AL
	MOV AX, [BX]				;movemos el contenido de la direccion indicada por BX a AX
	MOV [DI], AL				;movemos el contenido de AL a la direccion indicada por DI
	
; FIN DEL PROGRAMA 
	MOV AX, 4C00H 
	INT 21H 
INICIO ENDP 
; FIN DEL SEGMENTO DE CODIGO 
CODE ENDS 
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION 
END INICIO 