# 平台路由规则

## Android 原生工程

Gradle 工程不一定是 Android 应用。选择 Android 流程前，应确认存在 Android 应用模块（`com.android.application`）、Android Manifest 或 Android 源码。

## Unity Android Bridge 边界

Unity 工程同时包含 `Assets/` 和 `ProjectSettings/`。MediaGo 当前没有官方独立 Unity SDK/package；但具备 Android 目标证据的 Unity/团结引擎工程可以采用受支持的 **Unity Android Bridge 工作流**：通过 EDM4U/Gradle Template 引入 Android SDK，由经过审核的 C# `AndroidJavaObject`/`AndroidJavaProxy` bridge 承担调用和回调。

若存在 `Assets/Plugins/Android/`、EDM `*Dependencies.xml`、Android Gradle/Manifest Template 或 bridge 代码，路由至 `mediago-ads-unity-android-integration`。不得将该路径称作官方 Unity SDK、编造 C# API 签名，或修改 `Library/` 下生成的 Gradle 输出。

## 混合仓库

某些 Unity 项目会导出或包含 Android 模块。不能默认该模块就是客户希望接入的目标；必须先请客户选择。客户选择后，仅在该模块的构建边界内执行 Android Skill。
