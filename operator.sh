#!/bin/bash
a=10
b=20
echo ' '
echo 'a+b= ' `expr $a + $b`
echo 'a-b= ' `expr $a - $b`
echo 'a*b= ' `expr $a \* $b`
echo 'a/b= ' `expr $a / $b`
echo 'a%b= ' `expr $a % $b`

#判断是否相等
if [ $a == $b ]
then
	echo 'a等于b'
else
	echo 'a不等于b'
fi
