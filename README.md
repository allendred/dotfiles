# Dotfiles

[English](#english) | [中文](#中文)

<a id="english"></a>
## English

A collection of dotfiles to help you quickly set up a familiar development environment on a new machine.

### Features

- Automatic installation and configuration of Oh My Zsh and its plugins
- Vim/Neovim editor configuration
- Git configuration
- Terminal tools setup (kitty, yazi, etc.)
- Automatic installation of common software (via Homebrew)
- Window management tools configuration (Hammerspoon, Karabiner)

### Installation

```bash
# Clone the repository
git clone https://github.com/allendred/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run the installation script
./install
```

### Main Configuration Files

- `zshrc`: Zsh configuration
- `vimrc`: Vim configuration
- `gitconfig`: Git configuration
- `nvim/`: Neovim configuration
- `hammerspoon/`: Hammerspoon configuration
- `karabiner/`: Karabiner configuration

### Homebrew Package Management

This repository includes scripts for installing and managing Homebrew packages:

- `brew/0.install.sh` - Script to install Homebrew
- `brew/1.brewInstallApps.sh` - Script to install applications from configuration files
- `brew/brew-both.txt` - List of packages to install on all systems
- `brew/brew-mac.txt` - List of packages to install only on macOS
- `brew/brew-linux.txt` - List of packages to install only on Linux

#### Installing Applications

Serial installation (default):

```bash
./brew/1.brewInstallApps.sh
```

Parallel installation (faster but may have more errors):

```bash
./brew/1.brewInstallApps.sh --parallel
```

### Customization

- Host-specific configurations can be added to the `zsh/hosts/` directory
- Aliases can be defined in `zsh/aliases.sh`

### Updating

```bash
cd ~/.dotfiles
./update.sh
```

---

<a id="中文"></a>
## 中文

这是一个用于管理各种配置文件的dotfiles仓库，帮助你在新环境中快速设置熟悉的开发环境。

### 功能

- 自动安装和配置Oh My Zsh及其插件
- 配置Vim/Neovim编辑器
- 设置Git配置
- 配置终端工具(kitty, yazi等)
- 自动安装常用软件(通过Homebrew)
- 配置窗口管理工具(Hammerspoon, Karabiner)

### 安装

```bash
# 克隆仓库
git clone https://github.com/allendred/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 运行安装脚本
./install
```

### 主要配置文件

- `zshrc`: Zsh配置
- `vimrc`: Vim配置
- `gitconfig`: Git配置
- `nvim/`: Neovim配置
- `hammerspoon/`: Hammerspoon配置
- `karabiner/`: Karabiner配置

### Homebrew包管理

本仓库包含用于安装和管理Homebrew包的脚本：

- `brew/0.install.sh` - 安装Homebrew的脚本
- `brew/1.brewInstallApps.sh` - 从配置文件安装应用程序的脚本
- `brew/brew-both.txt` - 在所有系统上都要安装的包列表
- `brew/brew-mac.txt` - 仅在macOS上安装的包列表
- `brew/brew-linux.txt` - 仅在Linux上安装的包列表

#### 安装应用程序

串行安装（默认）：

```bash
./brew/1.brewInstallApps.sh
```

并行安装（更快但可能会有更多错误）：

```bash
./brew/1.brewInstallApps.sh --parallel
```

### 自定义

- 主机特定配置可以添加到`zsh/hosts/`目录
- 别名可以在`zsh/aliases.sh`中定义

### 更新

```bash
cd ~/.dotfiles
./update.sh
```
