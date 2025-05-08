#!/bin/sh

# 导入中国镜像源配置
BASEDIR="$(cd "$(dirname "${0}")" && pwd)"
. "${BASEDIR}/china_mirrors.sh"

# 检查是否已经安装 Oh My Zsh
if [ ! -d "${ZSH:-$HOME/.oh-my-zsh}" ]; then
    echo "Installing Oh My Zsh..."
    OMZ_INSTALL_URL=$(get_omz_install_mirror_url)
    echo "使用安装源: $OMZ_INSTALL_URL"
    
    # 尝试安装Oh My Zsh
    if sh -c "$(curl -fsSL $OMZ_INSTALL_URL)" "" --unattended; then
        echo "Oh My Zsh安装成功！"
    else
        echo "Oh My Zsh安装失败，请检查网络连接或手动安装。"
        exit 1
    fi
else
    echo "Oh My Zsh is already installed."
fi





