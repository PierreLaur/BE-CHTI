
	thumb
	include etat.inc
	extern StructS
	extern Position
	
TIM3_CCR3	equ	0x4000043C	; adresse registre PWM

	area  moncode, code, readonly
	export timer_callback
;
timer_callback	proc
	ldr r0,=StructS				; on charge l'adressse de la structure son
	ldr r1, =TIM3_CCR3			; charge l'adresse du registre de PWM dans r3 
	ldr r2,[r0] 				; position actuelle 
	ldr r3,[r0, #E_TAI]			; taille de notre échantillon 
	cmp r2,r3 					; on compare taille et position ( on ctn si position<taille)
	bhs silence 				; on quitte si on est à la fin 
	
	; si on est pas a la fin du coup ( resultat cmp) :
	push {r7,r8}                ; push r7 r8
	ldr r7, [r0,#E_SON]			; charge echantillon dans le registre r7
	ldrsh r12 ,[r7, r2, LSL #1] ; echantillon actuel ( pas besoin de push r12)
	add r12, #0x8000           ; addition composante ctn, on choisit la moitié de l'intervalle 32768 			
	ldr r8, [r0, #E_RES]	   ; affecte au registre r8 le resolution
	mul r12,r8				   ; mul résolution avec notre échantillon  
	lsr r12,#16 			   ; div par 2^16 
	
	; il est temps d'envoyer
	add r2,#1 				   ; maj de la position 
	str r2,[r0]                ; stock la nouvelle position dans la structure son
	str r12,[r1] 			   ; stock l'échantillon modifié dans le registre PWM 
	pop {r8,r7};			   
	b	fin
	
silence ldr r12, [r0, #E_RES]  ; charge la structure 
		lsr r12, #1            ; divpar 2^1 
		str r12,[r1]           ; stock r12 dans le registre de PWM 
		B fin
		
fin	bx	lr	
	endp
;
	end