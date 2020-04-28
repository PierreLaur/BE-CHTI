// test fonction som_cos_sin
int som_cos_sin(int);
int min = 1;
int max = 0;
int main(){
	int som = 0;
	for(int i=0;i<63;i++){
			som=som_cos_sin(i);
		if(som>max){
			max=som;
		}
		else if(som<min){
			min=som;
		}
	}
	while (1) {
	}
}