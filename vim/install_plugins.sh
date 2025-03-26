#!/bin/sh

# 导入中国镜像源配置
BASEDIR="$(cd "$(dirname "${0}")" && cd .. && pwd)"
source "${BASEDIR}/china_mirrors.sh"

# 在 .gitignore 中添加 `vim/pack/vendor/start/` 将 vim 插件全部不 track

mkdir -p ~/.vim/pack/vendor/start/

# 使用镜像源克隆仓库
clone_with_mirror() {
    local repo_url="$1"
    local target_dir="$2"
    
    # 检查目标目录是否已存在
    if [ -d "$target_dir" ]; then
        echo "✅ 已存在: $(basename "$target_dir")，跳过"
        return 0
    fi
    
    # 获取可能的镜像URL
    local mirror_url=$(get_github_mirror_url "$repo_url")
    echo "🔄 克隆: $(basename "$target_dir") (使用: $mirror_url)"
    
    # 克隆仓库
    if git clone --depth=1 "$mirror_url" "$target_dir"; then
        echo "✅ 成功安装: $(basename "$target_dir")"
        return 0
    else
        echo "❌ 安装失败: $(basename "$target_dir")"
        return 1
    fi
}

clone_with_mirror "https://github.com/preservim/nerdtree.git" ~/.vim/pack/vendor/start/nerdtree
clone_with_mirror "https://github.com/ojroques/vim-oscyank.git" ~/.vim/pack/vendor/start/vim-oscyank
