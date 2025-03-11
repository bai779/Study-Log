# uboot移植

首先需要解压官方uboot源码

1. 添加开发板默认配置文件

   在config目录下创建默认配置文件，复制官方配置文件进行重命名为mx6ull_alientek_emmc_defconfig

   ```less
   CONFIG_SYS_EXTRA_OPTIONS="IMX_CONFIG=board/freescale/mx6ull_alientek_emmc/imximage.cfg,MX6ULL_EVK_EMMC_REWORK"
   CONFIG_ARM=y
   CONFIG_ARCH_MX6=y
   CONFIG_TARGET_MX6ULL_ALIENTEK_EMMC=y
   CONFIG_CMD_DHCP=y
   CONFIG_CMD_PING=y
   ```

2. 添加开发板对应的头文件
   在include/configs下添加对应的头文件，复制官方文件进行重命名为mx6ull_alientek_emmc.h

   ```less
   宏定义改为
   #ifndef __MX6ULL_ALIENTEK_EMMC_CONFIG_H
   #define __MX6ULL_ALIENTEK_EMMC_CONFIG_H
   ```

   ```less
   /*
    * Copyright (C) 2016 Freescale Semiconductor, Inc.
    *
    * Configuration settings for the Freescale i.MX6UL 14x14 EVK board.
    *
    * SPDX-License-Identifier:	GPL-2.0+
    */
   #ifndef __MX6ULL_ALIENTEK_EMMC_CONFIG_H
   #define __MX6ULL_ALIENTEK_EMMC_CONFIG_H
   
   
   #include <asm/arch/imx-regs.h>
   #include <linux/sizes.h>
   #include "mx6_common.h"
   ////可以在mx6_common.h中寻找未发现但存在的命令或功能
   #include <asm/imx-common/gpio.h>
   
   /* uncomment for PLUGIN mode support */
   /* #define CONFIG_USE_PLUGIN */
   
   /* uncomment for SECURE mode support */
   /* #define CONFIG_SECURE_BOOT */
   
   #ifdef CONFIG_SECURE_BOOT
   #ifndef CONFIG_CSF_SIZE
   #define CONFIG_CSF_SIZE 0x4000
   #endif
   #endif
   
   #define is_mx6ull_9x9_evk()	CONFIG_IS_ENABLED(TARGET_MX6ULL_9X9_EVK)
   #ifdef CONFIG_TARGET_MX6ULL_9X9_EVK
   #define PHYS_SDRAM_SIZE		SZ_256M
   #define CONFIG_BOOTARGS_CMA_SIZE   "cma=96M "
   #else
   #define PHYS_SDRAM_SIZE		SZ_512M
   #define CONFIG_BOOTARGS_CMA_SIZE   ""
   /* DCDC used on 14x14 EVK, no PMIC */
   #undef CONFIG_LDO_BYPASS_CHECK
   #endif
   ////设置DRAM的大小
   
   /* SPL options */
   /* We default not support SPL
    * #define CONFIG_SPL_LIBCOMMON_SUPPORT
    * #define CONFIG_SPL_MMC_SUPPORT
    * #include "imx6_spl.h"
   */
   
   #define CONFIG_ENV_VARS_UBOOT_RUNTIME_CONFIG
   
   #define CONFIG_DISPLAY_CPUINFO
   ////uboot启动时可以输出CPU信息
   #define CONFIG_DISPLAY_BOARDINFO
   ////uboot启动时可以输出板子信息
   /* Size of malloc() pool */
   #define CONFIG_SYS_MALLOC_LEN		(16 * SZ_1M)
   ////这里定义的是内存池的大小设置为16MB
   #define CONFIG_BOARD_EARLY_INIT_F
   ////board_init_f函数会调用board_early_init_f函数
   #define CONFIG_BOARD_LATE_INIT
   ////会调用board_late_init函数
   #define CONFIG_MXC_UART
   #define CONFIG_MXC_UART_BASE		UART1_BASE
   ////使能imx6ull的uart串口功能，这里使用串口1，基地址为UART1_BASE，定义在文件arch/arm/include/asm/arch-mx6/imx-regs.h 中，这个imx-regs.h定义的是寄存器描述文件
   /* MMC Configs */
   #ifdef CONFIG_FSL_USDHC
   #define CONFIG_SYS_FSL_ESDHC_ADDR	USDHC2_BASE_ADDR
   ////EMMC接在USDHC2上，宏CONFIG_SYS_FSL_ESDHC_ADDR为EMMC所使用接口的寄存器基地址，也就死USDHC2的基地址
   /* NAND pin conflicts with usdhc2 */
   #ifdef CONFIG_SYS_USE_NAND
   #define CONFIG_SYS_FSL_USDHC_NUM	1
   ////跟NAND有关，因为NAND和USDHC2的引脚冲突，所以使用NAND只能使用一个USDHC设备(SD卡)，CONFIG_SYS_FSL_USDHC_NUM表示USDHC数量
   #else
   #define CONFIG_SYS_FSL_USDHC_NUM	2
   #endif
   #endif
   
   /* I2C configs */
   #define CONFIG_CMD_I2C
   #ifdef CONFIG_CMD_I2C
   #define CONFIG_SYS_I2C
   #define CONFIG_SYS_I2C_MXC
   #define CONFIG_SYS_I2C_MXC_I2C1		/* enable I2C bus 1 */
   #define CONFIG_SYS_I2C_MXC_I2C2		/* enable I2C bus 2 */
   #define CONFIG_SYS_I2C_SPEED		100000
   ////和i2c有关
   /* PMIC only for 9X9 EVK */
   #define CONFIG_POWER
   #define CONFIG_POWER_I2C
   #define CONFIG_POWER_PFUZE3000
   #define CONFIG_POWER_PFUZE3000_I2C_ADDR  0x08
   #endif
   
   #define CONFIG_SYS_MMC_IMG_LOAD_PART	1
   
   #ifdef CONFIG_SYS_BOOT_NAND
   #define CONFIG_MFG_NAND_PARTITION "mtdparts=gpmi-nand:64m(boot),16m(kernel),16m(dtb),1m(misc),-(rootfs) "
   #else
   #define CONFIG_MFG_NAND_PARTITION ""
   #endif
   ////NAND的分区设置
   #define CONFIG_MFG_ENV_SETTINGS \
   	"mfgtool_args=setenv bootargs console=${console},${baudrate} " \
   	    CONFIG_BOOTARGS_CMA_SIZE \
   		"rdinit=/linuxrc " \
   		"g_mass_storage.stall=0 g_mass_storage.removable=1 " \
   		"g_mass_storage.file=/fat g_mass_storage.ro=1 " \
   		"g_mass_storage.idVendor=0x066F g_mass_storage.idProduct=0x37FF "\
   		"g_mass_storage.iSerialNumber=\"\" "\
   		CONFIG_MFG_NAND_PARTITION \
   		"clk_ignore_unused "\
   		"\0" \
   	"initrd_addr=0x83800000\0" \
   	"initrd_high=0xffffffff\0" \
   	"bootcmd_mfg=run mfgtool_args;bootz ${loadaddr} ${initrd_addr} ${fdt_addr};\0" \
   ////定义一些环境变量，使用MfgTool烧写时候需要这些变量
   #if defined(CONFIG_SYS_BOOT_NAND)
   #define CONFIG_EXTRA_ENV_SETTINGS \
   	CONFIG_MFG_ENV_SETTINGS \
   	"panel=TFT43AB\0" \
   	"fdt_addr=0x83000000\0" \
   	"fdt_high=0xffffffff\0"	  \
   	"console=ttymxc0\0" \
   	"bootargs=console=ttymxc0,115200 ubi.mtd=4 "  \
   		"root=ubi0:rootfs rootfstype=ubifs "		     \
   		CONFIG_BOOTARGS_CMA_SIZE \
   		"mtdparts=gpmi-nand:64m(boot),16m(kernel),16m(dtb),1m(misc),-(rootfs)\0"\
   	"bootcmd=nand read ${loadaddr} 0x4000000 0x800000;"\
   		"nand read ${fdt_addr} 0x5000000 0x100000;"\
   		"bootz ${loadaddr} - ${fdt_addr}\0"
   
   #else
   #define CONFIG_EXTRA_ENV_SETTINGS \
   	CONFIG_MFG_ENV_SETTINGS \
   	"script=boot.scr\0" \
   	"image=zImage\0" \
   	"console=ttymxc0\0" \
   	"fdt_high=0xffffffff\0" \
   	"initrd_high=0xffffffff\0" \
   	"fdt_file=undefined\0" \
   	"fdt_addr=0x83000000\0" \
   	"boot_fdt=try\0" \
   	"ip_dyn=yes\0" \
   	"panel=TFT43AB\0" \
   	"mmcdev="__stringify(CONFIG_SYS_MMC_ENV_DEV)"\0" \
   	"mmcpart=" __stringify(CONFIG_SYS_MMC_IMG_LOAD_PART) "\0" \
   	"mmcroot=" CONFIG_MMCROOT " rootwait rw\0" \
   	"mmcautodetect=yes\0" \
   	"mmcargs=setenv bootargs console=${console},${baudrate} " \
   		CONFIG_BOOTARGS_CMA_SIZE \
   		"root=${mmcroot}\0" \
   	"loadbootscript=" \
   		"fatload mmc ${mmcdev}:${mmcpart} ${loadaddr} ${script};\0" \
   	"bootscript=echo Running bootscript from mmc ...; " \
   		"source\0" \
   	"loadimage=fatload mmc ${mmcdev}:${mmcpart} ${loadaddr} ${image}\0" \
   	"loadfdt=fatload mmc ${mmcdev}:${mmcpart} ${fdt_addr} ${fdt_file}\0" \
   	"mmcboot=echo Booting from mmc ...; " \
   		"run mmcargs; " \
   		"if test ${boot_fdt} = yes || test ${boot_fdt} = try; then " \
   			"if run loadfdt; then " \
   				"bootz ${loadaddr} - ${fdt_addr}; " \
   			"else " \
   				"if test ${boot_fdt} = try; then " \
   					"bootz; " \
   				"else " \
   					"echo WARN: Cannot load the DT; " \
   				"fi; " \
   			"fi; " \
   		"else " \
   			"bootz; " \
   		"fi;\0" \
   	"netargs=setenv bootargs console=${console},${baudrate} " \
   		CONFIG_BOOTARGS_CMA_SIZE \
   		"root=/dev/nfs " \
   	"ip=dhcp nfsroot=${serverip}:${nfsroot},v3,tcp\0" \
   		"netboot=echo Booting from net ...; " \
   		"run netargs; " \
   		"if test ${ip_dyn} = yes; then " \
   			"setenv get_cmd dhcp; " \
   		"else " \
   			"setenv get_cmd tftp; " \
   		"fi; " \
   		"${get_cmd} ${image}; " \
   		"if test ${boot_fdt} = yes || test ${boot_fdt} = try; then " \
   			"if ${get_cmd} ${fdt_addr} ${fdt_file}; then " \
   				"bootz ${loadaddr} - ${fdt_addr}; " \
   			"else " \
   				"if test ${boot_fdt} = try; then " \
   					"bootz; " \
   				"else " \
   					"echo WARN: Cannot load the DT; " \
   				"fi; " \
   			"fi; " \
   		"else " \
   			"bootz; " \
   		"fi;\0" \
   		"findfdt="\
   			"if test $fdt_file = undefined; then " \
   				"if test $board_name = EVK && test $board_rev = 9X9; then " \
   					"setenv fdt_file imx6ull-9x9-evk.dtb; fi; " \
   				"if test $board_name = EVK && test $board_rev = 14X14; then " \
   					"setenv fdt_file imx6ull-14x14-evk.dtb; fi; " \
   				"if test $fdt_file = undefined; then " \
   					"echo WARNING: Could not determine dtb to use; fi; " \
   			"fi;\0" \
   ////通过条件编译来设置宏CONFIG_EXTRA_ENV_SETTINGS，CONFIG_EXTRA_ENV_SETTING，此宏会设置bootargs这个环境变量
   #define CONFIG_BOOTCOMMAND \
   	   "run findfdt;" \
   	   "mmc dev ${mmcdev};" \
   	   "mmc dev ${mmcdev}; if mmc rescan; then " \
   		   "if run loadbootscript; then " \
   			   "run bootscript; " \
   		   "else " \
   			   "if run loadimage; then " \
   				   "run mmcboot; " \
   			   "else run netboot; " \
   			   "fi; " \
   		   "fi; " \
   	   "else run netboot; fi"
   #endif
   ////设置宏CONFIG_BOOTCOMMAND，此宏会设置bootcmd的值
   /* Miscellaneous configurable options */
   #define CONFIG_CMD_MEMTEST
   #define CONFIG_SYS_MEMTEST_START	0x80000000
   #define CONFIG_SYS_MEMTEST_END		(CONFIG_SYS_MEMTEST_START + 0x8000000)
   ////设置命令memtest相关宏定义
   #define CONFIG_SYS_LOAD_ADDR		CONFIG_LOADADDR
   ////表示linux内核在DRAM中的加载地址
   #define CONFIG_SYS_HZ			1000
   ////系统时钟频率
   #define CONFIG_STACKSIZE		SZ_128K
   ////栈大小
   /* Physical Memory Map */
   #define CONFIG_NR_DRAM_BANKS		1
   ////DRAM BANK的数量，imx6ull只用到一个BANK
   #define PHYS_SDRAM			MMDC0_ARB_BASE_ADDR
   ////为DRAM的控制器MMDC0所管辖的DRAM范围起始地址
   #define CONFIG_SYS_SDRAM_BASE		PHYS_SDRAM
   ////DRAM的起始地址
   #define CONFIG_SYS_INIT_RAM_ADDR	IRAM_BASE_ADDR
   ////内部IRAM的起始地址(OCRAM)
   #define CONFIG_SYS_INIT_RAM_SIZE	IRAM_SIZE
   ////内部IRAM的大小 128KB
   #define CONFIG_SYS_INIT_SP_OFFSET \
   	(CONFIG_SYS_INIT_RAM_SIZE - GENERATED_GBL_DATA_SIZE)
   #define CONFIG_SYS_INIT_SP_ADDR \
   	(CONFIG_SYS_INIT_RAM_ADDR + CONFIG_SYS_INIT_SP_OFFSET)
   ////与初始SP有关，初始SP偏移，初始SP地址
   /* FLASH and environment organization */
   #define CONFIG_SYS_NO_FLASH
   
   #ifdef CONFIG_SYS_BOOT_QSPI
   #define CONFIG_FSL_QSPI
   #define CONFIG_ENV_IS_IN_SPI_FLASH
   #elif defined CONFIG_SYS_BOOT_NAND
   #define CONFIG_SYS_USE_NAND
   #define CONFIG_ENV_IS_IN_NAND
   #else
   #define CONFIG_FSL_QSPI
   #define CONFIG_ENV_IS_IN_MMC
   #endif
   
   #define CONFIG_SYS_MMC_ENV_DEV		1   /* USDHC2 */
   ////默认MMC设备，默认为USDHC2，也就是EMMC
   #define CONFIG_SYS_MMC_ENV_PART		0	/* user area */
   ////MMC模式分区，默认为第0个分区
   #define CONFIG_MMCROOT			"/dev/mmcblk1p2"  /* USDHC2 */
   ////设置进入linux系统的根文件系统所在的分区，"/dev/mmcblk1p2"为EMMC设备的第2个分区。
   ////第0个分区保存uboot，第1个分区保存linux镜像，第2个分区为linux系统的根文件系统
   
   #define CONFIG_CMD_BMODE
   
   #ifdef CONFIG_FSL_QSPI
   #define CONFIG_QSPI_BASE		QSPI0_BASE_ADDR
   #define CONFIG_QSPI_MEMMAP_BASE		QSPI0_AMBA_BASE
   
   #define CONFIG_CMD_SF
   #define CONFIG_SPI_FLASH
   #define CONFIG_SPI_FLASH_BAR
   #define CONFIG_SF_DEFAULT_BUS		0
   #define CONFIG_SF_DEFAULT_CS		0
   #define CONFIG_SF_DEFAULT_SPEED	40000000
   #define CONFIG_SF_DEFAULT_MODE		SPI_MODE_0
   #define CONFIG_SPI_FLASH_STMICRO
   #endif
   
   /* NAND stuff */
   ////和NAND有关的定义
   #ifdef CONFIG_SYS_USE_NAND
   #define CONFIG_CMD_NAND
   #define CONFIG_CMD_NAND_TRIMFFS
   
   #define CONFIG_NAND_MXS
   #define CONFIG_SYS_MAX_NAND_DEVICE	1
   #define CONFIG_SYS_NAND_BASE		0x40000000
   #define CONFIG_SYS_NAND_5_ADDR_CYCLE
   #define CONFIG_SYS_NAND_ONFI_DETECTION
   
   /* DMA stuff, needed for GPMI/MXS NAND support */
   #define CONFIG_APBH_DMA
   #define CONFIG_APBH_DMA_BURST
   #define CONFIG_APBH_DMA_BURST8
   #endif
   
   #define CONFIG_ENV_SIZE			SZ_8K
   ////环境变量的大小，默认为8KB
   #if defined(CONFIG_ENV_IS_IN_MMC)
   #define CONFIG_ENV_OFFSET		(12 * SZ_64K)
   ////表示环境变量偏移地址，这里是相对于存储器的首地址。
   如果保存在EMMC，偏移地址为12*64KB
   如果是SPI FLASH中，偏移地址为768*1024KB
   如果在NAND中，偏移地址为60<<20(60MB)，并且重新设置环境变量的大小为128KB
   #elif defined(CONFIG_ENV_IS_IN_SPI_FLASH)
   #define CONFIG_ENV_OFFSET		(768 * 1024)
   #define CONFIG_ENV_SECT_SIZE		(64 * 1024)
   #define CONFIG_ENV_SPI_BUS		CONFIG_SF_DEFAULT_BUS
   #define CONFIG_ENV_SPI_CS		CONFIG_SF_DEFAULT_CS
   #define CONFIG_ENV_SPI_MODE		CONFIG_SF_DEFAULT_MODE
   #define CONFIG_ENV_SPI_MAX_HZ		CONFIG_SF_DEFAULT_SPEED
   #elif defined(CONFIG_ENV_IS_IN_NAND)
   #undef CONFIG_ENV_SIZE
   #define CONFIG_ENV_OFFSET		(60 << 20)
   #define CONFIG_ENV_SECT_SIZE		(128 << 10)
   #define CONFIG_ENV_SIZE			CONFIG_ENV_SECT_SIZE
   #endif
   
   
   /* USB Configs */
   ////USB相关宏定义
   #define CONFIG_CMD_USB
   #ifdef CONFIG_CMD_USB
   #define CONFIG_USB_EHCI
   #define CONFIG_USB_EHCI_MX6
   #define CONFIG_USB_STORAGE
   #define CONFIG_EHCI_HCD_INIT_AFTER_RESET
   #define CONFIG_USB_HOST_ETHER
   #define CONFIG_USB_ETHER_ASIX
   #define CONFIG_MXC_USB_PORTSC  (PORT_PTS_UTMI | PORT_PTS_PTW)
   #define CONFIG_MXC_USB_FLAGS   0
   #define CONFIG_USB_MAX_CONTROLLER_COUNT 2
   #endif
   
   ////网络相关宏定义
   #ifdef CONFIG_CMD_NET
   #define CONFIG_CMD_PING
   #define CONFIG_CMD_DHCP
   #define CONFIG_CMD_MII
   #define CONFIG_FEC_MXC
   #define CONFIG_MII
   #define CONFIG_FEC_ENET_DEV		1
   ////指定使能网口0表示使能ENET1，1表示使能ENET2
   #if (CONFIG_FEC_ENET_DEV == 0)
   #define IMX_FEC_BASE			ENET_BASE_ADDR
   #define CONFIG_FEC_MXC_PHYADDR          0x2
   #define CONFIG_FEC_XCV_TYPE             RMII
   #elif (CONFIG_FEC_ENET_DEV == 1)
   #define IMX_FEC_BASE			ENET2_BASE_ADDR
   #define CONFIG_FEC_MXC_PHYADDR		0x1
   #define CONFIG_FEC_XCV_TYPE		RMII
   #endif
   #define CONFIG_ETHPRIME			"FEC"
   
   #define CONFIG_PHYLIB
   #define CONFIG_PHY_MICREL
   #endif
   
   #define CONFIG_IMX_THERMAL
   
   #ifndef CONFIG_SPL_BUILD
   #define CONFIG_VIDEO
   #ifdef CONFIG_VIDEO
   #define CONFIG_CFB_CONSOLE
   #define CONFIG_VIDEO_MXS
   #define CONFIG_VIDEO_LOGO
   #define CONFIG_VIDEO_SW_CURSOR
   #define CONFIG_VGA_AS_SINGLE_DEVICE
   #define CONFIG_SYS_CONSOLE_IS_IN_ENV
   #define CONFIG_SPLASH_SCREEN
   #define CONFIG_SPLASH_SCREEN_ALIGN
   #define CONFIG_CMD_BMP
   #define CONFIG_BMP_16BPP
   #define CONFIG_VIDEO_BMP_RLE8
   #define CONFIG_VIDEO_BMP_LOGO
   #define CONFIG_IMX_VIDEO_SKIP
   #endif
   #endif
   
   #define CONFIG_IOMUX_LPSR
   
   #if defined(CONFIG_ANDROID_SUPPORT)
   #include "mx6ullevk_android.h"
   #endif
   
   #endif
   ```

3. 添加开发板对应的板级文件夹
   在board/freescale目录下创建mx6ull_alientek_emmc文件夹，复制官方 mx6ullevk 文件夹

   + 修改makefile
     ```makefile
     # (C) Copyright 2015 Freescale Semiconductor, Inc.
     #
     # SPDX-License-Identifier:	GPL-2.0+
     #
     
     obj-y  := mx6ull_alientek_emmc.o
     
     extra-$(CONFIG_USE_PLUGIN) :=  plugin.bin
     $(obj)/plugin.bin: $(obj)/plugin.o
     	$(OBJCOPY) -O binary --gap-fill 0xff $< $@
     ```

   + 修改mx6ull_alientek_emmc下的imximage.cfg的内容
     ```less
     #ifdef CONFIG_USE_PLUGIN
     /*PLUGIN    plugin-binary-file    IRAM_FREE_START_ADDR*/
     PLUGIN	board/freescale/mx6ull_alientek_emmc/plugin.bin 0x00907000
     #else
     ```

   + 修改mx6ull_alientek_emmc 目录下的Kconfig文件
     ```less
     if TARGET_MX6ULL_14X14_EVK || TARGET_MX6ULL_9X9_EVK
     
     config SYS_BOARD
     	default "mx6ull_alientek_emmc"
     
     config SYS_VENDOR
     	default "freescale"
     
     config SYS_SOC
     	default "mx6"
     
     config SYS_CONFIG_NAME
     	default "mx6ull_alientek_emmc"
     
     endif
     ```

   + 修改mx6ull_alientek_emmc目录下的MAINTAINERS文件
     ```less
     MX6ULLEVK BOARD
     M:	Peng Fan <peng.fan@nxp.com>
     S:	Maintained
     F:	board/freescale/mx6ull_alientek_emmc/
     F:	include/configs/mx6ull_alientek_emmc.h
     F:	configs/mx6ull_14x14_evk_defconfig
     F:	configs/mx6ull_9x9_evk_defconfig
     ```

4. 修改uboot的图形界面配置文件
   在arch/arm/cpu/armv7/mx6/Kconfig  207行添加内容

   ```less
   config TARGET_MX6ULL_ALIENTEK_EMMC
   	bool "Support mx6ull_alientek_emmc"
   	select MX6ULL
   	select DM
   	select DM_THERMAL
   ```

   在最后一行endif添加内容

   ```less
   source "board/freescale/mx6ull_alientek_emmc/Kconfig"
   ```

5. LCD驱动修改
   因为默认的LCD驱动是4英寸的需要修改成7英寸的LCD

   + 一般uboot中修改驱动都是在xxx.c和xxx.h中进行，xxx为板子名称

     > 1. LCD所使用的GPIO，查看uboot中的LCD的IO配置是否争取
     > 2. LCD背光引脚GPIO配置
     > 3. LCD配置参数是否正确

   

6. 使用新添加的板配置编译uboot

   + 在根目录下新建一个shell脚本

   ```shell
   #!/bin/bash
   make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- distclean
   make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- mx6ull_alientek_emmc_defconfig
   make V=1 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j16
   ```

   + 运行脚本进行编译
     ```less
     编译之后使用grep -nR "mx6ull_alientek_emmc.h"命令检查自己定义的头文件是否被引用，如果很多文件都引用了这个头文件，说明自定义的板子信息添加成功
     ```

   + 使用imxdownloa将新编译出来的uboot.bin烧写到sd卡中进行测试








