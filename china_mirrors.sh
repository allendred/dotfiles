#!/usr/bin/env bash

# 此文件包含针对中国网络环境的镜像源配置

# GitHub相关镜像
# 更新于2023年，当前可用的镜像站点
GITHUB_MIRROR="https://ghfast.top/"
GITHUB_RAW_MIRROR="https://ghfast.top/"

# Homebrew镜像
BREW_INSTALL_MIRROR="https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh"

# Oh-My-Zsh镜像
OMZ_INSTALL_MIRROR="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

# uv安装脚本镜像
# 主镜像
UV_INSTALL_MIRROR="https://astral.sh/uv/install.sh"
# 备用镜像列表
UV_INSTALL_MIRROR_BACKUPS=(
    "https://ghproxy.com/https://astral.sh/uv/install.sh"
    "https://gh.api.99988866.xyz/https://astral.sh/uv/install.sh"
    "https://hub.fastgit.xyz/astral-sh/uv/releases/download/latest/uv-installer.sh"
)

# Python相关镜像
PYPI_MIRROR="https://pypi.tuna.tsinghua.edu.cn/simple"

# NPM镜像
NPM_MIRROR="https://registry.npmmirror.com"

# Docker镜像
DOCKER_MIRROR="https://registry.docker-cn.com"
DOCKER_MIRROR_ALIYUN="https://mirrors.aliyun.com/docker-ce"

# Maven镜像
MAVEN_MIRROR="https://maven.aliyun.com/repository/public"

# Gradle镜像
GRADLE_MIRROR="https://mirrors.cloud.tencent.com/gradle"

# Alpine镜像
ALPINE_MIRROR="https://mirrors.tuna.tsinghua.edu.cn/alpine"

# Ubuntu/Debian镜像
UBUNTU_MIRROR="https://mirrors.tuna.tsinghua.edu.cn/ubuntu/"
DEBIAN_MIRROR="https://mirrors.tuna.tsinghua.edu.cn/debian/"

# 检测是否需要使用镜像
check_need_mirror() {
    # 尝试多个国际网站来测试网络连通性
    local sites=("google.com" "facebook.com" "twitter.com")
    local need_mirror=1
    
    for site in "${sites[@]}"; do
        if curl -s --connect-timeout 2 "https://www.$site" > /dev/null; then
            # 可以访问国际网站，说明网络通畅，不需要镜像
            need_mirror=0
            break
        fi
    done
    
    # 如果无法访问国际网站，再检查是否可以访问国内网站
    if [ $need_mirror -eq 1 ]; then
        local cn_sites=("baidu.com" "qq.com" "taobao.com")
        local cn_accessible=0
        
        for site in "${cn_sites[@]}"; do
            if curl -s --connect-timeout 2 "https://www.$site" > /dev/null; then
                # 可以访问国内网站，确认需要使用镜像
                cn_accessible=1
                break
            fi
        done
        
        # 如果连国内网站都访问不了，可能是网络问题而非墙的问题
        if [ $cn_accessible -eq 0 ]; then
            need_mirror=0
        fi
    fi
    
    return $need_mirror
}

# 获取GitHub仓库镜像URL
get_github_mirror_url() {
    local original_url="$1"
    
    if check_need_mirror; then
        # 如果原始URL已经包含github.com，则替换为镜像URL
        if echo "$original_url" | grep -q "github.com"; then
            echo "${GITHUB_MIRROR}${original_url#https://github.com/}"
        else
            echo "$original_url"
        fi
    else
        echo "$original_url"
    fi
}

# 获取GitHub Raw内容镜像URL
get_github_raw_mirror_url() {
    local original_url="$1"
    
    if check_need_mirror; then
        # 替换raw.githubusercontent.com的URL
        if echo "$original_url" | grep -q "raw.githubusercontent.com"; then
            echo "${GITHUB_RAW_MIRROR}${original_url#https://raw.githubusercontent.com/}"
        # 替换直接指向GitHub raw内容的URL
        elif echo "$original_url" | grep -q "github.com.*master/\|github.com.*main/"; then
            echo "${GITHUB_RAW_MIRROR}${original_url#https://github.com/}"
        else
            echo "$original_url"
        fi
    else
        echo "$original_url"
    fi
}

# 获取Homebrew安装脚本镜像URL
get_brew_install_mirror_url() {
    if check_need_mirror; then
        echo "$BREW_INSTALL_MIRROR"
    else
        echo "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
    fi
}

# 获取Oh-My-Zsh安装脚本镜像URL
get_omz_install_mirror_url() {
    if check_need_mirror; then
        echo "$OMZ_INSTALL_MIRROR"
    else
        echo "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
    fi
}

# 获取pip镜像参数
get_pip_mirror_args() {
    if check_need_mirror; then
        echo "--index-url $PYPI_MIRROR"
    else
        echo ""
    fi
}

# 获取uv镜像参数
get_uv_mirror_args() {
    if check_need_mirror; then
        echo "--index-url $PYPI_MIRROR"
    else
        echo ""
    fi
}

# 获取uv安装脚本镜像URL
get_uv_install_mirror_url() {
    if check_need_mirror; then
        # 返回主镜像
        echo "$UV_INSTALL_MIRROR"
    else
        echo "https://astral.sh/uv/install.sh"
    fi
}

# 获取uv安装脚本备用镜像URL
get_uv_install_backup_mirrors() {
    if check_need_mirror; then
        # 返回备用镜像列表
        for mirror in "${UV_INSTALL_MIRROR_BACKUPS[@]}"; do
            echo "$mirror"
        done
    else
        # 如果不需要镜像，返回空
        echo ""
    fi
}

# 获取npm镜像配置命令
get_npm_mirror_config() {
    if check_need_mirror; then
        echo "npm config set registry $NPM_MIRROR"
    else
        echo "# npm使用默认镜像"
    fi
}

# 获取yarn镜像配置命令
get_yarn_mirror_config() {
    if check_need_mirror; then
        echo "yarn config set registry $NPM_MIRROR"
    else
        echo "# yarn使用默认镜像"
    fi
}

# 获取Docker镜像配置
get_docker_mirror_config() {
    if check_need_mirror; then
        cat << EOF
{
  "registry-mirrors": [
    "https://registry.docker-cn.com",
    "https://docker.mirrors.ustc.edu.cn",
    "https://hub-mirror.c.163.com"
  ]
}
EOF
    else
        echo "{}"
    fi
}

# 获取Maven镜像配置
get_maven_mirror_config() {
    if check_need_mirror; then
        cat << EOF
<mirror>
  <id>aliyun-public</id>
  <mirrorOf>central</mirrorOf>
  <name>Aliyun Public Repository</name>
  <url>$MAVEN_MIRROR</url>
</mirror>
EOF
    else
        echo "<!-- 使用默认Maven仓库 -->"
    fi
}

# 获取Gradle镜像配置
get_gradle_mirror_config() {
    if check_need_mirror; then
        cat << EOF
allprojects {
    repositories {
        maven { url 'https://maven.aliyun.com/repository/public/' }
        maven { url 'https://maven.aliyun.com/repository/google/' }
        maven { url 'https://maven.aliyun.com/repository/gradle-plugin/' }
        mavenCentral()
        google()
    }
}
EOF
    else
        echo "// 使用默认Gradle仓库"
    fi
}

# 获取Alpine镜像配置
get_alpine_mirror_config() {
    if check_need_mirror; then
        echo "$ALPINE_MIRROR"
    else
        echo "http://dl-cdn.alpinelinux.org/alpine"
    fi
}

# 获取Ubuntu镜像配置
get_ubuntu_mirror_config() {
    if check_need_mirror; then
        echo "$UBUNTU_MIRROR"
    else
        echo "http://archive.ubuntu.com/ubuntu/"
    fi
}

# 获取Debian镜像配置
get_debian_mirror_config() {
    if check_need_mirror; then
        echo "$DEBIAN_MIRROR"
    else
        echo "http://deb.debian.org/debian/"
    fi
}