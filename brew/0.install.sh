#!/bin/sh

set -e

# 颜色定义
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
NC="\033[0m" # No Color

# ----- Constants -----
LINUX_BREW_PATH="/home/linuxbrew/.linuxbrew/bin/brew"
MACOS_BREW_PATH="/opt/homebrew/bin/brew"

# 导入中国镜像源配置
BASEDIR="$(cd "$(dirname "${0}")" && cd .. && pwd)"
. "${BASEDIR}/china_mirrors.sh"

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

# 获取系统相关信息
get_system_info() {
    OS_TYPE="$(uname)"
    ARCH_TYPE="$(uname -m)"
}

# 根据系统类型确定 brew 路径
# Determine brew path based on OS
get_brew_path() {
    if [ "$OS_TYPE" = "Darwin" ]; then
        echo "$MACOS_BREW_PATH"
    else
        echo "$LINUX_BREW_PATH"
    fi
}

# 检查系统兼容性
check_system_compatibility() {
    # homebrew 目前不支持 ARM 架构的 Linux
    if [ "$OS_TYPE" = "Linux" ] && [ "$ARCH_TYPE" = "aarch64" ]; then
        echo_error "Homebrew on Linux is not supported on ARM processors."
        echo_info "https://docs.brew.sh/Homebrew-on-Linux#arm-unsupported"
        return 1
    fi
    return 0
}

# 检查 brew 是否已安装且正常工作
# Check if brew is installed and working
check_brew_installation() {
    local brew_path="$1"
    if [ -x "$brew_path" ] && "$brew_path" --version >/dev/null 2>&1; then
        return 0
    fi
    return 1
}

# 安装 Homebrew
install_homebrew() {
    echo_info "Homebrew未安装或无法正常工作，正在安装..."
    BREW_INSTALL_URL=$(get_brew_install_mirror_url)
    echo_info "使用安装源: $BREW_INSTALL_URL"
    if /bin/bash -c "$(curl -fsSL $BREW_INSTALL_URL)"; then
        echo_success "Homebrew安装成功"
        return 0
    else
        echo_error "Homebrew安装失败"
        return 1
    fi
}

# 主函数
main() {
    echo_info "检查Homebrew安装状态..."
    get_system_info
    
    # 检查系统兼容性
    check_system_compatibility || exit 1
    
    BREW_PATH=$(get_brew_path)
    
    if check_brew_installation "$BREW_PATH"; then
        echo_success "Homebrew已安装且正常工作"
    else
        if install_homebrew; then
            echo_success "Homebrew安装和配置完成"
        else
            echo_error "Homebrew安装失败，请手动安装"
            exit 1
        fi
    fi
}

# 执行主函数
# Execute main function
main
