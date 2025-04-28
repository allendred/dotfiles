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

# 获取当前主机名
get_hostname() {
    hostname
}

# 检查主机配置文件是否存在
check_host_config() {
    local hostname="$1"
    local config_file="$HOME/.dotfiles/zsh/hosts/${hostname}.local.zshrc"
    
    if [ -f "$config_file" ]; then
        return 0 # 文件存在
    else
        return 1 # 文件不存在
    fi
}

# 创建主机配置文件
create_host_config() {
    local hostname="$1"
    local config_file="$HOME/.dotfiles/zsh/hosts/${hostname}.local.zshrc"
    
    # 确保目录存在
    mkdir -p "$HOME/.dotfiles/zsh/hosts"
    
    # 创建配置文件
    touch "$config_file"
    echo "# 主机特定配置文件: $hostname" > "$config_file"
    echo "# 创建时间: $(date)" >> "$config_file"
    echo "" >> "$config_file"
    
    echo_success "创建了主机配置文件: $config_file"
}

# 备份Homebrew安装的软件包
backup_homebrew() {
    local hostname="$1"
    local config_file="$HOME/.dotfiles/zsh/hosts/${hostname}.local.zshrc"
    
    echo_info "正在备份Homebrew配置..."
    
    # 检查Homebrew是否安装
    if command -v brew &> /dev/null; then
        # 检测操作系统类型
        if [[ "$(uname)" == "Darwin" ]]; then
            echo "# ----- Homebrew(Mac) -----" >> "$config_file"
            echo "# 以下是自动生成的Homebrew配置，请勿手动修改" >> "$config_file"
            echo "export HOMEBREW_PREFIX=\"$(brew --prefix)\"" >> "$config_file"
            echo "eval \"\$(\$HOMEBREW_PREFIX/bin/brew shellenv)\"" >> "$config_file"
            echo "" >> "$config_file"
        elif [[ "$(uname)" == "Linux" ]]; then
            echo "# ----- Homebrew(Linux) -----" >> "$config_file"
            echo "# 以下是自动生成的Homebrew配置，请勿手动修改" >> "$config_file"
            echo "eval \"\$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)\"" >> "$config_file"
            echo "" >> "$config_file"
        fi
        
        echo_success "Homebrew配置已备份"
    else
        echo_warning "未检测到Homebrew，跳过备份"
    fi
}

# 备份Node.js环境
backup_nodejs() {
    local hostname="$1"
    local config_file="$HOME/.dotfiles/zsh/hosts/${hostname}.local.zshrc"
    
    echo_info "正在备份Node.js环境..."
    
    # 检查NVM是否安装
    if [ -d "$HOME/.nvm" ]; then
        echo "# ----- Node.js(NVM) -----" >> "$config_file"
        echo "# 以下是自动生成的NVM配置，请勿手动修改" >> "$config_file"
        echo "export NVM_DIR=\"\$HOME/.nvm\"" >> "$config_file"
        echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && \\. \"\$NVM_DIR/nvm.sh\"  # This loads nvm" >> "$config_file"
        echo "[ -s \"\$NVM_DIR/bash_completion\" ] && \\. \"\$NVM_DIR/bash_completion\"  # This loads nvm bash_completion" >> "$config_file"
        echo "" >> "$config_file"
        
        echo_success "NVM配置已备份"
    else
        echo_warning "未检测到NVM，跳过备份"
    fi
}

# 备份Python环境
backup_python() {
    local hostname="$1"
    local config_file="$HOME/.dotfiles/zsh/hosts/${hostname}.local.zshrc"
    
    echo_info "正在备份Python环境..."
    
    # 检查pyenv是否安装
    if command -v pyenv &> /dev/null; then
        echo "# ----- Python(pyenv) -----" >> "$config_file"
        echo "# 以下是自动生成的pyenv配置，请勿手动修改" >> "$config_file"
        echo "export PYENV_ROOT=\"\$HOME/.pyenv\"" >> "$config_file"
        echo "command -v pyenv >/dev/null || export PATH=\"\$PYENV_ROOT/bin:\$PATH\"" >> "$config_file"
        echo "eval \"\$(pyenv init -)\"" >> "$config_file"
        echo "" >> "$config_file"
        
        echo_success "pyenv配置已备份"
    else
        echo_warning "未检测到pyenv，跳过备份"
    fi
}

# 备份自定义PATH
backup_custom_paths() {
    local hostname="$1"
    local config_file="$HOME/.dotfiles/zsh/hosts/${hostname}.local.zshrc"
    
    echo_info "正在备份自定义PATH..."
    
    echo "# ----- 自定义PATH -----" >> "$config_file"
    echo "# 以下是自动生成的PATH配置，请根据需要修改" >> "$config_file"
    echo "# export PATH=\"\$PATH:/custom/path1:/custom/path2\"" >> "$config_file"
    echo "" >> "$config_file"
    
    echo_success "自定义PATH模板已添加"
}

# 备份代理设置
backup_proxy_settings() {
    local hostname="$1"
    local config_file="$HOME/.dotfiles/zsh/hosts/${hostname}.local.zshrc"
    
    echo_info "正在备份代理设置..."
    
    echo "# ----- 代理设置 -----" >> "$config_file"
    echo "# 以下是自动生成的代理设置，请根据需要修改" >> "$config_file"
    echo "# pxyon > /dev/null  # 启用代理" >> "$config_file"
    echo "" >> "$config_file"
    
    echo_success "代理设置模板已添加"
}

# 提交更改到Git仓库
commit_changes() {
    local hostname="$1"
    
    echo_info "正在提交更改到Git仓库..."
    
    # 切换到dotfiles目录
    cd "$HOME/.dotfiles"
    
    # 检查是否有更改
    if [ -n "$(git status --porcelain)" ]; then
        git add -A
        git commit -m "备份 $hostname 的机器配置 $(date +"%Y-%m-%d %H:%M:%S")"
        echo_success "更改已提交到本地Git仓库"
        
        echo_info "您可以使用 'git push' 将更改推送到远程仓库"
    else
        echo_warning "没有检测到更改，无需提交"
    fi
}

# 主函数
main() {
    echo_info "开始备份机器配置..."
    
    # 获取当前主机名
    local hostname=$(get_hostname)
    echo_info "当前主机名: $hostname"
    
    # 检查主机配置文件是否存在
    if ! check_host_config "$hostname"; then
        echo_info "主机配置文件不存在，正在创建..."
        create_host_config "$hostname"
    else
        echo_info "主机配置文件已存在，将进行更新"
        # 备份原文件
        cp "$HOME/.dotfiles/zsh/hosts/${hostname}.local.zshrc" "$HOME/.dotfiles/zsh/hosts/${hostname}.local.zshrc.bak"
        # 重新创建配置文件
        create_host_config "$hostname"
    fi
    
    # 备份各种配置
    backup_homebrew "$hostname"
    backup_nodejs "$hostname"
    backup_python "$hostname"
    backup_custom_paths "$hostname"
    backup_proxy_settings "$hostname"
    
    # 提交更改
    read -p "是否要提交更改到Git仓库？(y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        commit_changes "$hostname"
    fi
    
    echo_success "机器配置备份完成！"
}

# 执行主函数
main