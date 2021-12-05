CH1	equ	p3.0

	org	00h
	sjmp	INICIO

	org	030h
INICIO:	
	mov	tmod, #1	;configura temporizador zero no modo 1
	mov	P1, #1		;inicialisa com o led 0 aceso
	sjmp	LER_CH
ESQ:	lcall	ATRASO		; chama um atraso de 0,5s
	mov	A, P1		;lê o estado de P1
	rl	A		;rotaciona
	mov	P1, A		;devolve o valor rotacionado para P1
LER_CH:	jnb	CH1, ESQ	;se a chave estiver pressionada, rot a esquerda
	sjmp	LER_CH		;continua a leitura da chave CH1

ATRASO:	mov	R7, #10			;10 * 50ms == 0,5s
L1:	mov	th0, #high(19455)	; th0 recebe o byte alto de 19455; para 50ms
	mov	tl0, #low(19455)	; tl0 recebe o byte baixo de 19455; para 50ms
	setb	tr0		;inicia o temporizador
	jb 	CH1, LER_CH
	jnb	tf0, $		;aguarda o temporizador com 50 ms
	clr	tf0		;limpa o bit para poder contar de novo	
	djnz	r7, L1		; repete 10 vezes 50 ms
	ret

	end

