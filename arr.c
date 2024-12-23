#include<stdio.h>
int main(){
int a[10]={1,2,3,4,5,6,7,8,9,0};
int *p=&a[2];
printf("a[2]=%d p[0]=%d a[1]=%d p[-1]=%d\n",a[2],p[0],a[1],p[-1]);
return 0;
}
