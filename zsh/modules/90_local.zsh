#!/usr/bin/env zsh

# 90_local.zsh - 本地配置加载器
# 加载主机特定的配置文件

# 加载主机特定配置
if [ -f "$HOME/.zsh/hosts/local_index.sh" ]; then
  source "$HOME/.zsh/hosts/local_index.sh"
  
  # 获取当前主机名
  local hostname=$(hostname)
  
  # 加载主机特定配置
  load_host_config "$hostname"
fi