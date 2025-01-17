# 检查是否已经安装 Oh My Zsh
if [ ! -d "${ZSH:-$HOME/.dotfiles/oh-my-zsh}" ]; then
    echo "Installing Oh My Zsh..."
    ZSH="$HOME/.dotfiles/oh-my-zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh is already installed."
fi
