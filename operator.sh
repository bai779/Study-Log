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

#--------------------------------

read -p '请输入需要查询的用户名:' username
#获取指定用户名在passwd文件中出现的次数
count=$(cat /etc/passwd | grep $username | wc -l)
#count=`cat /etc/passwd | grep $username | wc -l`

#判断出现的次数，如果次数=0则用户不存在
if [ $count -eq 0 ] 
then
		echo '用户不存在'
	else
		echo '用户存在'
fi

#----------------------------------

#文件测试运算符
file=test
`mkdir $file`
if [ -e $file ]
then
		echo "$file exist"
	else
		echo "$file not exist"
fi
if [ -b $file ]
then
		echo "$file is block file"
	else
		echo "$file is not block file"
fi
if [ -r $file ]
then
		echo "$file is readable"
	else
		echo "$file is unreadable"
fi

`rm -rf $file`
if [ $? -eq 0 ]
then
		echo "$file delete succeeded"
	else
		echo "$file delete failed"
fi
















