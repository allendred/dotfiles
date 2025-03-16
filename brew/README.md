<!--
 * @Author: allendred allendred@163.com
 * @Date: 2025-03-15 22:24:17
 * @LastEditors: allendred allendred@163.com
 * @LastEditTime: 2025-03-16 10:12:10
 * @FilePath: /.dotfiles/brew/README.md
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
-->
# Homebrew 安装脚本

这个目录包含用于安装和管理 Homebrew 包的脚本。

## 文件说明

- `0.install.sh` - 安装 Homebrew 的脚本
- `1.brewInstallApps.sh` - 从配置文件安装应用程序的脚本
- `brew-both.txt` - 在所有系统上都要安装的包列表
- `brew-mac.txt` - 仅在 macOS 上安装的包列表
- `brew-linux.txt` - 仅在 Linux 上安装的包列表

## 使用方法

### 安装 Homebrew

```bash
./0.install.sh
```

### 安装应用程序

串行安装（默认）：

```bash
./1.brewInstallApps.sh
```

并行安装（更快但可能会有更多错误）：

```bash
./1.brewInstallApps.sh --parallel
```

## 功能特点

- **自动检测系统类型**：根据系统自动选择安装 macOS 或 Linux 的包
- **跳过已安装的包**：避免重复安装已有的包
- **重试机制**：网络问题时自动重试安装
- **并行安装**：支持并行安装多个包以提高效率
- **安装验证**：安装后验证包是否正确安装
- **详细日志**：记录安装过程，方便排查问题

## 日志文件
安装日志保存在 `~/.dotfiles/logs/` 目录下，格式为 `brew_install_YYYYMMDD_HHMMSS.log`。

## 自定义包列表

您可以编辑以下文件来自定义要安装的包：

- `brew-both.txt` - 添加在所有系统上都要安装的包
- `brew-mac.txt` - 添加仅在 macOS 上安装的包
- `brew-linux.txt` - 添加仅在 Linux 上安装的包

文件格式说明：
- 每行一个包名
- 空行会被忽略
- 以 `#` 开头的行会被视为注释并忽略