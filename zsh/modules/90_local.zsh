# Load host-specific and other local configurations

# Load host-specific config
if [ -f "$HOME/.zsh/hosts/local_index.sh" ]; then
  source "$HOME/.zsh/hosts/local_index.sh"
fi

# Autostart Zellij
if [ -f "$HOME/.dotfiles/zsh/zellij_autostart.sh" ]; then
  source "$HOME/.dotfiles/zsh/zellij_autostart.sh"
fi
