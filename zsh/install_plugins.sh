#!/bin/sh
###
 # @Author: allendred allendred@163.com
 # @Date: 2025-01-13 20:02:38
 # @LastEditors: allendred allendred@163.com
 # @LastEditTime: 2025-01-19 14:24:59
 # @FilePath: /.dotfiles/zsh/install_plugins.sh
 # @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
### 

# 导入中国镜像源配置
BASEDIR="$(cd "$(dirname "${0}")" && cd .. && pwd)"
. "${BASEDIR}/china_mirrors.sh"

# 在 .gitignore 中添加 `zsh/plugins/` 将 zsh 插件全部不 track
echo "🔄 安装 zsh 插件..."

# mkdir -p ~/.oh-my-zsh/custom/plugins/

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

clone_with_mirror "https://github.com/romkatv/powerlevel10k.git" ~/.oh-my-zsh/custom/plugins/powerlevel10k
clone_with_mirror "https://github.com/zsh-users/zsh-autosuggestions.git" ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
clone_with_mirror "https://github.com/zsh-users/zsh-syntax-highlighting.git" ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
clone_with_mirror "https://github.com/junegunn/fzf-git.sh.git" ~/.oh-my-zsh/custom/plugins/fzf-git.sh

echo "✅ zsh 插件安装完成"
echo