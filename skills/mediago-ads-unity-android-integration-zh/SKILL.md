---
name: mediago-ads-unity-android-integration-zh
description: 在使用 EDM4U、Android Gradle/Manifest Template 与已审核 C# JNI Bridge 的 Unity 或团结引擎工程中接入、审查、升级、排查或验证 MediaGo Ads。适用于存在 Android 目标或 AndroidJavaObject/AndroidJavaProxy Bridge 证据的工程。
---

# MediaGo Ads Unity Android Bridge 接入（中文）

本 Skill 面向通过 C# 到 Android Bridge 接入 MediaGo 的 Unity/团结引擎客户工程。这不是官方独立 Unity SDK。不得编造 C# API、凭记忆推导 Android 签名，或修改 `Library/` 下生成的文件。

## 不可跳过的规则

- 先检查真实 Unity 工程。EDM 依赖、Gradle Template、Manifest、JNI 类、回调接口和 SDK 版本均须由工程或导出证据验证。
- 修改 EDM XML、Gradle/Manifest Template、C# Bridge、原生 Android Library、Player Setting，或执行 Force Resolve、导出、Unity Build、Gradle 命令前，必须展示计划并获得明确确认。
- `Library/`、生成 Gradle 工程和生成 merged Manifest 只可作为证据，不得直接修改。
- 不得使用或外泄生产 App ID、广告位 ID、凭证、竞价值和完整日志。
- 只能报告：**已规划、已应用变更、构建通过、真机已验证**。

实施、迁移、审查或排障前，先阅读[Bridge 状态与硬门禁](references/bridge-state.md)。

## 1. 判断请求类型

- 新 Unity Android Bridge 可行性/接入；
- 既有 Bridge 审查或修复；
- 通过 Bridge 新增直连广告样式；
- EDM4U、Gradle Template、Manifest、导出或构建问题；
- Android Activity、全屏广告或 Native View 生命周期问题；
- 迁移或升级。

仅咨询时基于已批准 references 回答，不修改工程。

## 2. 只读检查

读取 `ProjectSettings/ProjectVersion.txt`、Android Player Setting、`Packages/`、EDM `*Dependencies.xml`、`Assets/Plugins/Android/`、`.androidlib`、C# `AndroidJavaObject`/`AndroidJavaProxy` Bridge，以及已有生成输出作为佐证。

输出 Unity/团结版本、Android 目标、EDM 和依赖事实源、SDK 声明与解析证据、Template/生成输出差异、Bridge 初始化/回调线程/广告生命周期归属和未知事实。

## 3. 验证 Bridge 路径

仅选择一条：直连 Bridge、Client Bidding Bridge 或已批准 Adapter Bridge。应用其他位置使用聚合 SDK，不代表 MediaGo 直连 Bridge 就是 Adapter 路径。

直连和 Client Bidding Bridge 必须验证唯一初始化责任方，且仅在初始化成功后加载。Adapter 以 Adapter 文档规定的生命周期为准。精确 Java 类、方法、回调接口和版本必须来自已批准发布条目；若导出项目使用 SNAPSHOT 或没有批准兼容条目，只能报告发布阻塞，不得编造兼容性。

按需阅读[Bridge 工程模型](references/bridge-project-model.md)、Android Skill 的[直连接入](../mediago-ads-android-integration/references/direct-integration.md)、[广告样式](../mediago-ads-android-integration/references/ad-formats.md)、[聚合](../mediago-ads-android-integration/references/mediation-adapters.md)、[Client Bidding](../mediago-ads-android-integration/references/client-bidding.md)。

## 4. 计划与确认

展示准确事实源文件、是否需要 EDM Force Resolve/导出/构建、待检查生成证据、依赖/仓库/Manifest/JNI 生命周期影响及最小验证命令。确认绑定计划标识和摘要；任何新增文件、命令、依赖/版本、权限、外发数据或 Player Setting 都必须重新确认。

## 5. 实施与验证

在接触 Unity 对象前，将 Java 回调调度到 Unity 主线程。全屏广告需同时处理 Unity 暂停/恢复和 Android Activity 生命周期；只有文档规定的奖励回调可发奖。Native 广告终态必须同时释放 Android View/广告对象和 Unity 侧容器。

确认后先执行最小操作：Force Resolve、Android 导出、生成 Gradle/Manifest 检查、Unity Android Build，再按需真机验证。生成输出仅证明导出解析；只有 Android 真机观察到加载、展示和回调后才能报告真机已验证。
