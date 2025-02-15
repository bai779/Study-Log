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

1. uboot命令
   ```less
   help 或？ 查看当前uboot所支持的命令
   ```

   



++++
