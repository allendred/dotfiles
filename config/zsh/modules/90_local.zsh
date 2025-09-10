# Load host-specific and other local configurations

# Load host-specific config
if [ -f "$HOME/.dotfiles/config/zsh/hosts/local_index.sh" ]; then
  source "$HOME/.dotfiles/config/zsh/hosts/local_index.sh"
fi

# Autostart Zellij
if [ -f "$HOME/.dotfiles/config/zsh/zellij_autostart.sh" ]; then
  source "$HOME/.dotfiles/config/zsh/zellij_autostart.sh"
fi
