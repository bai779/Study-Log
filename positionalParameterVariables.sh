#!/bin/bash
for i in "$*"
#定义for循环，in后有几个值就会循环多少次，"$*"要用双引号括起来
#shell会把$*中的所有参数看成一个整体，所以这个for循环只会循环一次
	do
		echo "The parameters is: $i"
		#打印变量$i的值
	done
x=1
#定义变量x的值为1，用于跟踪参数的索引
for j in "$@"
#shell会把$@中的每一个参数都看成独立的，所以"$@"中有几个参数，就会循环几次
	do
		echo "The paramenters $x is :$j"
		#输出变量j的值
		x=$((x+1))
	done

echo '$0:'$0  '$1:'$1  '$2:'$2 
