
	ORG	00H
	SJMP	INICIO

	ORG 	23H
	MOV	A, SBUF
	MOV 	R0, A	;EVITA O BUG
	MOV	R1, #1 	;FLAG DE CHEGADA DE NOVO CARACTER
	CLR	RI
	RETI
	
	
	ORG	30H
INICIO:	MOV	SP, #2FH
	MOV	IE, #90H	;habilita serial
	MOV 	SCON,#40H	;Serial no modo 1
	MOV	TMOD, #20H	;temp1 no modo 2
	MOV	TH1, #0F4H	;taxa de 2.400bps
	MOV	TL1, #0F4H	
	SETB	TR1		;dispara timer1
	SETB	REN		;habilita recepção
	MOV	P2, #0

	CALL	M1		;envia menssagem de MENU
L1:	MOV 	R1, #0		;zera a flag de caracter novo
	CJNE	R0, #'Y', N	;Y
	SETB	P2.7		;liga lampada, com driver da LAMPADA ligado no pino 2.7
	SJMP	L1
N:	CJNE	R0, #'N', ERR	;N
	CLR	P2.7		;desliga lampada, com driver da LAMPADA ligado no pino 2.7
	SJMP	L1
	
ERR:	CJNE	R1, #0, L1
	CJNE	A, #0, L3
	SJMP	L1
L3: 	CALL	M2		;envia menssagem de ERRO
	SJMP	L1


M1:	MOV 	DPTR, #TXT1	;pega o endereço inicial do texto1
M11:	MOV	R2, #0		;contador para leitura do texto
L:	MOV	A, R2
	MOVC	A, @A+DPTR
	CJNE	A, #0FFH, ENVIA	
	MOV 	A, #0
	RET
ENVIA:	MOV 	SBUF, A	;coloca o caracter a ser transmitido
	JNB	TI, $		;espera transmitir
	CLR	TI
	INC	R2
	SJMP	L

M2:	MOV 	DPTR, #TXT2	;pega o endereço inicial do texto2
	SJMP	M11

TXT1: DB '    MENU', 13, '1 - Digite "Y" para ligar a lampada', 13, '2 - Digite "N" para desligar a lampada', 13, 0FFH
TXT2: DB 13,'Digite "Y" ou "N" ', 13, 0FFH	

	END
