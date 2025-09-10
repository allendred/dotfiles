#!/usr/bin/env bash

# 此脚本用于自动应用中国镜像源配置到系统环境

# 导入镜像配置
BASEDIR="$(cd "$(dirname "${0}")" && pwd)"
source "${BASEDIR}/china_mirrors.sh"

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

# 检查是否需要使用镜像
if check_need_mirror; then
    echo_info "检测到中国网络环境，将应用国内镜像配置..."
    
    # 配置 npm
    if command -v npm &> /dev/null; then
        echo_info "配置 npm 镜像..."
        eval "$(get_npm_mirror_config)"
        echo_success "npm 镜像配置完成"
    fi
    
    # 配置 yarn
    if command -v yarn &> /dev/null; then
        echo_info "配置 yarn 镜像..."
        eval "$(get_yarn_mirror_config)"
        echo_success "yarn 镜像配置完成"
    fi
    
    # 配置 pip
    if command -v pip &> /dev/null || command -v pip3 &> /dev/null; then
        echo_info "配置 pip 镜像..."
        PIP_CMD="pip"
        if ! command -v pip &> /dev/null; then
            PIP_CMD="pip3"
        fi
        
        # 创建或更新 pip 配置目录
        mkdir -p "$HOME/.pip"
        cat > "$HOME/.pip/pip.conf" << EOF
[global]
index-url = $PYPI_MIRROR
trusted-host = pypi.tuna.tsinghua.edu.cn
EOF
        echo_success "pip 镜像配置完成"
    fi
    
    # 配置 Docker
    if command -v docker &> /dev/null; then
        echo_info "配置 Docker 镜像..."
        DOCKER_CONFIG_DIR="$HOME/.docker"
        mkdir -p "$DOCKER_CONFIG_DIR"
        
        # 检查是否已有配置文件
        if [ -f "$DOCKER_CONFIG_DIR/daemon.json" ]; then
            echo_warning "Docker 配置文件已存在，将备份并更新"
            cp "$DOCKER_CONFIG_DIR/daemon.json" "$DOCKER_CONFIG_DIR/daemon.json.bak"
        fi
        
        # 写入新配置
        get_docker_mirror_config > "$DOCKER_CONFIG_DIR/daemon.json"
        echo_success "Docker 镜像配置完成，可能需要重启 Docker 服务才能生效"
    fi
    
    # 配置 Maven（如果存在）
    if command -v mvn &> /dev/null; then
        echo_info "配置 Maven 镜像..."
        MAVEN_CONFIG_DIR="$HOME/.m2"
        mkdir -p "$MAVEN_CONFIG_DIR"
        
        # 检查是否已有配置文件
        if [ -f "$MAVEN_CONFIG_DIR/settings.xml" ]; then
            echo_warning "Maven 配置文件已存在，将备份并更新"
            cp "$MAVEN_CONFIG_DIR/settings.xml" "$MAVEN_CONFIG_DIR/settings.xml.bak"
            
            # 检查是否已有镜像配置，如果有则替换，没有则添加
            if grep -q "<mirrors>" "$MAVEN_CONFIG_DIR/settings.xml"; then
                # 如果已有 mirrors 标签，检查是否已有阿里云镜像
                if grep -q "aliyun" "$MAVEN_CONFIG_DIR/settings.xml"; then
                    echo_info "Maven 已配置阿里云镜像，跳过"
                else
                    # 在 mirrors 标签内添加阿里云镜像
                    sed -i.tmp "/<\/mirrors>/i\$(get_maven_mirror_config)" "$MAVEN_CONFIG_DIR/settings.xml"
                    rm -f "$MAVEN_CONFIG_DIR/settings.xml.tmp"
                fi
            else
                # 如果没有 mirrors 标签，在文件末尾添加
                sed -i.tmp "/<\/settings>/i\  <mirrors>\n$(get_maven_mirror_config)\n  </mirrors>" "$MAVEN_CONFIG_DIR/settings.xml"
                rm -f "$MAVEN_CONFIG_DIR/settings.xml.tmp"
            fi
        else
            # 创建新的配置文件
            cat > "$MAVEN_CONFIG_DIR/settings.xml" << EOF
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                              http://maven.apache.org/xsd/settings-1.0.0.xsd">
  <mirrors>
$(get_maven_mirror_config)
  </mirrors>
</settings>
EOF
        fi
        echo_success "Maven 镜像配置完成"
    fi
    
    # 配置 Gradle（如果存在）
    if command -v gradle &> /dev/null; then
        echo_info "配置 Gradle 镜像..."
        GRADLE_CONFIG_DIR="$HOME/.gradle"
        mkdir -p "$GRADLE_CONFIG_DIR"
        
        # 创建或更新 init.gradle 文件
        cat > "$GRADLE_CONFIG_DIR/init.gradle" << EOF
$(get_gradle_mirror_config)
EOF
        echo_success "Gradle 镜像配置完成"
    fi
    
    echo_success "所有镜像配置已应用完成！"
else
    echo_info "当前网络环境良好，无需使用国内镜像"
fi