#!/bin/bash

#统计根分区使用率
rate=$(df -h | grep "dev/sda2" |awk '{printf $5}'| cut -d "%" -f1)
#把根分区使用率作为变量赋予变量rate
if [ $rate -ge 80 ]
then
		echo "Warning!/dev/sda2 is full!!"
fi
		echo "/dev/sda2 using rate is $rate"

#------------------------------------------
#判断用户输入的是什么文件
read -p "please input a filename:" file
#接受键盘输入，并赋予变量file
if [ -z $file ]
#判断变量是否为空
then
		echo "Error,please input a filename"
		exit 1
elif [ ! -e $file ]
#判断file是否存在
then
		echo "Your input is not a file!"
		exit 2
elif [ -f $file ]
#判断是否为普通文件
then
		echo "$file is a regulare file!"
elif [ -d $file ]
#判断是否为目录文件
then
		echo "$file is a directory!"
else
	echo "$file is an other file!"
fi

