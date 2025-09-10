#!/bin/sh

set -e

# 颜色定义
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
NC="\033[0m" # No Color

# 打印带颜色的信息
echo_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

echo_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

echo_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

echo_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查是否已安装Zellij
check_zellij_installed() {
    if command -v zellij >/dev/null 2>&1; then
        return 0  # 已安装
    else
        return 1  # 未安装
    fi
}

# 通过Homebrew安装Zellij
install_zellij_with_brew() {
    echo_info "正在通过Homebrew安装Zellij..."
    if brew install zellij; then
        echo_success "Zellij安装成功"
        return 0
    else
        echo_error "Homebrew安装Zellij失败"
        return 1
    fi
}

# 创建Zellij配置目录
setup_zellij_config() {
    local config_dir="$HOME/.config/zellij"
    
    # 创建配置目录
    if [ ! -d "$config_dir" ]; then
        echo_info "创建Zellij配置目录: $config_dir"
        mkdir -p "$config_dir"
    fi
    
    # 链接配置文件
    local dotfiles_config="$HOME/.dotfiles/zellij/config"
    if [ -d "$dotfiles_config" ]; then
        echo_info "链接Zellij配置文件"
        ln -sf "$dotfiles_config"/* "$config_dir"/
        echo_success "Zellij配置文件链接成功"
    fi
}

# 主函数
main() {
    echo_info "检查Zellij安装状态..."
    
    if check_zellij_installed; then
        echo_success "Zellij已安装"
    else
        echo_info "Zellij未安装，开始安装..."
        if install_zellij_with_brew; then
            echo_success "Zellij安装完成"
        else
            echo_error "Zellij安装失败"
            return 1
        fi
    fi
    
    # 设置配置文件
    setup_zellij_config
    
    echo_success "Zellij安装和配置完成"
    return 0
}

# 执行主函数
main