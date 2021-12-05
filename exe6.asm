
	ORG	00H
	SJMP	INICIO

	ORG	03H		;interrupção 0
	CALL	AP
	RETI

	ORG	0BH		;interrupção do timer 0
	CALL	TIMER
	RETI	
	
	ORG	30H
INICIO:	MOV	SP, #2FH
	MOV	IE, #83H	;habilita a interrupção 0 e temporizador 0
	MOV	TMOD, #1	;configura temporizador 0 no modo 1
	MOV	TCON, #1	;interrupção 0 por transição
	MOV	P2, #0
	MOV	P1, #0
MONIT:	CJNE	R7, #1, $	;LOOP infinito de monitoramento dos sensores
	JB	P1.1, O1	
	JB	P1.0, O2	
	JB	P1.2, O3
	SJMP	MONIT
O1:	CALL	RE
	SJMP	MONIT
O2:	CALL	ESQ
	SJMP	MONIT
O3:	CALL	DIR
	SJMP	MONIT

ESQ:	MOV 	R6, #1  	; 1s
	MOV	P2, #90H	; motor M1 pra frente, M2 pra trás
	CALL 	CRONO
	CJNE	R7, #0, $	;ESPERA o fim do tempo solicitado
	CALL	AP
	RET

RE:	MOV 	R6, #5  	; 5 * 1s == 5s
	MOV	P2, #50H	; os dois motores rodam pra trás
	CALL 	CRONO		; marca o tempo de funcionamento
	CJNE	R7, #0, $	;ESPERA o fim do tempo solicitado
	MOV	R7, #1
	CALL	DIR
	RET

DIR:	MOV 	R6, #1  	; 1s
	MOV	P2, #60H	; motor M2 pra frente, M1 pra trás
	CALL	CRONO
	CJNE	R7, #0, $	;ESPERA o fim do tempo solicitado
	CALL	AP
	RET

CRONO:	MOV	R5, #20	; 20* 50ms == 1s
	SJMP	F
L1:	MOV 	R5, #20	; 20 * 50ms == 1s
	DJNZ	R6, F
	CALL	PARA
	RET			;
F:	MOV	TH0, #HIGH(19455); confg. temporizador 0 para 50ms
	MOV	TL0, #LOW(19455) ; confg. temporizador 0 para 50ms
	SETB 	TR0		;liga temporizador 0
	RET
	
TIMER:	DJNZ	R5, F
	SJMP	L1

AP:	CJNE	R7, #0, PARA 	;AP : ANDA OU PARA
	SETB 	P1.7
	MOV	R7, #1		; FLAG que indica ANDANDO
	MOV	P2, #0A0H	; motor M1 pra frente, M2 pra FRENTE
	RET
PARA:	SETB 	P1.4
MOV	P2, #0		; para os motores
	MOV	R7, #0		; FLAG que indica PARADO
	RET

END


	