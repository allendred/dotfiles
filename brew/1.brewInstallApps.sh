#!/bin/bash

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
    echo_warning "ARM Linux 暂不支持 Homebrew退出安装..."
    exit 0
fi

# 日志文件
LOG_DIR="$HOME/.dotfiles/logs"
LOG_FILE="$LOG_DIR/brew_install_$(date +"%Y%m%d_%H%M%S").log"

# 创建日志目录
mkdir -p "$LOG_DIR"

# 记录日志的函数
log() {
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] $1" >> "$LOG_FILE"
}

# 检查包是否已安装
is_package_installed() {
    if brew list "$1" &>/dev/null; then
        return 0  # 已安装
    else
        return 1  # 未安装
    fi
}

# 安装单个包的函数带重试机制
install_package() {
    local package=$1
    local max_retries=3
    local retry_count=0
    
    # 检查是否已安装
    if is_package_installed "$package"; then
        echo_info "已安装: $package跳过"
        log "已安装: $package跳过"
        return 0
    fi
    
    echo_info "正在安装: $package"
    log "开始安装: $package"
    
    while [ $retry_count -lt $max_retries ]; do
        if brew install "$package" 2>>"$LOG_FILE"; then
            echo_success "成功安装: $package"
            log "成功安装: $package"
            
            # 验证安装
            if is_package_installed "$package"; then
                log "验证安装成功: $package"
                return 0
            else
                echo_error "安装验证失败: $package"
                log "安装验证失败: $package"
                return 1
            fi
        else
            retry_count=$((retry_count + 1))
            if [ $retry_count -lt $max_retries ]; then
                echo_warning "安装失败: $package 第 $retry_count 次重试..."
                log "安装失败: $package第 $retry_count 次重试..."
                sleep 2  # 等待一段时间再重试
            else
                echo_error "安装失败: $package已达到最大重试次数"
                log "安装失败: $package已达到最大重试次数"
                return 1
            fi
        fi
    done
}

# 从文件读取并安装包的函数
install_from_file() {
    local file_path=$1
    local parallel=${2:-false}  # 默认为串行安装
    local packages_to_install=()
    
    echo_info "从文件安装: $file_path"
    log "从文件安装: $file_path"
    
    # 读取文件跳过空行和注释
    while read -r package || [ -n "$package" ]; do
        case "$package" in
            "") continue ;;
            \#*) continue ;;
            *) 
                # 检查是否已安装
                if ! is_package_installed "$package"; then
                    packages_to_install+=("$package")
                else
                    echo_info "已安装: $package 跳过"
                    log "已安装: $package 跳过"
                fi
                ;;
        esac
    done < "$file_path"
    
    # 如果没有需要安装的包直接返回
    if [ ${#packages_to_install[@]} -eq 0 ]; then
        echo_info "所有包已安装无需操作"
        log "所有包已安装无需操作"
        return 0
    fi
    
    # 根据是否并行安装选择不同的安装方式
    if [ "$parallel" = true ] && [ ${#packages_to_install[@]} -gt 1 ]; then
        echo_info "并行安装 ${#packages_to_install[@]} 个包..."
        log "并行安装 ${#packages_to_install[@]} 个包..."
        
        # 使用brew的并行安装功能
        if brew install "${packages_to_install[@]}" 2>>"$LOG_FILE"; then
            echo_success "成功并行安装所有包"
            log "成功并行安装所有包"
            
            # 验证所有包的安装
            local all_verified=true
            for package in "${packages_to_install[@]}"; do
                if ! is_package_installed "$package"; then
                    echo_error "安装验证失败: $package"
                    log "安装验证失败: $package"
                    all_verified=false
                fi
            done
            
            if [ "$all_verified" = true ]; then
                return 0
            else
                return 1
            fi
        else
            echo_error "并行安装失败将尝试串行安装"
            log "并行安装失败将尝试串行安装"
            # 失败后回退到串行安装
            parallel=false
        fi
    fi
    
    # 串行安装
    if [ "$parallel" = false ]; then
        for package in "${packages_to_install[@]}"; do
            install_package "$package" || log "安装失败: $package 继续安装其他包"
        done
    fi
}

# 主函数
main() {
    echo_info "开始安装Homebrew应用..."
    log "开始安装Homebrew应用..."
    
    # 检查是否启用并行安装
    PARALLEL_INSTALL=false
    if [ "$1" = "--parallel" ]; then
        PARALLEL_INSTALL=true
        echo_info "已启用并行安装模式"
        log "已启用并行安装模式"
    fi
    
    # 根据系统添加 Homebrew 路径
    if uname -a | grep -q "Darwin"; then
        # macOS
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo_info "brew 安装 mac apps..."
        log "brew 安装 mac apps..."
        install_from_file ~/.dotfiles/brew/brew-mac.txt "$PARALLEL_INSTALL"
    else
        # Linux (x86_64)
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        echo_info "brew 安装 linux apps..."
        log "brew 安装 linux apps..."
        install_from_file ~/.dotfiles/brew/brew-linux.txt "$PARALLEL_INSTALL"
    fi

    # 安装通用应用
    echo_info "brew 安装通用 apps..."
    log "brew 安装通用 apps..."
    install_from_file ~/.dotfiles/brew/brew-both.txt "$PARALLEL_INSTALL"

    echo_success "Homebrew应用安装完成！"
    log "Homebrew应用安装完成！"
    echo_info "安装日志已保存到: $LOG_FILE"
}

# 执行主函数传递命令行参数
main "$@"