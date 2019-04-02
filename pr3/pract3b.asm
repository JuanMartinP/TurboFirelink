;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 			SBM 2016. Practica 3 - Apartado b				;
;   Pareja 7 - Miguel Manzano y Juan Martin					;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

_TEXT SEGMENT BYTE PUBLIC 'CODE' 		;; Definición del segmento de código
ASSUME CS:_TEXT
			

	PUBLIC _createBarCode						
	_createBarCode PROC FAR 					

		PUSH BP 							
		MOV BP, SP
		PUSH BX CX DX SI DI DS ES
		
		MOV AX, [BP+18]									;country code					
		
		
	
	
	
	
	
	
	
	
		POP ES DS DI SI DX CX BX
		POP BP							
		RET								
	_createBarCode ENDP							
	
	
_TEXT ENDS
END