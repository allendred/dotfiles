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
./scripts/install
```

### Main Configuration Files

All configuration files are located in the `config/` directory.

- `config/zsh/zshrc`: Zsh configuration
- `config/vim/vimrc`: Vim configuration
- `config/git/gitconfig`: Git configuration
- `config/nvim/`: Neovim configuration
- `config/hammerspoon/`: Hammerspoon configuration
- `config/karabiner/`: Karabiner configuration

### Homebrew Package Management

This repository includes scripts for installing and managing Homebrew packages, located under `config/brew/`.

- `config/brew/0.install.sh` - Script to install Homebrew
- `config/brew/1.brewInstallApps.sh` - Script to install applications from configuration files
- `config/brew/brew-both.txt` - List of packages to install on all systems
- `config/brew/brew-mac.txt` - List of packages to install only on macOS
- `config/brew/brew-linux.txt` - List of packages to install only on Linux

#### Installing Applications

Serial installation (default):

```bash
./config/brew/1.brewInstallApps.sh
```

Parallel installation (faster but may have more errors):

```bash
./config/brew/1.brewInstallApps.sh --parallel
```

### Customization

- Host-specific configurations can be added to the `config/zsh/hosts/` directory
- Aliases can be defined in `config/zsh/aliases.sh`

### Updating

```bash
cd ~/.dotfiles
./scripts/update.sh
```

### Structure Optimization & Best Practices

This repository incorporates several best practices to enhance security, robustness, and maintainability.

- **Modular `zsh` Configuration**: The main `~/.zshrc` acts as a simple loader for modules located in `config/zsh/modules/`. This keeps the configuration clean and easy to manage.
- **Secrets Management**: A mechanism for managing sensitive information (like API keys and tokens) is in place. Local secrets should be stored in the `~/.local_secrets` file, which is automatically loaded on shell startup but is ignored by Git. You can start by copying the provided `.local_secrets.example` file.
- **Script Linting**: All key shell scripts have been analyzed and improved using `shellcheck` to prevent common errors and enhance reliability.

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
./scripts/install
```

### 主要配置文件

所有配置文件都位于 `config/` 目录下。

- `config/zsh/zshrc`: Zsh配置
- `config/vim/vimrc`: Vim配置
- `config/git/gitconfig`: Git配置
- `config/nvim/`: Neovim配置
- `config/hammerspoon/`: Hammerspoon配置
- `config/karabiner/`: Karabiner配置

### Homebrew包管理

本仓库包含用于安装和管理Homebrew包的脚本，位于 `config/brew/` 目录下。

- `config/brew/0.install.sh` - 安装Homebrew的脚本
- `config/brew/1.brewInstallApps.sh` - 从配置文件安装应用程序的脚本
- `config/brew/brew-both.txt` - 在所有系统上都要安装的包列表
- `config/brew/brew-mac.txt` - 仅在macOS上安装的包列表
- `config/brew/brew-linux.txt` - 仅在Linux上安装的包列表

#### 安装应用程序

串行安装（默认）：

```bash
./config/brew/1.brewInstallApps.sh
```

并行安装（更快但可能会有更多错误）：

```bash
./config/brew/1.brewInstallApps.sh --parallel
```

### 自定义

- 主机特定配置可以添加到 `config/zsh/hosts/` 目录
- 别名可以在 `config/zsh/aliases.sh` 中定义

### 更新

```bash
cd ~/.dotfiles
./scripts/update.sh
```

### 结构优化与最佳实践

为了提高安全性、健壮性和可维护性，本仓库集成了一些最佳实践。

- **模块化的 `zsh` 配置**: 主配置 `~/.zshrc` 仅作为加载器，负责加载 `config/zsh/modules/` 目录下的各个模块。这让配置更清晰、易于管理。
- **敏感信息管理**: 项目建立了一套敏感信息（如API密钥、Token等）的管理机制。私密信息应存放在 `~/.local_secrets` 文件中，该文件会在启动时自动加载，但会被Git忽略以确保安全。您可以从复制 `.local_secrets.example` 文件开始使用。
- **脚本健壮性**: 所有核心Shell脚本都经过了 `shellcheck` 工具的分析和修复，以避免常见错误，提高脚本的可靠性。
