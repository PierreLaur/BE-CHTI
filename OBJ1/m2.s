 thumb
	area	reset, data, readonly
	import reimdft
	import TabCos
	import TabSin
	export m2
	area fonction, code, readonly
		
m2 PROC
	push {r4,r5,r6,LR}
	; reimdft(=TabSig, k, =TabCos/TabSin)
	; l'adresse de TabSig est dans r0, k est dans r1
	mov r4, r0 ; on met l'adresse de TabSig dans r4
	
	ldr r2,=TabCos
	BL reimdft ; appel de reimdft avec cos (calcul de Re(k), retour dans r0)
	smull r5,r6,r0,r0 ; calcul de Re² : on garde 32 bits. POINT D'ARRET : Re(k) dans R0
	
	mov r0, r4 ; on remet l'adresse de TabSig dans r0
	ldr r2,=TabSin
	
	BL reimdft ; appel de reimdft avec sin (calcul de Im(k), retour dans r0)
	smlal r5,r6, r0,r0 ; calcul de Im² : on garde 32 bits. POINT D'ARRET : Im(k) dans R0
	mov r0,r6 ; on ajoute Re² à Im²
		
	pop{r4,r5,r6,PC}
	ENDP
	END