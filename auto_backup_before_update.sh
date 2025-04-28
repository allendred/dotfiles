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

# 获取当前时间戳
get_timestamp() {
    date +"%Y%m%d_%H%M%S"
}

# 创建备份目录
create_backup_dir() {
    local backup_dir="$HOME/.dotfiles_backups"
    local timestamp=$(get_timestamp)
    local backup_path="${backup_dir}/${timestamp}"
    
    mkdir -p "$backup_path"
    echo "$backup_path"
}

# 备份主机特定配置
backup_host_configs() {
    local backup_path="$1"
    local hosts_dir="$HOME/.dotfiles/zsh/hosts"
    local hosts_backup_dir="${backup_path}/zsh_hosts"
    
    mkdir -p "$hosts_backup_dir"
    
    echo_info "正在备份主机特定配置..."
    if cp -r "$hosts_dir"/* "$hosts_backup_dir"/; then
        echo_success "主机特定配置备份成功"
    else
        echo_warning "主机特定配置备份失败或没有配置文件"
    fi
}

# 备份重要的配置文件
backup_important_configs() {
    local backup_path="$1"
    local configs_backup_dir="${backup_path}/configs"
    
    mkdir -p "$configs_backup_dir"
    
    echo_info "正在备份重要配置文件..."
    
    # 要备份的文件列表
    local files_to_backup=(
        "$HOME/.zshrc"
        "$HOME/.vimrc"
        "$HOME/.gitconfig"
        "$HOME/.profile"
        "$HOME/.bashrc"
    )
    
    # 要备份的目录列表
    local dirs_to_backup=(
        "$HOME/.config/kitty"
        "$HOME/.hammerspoon"
    )
    
    # 备份文件
    for file in "${files_to_backup[@]}"; do
        if [ -f "$file" ]; then
            cp "$file" "$configs_backup_dir"/
            echo_success "已备份: $file"
        fi
    done
    
    # 备份目录
    for dir in "${dirs_to_backup[@]}"; do
        if [ -d "$dir" ]; then
            dir_name=$(basename "$dir")
            mkdir -p "$configs_backup_dir/$dir_name"
            cp -r "$dir"/* "$configs_backup_dir/$dir_name"/
            echo_success "已备份目录: $dir"
        fi
    done
}

# 运行机器特定配置备份
run_machine_config_backup() {
    echo_info "正在运行机器特定配置备份..."
    if "$HOME/.dotfiles/backup_machine_config.sh"; then
        echo_success "机器特定配置备份成功"
    else
        echo_warning "机器特定配置备份失败"
    fi
}

# 主函数
main() {
    echo_info "开始备份dotfiles配置..."
    
    # 创建备份目录
    local backup_path=$(create_backup_dir)
    echo_info "备份将保存到: $backup_path"
    
    # 运行机器特定配置备份
    run_machine_config_backup
    
    # 备份主机特定配置
    backup_host_configs "$backup_path"
    
    # 备份重要配置文件
    backup_important_configs "$backup_path"
    
    echo_success "dotfiles配置备份完成！备份路径: $backup_path"
    echo "$backup_path" > "$HOME/.dotfiles/.last_backup_path"
}

# 执行主函数
main