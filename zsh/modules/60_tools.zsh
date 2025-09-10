# Tool configurations

# 60_tools.zsh - 工具配置
# 包含各种开发工具的配置

# Custom Paths
export PATH="$HOME/python/bin:$PATH"

# asdf 版本管理器
if [ -f "$(brew --prefix asdf)/libexec/asdf.sh" ]; then
  source "$(brew --prefix asdf)/libexec/asdf.sh"
fi

# ---- direnv -----
eval "$(direnv hook zsh)"
export DIRENV_LOG_FORMAT=""     # 关闭 direnv 加载信息，使其不出现在终端中

# zoxide
export PATH="$HOME/.local/bin:$PATH"
#eval "$(zoxide init zsh)"

# yazi
function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}