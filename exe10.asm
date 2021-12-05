
	ORG	00H
	SJMP	INICIO

	ORG	03H
	CALL	M1
	RETI

	ORG	13H
	CALL	M2
	RETI

	ORG	30H
INICIO:	MOV	SP, #2FH
	MOV	IE, #95H	;habilita serial, int0 e int1
	MOV 	SCON,#40H	;Serial no modo 1
	MOV	TCON, #5
	MOV	TMOD, #20H	;temp1 no modo 2
	MOV	TH1, #0FAH	;taxa de 4.80bps
	MOV	TL1, #0FAH	
	SETB	TR1
	SJMP	$		;LOOP infinito

M1:	MOV 	DPTR, #TXT1	;pega o endereço inicial do texto1
M11:	MOV	R2, #0		;contador para leitura do texto
L:	MOV	A, R2
	MOVC	A, @A+DPTR
	CJNE	A, #0FFH, ENVIA	
	RET
ENVIA:	MOV 	SBUF, A	;coloca o caracter a ser transmitido
	JNB	TI, $		;espera transmitir
	CLR	TI
	INC	R2
	SJMP	L

M2:	MOV 	DPTR, #TXT2	;pega o endereço inicial do texto2
	SJMP	M11

TXT1: DB 13, 'Interrupcao externa 0 acionada', 13, 0FFH
TXT2: DB 13,'Interrupcao externa 1 acionada', 13, 0FFH	

	END