#!/bin/sh

# 导入中国镜像源配置
BASEDIR="$(cd "$(dirname "${0}")" && pwd)"
source "${BASEDIR}/china_mirrors.sh"

# 检查是否已经安装 Oh My Zsh
if [ ! -d "${ZSH:-$HOME/.dotfiles/oh-my-zsh}" ]; then
    echo "Installing Oh My Zsh..."
    OMZ_INSTALL_URL=$(get_omz_install_mirror_url)
    echo "使用安装源: $OMZ_INSTALL_URL"
    sh -c "$(curl -fsSL $OMZ_INSTALL_URL)" "" --unattended
else
    echo "Oh My Zsh is already installed."
fi





