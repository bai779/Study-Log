# Linux磁盘管理

## 1. 查看磁盘信息

### `lsblk` - 列出块设备信息

**参数**：

- `-a`：显示所有设备（包括空设备）。
- `-f`：显示文件系统类型。
- `-p`：显示完整设备路径。
- `-o`：指定输出列（如 `NAME,SIZE,FSTYPE`）。

**示例**：

```bash
lsblk -f
# 输出：
# NAME   FSTYPE LABEL UUID                                 MOUNTPOINT
# sda                                                  
# ├─sda1 ext4         c4d5e8d0...                         /
# └─sda2 xfs          8a3b1c2d...                         /data
```

### `df` - 显示磁盘空间使用情况

**参数**：

- `-h`：以人类可读格式显示（如 GB/MB）。
- `-T`：显示文件系统类型。
- `-i`：显示 inode 使用情况。

**示例**：

```bash
df -hT
# 输出：
# Filesystem     Type      Size  Used Avail Use% Mounted on
# /dev/sda1      ext4       50G   20G   28G  42% /
```

### `du` - 查看目录/文件磁盘使用

**参数**：

- `-s`：仅显示总大小。
- `-h`：人类可读格式。
- `--max-depth=N`：限制目录层级深度。

**示例**：

```bash
du -sh /var/log
# 输出：
# 1.2G    /var/log
```

## 2. 磁盘分区工具

### `fdisk` - 分区管理工具

**常用命令**（交互模式）：

- `n`：创建新分区。
- `d`：删除分区。
- `p`：打印分区表。
- `w`：保存并退出。
- `q`：退出不保存。

**示例**：

```bash
sudo fdisk /dev/sdb
# 进入交互模式后输入 `n` → 设置分区大小 → `w` 保存
```

### `parted` - 高级分区工具

**常用命令**：

- `mkpart [PART-TYPE] [FS-TYPE] START END`：创建分区。
- `rm [PARTITION]`：删除分区。
- `print`：显示分区表。

**示例**：

```bash
sudo parted /dev/sdb
(parted) mkpart primary ext4 0% 50%
(parted) print
```

## 3. 格式化与文件系统

### `mkfs` - 格式化分区

**格式**：

```bash
mkfs.<FSTYPE> [OPTIONS] DEVICE
```

**常用类型**：

- `mkfs.ext4`：格式化为 ext4。
- `mkfs.xfs`：格式化为 XFS。
- `mkfs.ntfs`：格式化为 NTFS。

**参数**：

- `-L`：设置卷标。
- `-b`：指定块大小（如 `-b 4096`）。

**示例**：

```bash
sudo mkfs.ext4 -L "DATA" /dev/sdb1
```

### `mkswap` - 创建交换分区

**示例**：

```bash
sudo mkswap /dev/sdb2
sudo swapon /dev/sdb2   # 启用交换分区
sudo swapoff /dev/sdb2  # 关闭交换分区
```

## 4. 挂载与卸载

### `mount` - 挂载文件系统

**参数**：

- `-t`：指定文件系统类型（如 `ext4`）。
- `-o`：挂载选项（如 `ro` 只读，`remount` 重新挂载）。

**示例**：

```bash
sudo mount -t ext4 /dev/sdb1 /mnt/data
sudo mount -o remount,rw /dev/sdb1  # 重新挂载为读写
```

### `umount` - 卸载文件系统

**参数**：

- `-l`：延迟卸载（Lazy unmount）。
- `-f`：强制卸载。

**示例**：

```bash
sudo umount /mnt/data
```

## 5. 磁盘检查与修复

### `fsck` - 文件系统检查

**参数**：

- `-y`：自动修复错误。
- `-C`：显示进度条（仅 ext2/3/4）。

**示例**：

```bash
sudo fsck -y /dev/sdb1
```

### `badblocks` - 检测磁盘坏块

**参数**：

- `-v`：显示详细信息。
- `-n`：非破坏性测试（不写入数据）。
- `-w`：破坏性测试（写入数据）。

**示例**：

```bash
sudo badblocks -v /dev/sdb
```

## 6. LVM 逻辑卷管理

### 物理卷（PV）操作

```bash
pvcreate /dev/sdb1       # 创建物理卷
pvdisplay               # 显示物理卷信息
pvmove /dev/sdb1        # 迁移物理卷数据
```

### 卷组（VG）操作

```bash
vgcreate vg_data /dev/sdb1   # 创建卷组
vgextend vg_data /dev/sdc1   # 扩展卷组
vgreduce vg_data /dev/sdb1   # 移除物理卷
```

### 逻辑卷（LV）操作

```bash
lvcreate -L 50G -n lv_data vg_data   # 创建逻辑卷
lvextend -L +10G /dev/vg_data/lv_data  # 扩展逻辑卷大小
resize2fs /dev/vg_data/lv_data         # 调整文件系统大小（ext4）
xfs_growfs /dev/vg_data/lv_data        # 调整文件系统大小（XFS）
```

## 7. 其他重要命令

### `dd` - 磁盘复制与备份

**参数**：

- `if`：输入文件（如 `/dev/sda`）。
- `of`：输出文件（如 `backup.img`）。
- `bs`：块大小（如 `4M`）。
- `status=progress`：显示进度。

**示例**：

```
dd if=/dev/sda of=disk_backup.img bs=4M status=progress
```

### `blkid` - 查看块设备 UUID

**示例**：

```bash
blkid /dev/sdb1
# 输出：
# /dev/sdb1: UUID="c4d5e8d0..." TYPE="ext4"
```

### `hdparm` - 磁盘性能测试

**参数**：

- `-T`：缓存读取速度测试。
- `-t`：磁盘读取速度测试。

**示例**：

```bash
sudo hdparm -Tt /dev/sda
```

+++++++

## 总结表

| 类别       | 命令        | 核心功能             | 常用参数/选项             |
| ---------- | ----------- | -------------------- | ------------------------- |
| 查看信息   | `lsblk`     | 列出块设备树         | `-f`, `-p`, `-o`          |
|            | `df`        | 磁盘使用统计         | `-h`, `-T`, `-i`          |
|            | `du`        | 目录占用空间         | `-s`, `-h`, `--max-depth` |
| 分区管理   | `fdisk`     | 交互式分区工具       | `n`, `d`, `p`, `w`        |
|            | `parted`    | 支持大磁盘的分区工具 | `mkpart`, `rm`, `print`   |
| 格式化     | `mkfs`      | 创建文件系统         | `-L`, `-t`                |
|            | `mkswap`    | 创建交换分区         | 无                        |
| 挂载/卸载  | `mount`     | 挂载设备             | `-t`, `-o`                |
|            | `umount`    | 卸载设备             | `-l`, `-f`                |
| 检查与修复 | `fsck`      | 文件系统检查修复     | `-y`, `-C`                |
|            | `badblocks` | 检测坏块             | `-v`, `-n`                |
| LVM 管理   | `pvcreate`  | 初始化物理卷         | 无                        |
|            | `vgcreate`  | 创建卷组             | 无                        |
|            | `lvcreate`  | 创建逻辑卷           | `-L`, `-n`                |
| 高级工具   | `dd`        | 磁盘复制与备份       | `if`, `of`, `bs`          |
|            | `blkid`     | 显示块设备 UUID      | 无                        |
|            | `hdparm`    | 磁盘性能测试         | `-T`, `-t`                |
