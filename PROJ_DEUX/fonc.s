	thumb
	area	reset, data, readonly
	import TabCos; tableau contenant le cosinus des angles
	import TabSin; tableau contenant le sinus des mêmes angles
	export som_cos_sin
	area reset, data, readwrite
debut
	dcd	0x20004000	; stack en fin de la zone de 20k de RAM
	area fonction, code, readonly
;fonction som_cos_sin 
som_cos_sin proc
	ldr r1,=TabCos; charger la tab de cos
	ldr r2,=TabSin; charger la tab de sin
	;on considere r0 le parametre initial qui contient l'indice d'entrée
	ldrsh r1,[r1,r0,lsl #1]; charger TabCos[r0] dans r1 avec extension de signe
	ldrsh r2,[r2,r0,lsl #1]; charger Tabsin[r0] dans r2 avec extension de signe	
	mul r4,r1,r1; (cos(x)*cos(x))
	mul r7,r2,r2 ;(sin(x)*sin(x))
	add r0,r7,r4 ; resultat dans r0=cos(x).cos(x) + sin(x)sin(x)
	bx lr;
	endp

	end