# EMbedded

### 1.数组下标可以为负数

+ 下标只是给出了一个与当前地址的偏移量，只要根据这个偏移量能定位得到目标地址即可。

```c
int a[10]={1,2,3,4,5,6,7,8,9,0};
int *p=&a[2];
printf("a[2]=%d p[0]=%d a[1]=%d p[-1]=%d\n",a[2],p[0],a[1],p[-1]);

输出：[0]=3 a[1]=2 p[-1]=2
```

### 2.

