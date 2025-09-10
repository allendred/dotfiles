#!/bin/zsh

# Zellij 自动启动脚本

# 1. 检查是否需要跳过
if [[ -n "$ZELLIJ" || -n "$NO_ZELLIJ" || -n "$SSH_CONNECTION" || "$TERM_PROGRAM" == "vscode" || ! -x "$(command -v zellij)" ]]; then
  return
fi

# 2. 尝试附加到第一个可用的会话（不含时间戳）
#    - `zellij list-sessions` 获取列表
#    - `head -n 1`         取第一行
#    - `sed 's/ .*//'`     移除第一个空格之后的所有内容，得到干净的会话名
SESSION_TO_ATTACH=$(zellij list-sessions | head -n 1 | sed 's/ .*//')

# 3. 判断并执行
if [[ -n "$SESSION_TO_ATTACH" ]]; then
    zellij attach "$SESSION_TO_ATTACH"
    # 检查附加是否成功。如果失败（例如，会话已死），则继续创建新会话
    if [ $? -ne 0 ]; then
        zellij
    fi
else
    # 如果没有任何会话，就创建一个新的（让 Zellij 自己随机命名）
    zellij
fi