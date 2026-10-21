# 工程前置条件

## 基线

当前 Android 支持基线为 `minSdk 21` 和 `compileSdk 34` 或更高版本。发现较低版本时应报告其为前置问题，不得静默修改。

MediaGo 产物发布于 Maven Central。检查构建实际使用的仓库配置是否包含 `mavenCentral()`：

- Gradle 7+：通常为 `settings.gradle(.kts)` 中的 `dependencyResolutionManagement.repositories`；
- 较旧工程：通常为根构建文件中的 `allprojects.repositories`。

未确认仓库模型前，不要重复添加仓库块。

## SDK 直连依赖

使用客户支持版本对应的 SDK 坐标，通常为：

```gradle
implementation "cc.admaster.android:sdk:<approved-version>"
```

面向客户发布时优先使用已批准的固定版本。不要在生产工程中静默添加动态版本 `+`；应解释风险并遵循客户的版本策略。

## 权限与 Manifest

网络权限由 SDK 内部声明。Android 13+ 的 `com.google.android.gms.permission.AD_ID` 为可选权限，仅在客户需要 Advertising ID 时才相关。不得因为旧示例工程包含某些权限，就添加定位、存储、电话状态、安装或其他敏感权限。

提出 MediaGo Activity、Provider 或进程覆盖前，先检查合并 Manifest 的输入，保留客户已有的 manifest placeholder，并避免重复 authority。
