#!/usr/bin/env bash

# 此文件包含针对中国网络环境的镜像源配置

# GitHub相关镜像
# 更新于2023年，当前可用的镜像站点
GITHUB_MIRROR="https://ghfast.top/"
GITHUB_RAW_MIRROR="https://ghfast.top/https://raw.githubusercontent.com/"

# Homebrew镜像
BREW_INSTALL_MIRROR="https://gitee.com/cunkai/HomebrewCN/raw/master/Homebrew.sh"

# Oh-My-Zsh镜像
OMZ_INSTALL_MIRROR="https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh"

# Python相关镜像
PYPI_MIRROR="https://pypi.tuna.tsinghua.edu.cn/simple"

# 检测是否需要使用镜像
check_need_mirror() {
    # 尝试访问Google来测试网络连通性
    if curl -s --connect-timeout 2 https://www.google.com > /dev/null; then
        # 可以访问Google，说明网络通畅，不需要镜像
        return 1
    else
        # 无法访问Google，可能需要使用镜像
        return 0
    fi
}

# 获取GitHub仓库镜像URL
get_github_mirror_url() {
    local original_url="$1"
    
    if check_need_mirror; then
        # 如果原始URL已经包含github.com，则替换为镜像URL
        if echo "$original_url" | grep -q "github.com"; then
            echo "${GITHUB_MIRROR}${original_url}"
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
            local new_url=$(echo "$original_url" | sed 's|https://raw.githubusercontent.com/|'"${GITHUB_RAW_MIRROR}"'|')
            echo "$new_url"
        # 替换直接指向GitHub raw内容的URL
        elif echo "$original_url" | grep -q "github.com.*master/\|github.com.*main/"; then
            echo "${GITHUB_RAW_MIRROR}${original_url#*https://raw.githubusercontent.com/}"
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