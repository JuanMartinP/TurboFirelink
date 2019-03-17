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
	MOV AX, 15H ;carga 15H en AX
	
	MOV BX, 0BBH   		;carga BBH en BX
	
	MOV CX, 3412H 		;carga 3412H en AX
	
	MOV DX, CX 			;carga el contenido de CX en DX 
	
	MOV AX, 6550H 		;movemos AX a la direccion de memoria de 6550H
	MOV DS, AX 			;utilizamos DS para acceder a AX en la siguiente instruccion
	
	MOV BH, DS:[36H] 	;carga en BH el contenido de la posicion de memoria 65536H
	MOV BL, DS:[37H] 	;carga en BL el contenido de la posicion de memoria 65537H
	
	MOV AX, 5000H 		;movemos AX a la direccion de memoria de 6550H
	MOV DS:[005H], CH 	;cargar en la posicion de memoria 50005H el contenido de CH
	
	MOV AX, [SI] 		;cargar en AX el contenido de la direccion de memoria apuntada por SI
	
	MOV BX, [BP + 10] 	;cargar en BX el contenido de la direccion de memoria que esta 10 bytes por encima de la direccion apuntada por BP
	
; FIN DEL PROGRAMA 
	MOV AX, 4C00H 
	INT 21H 
INICIO ENDP 
; FIN DEL SEGMENTO DE CODIGO 
CODE ENDS 
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION 
END INICIO 