#!/bin/zsh

# Zellij 自动启动脚本

# 1. 检查是否需要跳过
#    - 已在 Zellij 会话中
#    - 用户设置了临时禁用开关
#    - SSH 会话
#    - VS Code 集成终端
#    - Zellij 命令不存在
if [[ -n "$ZELLIJ" || -n "$NO_ZELLIJ" || -n "$SSH_CONNECTION" || "$TERM_PROGRAM" == "vscode" || ! command -v zellij &> /dev/null ]]; then
  return
fi

# 2. 启动或附加到会话
# --create 选项会自动判断：如果存在会话，则附加；如果不存在，则创建。
zellij attach --create
