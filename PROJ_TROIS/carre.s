    thumb
	area	reset, data, readonly
	import TabCos; tableau contenant le cosinus des angles
	import TabSin; tableau contenant le sinus des m?mes angles
	export redft
	area reset, data, readwrite
debut
	dcd	0x20019000	; stack en fin de la zone de 20k de RAM
	area fonction, code, readonly
		
	
redft	PROC
	mov r3, #0
	push{r4,r5}
;r0=adresse de base du signal, r1=valeur de k, r2=adresse de TabCos, r3=valeur de i, lr=valeur somme
	mov lr, #0
	
somme
	mul r4, r1, r3 ; r4=ik
	and r4, #0x8F ; r4=r4 mod 64
	ldrsh r4,[r2,r4,lsl#1]; charger TabCos[r4] dans r4
	ldrsh r5,[r0,r3,lsl#1]; charger TabSig[r3] dans r5
	mul r4, r4,r5
	add lr, r4
	add r3, #1
	ENDP
		
	cmp r3,#64
	blo somme ; si i<64 on revient au label somme
		
	pop {r4,r5}	
	bx lr
	END