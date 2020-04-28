    thumb
	AREA    PROGRAM, CODE, READONLY
	EXPORT timer_callback		[WEAK]
GPIOB_BSRR	equ	0x40010C10	; Bit Set/Reset register
	IMPORT state
	
timer_callback	PROC

	ldr r2, =state	; on met l'adresse de la variable state dans r2
	ldr r4, [r2] ; on met la valeur de state dans r4
	cbnz r4, state1 ; si r0 > 0, on jump au label state1
	; else :
; mise à 1 de state
	mov r4, #1
	str r4, [r2]
; mise a 1 de PB1
	ldr	r3, =GPIOB_BSRR
	mov	r1, #0x00000002
	str	r1, [r3]
state1
; mise à zero de state
	mov r4, #0
	str r4, [r2]
; mise a zero de PB1
	ldr	r3, =GPIOB_BSRR
	mov	r1, #0x00020000
	str	r1, [r3]
	bx lr
; N.B. le registre BSRR est write-only, on ne peut pas le relire
	ENDP
	END