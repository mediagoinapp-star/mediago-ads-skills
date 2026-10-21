---
name: mediago-ads-android-integration-zh
description: 在 Android 原生 Java 或 Kotlin 工程中接入、升级、审查、排查或验证 MediaGo Ads SDK，覆盖 SDK 直连以及 AdMob、AppLovin MAX、TradPlus 和 TopOn 聚合 Adapter。
---

# MediaGo Ads Android 接入（中文）

本 Skill 用于 Android 原生工程的 MediaGo Ads 工作。支持 SDK 直连及已批准的 AdMob、AppLovin MAX、TradPlus、TopOn 国际版、TopOn 旧版 Adapter 路径；不支持 Unity、Flutter、React Native、仅 iOS 工程或未文档化的自定义桥接。

## 不可跳过的规则

- 先检查客户真实工程。依赖、Manifest、初始化、Adapter 或版本即使被客户声明，也必须有工程/构建证据后才可视为已验证。
- 修改 Gradle、Manifest、源码、ProGuard/R8，或运行任何 Gradle 命令前，必须展示计划并获得客户**明确确认**。
- 不得将示例生产 App ID/广告位 ID 写入工程。仅当客户明确要求测试、Demo 或验证时，才能使用官方测试配置。
- 不得因源码已修改就报告成功；只能报告：**已规划、已应用变更、构建通过、真机已验证**。
- 不得声称法律、隐私或商店合规；不得上传源码、凭证、完整日志、App ID、广告位 ID 或内部链接。

实施、迁移、审查或排障前，先阅读[接入状态与硬门禁](references/integration-state.md)。

## 1. 判断请求类型

将请求归类为：

- 新增 SDK 直连；
- 在直连工程中新增广告样式；
- 接入 AdMob、MAX、TradPlus、TopOn 国际版或 TopOn 旧版 Adapter；
- 迁移或升级；
- 构建、Manifest、初始化、加载、展示、回调或无填充问题排查；
- 接入审查。

若用户仅咨询、查询错误码或需要概念说明，基于已批准 references 回答，不修改工程。若用户明确要求实现或修复代码，再进入以下门禁。

## 2. 只读检查工程

只读取目标模块的 Gradle settings/build 文件、版本目录（如有）、App Manifest、Application/初始化入口、已有 MediaGo 引用和目标语言。`scripts/inspect_android_project.sh` 仅作为只读辅助；多 App 仓库中必须限制到已选模块。

输出简洁事实快照：

```text
目标模块 / Java 或 Kotlin / Gradle DSL
已发现的 minSdk / compileSdk / AGP / Gradle / JDK
直连 SDK 与 Adapter 的声明和已解析版本证据
Maven Central 可用性
初始化责任方和首次加载时机证据
Manifest Activity、权限、进程覆盖与 merger 证据
选定接入路径、缺失前置、冲突或未知事实
```

需要版本化事实时，阅读[官方资料与事实优先级](references/official-sources.md)。

## 3. 验证接入路径

生成实现代码前，仅选择一条路径：

- **SDK 直连：** 应用负责 `AdMaster.initialize` 和 MediaGo 广告 API；
- **Adapter：** 选定聚合平台负责文档规定的 Adapter 生命周期；不得因习惯增加直连初始化。

TopOn 必须先检查已安装类型：

- `com.thinkup.sdk:core-tpn` → TopOn 国际版；
- `com.anythink.sdk:core-tpn` → TopOn 旧版。

若路径、已解析依赖、已批准版本或初始化归属未知，说明阻塞点，只请求解决问题所需的证据；不得提前写代码。

按需阅读[工程前置条件](references/project-prerequisites.md)、[SDK 直连接入](references/direct-integration.md)、[聚合 Adapter](references/mediation-adapters.md)和[兼容性维护](references/compatibility.md)。

## 4. 给出计划并获得明确确认

列出准确的文件变更和最小验证命令，包括依赖/版本变化、Manifest 影响、初始化责任、测试或生产配置及预期风险。

提出一个明确确认问题并等待。批准后如出现新的必要变更，必须说明并再次请求确认。

## 5. 执行已批准的范围

写代码前按需阅读：

- [广告样式](references/ad-formats.md)
- [多进程](references/multi-process.md)
- [隐私与权限](references/privacy.md)
- [迁移与升级](references/migration.md)
- [测试参数与配置](references/test-credentials.md)

同一逻辑广告位默认仅保留一个加载中的请求，除非已批准 API 明确支持其他策略。广告只缓存到被消费为止，在文档规定的终态清理；任何加载/展示失败均应保持宿主业务兜底。

## 6. 验证并报告

客户确认后，先运行最小范围的 Gradle 任务，再检查依赖解析、编译和 manifest-merger 输出。根据选定路径/样式使用[验收清单](references/acceptance-checklist.md)和[验证标准](references/verification.md)。

报告实际达到的最高证据级别和剩余客户侧步骤。需升级诊断时，在请求或发送证据前先阅读[支持、诊断与隐私边界](references/telemetry-and-support.md)。

## Reference 索引

- 门禁与证据：[接入状态与硬门禁](references/integration-state.md)
- 版本事实优先级：[官方资料与事实优先级](references/official-sources.md)
- Gradle、Maven Central、Manifest：[工程前置条件](references/project-prerequisites.md)
- 初始化：[SDK 直连接入](references/direct-integration.md)
- 广告样式：[广告样式](references/ad-formats.md)
- 聚合：[聚合 Adapter](references/mediation-adapters.md)
- 多进程：[多进程](references/multi-process.md)
- 隐私/权限：[隐私与权限](references/privacy.md)
- 升级：[迁移与升级](references/migration.md)
- 测试：[测试参数与配置](references/test-credentials.md)
- 错误：[问题排查](references/troubleshooting.md)
- 验证：[验收清单](references/acceptance-checklist.md) 与 [验证标准](references/verification.md)
- 兼容性发布数据：[兼容性维护](references/compatibility.md)
