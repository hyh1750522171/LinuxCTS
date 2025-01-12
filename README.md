# LinuxCTS - Linux 综合测试脚本

## 项目简介

LinuxCTS 是一个用于 Linux 系统的综合测试脚本，旨在帮助用户快速、方便地对 Linux 系统进行多方面的测试，以评估系统的性能、配置和功能完整性。该脚本整合了一系列实用的测试功能，能够满足不同场景下对 Linux 系统的检测需求。

## 功能特性

- **系统信息检测**：全面展示 Linux 系统的基本信息，包括内核版本、操作系统发行版、CPU 信息、内存信息等，让用户对系统硬件和软件配置一目了然。
- **性能测试**：具备多种性能测试功能，如 CPU 性能测试、内存读写速度测试、磁盘 I/O 性能测试等，帮助用户评估系统在不同负载下的性能表现。
- **网络测试**：可以检测网络连接状态、网络速度测试、端口扫描等，方便用户排查网络相关问题，确保网络配置正确且稳定。
- **服务状态检查**：检查常见系统服务（如 SSH、HTTP、FTP 等）的运行状态，确保服务正常运行，保障系统的可用性。

## 安装与使用

## 依赖

```bash
# ubuntu/debian
sudo apt update && sudo apt install curl -y && sudo su
# readhat/centos
sudo yum update && sudo yum install curl -y && sudo su
```

### 一键脚本 （临时使用）

```bash
source <(curl -s https://gitee.com/muaimingjun/LinuxCTS/raw/main/linux.sh)
```

## 安装到系统里

```bash
# 如何安装？
sudo curl -L https://gitee.com/muaimingjun/LinuxCTS/raw/main/linux.sh > /usr/bin/linux && sudo chmod +x /usr/bin/linux
# 如何使用
linux
# 如何更新？
sudo curl -L https://gitee.com/muaimingjun/LinuxCTS/raw/main/linux.sh > /usr/bin/linux && sudo chmod +x /usr/bin/linux
# 如何卸载
sudo rm -rf /usr/bin/linux
```

## 项目结构

- **`app/`**：可能存放与应用程序相关的测试脚本或配置文件（具体功能可能因项目而异）。
- **`os/`**：用于存放与操作系统相关的测试模块，例如系统信息获取、系统服务检测等功能的实现代码。
- **`tools/`**：包含一些辅助工具或脚本，用于支持主脚本的功能实现，如性能测试工具、网络测试工具等。
- **`.gitignore`**：指定了哪些文件或目录不需要被 Git 版本控制系统跟踪，例如临时文件、编译生成的文件等。
- **`README.md`**：项目的说明文档，即你正在阅读的此文件，用于向用户介绍项目的功能、安装使用方法等信息。
- **`linux.sh`**：主脚本文件，整合了各种测试功能，是整个项目的核心执行文件。

## 贡献指南

1. 欢迎大家对本项目进行贡献！如果你有任何改进建议或新功能想法，请先 Fork 本项目到你的 GitHub 账号。
2. 创建一个新的分支，分支命名建议遵循`feature/你的功能名称`或`bugfix/你的bug修复名称`的格式，以便清晰区分不同类型的贡献。
3. 在新分支上进行代码修改和开发，确保你的代码符合项目的代码风格和规范。
4. 提交你的修改时，请提供清晰明了的提交信息，描述修改的内容和目的。
5. 将你的分支推送到你的 GitHub 仓库，然后发起一个 Pull Request 到本项目的主仓库，详细说明你的修改内容和期望的合并原因，等待项目维护者进行审核和合并。

## 许可证

本项目遵循开源协议，具体许可证信息可查看项目中的 LICENSE 文件

## 联系我们

如果你在使用过程中遇到问题或有任何建议，欢迎通过以下方式联系我们：

- **项目原作者**：[muaimingjun](https://gitee.com/muaimingjun)
- **致谢作者**：[xccado](https://github.com/xccado/LinuxCTS)

感谢你使用 LinuxCTS！希望这个脚本能够帮助你更好地管理和优化你的 Linux 系统。如果你发现任何问题或有改进的想法，请随时贡献你的力量。