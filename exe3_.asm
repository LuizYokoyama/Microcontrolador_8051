
	org	00H
	sjmp	INICIO

	ORG	03H		;interrupção 0
	LCALL	OQ400
	RETI

	ORG	0BH		;interrupção do timer zero
	LCALL	TIMER
	RETI	
	
	ORG	13H		;interrupção 1
	LCALL	OQ800
	RETI

	ORG	30H
INICIO:	MOV	SP, #2FH
	MOV	IE, #87H	;habilita as interrupções 0 e 1 e timer zero
	MOV	TCON, #5	;interrupções 0 e 1 por transição
	MOV	TMOD, #1	;configura temporizador zero no modo 1
	MOV	TH0, #HIGH(19455); confg. temporizador para 50ms
	MOV	TL0, #LOW(19455); confg. temporizador para 50ms
	SJMP	$

OQ400:	MOV	R7, #4		; confg. meio período para 200ms (4x50ms)
	MOV	A, R7
	SETB	TR0		;inicia tempo de 50ms
	RET
OQ800:	MOV	R7, #8		; confg. meio período para 400ms (8x50ms)
	MOV	A, R7
	SETB	TR0		;inicia tempo de 50ms
	RET
TIMER:	MOV	TH0, #HIGH(19455); confg. temporizador para 50ms
	MOV	TL0, #LOW(19455); confg. temporizador para 50ms
	SETB 	TR0		;inicia outro semiciclo
	DJNZ	A, L1		
	MOV	A, R7		;recarrega a qtd de vezes que deve repetir 50ms
	CPL 	P1.0		;complementa o pino da onda quadrada
L1:	RET
	
	END




