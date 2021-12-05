
	ORG	00H
	SJMP	INICIO

	ORG	0BH		;interrupção do timer 0
	CALL	TIMER
	RETI	

	ORG 	23H
	MOV	A, SBUF
	MOV	R0, A		;EVITA O BUG
	CLR	RI
	RETI
	
	ORG	30H
INICIO:	MOV	SP, #2FH
	MOV	IE, #92H	;habilita serial e temporizador 0
	MOV 	SCON,#40H	;Serial no modo 1
	MOV	TMOD, #21H	;configura temp0 no modo 1 e temp1 no modo 2
	MOV	TH1, #0E8H	;taxa de 1.200bps
	MOV	TL1, #0E8H	
	MOV	P2, #0		;limpa P2
	SETB	TR1		;dispara timer1
	SETB	REN		;habilita recepção
	MOV	R3, #1		;FLAG pra indicar que DEVE Aguardar
	
LOOP:	CJNE	R0, #'B', $
	MOV	R0, #0
	SETB	P2.7
	MOV 	R6, #30  	; ESPERA 30s
	CALL	M1		;envia menssagem de ligada
	CALL 	CRONO
T:	CJNE	R3, #0, $	;
	MOV	R3, #1		;FLAG pra indicar que DEVE Aguardar
	CLR	P2.7
	CALL 	M2		;envia menssagem de desligada
 	SJMP	LOOP
	
CRONO:	MOV	R5, #20	; 20* 50ms == 1s
	SJMP	F
L1:	MOV 	R5, #20	; 20 * 50ms == 1s
	DJNZ	R6, F
	MOV	R3, #0		;FLAG pra indicar que terminou
	RET			;
F:	MOV	TH0, #HIGH(19455); confg. temporizador 0 para 50ms
	MOV	TL0, #LOW(19455) ; confg. temporizador 0 para 50ms
	SETB 	TR0		;liga temporizador 0
	RET
	
TIMER:	DJNZ	R5, F
	SJMP	L1

M1:	MOV 	DPTR, #TXT1	;pega o endereço inicial do texto1
M11:	MOV	R2, #0		;contador para leitura do texto
L:	MOV	A, R2
	MOVC	A, @A+DPTR
	CJNE	A, #0FFH, ENVIA	
	RET
ENVIA:	MOV 	SBUF,	A	;coloca o caracter a ser transmitido
	JNB	TI, $		;espera transmitir
	CLR	TI
	INC	R2
	SJMP	L

M2:	MOV 	DPTR, #TXT2	;pega o endereço inicial do texto2
	SJMP	M11

TXT1: DB ' Lampada Ligada ', 13, 0FFH
TXT2: DB ' Lampada Desligada ', 0DH, 0FFH	
	
	END