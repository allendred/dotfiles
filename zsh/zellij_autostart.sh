#!/bin/zsh

# Zellij 自动启动脚本

# 1. 如果 Zellij 命令不存在，则直接退出
if ! command -v zellij &> /dev/null; then
  return
fi

# 2. 检查是否需要跳过 (已在会话中、SSH等)
if [[ -n "$ZELLIJ" || -n "$NO_ZELLIJ" || -n "$SSH_CONNECTION" || "$TERM_PROGRAM" == "vscode" ]]; then
  return
fi

# 3. 检查现有会话并决定操作
# 获取第一个会话的名称
first_session=$(zellij list-sessions | head -n 1)

if [ -z "$first_session" ]; then
  # 如果没有会话在运行，则创建一个新的
  zellij
else
  # 否则，附加到找到的第一个会话
  zellij attach "$first_session"
fi