#include "gassp72.h"
#include <stdlib.h>
#include <time.h>
#include <stdio.h>
#include "etat.h"

#define SYSTICK_PER 360000
#define M2TIR 985988
#define DET 0x52
extern void timer_callback(void);
#define tick_horloge    720000
int resolution;
type_etat StructS;
extern short Son;
extern int LongueurSon;
extern int PeriodeSonMicroSec;
int m2 (unsigned short*, int k) ;
extern short TabSig[] ;

int cpt[6];
int scores[6] ;
int kval[]= {17,18,19,20,23,24} ;
int res=0 ;
unsigned short dma_buf[64];

void checkcpt(void){
	for(int i=0; i<6; i++) {
		if(cpt[i] >= 13){
			cpt[i]=0;
			scores[i]++;
			StructS.position=0;
		}
	}
}

void sys_callback(void){
	// Démarrage DMA pour 64 points
	Start_DMA1(64);
	Wait_On_End_Of_DMA1();
	Stop_DMA1;
	
	for(int j=0; j<6; j++){
		res = m2(dma_buf, kval[j]);
		if(res > M2TIR){
			cpt[j]++;
		}else{
			cpt[j] = 0;
		}
	}
	
	checkcpt();
}

int main () {
	
	  StructS.position=LongueurSon+1; // index courant dans le tableau d'echantillons
    StructS.taille=LongueurSon; // nombre d'echantillons de l'enregistrement
    StructS.son=&Son; // adresse de base du tableau d'echantillons en ROM
    StructS.periode_ticks=72*PeriodeSonMicroSec;

	for (int i=0 ; i<6 ; i++) {
		cpt[i]=0 ;
		scores[i]=0 ;
	}
	
		// activation de la PLL qui multiplie la fréquence du quartz par 9
	CLOCK_Configure();
	// PA2 (ADC voie 2) = entrée analog
	GPIO_Configure(GPIOA, 2, INPUT, ANALOG);
	// PB1 = sortie pour profilage à l'oscillo
	GPIO_Configure(GPIOB, 1, OUTPUT, OUTPUT_PPULL);
	// PB14 = sortie pour LED
	// config port PB1 pour être utilisé en sortie
	GPIO_Configure(GPIOB, 0, OUTPUT, ALT_PPULL);
	GPIO_Configure(GPIOB, 14, OUTPUT, OUTPUT_PPULL);
	StructS.resolution = PWM_Init_ff( TIM3, 3, StructS.periode_ticks/3 );
	// activation ADC, sampling time 1us
	Init_TimingADC_ActiveADC_ff( ADC1, DET );
	Single_Channel_ADC( ADC1, 2 );
	// Déclenchement ADC par timer2, periode (72MHz/320kHz)ticks
	Init_Conversion_On_Trig_Timer_ff( ADC1, TIM2_CC2, 225 );
	// Config DMA pour utilisation du buffer dma_buf (a créér)
	Init_ADC1_DMA1( 0, dma_buf );

	// initialisation du timer 4
	// Periode_en_Tck doit fournir la durée entre interruptions
	Timer_1234_Init_ff( TIM4, StructS.periode_ticks  );	
	Active_IT_Debordement_Timer( TIM4, 2, timer_callback );
	// lancement du timer
	Run_Timer( TIM4 );
	
	// Config Timer, période exprimée en périodes horloge CPU (72 MHz)
	Systick_Period_ff( SYSTICK_PER );
	// enregistrement de la fonction de traitement de l'interruption timer
	// ici le 3 est la priorité, sys_callback est l'adresse de cette fonction, a créér en C
	Systick_Prio_IT( 3, sys_callback );
	SysTick_On;
	SysTick_Enable_IT;
	
	while (1) { 
		
	} 
}