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

# 获取备份目录
get_backup_dir() {
    echo "$HOME/.dotfiles_backups"
}

# 列出所有可用的备份
list_backups() {
    local backup_dir=$(get_backup_dir)
    
    if [ ! -d "$backup_dir" ]; then
        echo_error "备份目录不存在: $backup_dir"
        return 1
    fi
    
    local backups=($(ls -1 "$backup_dir" | sort -r))
    local count=${#backups[@]}
    
    if [ $count -eq 0 ]; then
        echo_warning "没有找到任何备份"
        return 1
    fi
    
    echo_info "找到 $count 个备份:"
    
    for i in $(seq 0 $(($count - 1))); do
        local backup=${backups[$i]}
        echo "[$i] $backup"
    done
    
    echo "${backups[@]}"
}

# 选择要恢复的备份
select_backup() {
    local backups=($(list_backups))
    local count=${#backups[@]}
    
    if [ $count -eq 0 ]; then
        return 1
    fi
    
    local selection
    read -p "请选择要恢复的备份 [0-$(($count - 1))]: " selection
    
    if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -ge "$count" ]; then
        echo_error "无效的选择"
        return 1
    fi
    
    local selected_backup=${backups[$selection]}
    local backup_dir=$(get_backup_dir)
    echo "$backup_dir/$selected_backup"
}

# 恢复主机特定配置
restore_host_configs() {
    local backup_path="$1"
    local hosts_backup_dir="${backup_path}/zsh_hosts"
    local hosts_dir="$HOME/.dotfiles/zsh/hosts"
    
    if [ ! -d "$hosts_backup_dir" ]; then
        echo_warning "备份中没有找到主机特定配置"
        return 1
    fi
    
    echo_info "正在恢复主机特定配置..."
    
    # 确保目标目录存在
    mkdir -p "$hosts_dir"
    
    # 列出备份中的所有配置文件
    local config_files=($(ls -1 "$hosts_backup_dir"))
    local count=${#config_files[@]}
    
    if [ $count -eq 0 ]; then
        echo_warning "备份中没有找到任何配置文件"
        return 1
    fi
    
    echo_info "找到 $count 个配置文件:"
    
    for i in $(seq 0 $(($count - 1))); do
        local config=${config_files[$i]}
        echo "[$i] $config"
    done
    
    # 选择要恢复的配置文件
    local selections
    read -p "请选择要恢复的配置文件 (输入数字，用空格分隔，输入 'all' 恢复所有): " selections
    
    if [ "$selections" = "all" ]; then
        # 恢复所有配置文件
        for config in "${config_files[@]}"; do
            cp "$hosts_backup_dir/$config" "$hosts_dir/"
            echo_success "已恢复: $config"
        done
    else
        # 恢复选定的配置文件
        for selection in $selections; do
            if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -ge "$count" ]; then
                echo_warning "跳过无效的选择: $selection"
                continue
            fi
            
            local config=${config_files[$selection]}
            cp "$hosts_backup_dir/$config" "$hosts_dir/"
            echo_success "已恢复: $config"
        done
    fi
    
    return 0
}

# 恢复重要的配置文件
restore_important_configs() {
    local backup_path="$1"
    local configs_backup_dir="${backup_path}/configs"
    
    if [ ! -d "$configs_backup_dir" ]; then
        echo_warning "备份中没有找到重要配置文件"
        return 1
    fi
    
    echo_info "正在恢复重要配置文件..."
    
    # 列出备份中的所有配置文件和目录
    local items=($(ls -1 "$configs_backup_dir"))
    local count=${#items[@]}
    
    if [ $count -eq 0 ]; then
        echo_warning "备份中没有找到任何配置文件或目录"
        return 1
    fi
    
    echo_info "找到 $count 个配置项:"
    
    for i in $(seq 0 $(($count - 1))); do
        local item=${items[$i]}
        if [ -d "$configs_backup_dir/$item" ]; then
            echo "[$i] $item/ (目录)"
        else
            echo "[$i] $item (文件)"
        fi
    done
    
    # 选择要恢复的配置项
    local selections
    read -p "请选择要恢复的配置项 (输入数字，用空格分隔，输入 'all' 恢复所有): " selections
    
    if [ "$selections" = "all" ]; then
        # 恢复所有配置项
        for item in "${items[@]}"; do
            if [ -d "$configs_backup_dir/$item" ]; then
                # 是目录
                mkdir -p "$HOME/.config/$item"
                cp -r "$configs_backup_dir/$item/"* "$HOME/.config/$item/"
                echo_success "已恢复目录: $item"
            else
                # 是文件
                cp "$configs_backup_dir/$item" "$HOME/.$item"
                echo_success "已恢复文件: $item"
            fi
        done
    else
        # 恢复选定的配置项
        for selection in $selections; do
            if ! [[ "$selection" =~ ^[0-9]+$ ]] || [ "$selection" -ge "$count" ]; then
                echo_warning "跳过无效的选择: $selection"
                continue
            fi
            
            local item=${items[$selection]}
            if [ -d "$configs_backup_dir/$item" ]; then
                # 是目录
                mkdir -p "$HOME/.config/$item"
                cp -r "$configs_backup_dir/$item/"* "$HOME/.config/$item/"
                echo_success "已恢复目录: $item"
            else
                # 是文件
                cp "$configs_backup_dir/$item" "$HOME/.$item"
                echo_success "已恢复文件: $item"
            fi
        done
    fi
    
    return 0
}

# 应用主机配置
apply_host_config() {
    echo_info "正在应用主机配置..."
    
    # 重新加载 zsh 配置
    if [ -f "$HOME/.zshrc" ]; then
        echo_info "请手动执行以下命令以应用新配置:"
        echo "source $HOME/.zshrc"
    fi
}

# 主函数
main() {
    echo_info "开始恢复dotfiles配置..."
    
    # 选择要恢复的备份
    local backup_path=$(select_backup)
    if [ -z "$backup_path" ]; then
        echo_error "未选择有效的备份，退出"
        exit 1
    fi
    
    echo_info "将从以下备份恢复: $backup_path"
    
    # 确认恢复操作
    local confirm
    read -p "确定要从此备份恢复吗？这将覆盖当前的配置。(y/n) " -n 1 -r confirm
    echo
    
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        echo_info "已取消恢复操作"
        exit 0
    fi
    
    # 恢复主机特定配置
    restore_host_configs "$backup_path"
    
    # 恢复重要配置文件
    restore_important_configs "$backup_path"
    
    # 应用主机配置
    apply_host_config
    
    echo_success "dotfiles配置恢复完成！"
}

# 执行主函数
main