# Mihomo (Clash.Meta) 内核自动更新脚本

这个项目提供了一个自动下载并更新 [Mihomo (Clash.Meta)](https://github.com/MetaCubeX/mihomo) 内核的脚本，专为 OpenWrt 中的 OpenClash 设计。

## 功能特点

- 支持多平台多架构，自动适配各种设备
- 仅支持 Prerelease-Alpha 版本下载
- 通过交互式菜单，方便用户选择合适的版本
- 自动备份原有 clash_meta 文件，保留最近7个备份
- 支持检测当前系统和架构，辅助用户选择
- 支持配置 GitHub Token，解决 API 限流问题
- 自动检查和安装必要的依赖

## 使用方法

### 在线运行

```bash
curl -sL https://raw.githubusercontent.com/maxage/openclash/main/openclash/update_mihome.sh | sh
```

或者

```bash
bash <(curl -Ls https://raw.githubusercontent.com/maxage/openclash/main/openclash/update_mihome.sh)
```

### 本地运行

1. 下载脚本：

```bash
wget https://raw.githubusercontent.com/maxage/openclash/main/openclash/update_mihome.sh -O update_mihome.sh
```

2. 赋予执行权限：

```bash
chmod +x update_mihome.sh
```

3. 运行脚本：

```bash
./update_mihome.sh
```

## 菜单选项

脚本提供以下操作选项：

1. **手动分级选择**：依次选择操作系统 → 架构 → 编译方式 → 具体包
2. **检测当前系统和架构**：显示当前系统和架构信息（仅供参考）
3. **设置GitHub Token**：配置GitHub Token以解决API限流问题
4. **退出**：退出脚本

## 自动检测与兼容性

脚本会自动检测您的系统是否安装了 OpenClash，确保 `/etc/openclash/core` 目录存在。它还会检查系统架构，帮助您选择合适的内核版本。

## 依赖项

脚本需要以下依赖：
- curl
- jq
- gzip

如果这些依赖不存在，脚本会尝试使用 opkg 自动安装。

## GitHub Token 配置

如果遇到 GitHub API 限流问题，您可以配置一个 GitHub Token 来解决：

1. 访问 https://github.com/settings/tokens
2. 点击 'Generate new token'
3. 只需勾选 'public_repo' 权限
4. 点击生成并复制 Token
5. 在脚本中选择"设置 GitHub Token"选项，并粘贴您的 Token

## 注意事项

- 脚本仅适用于 OpenWrt 中的 OpenClash
- 需要 root 权限运行
- 建议在更新前确保 OpenClash 处于停止状态
- 更新完成后需要在 OpenClash 中重新启用 Meta 内核

## 原作者

- Mihomo (Clash.Meta)：https://github.com/MetaCubeX
- 脚本维护：https://github.com/maxage/openclash

## 许可证 

MIT 