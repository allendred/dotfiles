#!/usr/bin/env zsh

# 10_oh-my-zsh.zsh - Oh-My-Zsh配置
# 包含Oh-My-Zsh的基本设置和插件配置

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# 设置主题
ZSH_THEME="robbyrussell"

# 插件配置
# 注意：过多的插件会降低shell启动速度
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# 加载Oh-My-Zsh
source $ZSH/oh-my-zsh.sh