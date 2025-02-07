# Linux虚拟化

## KVM

+ Kernel-based Virtual Machine
+ 一个基于Linux内核的虚拟化解决方案，它允许用户在Linux操作系统上运行虚拟机。KVM是一种 **硬件虚拟化** 方案，依赖于现代处理器的硬件虚拟化扩展(intel VT-x和AMD-V)来提高虚拟化性能。

### 概念

+ KVM实际上是一个Linux内核模块，它提供了硬件虚拟化支持。它允许Linux内核成为一个Hypervisor（虚拟机监控器），并能够运行多个虚拟机，每个虚拟机都具有自己的虚拟硬件（cpu，内存，硬盘和网络接口）。
+ KVM内核模块的名称是`kvm.ko`，并且根据CPU类型，还会加载不同的子模块，如`kvm-intel.ko`（用于intel处理器）或`kvm-amd.ko`（用于AMD处理器）。
+ KVM支持硬件虚拟化（VT-x或AMD-V），能够为每个虚拟机提供虚拟的硬件资源。当CPU支持虚拟化时，KVM会利用这一硬件支持来提高虚拟机性能，减少虚拟化开销

### 特点

+ 高性能：KVM利用硬件虚拟化支持，提供接近裸机的性能
+ 资源隔离：每个虚拟机都有自己的独立内存，硬盘和cpu，且操作系统相互隔离
+ 广泛支持操作系统

+++++++++++++

## QEMU

+ Quick EMUlator

+ 开源的虚拟化工具，支持多种架构。能够在软件中模拟硬件设备，也可以在支持硬件虚拟化的机器上高效地运行虚拟机。QEMU可以作为虚拟化的基础，执行虚拟机操作。可以和 KVM 配合使用，提供虚拟化加速。

### 工作原理

+ 模块和虚拟化：QEMU本身可以作为一个完全的软件模拟器，模拟不用的硬件架构（ARM，X86等），会受到性能的限制
+ 与KVM配合使用：QEMU负责提供虚拟机的硬件模拟，而KVM则提供硬件加速，直接使用CPU的虚拟化扩展。通过这种方式，共同实现了高性能的虚拟化。
+ 虚拟化和仿真：QEMU可以同时进行虚拟化和仿真。虚拟化指利用硬件扩展提供高效虚拟机支持，仿真则是完全模拟硬件的过程，允许在不支持硬件虚拟化的系统上运行

### 特点

+ 跨平台
+ 灵活性：QEMU 允许对虚拟机硬件进行高度配置和自定义，如虚拟 CPU、内存、磁盘等资源。
+ 与KVM配置提高性能

++++++++++++++

## Libvirt

+ 是一个开源的虚拟化管理工具库，提供了一个抽象层，使得用户能够通过统一的API来管理虚拟化平台。Libvirt可以管理多个虚拟化技术，包括KVM，Xen，LXC等。

### 工作原理

+ **API 和工具**：Libvirt 提供了 C 库 API，以及多种命令行工具（如 `virsh`）和图形化管理工具
+ **虚拟机管理**：Libvirt 管理虚拟机的生命周期，包括创建、删除、启动、停止、暂停、恢复虚拟机等操作。
+ **资源管理**：Libvirt 允许管理虚拟机的硬件资源，如 CPU、内存、存储和网络配置。它可以简化不同虚拟化技术的配置和管理。

### 特点

+ **统一接口**：Libvirt 提供了统一的接口来管理不同虚拟化平台，如 KVM、Xen、LXC 等。
+ **虚拟机的生命周期管理**：通过 Libvirt，可以管理虚拟机的所有生命周期操作。
+ **支持多种虚拟化后端**：Libvirt 支持多种虚拟化技术，可以同时管理不同虚拟化平台中的虚拟机。

++++++++++

## Virt-Manager

+ **Virt-Manager** 是一个图形化工具，用于管理虚拟机和虚拟化资源。它基于 Libvirt 提供的 API，允许用户通过 GUI 方便地创建、配置和管理虚拟机。

### 工作原理

+ **图形化管理**：Virt-Manager 提供了一个直观的图形界面，用户可以通过它方便地进行虚拟机的创建、配置、启动、停止、监控等操作。
+ **基于 Libvirt**：Virt-Manager 通过 Libvirt 与 KVM 等虚拟化技术交互，它利用 Libvirt 提供的接口来执行虚拟机管理任务。

### 特点

+ **简洁易用**：Virt-Manager 提供了图形界面，用户无需通过命令行即可轻松管理虚拟机。
+ **支持多种虚拟化技术**：Virt-Manager 支持 KVM、Xen 和其他虚拟化技术。
+ **实时监控**：Virt-Manager 可以实时显示虚拟机的性能数据，如 CPU、内存使用情况，以及磁盘和网络负载。

++++++++++

## 关联

+ **QEMU** 是核心的虚拟化组件，它负责模拟虚拟机的硬件。QEMU 本身可以进行完全的软件虚拟化，但在支持硬件虚拟化的系统上，通常与 **KVM** 配合使用，提供高效的虚拟化性能。
+ **KVM** 是 Linux 内核的虚拟化模块，负责提供硬件加速的虚拟化支持。它依赖 QEMU 来模拟硬件和管理虚拟机的运行。KVM 和 QEMU 配合使用时，KVM 提供硬件加速，QEMU 提供虚拟机的硬件模拟。
+ **Libvirt** 是虚拟化管理的工具库，它为虚拟化技术提供统一的管理接口，简化了虚拟机管理。Libvirt 可以管理不同虚拟化平台的虚拟机（如 KVM、Xen、LXC 等），它是 QEMU 和 KVM 的管理工具。
+ **Virt-Manager** 是基于 Libvirt 提供的 API 的图形化管理工具，它通过图形化界面为用户提供了易用的虚拟机管理功能。

+++

## 常用命令libvirt

### 1.安装libvirt组件

```less
# Ubuntu/Debian
sudo apt install libvirt-daemon-system libvirt-clients qemu-kvm virt-manager virt-install

# CentOS/RHEL
sudo yum install libvirt libvirt-client qemu-kvm virt-install
```

### 2.启动libvirt服务

```less
sudo systemctl start libvirtd    # 启动服务
sudo systemctl enable libvirtd   # 开机自启
sudo usermod -aG libvirt $USER   # 将当前用户加入 libvirt 组（避免频繁使用 sudo）
newgrp libvirt                   # 刷新用户组
```

### 3.创建虚拟机

+ 使用**virt-install**快速创建

```less
virt-install \
  --name=myvm \                  # 虚拟机名称
  --ram=2048 \                   # 内存（MB）
  --vcpus=2 \                    # 虚拟 CPU 数量
  --disk path=/var/lib/libvirt/images/myvm.qcow2,size=10 \  # 磁盘路径和大小（GB）
  --os-type=linux \              # 操作系统类型
  --os-variant=ubuntu22.04 \     # 系统变体（可选，通过 `osinfo-query os` 查看支持列表）
  --network network=default \    # 使用默认 NAT 网络
  --graphics spice \             # 图形协议（spice/vnc）
  --cdrom=/path/to/ubuntu-22.04.iso  # 安装镜像路径
```

+ 使用XML文件定义虚拟机

  + 生成XML配置文件

    ```xml
    <domain type='kvm'>
      <name>myvm</name>
      <memory unit='KiB'>2097152</memory>  <!-- 2GB 内存 -->
      <vcpu placement='static'>2</vcpu>
      <os>
        <type arch='x86_64' machine='q35'>hvm</type>
        <boot dev='cdrom'/>     <!-- 首次启动从光盘引导 -->
        <boot dev='hd'/>        <!-- 后续从硬盘启动 -->
      </os>
      <devices>
        <disk type='file' device='cdrom'>
          <driver name='qemu' type='raw'/>
          <source file='/path/to/ubuntu-22.04.iso'/>
          <target dev='sda' bus='sata'/>
          <readonly/>
        </disk>
        <disk type='file' device='disk'>
          <driver name='qemu' type='qcow2'/>
          <source file='/var/lib/libvirt/images/myvm.qcow2'/>
          <target dev='vda' bus='virtio'/>
        </disk>
        <interface type='network'>
          <source network='default'/>
          <model type='virtio'/>
        </interface>
        <graphics type='spice' autoport='yes'/>
      </devices>
    </domain>
    ```

  + 创建并启动虚拟机

    ```less
    virsh define myvm.xml    # 定义虚拟机配置
    virsh start myvm         # 启动虚拟机
    ```

### 4.控制虚拟机生命周期

+ 启动和关闭

  ```bash
  virsh start myvm #启动虚拟机
  virsh shutdown myvm #正常关机（需虚拟机内ACPI支持）
  virsh destroy myvm #强制断电
  virsh reboot myvm #重启
  ```

+ 暂停与恢复

  ```bash
  virsh suspend myvm #暂停虚拟机
  virsh resume myvm #恢复运行
  ```

+ 自启动管理

  ```bash
  virsh autostart myvm #开机自启
  virsh autostart --disable myvm 
  ```

### 5.虚拟机配置管理

+ 查看你虚拟机信息
  ```bash
  virsh list -all #列出所有虚拟机（状态）
  virsh dominfo myvm #查看基本信息（CPU、内存等）
  virsh domifaddr myvm #查看虚拟机ip
  virsh dumpxml myvm #到处虚拟机xml配置
  ```

+ 修改配置
  ```bash
  virsh edit myvm #编辑虚拟机XML配置（保存后自动生效）
  virsh setmem myvm 4096M --live #动态调整内存
  virsh setvcpus myvm4 --live #动态调整CPU数量
  ```

### 6.磁盘与网络管理

+ 添加磁盘

  + 创建新磁盘镜像
    ```less
    qemu-img create -f qcow2 /path/to/new_disk.qcow2 20G
    ```

  + 编辑虚拟机XML配置
    ```less
    <disk type='file' device='disk'>
      <driver name='qemu' type='qcow2'/>
      <source file='/path/to/new_disk.qcow2'/>
      <target dev='vdb' bus='virtio'/>
    </disk>
    ```

  + 重新加载配置
    ```less
    virsh define myvm.xml
    virsh reboot myvm    # 或热插拔（需额外步骤）
    ```

+ 管理虚拟网络
  ```less
  virsh net-list --all           # 列出所有网络
  virsh net-info default         # 查看默认网络信息
  virsh net-edit default         # 编辑网络配置
  virsh net-start default        # 启动网络
  virsh net-destroy default      # 停止网络
  ```

### 7.销毁虚拟机

+ 删除虚拟机配置
  ```less
  virsh shutdown myvm           # 先关闭虚拟机（若在运行）
  virsh undefine myvm           # 删除虚拟机配置（保留磁盘文件）
  virsh undefine --storage myvm # 同时删除关联的磁盘文件（谨慎操作！）
  ```

+ 手动清理磁盘
  ```less
  rm -f /var/lib/libvirt/images/myvm.qcow2  # 删除磁盘文件
  ```

### 8.其他命令

+ 控制台访问
  ```less
  virsh console myvm #连接控制台
  ```

+ 克隆虚拟机
  ```less
  virt-clone --original myvm  --name myvm_clone --file /path/to/clone_disk.qcow2
  ```

+ 快照管理
  ```less
  virsh snapshot-create-as myvm --name snap1   # 创建快照
  virsh snapshot-list myvm                     # 列出快照
  virsh snapshot-revert myvm --snapshot snap1  # 恢复快照
  ```

  


