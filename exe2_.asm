
	org	00H
	sjmp	INICIO

	ORG	03H		;interrupção 0
	LCALL	R150PE
	RETI
	
	ORG	13H		;interrupção 1
	LCALL	R180GD
	RETI

	ORG	30H
INICIO:	MOV	SP, #2FH
	MOV	IE, #85H	;habilita as interrupções 0 e 1
	MOV	TCON, #5	;interrupções 0 e 1 por transição
	MOV	P2, #0
	SJMP	$
	
R150PE:	MOV	DPTR, #TAB_AT	;pega o endereço da tabela para rotação antihorária
	MOV	R6, #0
L1:	MOV	R7, #0
L2:	CJNE	R6, #151, D1	;conta 150 passos
	RET
D1:	MOV	A, R7
	MOVC	A, @A+DPTR
	MOV	P2, A
	LCALL	DELAY1
	INC	R7
	INC	R6
	CJNE	R7, #4, L2
	SJMP	L1
R180GD:	MOV	DPTR, #TAB_HR	;pega o endereço da tabela para rotação horária
	MOV	R6, #0
L3:	MOV	R7, #0
L4:	CJNE	R6, #37, D2	;conta 36 passos de 5º para dar os 180º pedidos
	RET
D2:	MOV	A, R7
	MOVC	A, @A+DPTR
	MOV	P2, A
	LCALL	DELAY1
	INC	R7
	INC	R6
	CJNE	R7, #4, L4
	SJMP	L3
DELAY1:	MOV	B, #0FFH
DELAY2:	MOV	R0, #0FFH
	DJNZ	R0, $
	DJNZ	B, DELAY2
	RET
TAB_AT:	DB	01H;0011		;tabela para rotação antihorária
	DB	02H;0110
	DB	04H;1100
	DB	08H;1001
TAB_HR:	DB	09H;1001		;tabela para rotação horária
	DB	0CH;1100
	DB	06H;0110
	DB	03H;0011

	END

