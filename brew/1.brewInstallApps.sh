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

# 检查是否为 ARM Linux
if uname -a | grep -q "Linux" && uname -m | grep -q "aarch64"; then
    echo_warning "ARM Linux 暂不支持 Homebrew，退出安装..."
    exit 0
fi

# 安装单个包的函数
install_package() {
    echo_info "正在安装: $1"
    if brew install "$1" 2>/dev/null; then
        echo_success "成功安装: $1"
    else
        echo_error "安装失败: $1"
        return 1
    fi
}

# 从文件读取并安装包的函数
install_from_file() {
    while read -r package || [ -n "$package" ]; do
        # 跳过空行和注释
        case "$package" in
            ""|\#*) continue ;;
            *) install_package "$package" || : ;;  # : 是 shell 的空操作符
        esac
    done < "$1"
}


# 主函数
main() {
    echo_info "开始安装Homebrew应用..."
    
    # 根据系统添加 Homebrew 路径
    if uname -a | grep -q "Darwin"; then
        # macOS
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo_info "brew 安装 mac apps..."
        install_from_file ~/.dotfiles/brew/brew-mac.txt
    else
        # Linux (x86_64)
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        echo_info "brew 安装 linux apps..."
        install_from_file ~/.dotfiles/brew/brew-linux.txt
    fi

    # 安装通用应用
    echo_info "brew 安装通用 apps..."
    install_from_file ~/.dotfiles/brew/brew-both.txt

    echo_success "Homebrew应用安装完成！"
}

# 执行主函数
main