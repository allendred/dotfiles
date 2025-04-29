#!/usr/bin/env zsh

# 60_tools.zsh - 工具配置
# 包含各种开发工具的配置

# asdf 版本管理器
if [ -f "$(brew --prefix asdf)/libexec/asdf.sh" ]; then
  source "$(brew --prefix asdf)/libexec/asdf.sh"
fi

# direnv 目录环境管理
if command -v direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
  export DIRENV_LOG_FORMAT=""     # 关闭 direnv 加载信息，使其不出现在终端中
fi

# zoxide 智能目录跳转
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# yazi 文件管理器
function yy() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}