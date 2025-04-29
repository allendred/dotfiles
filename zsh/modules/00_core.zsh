#!/usr/bin/env zsh

# 00_core.zsh - 核心设置
# 包含基本的环境变量、路径等核心配置

# 设置系统语言环境为美式英语, 字符编码为 UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# 设置终端颜色(修复远程登录主机时 kcbt 异常导致的命令预测字符无法清除的问题)
export TERM=xterm-256color

# 设置默认编辑器
export EDITOR='nvim'

# 添加用户bin目录到PATH
export PATH="$HOME/.local/bin:$PATH"

# vim风格的命令行编辑模式
set -o vi