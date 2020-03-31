    thumb
	area	reset, data, readonly
	import TabCos; tableau contenant le cosinus des angles
	import TabSin; tableau contenant le sinus des m?mes angles
	export redft
	area fonction, code, readonly
		
	
redft	PROC
	mov r3, #0
	push{r4,r5,r6}
	mov r6,r0
;r6=adresse de base du signal, r1=valeur de k, r2=adresse de TabCos, r3=valeur de i, r0=valeur somme
	mov r0, #0
	
somme
	mul r4, r1, r3 ; r4=ik
	and r4, #0x3F ; r4=r4 mod 64
	ldrsh r4,[r2,r4]; charger TabCos[r4] dans r4
	ldrsh r5,[r6,r3]; charger TabSig[r3] dans r5
	smull r4,r5, r4,r5
	add r0, r4
	add r3, #2
	ENDP
		
	cmp r3,#124
	blo somme ; si i<=62 on revient au label somme
		
	pop {r4,r5,r6}	
	bx lr
	END