#!/usr/bin/env bash

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

# 主函数
main() {
    echo_info "正在更新dotfiles..."

    # 切换到dotfiles目录
    cd "$(dirname "$0")"

    # 保存当前的更改（如果有）
    if [ -n "$(git status --porcelain)" ]; then
        echo_warning "检测到本地有未提交的更改"
        read -p "是否要保存这些更改？(y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo_info "正在提交本地更改..."
            git add -A
            git commit -m "自动保存本地更改 $(date +"%Y-%m-%d %H:%M:%S")"
            echo_success "本地更改已保存"
        fi
    fi

    # 拉取最新的更改
    echo_info "正在拉取最新的更改..."
    if git pull; then
        echo_success "更新成功"
    else
        echo_error "拉取更新失败，可能存在冲突"
        exit 1
    fi

    # 更新子模块
    echo_info "正在更新子模块..."
    if git submodule update --init --recursive; then
        echo_success "子模块更新成功"
    else
        echo_error "子模块更新失败"
        exit 1
    fi

    # 运行安装脚本
    echo_info "正在运行安装脚本..."
    if ./install; then
        echo_success "dotfiles更新完成！"
    else
        echo_error "安装脚本执行失败"
        exit 1
    fi
}

# 执行主函数
main