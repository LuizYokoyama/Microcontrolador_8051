
	ORG	00H
	SJMP	INICIO

	ORG	03H		;interrupção 0
	CALL	MOTOR
	RETI
	
	ORG	1BH		;interrupção do timer 1
	CALL	TIMER
	RETI	
	
	ORG	30H
INICIO:	MOV	SP, #2FH
	MOV	IE, #89H	;habilita a interrupção 0 e temporizador 1
	MOV	TMOD, #10H	;configura temporizador 1 no modo 1
	MOV	TCON, #1	;interrupção 0 por transição
	MOV	IP, #8		;TEMPORIZADOR 1 TEM PRIORIDADE!
	MOV	P2, #0
	MOV	DPTR, #TAB_AT	;pega o endereço da tabela para rotação antihorária
	SJMP	$
	
MOTOR:	CALL 	CRONO		;inicia tempo de 1 minuto
	MOV	R3, #1		;INICIALIZA FLAG de parada do motor
M1:	MOV	R0, #0
M2:	CJNE	R3, #1, PARA	;FLAG de parada do motor
	MOV	A, R0
	MOVC	A, @A+DPTR
	MOV	P2, A
	CALL	DELAY
	INC	R0
	CJNE	R0, #4, M2
	SJMP	M1
PARA:	RETI

CRONO:	MOV	R7, #1		; 1 minuto; aumentar caso precise de mais minutos
	MOV	R5, #200	; 200 * 50ms == 10s
L1:	MOV	R6, #6		; 6 * 10s == 60s
	SJMP	F
L2:	MOV 	R5, #200	; 200 * 50ms == 10s
	DJNZ	R6, F
	DJNZ	R7, L1
	MOV	R3, #0		;FLAG de parada do motor
	RET			;
F:	MOV	TH1, #HIGH(19455); confg. temporizador 1 para 50ms
	MOV	TL1, #LOW(19455) ; confg. temporizador 1 para 50ms
	SETB 	TR1		;liga temporizador 1
	RET
TIMER:	DJNZ	R5, F
	SJMP	L2	

DELAY:	MOV	R1, #0FFH
DELAY2:	MOV	R2, #0FFH
	DJNZ	R2, $
	DJNZ	R1, DELAY2
	RET
		
TAB_AT:	DB	01H;0011		;tabela para rotação antihorária
	DB	02H;0110
	DB	04H;1100
	DB	08H;1001

	END


