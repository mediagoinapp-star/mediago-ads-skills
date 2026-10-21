# 平台路由规则

## Android 原生工程

Gradle 工程不一定是 Android 应用。选择 Android 流程前，应确认存在 Android 应用模块（`com.android.application`）、Android Manifest 或 Android 源码。

## Unity 边界

Unity 工程同时包含 `Assets/` 和 `ProjectSettings/`。MediaGo 当前没有官方 Unity SDK，因此不能从 Android API 推导 Unity 接入方案。应明确该限制，并建议客户联系 MediaGo 技术支持了解产品可用性。

## 混合仓库

某些 Unity 项目会导出或包含 Android 模块。不能默认该模块就是客户希望接入的目标；必须先请客户选择。客户选择后，仅在该模块的构建边界内执行 Android Skill。
