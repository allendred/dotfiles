# 机器特定配置说明

本目录包含针对不同主机的特定配置文件，用于在不同机器上加载对应的环境设置。

## 配置文件命名规则

- 标准命名格式：`hostname.local.zshrc`
- 特殊主机名配置：在 `local_index.sh` 的 `handle_special_hostname` 函数中定义

## 如何备份当前机器配置

您可以使用以下命令备份当前机器的配置：

```bash
backup_machine_config
```

该命令会自动：

1. 检测当前主机名
2. 创建或更新对应的配置文件
3. 自动备份以下配置：
   - Homebrew 配置
   - Node.js (NVM) 环境
   - Python (pyenv) 环境
   - 自定义 PATH 设置模板
   - 代理设置模板
4. 提示是否将更改提交到 Git 仓库

## 配置文件内容示例

```bash
# 主机特定配置文件: your-hostname
# 创建时间: 日期时间

# ----- Homebrew(Mac/Linux) -----
# Homebrew 相关配置

# ----- Node.js(NVM) -----
# NVM 相关配置

# ----- Python(pyenv) -----
# pyenv 相关配置

# ----- 自定义PATH -----
# 自定义 PATH 配置

# ----- 代理设置 -----
# 代理相关配置
```

## 手动添加配置

如果您需要手动添加特定配置，可以直接编辑对应主机名的配置文件。建议在文件中添加清晰的注释，说明每个配置的用途。

## 特殊主机名处理

如果您的主机名需要特殊处理（例如，使用不同的配置文件名），请在 `local_index.sh` 的 `handle_special_hostname` 函数中添加相应的规则。

```bash
case "$hostname" in
"your-special-hostname")
  . "$DOTFILES_ZSH_HOSTS/your-special-config.local.zshrc"
  return 0
  ;;
# 添加更多特殊主机名处理...
esac
```