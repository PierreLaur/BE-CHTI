int m2 (short*TabSig, int k) ;
extern short TabCos[] ;
extern short TabSin[] ;
extern short TabSig[] ;
int mod ;
int k ;
int main () {
	
	for (k=0 ; k<64 ; k++) {
		mod=m2(TabSig,k) ; // POINT D'ARRET : M2(k-1) dans mod
	}
	while (1) { 
	} 
}