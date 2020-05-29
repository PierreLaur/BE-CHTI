#include "gassp72.h"
#include "etat.h"

extern void timer_callback(void);
#define tick_horloge    720000
int resolution;
type_etat StructS;
extern short Son;
extern int LongueurSon;
extern int PeriodeSonMicroSec;

int main(void)
{
    StructS.position=0; // index courant dans le tableau d'echantillons
    StructS.taille=LongueurSon; // nombre d'echantillons de l'enregistrement
    StructS.son=&Son; // adresse de base du tableau d'echantillons en ROM
    StructS.periode_ticks=72*PeriodeSonMicroSec;

// activation de la PLL qui multiplie la fréquence du quartz par 9
CLOCK_Configure();
// config port PB1 pour être utilisé en sortie
GPIO_Configure(GPIOB, 0, OUTPUT, ALT_PPULL);
        StructS.resolution = PWM_Init_ff( TIM3, 3, StructS.periode_ticks/3 );
// initialisation du timer 4
// Periode_en_Tck doit fournir la durée entre interruptions
Timer_1234_Init_ff( TIM4, StructS.periode_ticks  );
Active_IT_Debordement_Timer( TIM4, 2, timer_callback );
// lancement du timer
Run_Timer( TIM4 );
//une boucle infinie après initialisation des périphériques
while    (1)
    {
    }
}