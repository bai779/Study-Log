# Uboot

## uboot编译和烧写

1. 解压uboot源码压缩包

2. emmc核心板编译uboot命令
   ```bash
   #!/bin/bash
   #shell脚本自动执行
   make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- distclean
   make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- mx6ull_14x14_ddr512_emmc_defconfig
   make V=1 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j12
   ```

   + 第一条命令相当于`make distclean`，目的是清除工程

   + 第二条命令相当于`make mx6ull_14x14_ddr512_emmc-defconfig`，用于配置uboot。配置文件为`mx6ull_14x14_ddr512_emmc-defconfig`

     > uboot 除了引导 Linux 以外还可以引导其它的系统，而且 uboot 还支持其它的架构
     > 和外设，比如 USB、网络、SD 卡等。
     > 编译 uboot 之前，一定要根据自己的需求配置 uboot。`mx6ull_14x14_ddr512_emmc_defconfig`
     > 就是正点原子针对 `I.MX6U-ALPHA `的 `EMMC` 核心板编写的配置文件，这个配置文件在 `uboot`
     > 源码的 `configs` 目录中。在` uboot` 中，通过“`make xxx_defconfig`”来配置 `uboot，xxx_defconfig`
     > 就是不同板子的配置文件，这些配置文件都在` uboot/configs `目录中

   + 最后一条命令相当于`make -j12`，也就是使用12核来编译uboot

     > V=1用于设置编译过程的信息输出级别 -j用于设置主机使用多少线程编译

3. 编译出来的二进制文件是u-boot.bin，需要在加上头部(IVT、DCD等)才能在6ull上执行，将u-boot烧写到sd卡上

   `./imxdownload uboot.bin /dev/sdd`

4. 使用数据线链接板子的USB_TTL接口，打开mobaxterm软件，选择serial，速率选择115200，链接串口接收板子的日志

5. sd卡插入板子，打开开关，按下复位键

6. 当mobaxterm上出现`Hit any Key ti stop autoboot`时按回车键，默认是3秒倒计时，如果3秒结束没有摁回车，uboot就会使用默认参数来启动linux内核，按下回车会进入uboot命令行模式

++++++++++++++++++++++++

## uboot命令行模式

1. 帮助命令
   ```less
   help 或？ 查看当前uboot所支持的命令
   ? bootz 或 help bootz 查询bootz命令的用法
   ```

2. 信息查询命令
   ```less
   bdinfo 查看板子信息
   printenv 输出环境变量
   version 查看板子的版本号
   ```

3. 环境变量操作

   + 修改环境变量

   ```less
   saveenv 将修改后的环境变量保存到flash中
   ```

   ```less
   setenv bootdelay 5 将环境变量bootdelay修改为5(修改后需要使用saveenv保存环境变量)
   
   setenv bootargs 'console=ttymxc0,115200 root=/dev/mmcblk1p2 rootwait rw' 修改的值可以加单引号括起来表示这些值都属于bootargs(修改后需要使用saveenv保存环境变量)
   ```

   ```less
   ```

   + 新建环境变量

   ```less
   setenv author baiyanjie
   saveenv
   ```

   + 删除环境变量

   ```less
   setenv author
   saveenv  将环境变量赋予空值后保存就是删除
   ```

4. 内存操作命令

   + md 显示内存值
     ```less
     md[.b,.w,.l] address [#of objects]
     bwl对应byte，word，long以1字节，2字节，4字节显示内存值
     address是要查看的内存的地址
     of objects表示要查看的数据块的数量，取决于显示内存值大小(.b.w.l) 
     !!!数字表示全都是十六进制不是十进制!!!
     ```

   + nm 修改指定地址的内存值
     ```less
     nm[.b,.w,.l] address
     输入命令后在 问号(?)后输入修改后的数据
     ```

   + mm 修改指定地址的内存值（自动自增）

     ```less
     mm[.b,.w,.l] address
     输入命令后在 问号(?)后输入修改后的数据，输入q退出修改
     ```

   + mw 用于使用一个指定的数据填充一段内存
     ```less
     mw[.b,.w,.l] address value [count]
     address起始地址
     value表示要填充的数据
     count表示填充的块长度，块取决于[.b,.w,.l]
     ```

   + cp 将DRAM数据从一段内存拷贝到另一段内存中(将flash拷贝到DRAM中)
     ```less
     cp[.b,.w,.l] source target count
     count 拷贝块长度，块取决于[.b,.w,.l]
     ```

   + cmp 比较两段内存的数据是否相等
     ```less
     cmp[.b,.w,.l] addr1 addr2 count
     count 拷贝块长度，块取决于[.b,.w,.l]
     ```

5. 网络操作命令

   + 设置环境变量
     ```less
     setenv ipaddr 192.168.1.252  板子ip地址
     setenv ethaddr a1:b2:c3:00:00:00  板子MAC地址
     setenv gatewayip 192.168.1.1  网关地址
     setenv netmask  255.255.255.0  子网掩码
     setenv serverip 192.168.1.251  服务器地址 ubuntu虚拟机地址
     saveenv
     ```

   + ping
     ```less
     只能boot ping别的机器，因为boot没有对ping命令做处理
     ```

   + dhcp
     ```less
     从路由器获取ip，开发板没有链接路由器此命令就失效
     ```

   + nfs 网络系统文件命令
     ```less
     nfs [loadAddress] [[hostIPaddr:]bootfilename]
     loadAddress是保存的DRAM地址
     [hostIPaddr:]bootfilename是要下载的文件地址
     ```

     

++++`
