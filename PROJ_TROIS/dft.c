int redft (int*adr,int k,int*adr2) ;
extern int * TabCos ;
extern int * TabSig ;

int main () {
	int ok=0 ;
	for (int k=0 ; k<64 ; k++) {
		ok=redft(TabCos,k,TabSig) ;
	}
	return(0) ;
}