int redft (short*adr,int k,short*adr2) ;
extern short TabCos[] ;
extern short TabSig[] ;
int res ;
int k ;
int main () {
	
	for (k=0 ; k<64 ; k++) {
		res=redft(TabSig,k,TabCos) ;
	}
	while (1) {
	}
}