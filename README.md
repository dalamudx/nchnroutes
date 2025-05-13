# 🌐 nchnroutes

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/dalamudx/nchnroutes/autoupdate.yml?label=Auto%20Update&logo=github)
![GitHub Release](https://img.shields.io/github/v/release/dalamudx/nchnroutes?label=Latest%20Release)

该项目fork自[dndx/nchnroutes](https://github.com/dndx/nchnroutes)
> 生成非中国大陆来源的路由表，以BIRD静态路由格式输出

## 📋 概述

nchnroutes与chnroutes类似，但它生成的是**非**来自中国大陆的路由表，并以BIRD静态路由格式输出结果。这对于需要对国内外流量进行分流的网络环境非常有用。

### ✨ 特点

- 同时支持IPv4和IPv6
- 自动从APNIC和ipip.net获取最新的中国IP列表
- 生成BIRD路由器兼容的配置文件
- 通过GitHub Actions自动每日更新，增加PASS_IPS环境变量用以动态控制排除的IP
- 无需额外依赖，仅需Python 3

### 📊 路由表规模

截至2023年，生成的路由表大小约为：
- IPv4：11000-12000条记录（取决于使用的IP列表）
- IPv6：约14000条记录

在Raspberry Pi 4上运行BIRD，通过OSPF与运行RouterOS的Mikrotik hEX进行完全加载和收敛，大约需要5秒。

## 🚀 快速开始

### 获取预生成的路由表

最简单的方法是直接从GitHub Releases下载最新的预生成路由表：

1. 访问[Releases页面](https://github.com/dalamudx/nchnroutes/releases/tag/latest)
2. 下载`routes4.conf`（IPv4路由）和`routes6.conf`（IPv6路由）
3. 将这些文件导入到您的BIRD配置中

路由表每天自动更新，确保您始终使用最新的IP数据。

### 手动生成路由表

如果您需要自定义路由表，可以手动运行脚本：

```bash
# 克隆仓库
git clone https://github.com/dalamudx/nchnroutes.git
cd nchnroutes

# 运行生成脚本
python3 produce.py --next your_tunnel_interface
```

#### 命令行选项

```
usage: produce.py [-h] [--exclude [CIDR [CIDR ...]]] [--next INTERFACE OR IP]
                  [--ipv4-list [{apnic,ipip} [{apnic,ipip} ...]]]

Generate non-China routes for BIRD.

optional arguments:
  -h, --help            显示帮助信息并退出
  --exclude [CIDR [CIDR ...]]
                        要排除的IPv4范围（CIDR格式）
  --next INTERFACE OR IP
                        非中国IP地址的下一跳，通常是隧道接口
  --ipv4-list [{apnic,ipip} [{apnic,ipip} ...]]
                        用于减去中国IP的IPv4列表，可以同时使用多个列表
                        （默认：apnic ipip）
```

#### 指定中国IPv4列表

您可以使用`--ipv4-list`参数指定要使用的中国IPv4列表：

* `python3 produce.py --ipv4-list ipip` - 仅使用[ipip.net的列表](https://github.com/17mon/china_ip_list)
* `python3 produce.py --ipv4-list apnic` - 仅使用[APNIC的列表](https://ftp.apnic.net/stats/apnic/delegated-apnic-latest)
* `python3 produce.py --ipv4-list apnic ipip` - 同时使用两个列表（**默认**）

## ⏱️ 自动化选项

### 使用GitHub Actions（推荐）

本项目配置了GitHub Actions工作流，可以：
- 每天自动更新路由表
- 将生成的路由表发布到GitHub Releases
- 保留历史版本，同时提供"latest"标签以便访问最新版本

您可以通过以下方式触发工作流：
- 自动：每天凌晨2点UTC
- 手动：通过GitHub Actions界面
- 互动：当有人为仓库加星标时
- 代码更新：当主分支上的关键文件发生变更时

### 使用本地Cron作业

如果您想在本地自动运行，可以编辑`Makefile`并取消注释末尾的BIRD重载代码，然后：

```bash
sudo crontab -e
```

添加`0 0 * * 0 make -C /path/to/nchnroutes`到文件中。

这将在每周日午夜重新生成路由表并重新加载BIRD。