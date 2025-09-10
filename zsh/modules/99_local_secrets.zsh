# Load local secrets, this file should be ignored by git
if [ -f "$HOME/.local_secrets" ]; then
  source "$HOME/.local_secrets"
fi
