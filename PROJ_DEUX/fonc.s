	thumb
	import TabCos; tableau contenant le cosinus des angles
	import TabSin; tableau contenant le sinus des mêmes angles
	export som_cos_sin
	area fonction, code, readonly
;fonction som_cos_sin 
som_cos_sin proc
	push{r4,r7}
	ldr r1,=TabCos; charger la tab de cos
	ldr r2,=TabSin; charger la tab de sin
	; on considere r0 le parametre initial qui contient l'indice d'entrée
	ldrsh r1,[r1,r0,lsl #1]; charger TabCos[r0] dans r1
	ldrsh r2,[r2,r0,lsl #1]; charger Tabsin[r0] dans r2
	push {r4} ; on sauvegarde les valeurs de r4 et r7 dans la pile
	push {r7} ;
	mul r4,r1,r1; (cos(x)*cos(x))
	mul r7,r2,r2 ;(sin(x)*sin(x))
	add r0,r7,r4 ; resultat dans r0=cos(x).cos(x) + sin(x)sin(x)
	pop {r4,r7} ;
	bx lr;
	endp

	end