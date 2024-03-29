
	ORG	00H
	SJMP	INICIO

	ORG 	23H
	CALL	SERIAL
	RETI
	
	ORG	30H
INICIO:	MOV	P2, #0
	MOV	SP, #2FH
	MOV	IE, #90H	;habilita serial
	MOV 	SCON,#40H	;Serial no modo 1
	MOV	TMOD, #20H	;temp1 no modo 2
	MOV	TH1, #0FDH	;taxa de 9.600bps
	MOV	TL1, #0FDH	
	SETB	TR1		;dispara timer1
	SETB	REN		;habilita recepção
	MOV	R3, #1		;FLAG DE PRIMEIRA VEZ A ACIONAR
	SJMP	M1		;LOOP infinito
	
SERIAL: MOV	A, SBUF
	MOV 	R0, A	;EVITA O BUG
	CJNE	R3, #1, PEGA	;FLAG DE PRIMEIRA VEZ A ACIONAR
	MOV	P2, #99H	;PRIMEIRO PASSO
	MOV	R3, #0
PEGA:	MOV	A, P2	;pega posição atual do motor
	CLR	RI
	RET

M1:	CJNE	R0, #'1', M2	;'1'
	MOV	R2, #1		;1 volta
	CALL	ANT		;
	MOV	R0, #0
	SJMP	M1
M2:	CJNE	R0, #'2', M3	;'2'
	MOV	R2, #2		;2 voltas
	CALL	HOR		;
	MOV	R0, #0
	SJMP	M1	
M3:	CJNE	R0, #'3', M4	;'3'
	MOV	R2, #10		;10 voltas
	CALL	ANT		;
	MOV	R0, #0
	SJMP	M1	
M4:	CJNE	R0, #'4', M1	;'4'
	MOV	R2, #10		;10 voltas
	CALL	HOR		;
	MOV	R0, #0
	SJMP	M1	

ANT:	MOV	R1, #0
ANTL:	RL	A
	INC	R1
	MOV	P2, A
	LCALL	DELAY1		
	CJNE	R1, #72, ANTL
	DEC	R2
	CJNE	R2, #0, ANT
	RET		
	
HOR:	MOV	R1, #0
HORL:	RR	A
	INC	R1
	MOV	P2, A
	LCALL	DELAY1		
	CJNE	R1, #72, HORL
	DEC	R2
	CJNE	R2, #0, HOR
	RET

DELAY1:	MOV	R4, #04FH
DELAY2:	MOV	R5, #0FFH
	DJNZ	R5, $
	DJNZ	R4, DELAY2
	RET
	
	END

