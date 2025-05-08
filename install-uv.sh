#!/usr/bin/env bash

# 颜色定义
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
NC="\033[0m" # No Color

# 导入中国镜像源配置
BASEDIR="$(cd "$(dirname "${0}")" && pwd)"
source "${BASEDIR}/china_mirrors.sh"

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

# 检查命令是否存在
check_command() {
    if ! command -v $1 &> /dev/null; then
        return 1
    fi
    return 0
}

# 主函数
main() {
    echo_info "开始安装uv..."
    
    # 检查uv是否已安装
    if check_command uv; then
        echo_info "uv已安装，版本信息："
        uv --version
        read -p "是否重新安装？(y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo_info "跳过安装"
            return 0
        fi
    fi
    
    # 使用镜像源或直接源，根据网络情况
    UV_INSTALL_URL="https://astral.sh/uv/install.sh"
    if check_need_mirror; then
        echo_info "检测到需要使用镜像源"
        # 使用ghproxy代理
        UV_INSTALL_URL="${GITHUB_MIRROR}https://astral.sh/uv/install.sh"
    fi
    
    echo_info "使用安装源: $UV_INSTALL_URL"
    
    # 安装uv
    echo_info "正在下载并安装uv..."
    if curl -LsSf $UV_INSTALL_URL | sh; then
        echo_success "uv安装脚本执行成功"
        
        # 添加uv到PATH
        UV_PATH="$HOME/.cargo/bin/uv"
        
        # 检查uv是否已在PATH中
        if ! check_command uv; then
            echo_info "将uv添加到当前会话的PATH中"
            export PATH="$HOME/.cargo/bin:$PATH"
            
            # 检查shell类型并添加到相应的配置文件
            SHELL_TYPE=$(basename "$SHELL")
            if [[ "$SHELL_TYPE" == "zsh" ]]; then
                CONFIG_FILE="$HOME/.zshrc"
            elif [[ "$SHELL_TYPE" == "bash" ]]; then
                CONFIG_FILE="$HOME/.bashrc"
            else
                CONFIG_FILE="$HOME/.profile"
            fi
            
            # 检查配置文件中是否已有PATH设置
            if ! grep -q "export PATH=\"\$HOME/.cargo/bin:\$PATH\"" "$CONFIG_FILE"; then
                echo_info "将uv路径添加到$CONFIG_FILE"
                echo '\n# 添加uv到PATH\nexport PATH="$HOME/.cargo/bin:$PATH"' >> "$CONFIG_FILE"
            fi
            
            echo_warning "请运行以下命令使PATH设置生效："
            echo "  source $CONFIG_FILE"
        fi
        
        # 再次检查uv命令
        if check_command uv; then
            echo_success "uv安装成功并可用！版本信息："
            uv --version
        elif [ -f "$UV_PATH" ]; then
            echo_warning "uv已安装但未在PATH中，可以使用完整路径运行：$UV_PATH"
            echo_warning "或者重新打开终端后再试"
        else
            echo_error "uv安装失败，无法找到可执行文件"
            return 1
        fi
    else
        echo_error "uv安装失败，请检查网络连接或手动安装"
        return 1
    fi
    
    return 0
}

# 执行主函数
main