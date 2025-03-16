#!/bin/sh
###
 # @Author: allendred allendred@163.com
 # @Date: 2025-01-13 20:02:38
 # @LastEditors: allendred allendred@163.com
 # @LastEditTime: 2025-01-19 14:24:59
 # @FilePath: /.dotfiles/zsh/install_plugins.sh
 # @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
### 

# 在 .gitignore 中添加 `zsh/plugins/` 将 zsh 插件全部不 track
echo "🔄 安装 zsh 插件..."

# mkdir -p ~/.oh-my-zsh/custom/plugins/

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/plugins/powerlevel10k
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

git clone --depth=1 https://github.com/junegunn/fzf-git.sh.git ~/.oh-my-zsh/custom/plugins/fzf-git.sh

echo "✅ zsh 插件安装完成"
echo