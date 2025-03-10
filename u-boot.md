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

   + nfs 网络文件系统命令
     ```less
     nfs [loadAddress] [[hostIPaddr:]bootfilename]
     loadAddress是保存的DRAM地址
     [hostIPaddr:]bootfilename是要下载的文件地址
     ```

     > 使用nfs命令将zImage下载到开发板DRAM的`0X80800000`地址处
     > `nfs 80800000 192.168.1.150:/home/baiyanjie/linux/nfs/zImage`
     >
     > 需要在`/etc/exports`中设置nfs的导出目录，以确保板子能够正确访问，且设置权限能够正确访问
     
   + tftp 网络文件命令(使用TFTP协议)

     ```less
     Ubuntu作为tftp服务器，需要安装tftp-hpa和tftpd-hpa
     sudo apt-get install tftp-hpa tftpd-hpa
     sudo apt-get install xinetd
     创建一个文件夹来存放文件并设置权限 /home/baiyanjie/linux/tftpboot
     sudo vim /etc/xinetd.d/tftp
     ###############################
      server tftp
      {
      socket_type = dgram
      protocol = udp
      wait = yes
      user = root
      server = /usr/sbin/in.tftpd
      server_args = -s /home/zuozhongkai/linux/tftpboot/
      disable = no
      per_source = 11
      cps = 100 2
      flags = IPv4
      }
     #################################
     启动服务sudo service tftpd-hpa start
     修改配置
     sudo vim /etc/default/tftpd-hpa
     ###############################
      # /etc/default/tftpd-hpaTFTP_USERNAME="tftp"TFTP_DIRECTORY="/home/baiyanjie/linux/tftpboot"TFTP_ADDRESS=":69" 
     TFTPOPTIONS="-l -c -s" 
     ###############################
     重启服务sudo service tftpd-hpa restart
     
     tftpboot [loadAddress][[hostIPadde:]bootfilename]
     tftp不需要输入文件完整路径
     ```
     

6. EMMC和SD卡操作

| 命令            | 操作                                   |
| --------------- | -------------------------------------- |
| mmc info        | 输出MMC设备信息                        |
| mmc read        | 读取MMC中的数据                        |
| mmc write       | 向MMC设置写入数据                      |
| mmc rescan      | 扫描MMC设备                            |
| mmc part        | 列出MMC设备的分区                      |
| mmc dev         | 切换MMC设备                            |
| mmc list        | 列出当前有效的所有MMC设备              |
| mmc hwpartition | 设置MMC设备的分区                      |
| mmc bootbus     | 设置指定MMC设备的BOOT_BUS_WIDTH域的值  |
| mmc bootpart    | 设置指定MMC设备的boot和RPMB分区的大小  |
| mmc partconf    | 设置指定MMC设备的PARTITION_CONFG域的值 |
| mmc rst         | 复位MMC设备                            |
| mmc setdsr      | 设置DSR寄存器的值                      |

+ mmc read

  ```less
  mmc read addr blk# cnt
  addr数据读取到DRAM中的地址
  blk是读取的起始地址
  cnt是读取的块的数量(一个块是512字节)
  ```

+ mmc write

  ```less
  mmc write addr blk# cnt
  addr 写入MMC中的数据在DRAM中的起始地址
  blk是要写入MMC块起始地址
  cnt是写入的块大小
  ```

+ mmc erase

  ```less
  mmc erase blk# cnt  擦除指定块
  ```

7. FAT格式文件系统操作命令

   + fatinfo
     ```less
     fatinfo <interface> [<dev[:part]
     用于查询指定MMC设备分区的文件系统信息
     interface是接口，例如MMC
     dev是设备号
     part是分区
     ```

   + fatls

     ```less
     fatls <interface> [<dev[:part]>] [directory]
     查询FAT格式设备的目录和文件信息
     directory是要查询的目录
     ```

   + fstype
     ```less
     fstype <interface> <dev>:<par
     查看MMC设备某个分区的文件系统格式
     ```

   + fatload
     ```less
     fatload <interface> [<dev[:part]> [<addr> [<filename> [bytes [pos]]]
     将指定的文件读取到DRAM中
     addr是 保存在DRAM中的起始地址
     filename是要读取的文件名字
     bytes是读取多少字节的数据，如果为0或省略表示读取整个文件
     pos是要读取的文件相对于文件首地址的便宜，为0或省略表示从首地址读取
     ```

   + fatwrite
     ```less
     fatwrite <interface> <dev[:part]> <addr> <filename> <byte>
     将DRAM中的数据写入到MMC设备中，默认未使能，需要在头文件中增加一行宏定义
     #define CONFIGFATWRITE /* 使能 fatwrite 命令 */
     
     
     ```

8. EXT格式文件系统操作命令

   ```less
   ext2load ext2ls ext4load ext4ls ext4write
   ```

9. BOOT操作命令

   + bootz
     ```less
     bootz [addr [initrd[:size]] [fdt]]
     bootz用于启动zImage镜像文件
     addr是镜像文件在DRAM中的位置
     initrd是initrd文件在DRAM中的地址，如果不使用initrd用'-'代替
     fdt是设备树文件在DRAM中的地址
     ```

   + bootm
     ```less
     bootm [addr [initrd[:size]] [fdt
     bootm和bootz功能类似，但是bootm用于启动uImage镜像文件
     ```

   + boot
     ```less
     boot也是用来启动linux系统，只是boot会读取环境变量bootcmd来启动linux系统
     如果要使用tftp命令从网络启动linux那么就可以设置bootcmd为
     "tftp 80800000 zImage; tftp 83000000 imx6ull-14x14-emmc-7-1024x600-c.dtb; bootz 80800000 - 83000000”，
     ```

10. 其他命令

    + reset
      复位

    + go
      跳转到指定地址执行程序

    + run

      用于运行环境变量中定义的命令，方便调试

    + mtest
      内存读写测试命令，测试DDR

      ```less
      mtest [start [end [pattern [iterations]]
      start 是要测试的 DRAM 开始地址
      end 是结束地址
      ```

      

++++++++++++

## 顶层makefile

++++

1. 版本号
   ```makefile
   VERSION = 2016
   PATCHLEVEL = 03
   SUBLEVEL =
   EXTRAVERSION =
   NAME =
   ```

   > VERSION是主版本号
   > PATCHLEVEL是补丁版本号
   >
   > EXTRAVERSION 是附加版本信息

2. MAKEFLAGS变量
   ```makefile
   MAKEFLAGS += -rR --include-dir=$(CURDIR)
   +=给MAKEFLAGS追加信息
   -rR表示禁止使用内置的隐含规则和变量定义
   --include-dir指明搜索路径
   $(CURDIR)表示当前路径
   ```

   > + make支持递归调用
   >
   > ```makefile
   > $(MAKE)-C subdir
   > $(MAKE)表示调用make命令，-C指定只目录
   > 如果要向子make传递或屏蔽变量，使用export，unexport导出或不导出
   > export VARIABLE …… //导出变量给子 make 。
   > unexport VARIABLE…… //不导出变量给子 make。
   > ```
   >
   > + `SHELL`和`MAKEFLAGS`变量默认在make执行过程中自动传递给 子make，除非使用unexport声明

3. 命令输出

   V=1

   ```makefile
   ifeq ("$(origin V)", "command line")
     KBUILD_VERBOSE = $(V)
   endif
   ifndef KBUILD_VERBOSE
     KBUILD_VERBOSE = 0
   endif
   
   ifeq ($(KBUILD_VERBOSE),1)
     quiet =
     Q =
   else
     quiet=quiet_
     Q = @
   endif
   ```

   > ifeq ("$(origin V)", "command line")
   >
   > 使用ifeq来判断断"$(origin V)"和"command line"是否相等
   >
   > + origin函数
   >
   >   > $(origin <variable>)
   >   >
   >   > variable是变量名，返回值是变量来源
   >
   > 意思是判断 V 的来源是否是 command line，若是则KBUILD_VERBOSE等于        V 的值；在命令行输入V=1的话那么就KBUILD_VERBOSE=1，实现uboot编译时命令的完整输出，不输入等于0为命令精简输出
   >
   > ++++
   >
   > ifndef KBUILD_VERBOSE
   >
   > 判断KBUILD_VERBOSE是否为1，如果为1变量quiet和Q都为空，否则quiet为'quiet_'，Q为'@'
   >
   > makefile中会用到变量quiet和Q来控制编译时是否在终端输出完整的命令

4. 静默输出

   V=0

   ```makefile
   ifneq ($(filter 4.%,$(MAKE_VERSION)),)	# make-4
   ifneq ($(filter %s ,$(firstword x$(MAKEFLAGS))),)
     quiet=silent_
   endif
   else					# make-3.8x
   ifneq ($(filter s% -s%,$(MAKEFLAGS)),)
     quiet=silent_
   endif
   endif
   
   export quiet Q KBUILD_VERBOSE
   ```

   > ifneq ($(filter 4.%,$(MAKE_VERSION)),)	# make-4
   >
   > 判断当前版本是否为4.x
   >
   > + filter函数
   >
   >   > $(filter <pattern...>,\<text>)
   >   >
   >   > filter函数表示以pattern模式过滤text字符串中的单词，仅保留符合模式pattern的单词，函数返回值就是符合pattern的字符串
   >
   > 意思是filter在MAKE_VERSION中招出符合4.%的字符串，%是通配符
   >
   > ++++
   >
   > ifneq ($(filter %s ,$(firstword x$(MAKEFLAGS))),)
   >
   > 判断filter在$(firstword x$(MAKEFLAGS)))中过滤出符合%s的字符串是否为空
   >
   > + firstworld函数
   >
   >   > $(firstword \<text>)
   >   >
   >   > 用于去除text字符串中的第一个单词，返回值就是获取到的第一个单词
   >
   > 当使用make -s 编译时，-s会作为MAKEFLAGS 变量的一部分传递给 Makefile。

5. 设置编译结果输出目录
   make O=out

   ```makefile
   ifeq ("$(origin O)", "command line")
     KBUILD_OUTPUT := $(O)
   endif
   PHONY := _all
   _all:
   $(CURDIR)/Makefile Makefile: ;
   
   ifneq ($(KBUILD_OUTPUT),)
   saved-output := $(KBUILD_OUTPUT)
   KBUILD_OUTPUT := $(shell mkdir -p $(KBUILD_OUTPUT) && cd $(KBUILD_OUTPUT) \
   								&& /bin/pwd)
   $(if $(KBUILD_OUTPUT),, \
        $(error failed to create output directory "$(saved-output)"))
   
   PHONY += $(MAKECMDGOALS) sub-make
   
   $(filter-out _all sub-make $(CURDIR)/Makefile, $(MAKECMDGOALS)) _all: sub-make
   	@:
   
   sub-make: FORCE
   	$(Q)$(MAKE) -C $(KBUILD_OUTPUT) KBUILD_SRC=$(CURDIR) \
   	-f $(CURDIR)/Makefile $(filter-out _all sub-make,$(MAKECMDGOALS))
   skip-makefile := 1
   endif # ifneq ($(KBUILD_OUTPUT),)
   endif # ifeq ($(KBUILD_SRC),)
   ```

   > ifeq ("$(origin O)", "command line")
   > 判断“O”是否来自命令行，若是则 KBUILD_OUTPUT := $(O)
   >
   > 因此变量KBUILD_OUTPUT 就是输出目录
   >
   > ++++
   >
   > ifneq ($(KBUILD_OUTPUT),)
   >
   > 判断是否为空
   >
   > ++++
   >
   > KBUILD_OUTPUT := $(shell mkdir -p $(KBUILD_OUTPUT) && cd $(KBUILD_OUTPUT) \
   >
   > ​                && /bin/pwd)
   >
   > 调用mkdir创建KBUILD_OUTPUT 目录，创建成功之后的绝对路径赋值给KBUILD_OUTPUT 

6. 代码检查
   make C=1

   ```makefile
   ifeq ("$(origin C)", "command line")
     KBUILD_CHECKSRC = $(C)
   endif
   ifndef KBUILD_CHECKSRC
     KBUILD_CHECKSRC = 0
   endif
   ```

   > ifeq ("$(origin C)", "command line")
   >
   > 判断C是否来自命令行，若是则将C赋值给KBUILD_CHECKSRC，否则为0

7. 模块编译
   make M=dir   旧语法make SUBDIRS=dir

   ```makefile
   ifdef SUBDIRS
     KBUILD_EXTMOD ?= $(SUBDIRS)
   endif
   
   ifeq ("$(origin M)", "command line")
     KBUILD_EXTMOD := $(M)
   endif
   
   ifdef SUBDIRS
     KBUILD_EXTMOD ?= $(SUBDIRS)
   endif
   
   ifeq ("$(origin M)", "command line")
     KBUILD_EXTMOD := $(M)
   endif
   
   PHONY += all
   ifeq ($(KBUILD_EXTMOD),)
   _all: all
   else
   _all: modules
   endif
   
   ifeq ($(KBUILD_SRC),)
           # building in the source tree
           srctree := .
   else
           ifeq ($(KBUILD_SRC)/,$(dir $(CURDIR)))
                   # building in a subdirectory of the source tree
                   srctree := ..
           else
                   srctree := $(KBUILD_SRC)
           endif
   endif
   objtree		:= .
   src		:= $(srctree)
   obj		:= $(objtree)
   
   VPATH		:= $(srctree)$(if $(KBUILD_EXTMOD),:$(KBUILD_EXTMOD))
   
   export srctree objtree VPATH
   ```

   > ifdef SUBDIRS
   >
   >  KBUILD_EXTMOD ?= $(SUBDIRS)
   >
   > endif
   >
   > 判断SUBDIRS是否定义，若是则将其赋值到KBUILD_EXTMOD，这里是为了支持老语法
   > ++++
   >
   > ifeq ("$(origin M)", "command line")
   >
   >  KBUILD_EXTMOD := $(M)
   >
   > endif
   >
   > 判断是否在命令定义M，并将其赋值到KBUILD_EXTMOD
   >
   > +++
   >
   > ifeq ($(KBUILD_EXTMOD),)
   >
   > 判断KBUILD_EXTMOD是否为空，若是则\_all依赖all，因此要先编译all，否则默认\_all以来modules，也就是先编译模块，一般不会在uboot编译模块，所以会编译all这个目标
   >
   > ++++
   >
   > ifeq ($(KBUILD_SRC),)
   >
   > 判断是否为空，若空则设置变量srctrss为当前目录，即 "." ，一般不设置KBUILD_SRC
   >
   > +++++
   >
   > objtree   := .
   >
   > 设置为当前目录
   >
   > +++
   >
   > src   := $(srctree)
   >
   > obj   := $(objtree)
   >
   > 设置为当前目录
   >
   > +++
   >
   > export srctree objtree VPATH
   >
   > 导出变量

8. 获取主机架构和系统
   ```makefile
   HOSTARCH := $(shell uname -m | \
   	sed -e s/i.86/x86/ \
   	    -e s/sun4u/sparc64/ \
   	    -e s/arm.*/arm/ \
   	    -e s/sa110/arm/ \
   	    -e s/ppc64/powerpc/ \
   	    -e s/ppc/powerpc/ \
   	    -e s/macppc/powerpc/\
   	    -e s/sh.*/sh/)
   
   HOSTOS := $(shell uname -s | tr '[:upper:]' '[:lower:]' | \
   	    sed -e 's/\(cygwin\).*/cygwin/')
   
   export	HOSTARCH HOSTOS
   ```

   >变量HOSTARCH用于保存主机架构
   >
   >调用shell命令uname -m 获取主机架构
   >
   >使用sed来将获取到的架构替换后面的路径
   >
   >+++
   >
   >uname -s 获取主机名字
   >
   >tr '[:upper:]' '[:lower:]'”表示将所有的大写字母替换为小写字母

9. 设置目标架构，交叉编译器和配置文件

   make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-

   ```makefile
   ifeq ($(HOSTARCH),$(ARCH))
   CROSS_COMPILE ?=
   endif
   
   KCONFIG_CONFIG	?= .config
   export KCONFIG_CONFIG
   ```

10. 调用scripts/Kbuild.include
   ```makefile




























