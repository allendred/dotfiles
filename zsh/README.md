# Zsh 配置模块化结构

## 概述

这个目录包含了模块化的Zsh配置文件。通过将配置拆分为多个功能模块，使得配置更加清晰、易于维护和扩展。

## 目录结构

```
zsh/
├── README.md                 # 本文档
├── activate_zsh.sh           # 激活Zsh的脚本
├── aliases.sh                # 别名定义
├── hosts/                    # 主机特定配置
│   ├── local_index.sh        # 主机配置加载器
│   └── *.local.zshrc         # 各主机特定配置文件
├── install_plugins.sh        # 插件安装脚本
├── modules/                  # 功能模块目录（新增）
│   ├── 00_core.zsh           # 核心设置（路径、环境变量等）
│   ├── 10_oh-my-zsh.zsh      # Oh-My-Zsh配置
│   ├── 20_completion.zsh     # 自动补全配置
│   ├── 30_history.zsh        # 历史记录配置
│   ├── 40_keybindings.zsh    # 按键绑定配置
│   ├── 50_aliases.zsh        # 别名加载器
│   ├── 60_tools.zsh          # 工具配置（asdf、direnv等）
│   ├── 70_prompt.zsh         # 提示符配置
│   └── 90_local.zsh          # 本地配置加载器
├── zellij_autostart.sh       # Zellij自动启动脚本
└── zshenv                    # 环境变量配置
```

## 加载顺序

1. 首先加载 `zshenv` - 设置基本环境变量
2. 然后加载主 `zshrc` 文件，它会按顺序加载 `modules/` 目录中的模块
3. 模块按照文件名前缀数字顺序加载，确保依赖关系正确
4. 最后加载主机特定配置

## 模块说明

- **00_core.zsh**: 基本设置，如PATH、LANG等环境变量
- **10_oh-my-zsh.zsh**: Oh-My-Zsh的配置和插件设置
- **20_completion.zsh**: 命令补全相关配置
- **30_history.zsh**: 历史记录设置
- **40_keybindings.zsh**: 键盘绑定设置
- **50_aliases.zsh**: 加载别名配置
- **60_tools.zsh**: 各种工具的配置（asdf、direnv、zoxide等）
- **70_prompt.zsh**: 命令提示符配置
- **90_local.zsh**: 加载主机特定配置

## 自定义

要添加自己的配置，可以：

1. 修改现有模块
2. 在 `modules/` 目录中创建新模块（使用适当的数字前缀确保加载顺序）
3. 编辑主机特定配置文件（在 `hosts/` 目录下）

## 备份与恢复

模块化结构完全兼容现有的备份和恢复脚本。备份脚本会保存整个 `zsh/` 目录，恢复脚本会还原所有配置。