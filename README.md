# Dotfiles

这是一个用于管理各种配置文件的dotfiles仓库，帮助你在新环境中快速设置熟悉的开发环境。

## 功能

- 自动安装和配置Oh My Zsh及其插件
- 配置Vim/Neovim编辑器
- 设置Git配置
- 配置终端工具(kitty, yazi等)
- 自动安装常用软件(通过Homebrew)
- 配置窗口管理工具(Hammerspoon, Karabiner)

## 安装

```bash
# 克隆仓库
git clone https://github.com/allendred/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 运行安装脚本
./install
```

## 主要配置文件

- `zshrc`: Zsh配置
- `vimrc`: Vim配置
- `gitconfig`: Git配置
- `nvim/`: Neovim配置
- `hammerspoon/`: Hammerspoon配置
- `karabiner/`: Karabiner配置

## 自定义

- 主机特定配置可以添加到`zsh/hosts/`目录
- 别名可以在`zsh/aliases.sh`中定义

## 更新

```bash
cd ~/.dotfiles
git pull
./install
```
