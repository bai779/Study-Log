#!/bin/bash

read -t 30 -p "Please input your name:" name
# 请输入姓名 并等待30秒，把用户的输入保存到变量name中
echo "Name is $name"

read -s -t 30 -p "Please enter your age:" age
# 请输入年龄 并等待30秒，把用户的输入保存到变量age中
# 年龄是隐私，使用 -s 选项来隐藏输入
echo -e "\n"
#调整输出格式，不输出换行，输出不会换行
echo "Age is $age"

read -n 1 -t 30 -p "Please select your gender[M/F]:" gender
# 请选择性别 并等待30秒，把用户的出入保存到变量gender
# 使用 -n1 选项只接收一个输入字符就会执行（不用输入回车）
echo -e "\n"
echo "Sex is $gender"
