# MediaGo Ads Skills（官方中文说明）

[English](README.md) | [简体中文](README_zh.md)

面向外部开发者的 **MediaGo Ads SDK**（`cc.admaster.android:sdk`）官方 AI Agent 接入、升级、代码审查与排障 Skill 集合。支持在 **Claude Code、Cursor、OpenAI Codex、GitHub Copilot、Windsurf、Cline、Roo Code、Antigravity** 等主流 AI 编程工具中开箱即用。

---

## Skill 支持的核心功能一览

### 1. 智能工程识别与路由 (`mediago-ads-integration-zh`)
- 只读扫描工程根目录结构，自动识别工程类型并路由到对应工作流：
  - **Android 原生工程**（含 `settings.gradle[.kts]`、`com.android.application`、`AndroidManifest.xml`）→ 自动路由至 `mediago-ads-android-integration-zh`。
  - **Unity / 团结引擎 Android 桥接工程**（含 `Assets/Plugins/Android/`、`*Dependencies.xml`、`mainTemplate.gradle`、`AndroidJavaObject` / `AndroidJavaProxy`）→ 自动路由至 `mediago-ads-unity-android-integration-zh`。
  - **混合工程（Unity + 独立原生模块）** → 先识别并向开发者确认目标模块，防止改错目录。

### 2. Android 原生全流程接入与排障 (`mediago-ads-android-integration-zh`)

#### A. 覆盖三大主流接入模式
| 接入模式 | 支持的具体功能 |
|---|---|
| **SDK 直连 (Direct Integration)** | 自动检查并配置 `mavenCentral()` 与 `cc.admaster.android:sdk:2.4.0` 依赖；生成 `Application` 单点初始化代码（`AdMaster.initialize` + `AdMasterSetting`），确保所有广告加载严格在 `InitCallback.onInitialized()` 成功后触发。 |
| **客户端竞价 (Client Bidding)** | 支持端侧并发竞价流程：通过 `getResponseInfo().getEcpmLevel()` 获取实时价格、比价前校验 `isExpired()`、竞胜展示前调用 `notifyWin`、竞败或过期时调用 `notifyLoss`（支持 `LossReason` 标准原因码，如被高价击败传 `102`）并销毁释放。 |
| **聚合平台 Adapter（支持 5 大聚合）** | 完整支持 **Google AdMob**、**AppLovin MAX**、**TradPlus**、**TopOn 国际版 (`com.thinkup`)**、**TopOn 旧版 (`com.anythink`)**。自动区分 TopOn 家族依赖、匹配对应 Adapter Maven 坐标、输出聚合后台 Custom Event 全限定类名与参数映射（`app_id` / `placement_id`），并防止错误叠加直连初始化。 |

#### B. 覆盖五大广告样式（提供完整 Java & Kotlin 代码模板）
| 广告样式 | 核心 SDK 类 | Skill 自动实现的接入细节 |
|---|---|---|
| **激励视频 (Rewarded)** | `RewardedAd`、`RewardedAdLoadCallback`、`RewardedAdInteractionCallback` | 单实例并发加载保护、`isReady()` 与存活 `Activity` 校验、严格仅在 `onUserEarnedReward(RewardItem)` 中单次发放奖励、关闭/失败终态自动 `destroy()`。 |
| **插屏广告 (Interstitial)** | `ExpressInterstitialAd`、`ExpressInterstitialAdLoadCallback`、`ExpressInterstitialAdInteractionCallback` | 模板插屏预加载、展示条件检查、曝光/点击/关闭/展示失败全回调处理及宿主业务流程兜底。 |
| **开屏广告 (Splash)** | `SplashAd`、`SplashAdLoadCallback`、`SplashAdInteractionCallback` | 冷/热启动开屏加载、承载容器 `ViewGroup` 可见性与尺寸校验、5 秒超时保護计时器、关闭与异常时安全跳转主界面。 |
| **信息流自渲染 (Native)** | `NativeAdLoader`、`NativeAd`、`NativeAdView`、`AdMediaView` | 自渲染素材绑定（标题、描述、Icon、CTA 按钮、`AdMediaView` 视频/主图容器）、`registerViewForInteraction` 可点击区域注册、列表复用与页面销毁时的内存释放。 |
| **横幅广告 (Banner)** | `BannerAdLoader`、`AdMBannerView`、`BannerAdSize` | 支持 `BANNER_320_50`（`320x50`）与 `MEDIUM_RECTANGLE_300_250`（`300x250`）两种标准尺寸加载、父容器挂载与生命周期销毁。 |

#### C. 进阶配置、合规设置与错误码诊断
- **多进程支持**：当应用在非主进程加载或展示广告时，指导配置 `AdActivityController`（映射 `MainProcessAdActivity` / `SubProcessAdActivity` 等组件）。
- **海外隐私合规接口**：支持在初始化前（`AdMasterSetting.Builder`）或运行时（`AdMaster` 静态方法）配置 **GDPR** (`setGdprConsent`)、**CCPA / 美国州隐私** (`setUsPrivacyLimit`) 与 **COPPA** (`setCoppa`)。
- **全量错误码速查与排障**：内置 `AdError` 全量错误码表（`1010001`、`1020001`~`1020004`、`1030001`~`1030004`、`1040001`~`1040008`、`20000`、`20400`、`30001`、`40001`、`40002`、`50001`），可根据报错码快速定位代码或配置问题。
- **官方联调测试参数**：内置官方测试 App ID（`39590`）及五大广告样式测试广告位 ID（激励 `12377`、插屏 `12378`、开屏 `12379`、横幅 `12380`、原生 `12382`），方便开发者快速跑通 Demo，并内置防误写生产配置的保护门禁。
- **接入审查与版本升级**：支持对照已验证兼容矩阵（[`compatibility/compatibility.json`](compatibility/compatibility.json)）检查 AGP / Gradle / JDK / `minSdk` / `compileSdk`、R8/ProGuard 混淆规则、Manifest 合并结果与生命周期内存泄漏隐患。

### 3. Unity / 团结引擎 Android 桥接支持 (`mediago-ads-unity-android-integration-zh`)
- 针对 Unity 直出 Android 的桥接工程，分层审查与实施：
  1. **EDM4U 依赖声明层**（`*Dependencies.xml` 版本锁定与无 GMS 依赖处理）
  2. **Android Gradle 与 Manifest 模板层**（`Assets/Plugins/Android/mainTemplate.gradle`、`settingsTemplate.gradle`、`AndroidManifest.xml`）
  3. **C# JNI 桥接代码层**（`AndroidJavaClass`、`AndroidJavaObject`、`AndroidJavaProxy` 回调签名对齐与 Unity 主线程派发）
  4. **构建与导出产物核验**（绝不直接手改 `Library/` 下会被覆盖的临时生成文件）

---

## 安全工作流保障（为什么不会乱改你的工程？）

1. **先只读检查，后给方案**：先扫描目标模块的 Gradle、Version Catalog (`libs.versions.toml`)、`AndroidManifest.xml` 与现有初始化代码，输出工程事实快照。
2. **文件级变更计划 + 显式确认门禁**：在修改任何 Gradle、Manifest、源码或执行 Gradle 构建命令前，必须先列出变更文件清单与验证命令，**获得开发者明确确认后才会执行**。
3. **基于真实证据汇报进度**：绝不把“改完代码”谎称为“接入成功”，严格按 **已规划 → 已应用变更 → 构建通过 → 真机已验证** 四个证据等级汇报。

---

## 快速安装

> **提示**：同一工程建议只安装一套语言版本（中文 `-zh` 或英文版），避免双语路由重复触发。

### 方式一：使用 `npx skills` 通用 CLI（推荐，全 IDE 通用）
支持自动安装到 **Cursor、Claude Code、Codex、Windsurf、GitHub Copilot、Cline、Roo Code、Antigravity** 等 20+ 种主流工具：

```bash
# 交互式选择要安装的 Skill 和目标工具
npx skills add mediagoinapp-star/mediago-ads-skills

# 或直接指定安装中文版 Android 接入 Skill
npx skills add mediagoinapp-star/mediago-ads-skills \
  --skill mediago-ads-integration-zh \
  --skill mediago-ads-android-integration-zh
```

### 方式二：Claude Code 原生插件市场安装
在 Claude Code 中直接运行：

```text
/plugin marketplace add mediagoinapp-star/mediago-ads-skills
/plugin install mediago-ads-zh@mediago-ads-skills
```

### 方式三：手动复制到工程目录
克隆本仓库，将 `skills/` 下对应目录复制到你的工程或全局 Agent Skill 目录中：
- **Cursor**：`.cursor/skills/`
- **Claude Code**：`.claude/skills/`
- **Codex / 通用 Agent**：`.agents/skills/`

---

## 包含的 Skill 目录清单

| Skill 目录 | 语言 | 功能说明 |
|---|---|---|
| `skills/mediago-ads-integration-zh` | 简体中文 | 识别客户工程类型并路由至受支持的工作流 |
| `skills/mediago-ads-android-integration-zh` | 简体中文 | Android 原生 Java/Kotlin 直连、Client Bidding、聚合 Adapter 接入、审查与排障 |
| `skills/mediago-ads-unity-android-integration-zh` | 简体中文 | Unity / 团结引擎 Android 桥接（EDM4U + Gradle 模板 + C# JNI）接入与审查 |
| `skills/mediago-ads-integration` | English | Project type detector and workflow router |
| `skills/mediago-ads-android-integration` | English | Native Android Java/Kotlin integration, adapters, Client Bidding, and troubleshooting |
| `skills/mediago-ads-unity-android-integration` | English | Unity / Tuanjie Android bridge via EDM4U, Gradle templates, and C# JNI |

---

## 各场景常用提示词（Prompt）模板

安装完成后，你可以在 AI 编程助手中直接复制以下提示词触发对应功能：

- **场景 1：全新 SDK 直连接入（含官方测试参数）**
  > “请使用 MediaGo Android 接入 Skill 检查我当前的 Android 工程，使用官方测试参数帮我规划 SDK 初始化以及激励视频（RewardedAd）和插屏广告（ExpressInterstitialAd）的直连接入方案。”
- **场景 2：在现有工程中新增信息流自渲染 / 横幅 / 开屏广告**
  > “帮我在现有的 Android 工程中新增 MediaGo 信息流自渲染广告（`NativeAdLoader` + `NativeAdView` + `AdMediaView`），并处理好可点击区域注册和页面销毁释放。”
- **场景 3：接入聚合平台 Adapter（AdMob / MAX / TradPlus / TopOn）**
  > “请检查我的 Android 应用模块，帮我接入 MediaGo 的 AppLovin MAX（或 TopOn / AdMob / TradPlus）聚合 Adapter，并告诉我聚合后台需要填写的自定义 Adapter 全限定类名和参数格式。”
- **场景 4：接入 Client Bidding（客户端竞价）**
  > “帮我在现有的激励视频加载逻辑中接入 MediaGo Client Bidding，实现获取 eCPM、校验过期时间，并在竞胜/竞败时调用 `notifyWin` 和 `notifyLoss`。”
- **场景 5：报错码诊断与无填充排查**
  > “我们请求广告时回调了错误码 `1030003`（或 `20400` / `40001`），请结合我们的代码帮我排查具体原因并给出修复方案。”
- **场景 6：上线前接入完整性审查（Audit）**
  > “请使用 MediaGo Android Skill 对我当前工程的广告接入代码做一次全面审查，检查是否存在初始化时机风险、内存泄漏、混淆缺失或测试 ID 未替换问题。”

---

## 安全与合规边界

- 本 Skill **不会**向外部上传客户源码、生产凭证、App ID、广告位 ID 或完整日志。
- 除非开发者明确要求使用测试参数进行 Demo/联调验证，否则绝不会用测试参数覆盖工程已有的正式参数。
- Skill 提供的技术配置建议不构成法律或商店合规意见，应用开发者仍需自行完成隐私政策披露、用户同意管理（CMP）及目标应用商店合规审核。
