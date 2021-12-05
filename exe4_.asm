
	org	00H
	sjmp	INICIO
	
	ORG	1BH		;interrupção do timer 1
	LCALL	TIMER
	RETI	
	
	ORG	13H		;interrupção1 
	SETB 	TR1		;liga temporizador 1
	LCALL	MOTOR
	RETI

	ORG	30H
INICIO:	MOV	SP, #2FH
	MOV	IE, #8CH	;habilita a interrupçÃO 1 e timer 1
	MOV	TCON, #4	;interrupçÃO 1 por transição
	MOV	TMOD, #10H	;configura temporizador 1 no modo 1
	MOV	TH1, #HIGH(19455); confg. temporizador 1 para 50ms
	MOV	TL1, #LOW(19455) ; confg. temporizador 1 para 50ms
	SJMP	$

MOTOR:	SETB 	P2.7
	CLR	P2.6		;liga o motor
	MOV	R7, #1		; 1 minuto; aumentar caso precise de mais minutos
	MOV	R5, #199	; (1 + 199) * 50ms == 10s
L1:	MOV	R6, #6	; 	; 6 * 10s == 60s
	SJMP	F
	
L2:	MOV 	R5, #200	; 200 * 50ms == 10s
	DJNZ	R6, F
	DJNZ	R7, L1
	SETB	P2.6 		;desliga o motor
	RET
F:	MOV	TH1, #HIGH(19455); confg. temporizador 1 para 50ms
	MOV	TL1, #LOW(19455) ; confg. temporizador 1 para 50ms
	SETB 	TR1		;liga temporizador 1
	RET

TIMER:	DJNZ	R5, F
	SJMP	L2		

	END





