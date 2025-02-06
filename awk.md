# awk

+ 处理文本

## 1.基本语法

`awk ' pattern { action } ' file`

+ pattern：匹配模式，指定哪些行符合条件，默认是匹配所有行
+ action：指定当前匹配模式时要执行的操作，默认为打印出改行

## 2.awk工作原理

awk逐行读取输入，按空白字符（空格、制表符）分割行，处理每个字段（默认为`$1`、`$2`等）。同时，可以设置输入字段分隔符（FS）来调整字段分隔符

## 3.常见选项

+ `-F`：设置字段分隔符。例如，`-F ","` 将字段分隔符设置为逗号。
+ `-f`：从文件中读取 `awk` 脚本。
+ `-v`：传递变量给 `awk` 脚本。

## 4.awk中内置变量

+ `FS`：输入字段分隔符，默认为空格或制表符。
+ `OFS`：输出字段分隔符，默认为空格。
+ `NR`：当前行号。
+ `NF`：当前行的字段数。
+ `$0`：当前整行内容。
+ `$1`, `$2`, ...：表示当前行的各个字段，`$1` 表示第一字段，`$2` 表示第二字段。

## 5.常见使用

### (1) 打印文件内容

`awk '{print $0}' file.txt`

打印出 `file.txt` 文件的每一行

### (2) 打印特定字段

`awk '{print $1}' file.txt`

打印 file.txt 文件中每一行的第一个字段。

### (3) 设置字段分隔符

`awk -F ',' '{print $1, $2}' file.csv`

将字段分隔符设置为逗号，打印每行的前两个字段。

### (4) 使用条件判断

`awk '$1 > 50 {print $1, $2}' file.txt`

如果第一字段大于 50，则打印该行的第一个和第二个字段。

### (5) 打印特定行

`awk 'NR == 3 {print $0}' file.txt`

打印文件 file.txt 的第三行。

### (6) 计算某一列的和

`awk '{sum += $1} END {print sum}' file.txt`

计算 file.txt 中第一列的总和。END 块在所有输入处理完后执行。

### (7) 修改字段内容

`awk '{$2 = "Modified"; print $0}' file.txt`

将每行的第二个字段修改为 "Modified"，然后打印整行。

### (8) 使用内置变量 NR 和 NF

`awk '{print "Line number:", NR, "Fields:", NF, "Content:", $0}' file.txt`

打印行号、字段数以及行内容。

### (9) 指定多个命令

`awk '{print $1; print $2}' file.txt`

打印每行的第一个和第二个字段。

### (10) 处理特定的文件类型

`awk 'BEGIN {FS=":"} {print $1}' /etc/passwd`

读取 /etc/passwd 文件，并指定字段分隔符为冒号 :，打印每个用户的用户名。

## 6.高级用法

### 6.1 定义函数

`awk 'function myFunction(x) { return x * 2 } {print myFunction($1)}' file.txt`

定义一个函数 myFunction，并在 awk 中使用。

### 6.2 多行输出

`awk '{print "Start"; print $0; print "End"}' file.txt`

对每一行输出多个内容。

### 6.3 使用数组

`awk '{arr[$1]++} END {for (i in arr) print i, arr[i]}' file.txt`

统计文件中每个第一列值出现的次数。
## 7.示例脚本

### 7.1 计算某列的平均值

`awk '{sum += $1} END {print "Average:", sum / NR}' file.txt`

计算 file.txt 中第一列的平均值。

### 7.2 格式化输出

`awk '{printf "Name: %-10s Age: %-3s\n", $1, $2}' file.txt`

格式化打印每行的前两个字段。

### 7.3 条件过滤并输出特定字段

`awk '$3 > 30 {print $1, $2}' file.txt`

如果第三列大于 30，打印前两列。

### 7.4 多个模式匹配

`awk '$1 ~ /pattern1/ && $2 ~ /pattern2/ {print $0}' file.txt`

筛选第一列匹配 pattern1 且第二列匹配 pattern2 的行。
