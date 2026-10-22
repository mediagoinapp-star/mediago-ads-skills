# MediaGo Ads Skills（中文说明）

[English](README.md) | [简体中文](README_zh.md)

面向外部开发者的 **MediaGo Ads SDK**（`cc.admaster.android:sdk`）官方 AI Agent 接入、升级、审查与排障 Skill 集合。

## 支持范围（当前验证基线：SDK `2.4.0`）

- **Android 原生工程（Java & Kotlin）**：
  - **SDK 直连**：`AdMaster.initialize` 初始化、激励视频（`RewardedAd`）、插屏（`ExpressInterstitialAd`）、开屏（`SplashAd`）、信息流自渲染（`NativeAdLoader` / `NativeAdView` / `AdMediaView`）、横幅（`BannerAdLoader` / `AdMBannerView`）。
  - **Client Bidding（客户端竞价）**：并发竞价规则、过期检查（`isExpired()`）、竞胜/竞败回传（`notifyWin` / `notifyLoss`）与 `LossReason`（被更高出价击败传 `102`）。
  - **五大聚合平台 Adapter**：AdMob（`cc.admaster.android:adapter`）、AppLovin MAX（`cc.admaster.android:max-adapter`）、TradPlus（`cc.admaster.android:tradplus-adapter`）、TopOn 国际版（`cc.admaster.android:topon-adapter`）、TopOn 旧版（`cc.admaster.android:topon-secmtp-adapter`）。
  - **多进程、隐私合规与错误码排障**：`AdActivityController` 多进程配置、GDPR / CCPA / COPPA 接口及 `AdError` 全量错误码表。
- **Unity / 团结引擎 Android 桥接工程**：
  - 基于 EDM4U（`*Dependencies.xml`）、Android Gradle/Manifest 模板与 C# `AndroidJavaObject` / `AndroidJavaProxy` 桥接代码的审查与接入。

---

## 快速安装

> **建议**：同一工程建议只安装一套语言版本（中文 `-zh` 或英文版），避免双语路由重复触发。

### 方式一：使用 `npx skills` 通用 CLI（支持 Cursor、Claude Code、Codex、Windsurf、Copilot、Cline、Antigravity 等）

```bash
# 交互式选择安装
npx skills add mediagoinapp-star/mediago-ads-skills

# 直接安装中文版 Android 接入 Skill
npx skills add mediagoinapp-star/mediago-ads-skills \
  --skill mediago-ads-integration-zh \
  --skill mediago-ads-android-integration-zh
```

### 方式二：Claude Code 插件市场安装

在 Claude Code 对话框中执行：

```text
/plugin marketplace add mediagoinapp-star/mediago-ads-skills
/plugin install mediago-ads-zh@mediago-ads-skills
```

### 方式三：手动复制到工程目录

克隆本仓库，将 `skills/` 下所需的目录复制到你的工程或全局 Agent Skill 目录中：
- **Cursor**：`.cursor/skills/`
- **Claude Code**：`.claude/skills/`
- **Codex / 通用 Agent**：`.agents/skills/`

---

## 常用提示词（Prompt）示例

- **全新直连接入**：
  > “请使用 MediaGo Android 接入 Skill 检查我当前的 Android 工程，使用官方测试参数帮我规划 SDK 初始化与激励视频（RewardedAd）直连接入方案。”
- **聚合 Adapter 接入**：
  > “检查我的 Android 应用模块，帮我接入 MediaGo 的 AppLovin MAX / TopOn 聚合 Adapter，并告诉我后台需要配置的自定义 Adapter 类名和参数。”
- **Client Bidding 接入**：
  > “帮我在现有的插屏广告加载逻辑中接入 MediaGo Client Bidding（获取 eCPM、检查过期并调用 `notifyWin` / `notifyLoss`）。”
- **错误码与问题排查**：
  > “我们请求广告时返回了错误码 `1030003`（或 `20400`），请帮我排查代码中的原因。”

---

## 安全与合规边界

本 Skill 严格遵循“先只读检查工程 → 展示文件级变更计划 → 获得开发者明确确认后再修改代码或运行 Gradle”的安全门禁；不会上传客户源码、生产凭证或完整日志。

Skill 提供的技术配置建议不构成法律或商店合规意见，应用开发者仍需自行完成隐私政策披露、用户同意弹窗（CMP）及目标应用商店合规审核。
