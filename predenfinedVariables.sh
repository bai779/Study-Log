#!/bin/bash
#$? 最后一次执行的命令的返回状态，正确执行为0
#$$ 当前进程的进程号
#$! 后台运行的最后一个进程的进程号

ls -a > command.txt
echo '$?:' $?
echo '$$:' $$
echo '$!:' $!

cat command.txt
rm -f command.txt
