;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 			SBM 2016. Practica 4 - Apartado b				;
;   Pareja 7 - Miguel Manzano y Juan Martin					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT

		POLIBIOTABLA DB 10, 13
					 DB " | 0 1 2 3 4 5", 10, 13
					 DB "--------------", 10, 13
					 DB "0| 4 5 6 7 8 9", 10, 13
					 DB "1| A B C D E F", 10, 13
					 DB	"2| G H I J K L", 10, 13
					 DB "3| M N O P Q R", 10, 13
					 DB "4| S T U V W X", 10, 13
					 DB "5| Y Z 0 1 2 3", 10, 13, '$'

	POLIBIODECOD DB "33322522112232545253053023$"
	POLIBIOCOD DB "MIGUELJUANPOLIBIO2019$"
	DECOD DB '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '0', '1', '2', '3'
	MSJ1 DB "Se esta codificando la cadena ", '$'
	MSJ2 DB "Se esta decodificando la cadena ", '$'
	
	
DATOS ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO DE PILA
PILA SEGMENT STACK "STACK"
DB 40H DUP (0)
PILA ENDS

;**************************************************************************
; DEFINICION DEL SEGMENTO DE CODIGO
CODE SEGMENT
ASSUME CS: CODE, DS: DATOS, SS: PILA

; COMIENZO DEL PROCEDIMIENTO PRINCIPAL
INICIO PROC

	MOV AX, DATOS
	MOV DS, AX
	MOV AX, PILA
	MOV SS, AX
	MOV SP, 64

	MOV AH, 9								;Imprime la matriz de polibio personalizada de la pareja 7
	MOV DX, OFFSET POLIBIOTABLA
	INT 21H
	
	MOV AH, 2H
	MOV DL, 10			
	INT 21H

	MOV AH, 9								;Imprime un mensaje informativo
	MOV DX, OFFSET MSJ1
	INT 21H
	
	MOV AH, 9								
	MOV DX, OFFSET POLIBIOCOD
	INT 21H
	
	MOV AH, 2H
	MOV DL, ':'			
	INT 21H
	
	MOV AH, 2H
	MOV DL, 10			
	INT 21H
	
	MOV DX, OFFSET POLIBIOCOD
	MOV AH, 10H								;Codificar
	INT 57H

	MOV AH, 2H
	MOV DL, 10			
	INT 21H
	MOV AH, 2H
	MOV DL, 10			
	INT 21H
	
	MOV AH, 9								;Imprime un mensaje informativo
	MOV DX, OFFSET MSJ2
	INT 21H

	MOV AH, 9								
	MOV DX, OFFSET POLIBIODECOD
	INT 21H
	
	MOV AH, 2H
	MOV DL, ':'			
	INT 21H
	
	MOV AH, 2H
	MOV DL, 10			
	INT 21H
	
	MOV AH, 11H								;Decodificar
	MOV DX, OFFSET POLIBIODECOD
	MOV DI, OFFSET DECOD
	INT 57H

; FIN DEL PROGRAMA
	MOV AX, 4C00H
	INT 21H
INICIO ENDP
; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO
