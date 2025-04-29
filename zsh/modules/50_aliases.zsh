#!/usr/bin/env zsh

# 50_aliases.zsh - 别名加载器
# 加载别名配置文件

# 加载主别名文件
if [ -f "$HOME/.zsh/aliases.sh" ]; then
  source "$HOME/.zsh/aliases.sh"
fi

# 可以在这里添加更多的别名文件加载逻辑
# 例如按功能分类的别名文件等