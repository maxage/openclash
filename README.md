# OpenClash 增强工具集

<div align="center">
  
![OpenClash Logo](https://raw.githubusercontent.com/vernesong/OpenClash/master/img/logo.png)

[![GitHub stars](https://img.shields.io/github/stars/maxage/openclash?style=flat-square&logo=github)](https://github.com/maxage/openclash/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/maxage/openclash?style=flat-square&logo=github)](https://github.com/maxage/openclash/network)
[![GitHub issues](https://img.shields.io/github/issues/maxage/openclash?style=flat-square&logo=github)](https://github.com/maxage/openclash/issues)
[![GitHub license](https://img.shields.io/github/license/maxage/openclash?style=flat-square)](https://github.com/maxage/openclash/blob/main/LICENSE)
[![OpenWrt](https://img.shields.io/badge/OpenWrt-支持-blue?style=flat-square&logo=openwrt)](https://openwrt.org/)
[![Mihomo](https://img.shields.io/badge/Mihomo-兼容-orange?style=flat-square)](https://github.com/MetaCubeX/mihomo)
[![最后更新](https://img.shields.io/github/last-commit/maxage/openclash?label=最后更新&style=flat-square)](https://github.com/maxage/openclash/commits)
[![Language](https://img.shields.io/badge/语言-简体中文-green?style=flat-square)](README.md)

</div>

<p align="center">🚀 为 OpenWrt 路由器上的 OpenClash 提供便捷的增强工具与规则集</p>

## 📋 目录

- [项目介绍](#-项目介绍)
- [快速开始](#-快速开始)
- [功能特点](#-功能特点)
- [内容目录](#-内容目录)
- [使用方法](#-使用方法)
- [兼容性](#-兼容性)
- [常见问题](#-常见问题)
- [注意事项](#-注意事项)
- [贡献](#-贡献)
- [许可证](#-许可证)
- [相关项目](#-相关项目)
- [更新日志](#-更新日志)
- [联系方式](#-联系方式)

## 📑 项目介绍

这是一个为 OpenClash 用户准备的增强工具集，提供了更便捷、更强大的使用体验。主要包括自动化更新工具、配置生成器和自用规则集等内容。通过这些工具，您可以更轻松地管理 OpenClash，无需繁琐的手动操作和配置。

> [OpenClash](https://github.com/vernesong/OpenClash) 是一个可运行在 OpenWrt 上的 Clash 客户端，支持多种代理协议，提供了丰富的功能和易用的界面。

<details>
<summary><b>🏆 为什么选择本项目？</b></summary>

- **简化操作**：自动化脚本减少手动操作，节省时间
- **稳定可靠**：经过测试的工具和规则，保证稳定性
- **持续更新**：定期更新脚本和规则，跟进上游项目变化
- **兼容性好**：适配多种 OpenWrt 设备和 OpenClash 版本
- **完全开源**：遵循 MIT 许可，代码公开透明

</details>

## ⚡ 快速开始

```bash
# 下载并运行 Mihomo 内核更新脚本
curl -sL https://raw.githubusercontent.com/maxage/openclash/main/openclash/update_mihome.sh | sh
```

<details>
<summary><b>🖼️ 脚本界面预览</b></summary>
<p align="center">（请在此处添加脚本运行界面截图）</p>
</details>

## 🚀 功能特点

### 🔄 Mihomo (Clash.Meta) 内核自动更新

- **[update_mihome.sh](./openclash/update_mihome.sh)**: 自动下载并更新 Mihomo 内核脚本
- 支持多平台多架构，自动适配各种设备
- 自动备份原有文件，避免更新失败导致的问题
- 支持 GitHub Token 配置，解决 API 限流
- 交互式菜单，方便选择合适的版本

<details>
<summary><b>🔍 支持的系统和架构</b></summary>

| 系统 | 架构 |
|------|------|
| linux | amd64, arm64, armv7, armv6, armv5, 386, mips, mipsle, mips64, mips64le |
| darwin | amd64, arm64 |
| windows | amd64, 386 |
| freebsd | amd64, 386 |

</details>

### 📋 自用规则集

- 精心整理的分流规则，适合中国大陆用户
- 针对常用服务进行了优化，提供更精准的分流体验
- 持续更新，确保规则的有效性

<details>
<summary><b>🔍 规则集分类</b></summary>

- **基础规则**：必要的网站和应用分流规则
- **增强规则**：针对特定场景优化的规则
- **自定义规则**：可根据个人需求定制的规则模板

</details>

### 🔧 其他工具

- **OpenClash 配置文件生成器**（开发中）：
  - 根据用户需求自动生成配置文件
  - 支持多种代理协议和分流策略

- **规则转换工具**（计划中）：
  - 转换不同格式的规则，兼容各种客户端
  - 批量处理和优化规则集

- **性能优化脚本**（计划中）：
  - 分析并优化 OpenClash 运行性能
  - 提供内存和 CPU 使用建议

## 📦 内容目录

| 目录/文件 | 描述 | 状态 |
|----------|------|------|
| [/openclash/update_mihome.sh](./openclash/update_mihome.sh) | Mihomo (Clash.Meta) 内核自动更新脚本 | ✅ 可用 |
| [/openclash/README.md](./openclash/README.md) | 更新脚本的详细说明文档 | ✅ 完成 |
| [/rules/](./rules/) | 自用规则集合 | 🔄 整理中 |
| [/configs/](./configs/) | 预设配置模板 | 🚧 开发中 |
| [/tools/](./tools/) | 辅助工具集 | 🚧 开发中 |

## 💡 使用方法

### Mihomo 内核更新

在 OpenWrt 终端运行以下命令：

```bash
curl -sL https://raw.githubusercontent.com/maxage/openclash/main/openclash/update_mihome.sh | sh
```

或者下载后本地运行：

```bash
wget https://raw.githubusercontent.com/maxage/openclash/main/openclash/update_mihome.sh -O update_mihome.sh
chmod +x update_mihome.sh
./update_mihome.sh
```

更多详细信息，请查看 [openclash/README.md](./openclash/README.md)。

### 自定义规则使用方法

1. 在 OpenClash 中导入自定义规则：
   - 进入 OpenClash 管理界面
   - 选择"配置文件管理" → "规则管理"
   - 添加规则链接：`https://raw.githubusercontent.com/maxage/openclash/main/rules/[规则文件名]`

2. 在配置文件中引用规则：
   ```yaml
   rule-providers:
     custom:
       type: http
       behavior: classical
       url: "https://raw.githubusercontent.com/maxage/openclash/main/rules/[规则文件名]"
       path: ./rule_providers/custom.yaml
       interval: 86400
   ```

## 📱 兼容性

### 系统要求

- OpenWrt 18.06 或更高版本
- 至少 4MB 可用存储空间
- 至少 64MB RAM

### 已测试设备

| 设备型号 | 架构 | OpenWrt 版本 | 状态 |
|--------|------|-------------|------|
| x86_64 | amd64 | 21.02 | ✅ 完全兼容 |
| 树莓派 4B | arm64 | 22.03 | ✅ 完全兼容 |
| 小米路由器 4A | mipsel | 21.02 | ✅ 完全兼容 |
| NanoPi R2S | arm64 | 21.02 | ✅ 完全兼容 |

## ❓ 常见问题

<details>
<summary><b>更新脚本报错 "API rate limit exceeded"</b></summary>

这是由于 GitHub API 限制造成的。有两种解决方法：
1. 等待一小时后再尝试
2. 在脚本中设置 GitHub Token（选择选项3）
</details>

<details>
<summary><b>如何检查我的 OpenWrt 设备架构？</b></summary>

在 OpenWrt 终端中运行以下命令：
```bash
uname -m
```
然后根据输出结果查看支持的架构列表。
</details>

<details>
<summary><b>更新后 Meta 内核无法启动</b></summary>

请检查以下几点：
1. 确认下载的版本与您的系统架构匹配
2. 在 OpenClash 中重新启用 Meta 内核
3. 检查 OpenClash 的运行日志以获取更详细的错误信息
</details>

<details>
<summary><b>如何回滚到之前的版本？</b></summary>

脚本会自动备份原有的 clash_meta 文件，备份位于 `/etc/openclash/core/meta-backup/` 目录下。您可以手动恢复：
```bash
cp /etc/openclash/core/meta-backup/clash_meta_[时间戳] /etc/openclash/core/clash_meta
chmod +x /etc/openclash/core/clash_meta
```
</details>

## 🔔 注意事项

- 所有工具均需在 OpenWrt 环境下使用
- 大部分功能需要 root 权限
- 在使用更新脚本前，建议先停止 OpenClash 服务
- 本项目不提供任何代理服务或订阅链接
- 更新内核后，需要在 OpenClash 中重新启用 Meta 内核

## 🤝 贡献

欢迎对本项目提出建议或贡献代码。请遵循以下步骤：

1. Fork 本仓库
2. 创建新的分支 (`git checkout -b feature/your-feature`)
3. 提交你的更改 (`git commit -m 'Add some feature'`)
4. 推送到分支 (`git push origin feature/your-feature`)
5. 创建一个 Pull Request

### 贡献指南

- 遵循项目现有的代码风格
- 确保所有脚本都有详细的注释
- 添加新功能时更新相应的文档
- 所有提交应该有清晰的描述

## 📜 许可证

本项目采用 [MIT 许可证](./LICENSE)。

## 📚 相关项目

- [OpenClash](https://github.com/vernesong/OpenClash): OpenWrt 上的 Clash 客户端
- [Mihomo (Clash.Meta)](https://github.com/MetaCubeX/mihomo): 增强版 Clash 核心
- [OpenWrt](https://openwrt.org/): 用于嵌入式设备的 Linux 操作系统
- [Clash](https://github.com/Dreamacro/clash): 原版 Clash 核心

## 🔄 更新日志

### 2023-12-30
- 添加 Mihomo 内核自动更新脚本
- 创建基本项目结构和文档

### 2024-01-10
- 优化 README 文档
- 添加 MIT 许可证
- 改进脚本兼容性

<details>
<summary><b>查看完整更新历史</b></summary>

### 2023-12-01
- 项目初始化
- 开始规划功能和结构
</details>

## 📞 联系方式

- GitHub Issue: [提交问题](https://github.com/maxage/openclash/issues)
- 电子邮件: [your-email@example.com](mailto:your-email@example.com)

---

<div align="center">

**如果这个项目对您有帮助，请考虑给它一个 ⭐ Star!**

<br>
<sub>📃 README 最后更新: 2024-01-15</sub>

</div>
