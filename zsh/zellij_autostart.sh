#!/bin/zsh

# Zellij自动启动脚本

# 如果已经在Zellij会话中，则不再启动新的会话
if [[ -n "$ZELLIJ" ]]; then
  return
fi

# 如果是SSH会话，不自动启动Zellij
if [[ -n "$SSH_CONNECTION" ]]; then
  return
fi

# 如果是VS Code的集成终端，不自动启动Zellij
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  return
fi

# 如果Zellij命令不存在，则不尝试启动
if ! command -v zellij &> /dev/null; then
  return
fi

# 检查是否有活动的Zellij会话
if zellij list-sessions &> /dev/null; then
  # 如果有活动会话，则附加到第一个会话
  zellij attach
else
  # 否则创建新会话
  zellij
fi