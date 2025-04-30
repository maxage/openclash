# OpenClash 增强工具集

<div align="center">
  
![OpenClash Logo](https://raw.githubusercontent.com/vernesong/OpenClash/master/img/logo.png)

[![GitHub stars](https://img.shields.io/github/stars/maxage/openclash?style=flat-square&logo=github)](https://github.com/maxage/openclash/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/maxage/openclash?style=flat-square&logo=github)](https://github.com/maxage/openclash/network)
[![GitHub issues](https://img.shields.io/github/issues/maxage/openclash?style=flat-square&logo=github)](https://github.com/maxage/openclash/issues)
[![GitHub license](https://img.shields.io/github/license/maxage/openclash?style=flat-square)](https://github.com/maxage/openclash/blob/main/LICENSE)
[![OpenWrt](https://img.shields.io/badge/OpenWrt-支持-blue?style=flat-square&logo=openwrt)](https://openwrt.org/)

</div>

## 📑 项目介绍

这是一个为 OpenClash 用户准备的增强工具集，提供了更便捷、更强大的使用体验。主要包括自动化更新工具、配置生成器和自用规则集等内容。

> [OpenClash](https://github.com/vernesong/OpenClash) 是一个可运行在 OpenWrt 上的 Clash 客户端，支持多种代理协议，提供了丰富的功能和易用的界面。

## 🚀 功能特点

### 🔄 Mihomo (Clash.Meta) 内核自动更新

- **[update_mihome.sh](./openclash/update_mihome.sh)**: 自动下载并更新 Mihomo 内核脚本
- 支持多平台多架构，自动适配各种设备
- 自动备份原有文件，避免更新失败导致的问题
- 支持 GitHub Token 配置，解决 API 限流

### 📋 自用规则集

- 精心整理的分流规则，适合中国大陆用户
- 针对常用服务进行了优化，提供更精准的分流体验
- 持续更新，确保规则的有效性

### 🔧 其他工具

- OpenClash 配置文件生成器（开发中）
- 规则转换工具（计划中）
- 性能优化脚本（计划中）

## 📦 内容目录

| 目录/文件 | 描述 |
|----------|------|
| [/openclash/update_mihome.sh](./openclash/update_mihome.sh) | Mihomo (Clash.Meta) 内核自动更新脚本 |
| [/openclash/README.md](./openclash/README.md) | 更新脚本的详细说明文档 |
| [/rules/](./rules/) | 自用规则集合（整理中） |

## 💡 使用方法

### Mihomo 内核更新

在 OpenWrt 终端运行以下命令：

```bash
curl -sL https://raw.githubusercontent.com/maxage/openclash/main/openclash/update_mihome.sh | sh
```

或者

```bash
bash <(curl -Ls https://raw.githubusercontent.com/maxage/openclash/main/openclash/update_mihome.sh)
```

更多详细信息，请查看 [openclash/README.md](./openclash/README.md)。

## 🔔 注意事项

- 所有工具均需在 OpenWrt 环境下使用
- 大部分功能需要 root 权限
- 在使用更新脚本前，建议先停止 OpenClash 服务
- 本项目不提供任何代理服务或订阅链接

## 🤝 贡献

欢迎对本项目提出建议或贡献代码。请遵循以下步骤：

1. Fork 本仓库
2. 创建新的分支 (`git checkout -b feature/your-feature`)
3. 提交你的更改 (`git commit -m 'Add some feature'`)
4. 推送到分支 (`git push origin feature/your-feature`)
5. 创建一个 Pull Request

## 📜 许可证

本项目采用 [MIT 许可证](./LICENSE)。

## 📚 相关项目

- [OpenClash](https://github.com/vernesong/OpenClash): OpenWrt 上的 Clash 客户端
- [Mihomo (Clash.Meta)](https://github.com/MetaCubeX/mihomo): 增强版 Clash 核心
- [OpenWrt](https://openwrt.org/): 用于嵌入式设备的 Linux 操作系统

## 📞 联系方式

- GitHub Issue: [提交问题](https://github.com/maxage/openclash/issues)
