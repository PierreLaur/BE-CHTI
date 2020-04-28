    thumb
	area	reset, data, readonly
	export reimdft
	area fonction, code, readonly
		
	
reimdft	PROC
	mov r3, #0 ; i=0 (r3<-0 : en réalité r3=2i)
	push{r4,r5,r6}
	mov r6,r0 ; adresse du tableau de valeurs du signal dans r6
	mov r0, #0 ; somme=0 (dans r0 pour retour fonction)
; r1=valeur de k, r2=adresse de TabCos ou TabSin
	
	
somme
	mul r4, r1, r3 ; r4=ik
	and r4, #0x3F ; r4=r4 mod 64
	ldrsh r4,[r2,r4,lsl#1]; charger TabCos[r4]=cos(ik2pi/N) dans r4 (en 1.15)
	ldrsh r5,[r6,r3,lsl#1]; charger TabSig[r3]=x(i) dans r5 (en 1.15)
	mul r4, r4,r5 ; cos(ik2pi/N)*x(i), résultat dans r4 (en 2.30)
	add r0, r4 ; on incrémente la somme (en 2.30)
	add r3, #1 ; i+=1
	ENDP
		
	cmp r3,#64 ;
	blo somme ; si i<=64 (incrémentation en fin de boucle) on revient au label somme
		
	pop {r4,r5,r6}	
	bx lr ; on retourne la somme qui est dans r0
	END