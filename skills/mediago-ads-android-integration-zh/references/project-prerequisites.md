# 工程前置与依赖

## 1. 环境与构建要求

- **Android 最低系统版本**：`minSdkVersion 19`（建议宿主使用 `minSdk 21+`；若接入 Google Play Services Ads Identifier / AppSet，SDK 内置了 `tools:overrideLibrary` 兜底兼容 API 19/20）
- **编译与目标版本**：建议 `compileSdkVersion 34+`、`targetSdkVersion 34+`
- **Java 版本**：`JavaVersion.VERSION_1_8` 及以上
- **AndroidX**：工程需开启 `android.useAndroidX=true`

## 2. Maven 仓库配置

SDK 及官方聚合 Adapter 均发布在 `mavenCentral()`。请在工程根目录的 `settings.gradle(.kts)` 或顶层 `build.gradle(.kts)` 中确保已声明 `google()` 与 `mavenCentral()`：

### Groovy (`settings.gradle`)

```groovy
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}
```

### Kotlin DSL (`settings.gradle.kts`)

```kotlin
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}
```

## 3. Gradle 依赖坐标

> 版本号请优先核对仓库内 [`compatibility/compatibility.json`](../../../compatibility/compatibility.json) 中的 `release_verified` 基线（当前推荐核心 SDK 版本：`2.0.38`，最低推荐基线：`2.0.20`）。

| 模块类型 | Maven 坐标 | 当前推荐版本 | 适用场景 |
| --- | --- | --- | --- |
| **核心 SDK（必选）** | `cc.admaster.android:sdk` | `2.0.38` | 直客接入（Direct）、自研聚合 Client Bidding、以及所有三方聚合底层依赖 |
| **AdMob Adapter** | `cc.admaster.android:adapter` | `1.0.0` | Google AdMob 自定义事件聚合接入 |
| **AppLovin MAX Adapter** | `cc.admaster.android:max-adapter` | `1.0.1` | AppLovin MAX 自定义网络聚合接入 |
| **TradPlus Adapter** | `cc.admaster.android:tradplus-adapter` | `0.0.6` | TradPlus 自定义网络聚合接入（支持 Waterfall 与 C2S Bidding） |
| **TopOn 海外版 Adapter** | `cc.admaster.android:topon-adapter` | `0.0.4` | TopOn 海外版（`com.thinkup.sdk:*`）自定义网络接入 |
| **TopOn 旧版 Adapter** | `cc.admaster.android:topon-secmtp-adapter` | `0.0.3` | TopOn 旧版（`com.anythink.sdk:*`）自定义网络接入 |

### 应用模块依赖示例 (`app/build.gradle`)

```groovy
android {
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}

dependencies {
    // 核心 SDK（直客接入 & 所有模式必选）
    implementation 'cc.admaster.android:sdk:2.0.38'

    // 如走三方聚合，按宿主实际使用的聚合平台二选一/按需添加：
    // implementation 'cc.admaster.android:adapter:1.0.0'               // AdMob
    // implementation 'cc.admaster.android:max-adapter:1.0.1'           // AppLovin MAX
    // implementation 'cc.admaster.android:tradplus-adapter:0.0.6'      // TradPlus
    // implementation 'cc.admaster.android:topon-adapter:0.0.4'         // TopOn 海外版 (com.thinkup.sdk)
    // implementation 'cc.admaster.android:topon-secmtp-adapter:0.0.3'  // TopOn 旧版 (com.anythink.sdk)
}
```

## 4. AndroidManifest 与权限配置

SDK AAR 的 `AndroidManifest.xml` 已内置声明 `INTERNET` 权限及内部激励视频/落地页 Activity（`cc.admaster.android.proxy.api.MobRewardVideoActivity`、`cc.admaster.android.proxy.api.AppActivity`、`cc.admaster.android.proxy.api.BdShellActivity`），常规单进程接入无需手写注册这些 Activity。

针对出海 Android 13（API 33）及以上设备获取 GAID（Google Advertising ID）以提高广告填充和变现效率，建议在宿主 `app/src/main/AndroidManifest.xml` 中显式声明 `AD_ID` 权限：

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <!-- 推荐：用于获取 Google Advertising ID (GAID)，提升海外广告填充率与 eCPM -->
    <uses-permission android:name="com.google.android.gms.permission.AD_ID" />

</manifest>
```

## 5. 混淆配置（ProGuard / R8）

SDK AAR 已自带 `consumer-rules.pro`，开启 R8 / ProGuard 时会自动合并混淆规则。若宿主工程使用了极限自定义混淆配置，请确保保留以下公开 API 与 Adapter 入口类：

```proguard
-keep class cc.admaster.android.proxy.api.** { *; }
-keep class com.google.ads.mediation.admaster.** { *; }
-keep class cc.admaster.android.max.adapter.** { *; }
-keep class cc.admaster.android.tradplus.adapter.** { *; }
-keep class cc.admaster.android.topon.adapter.** { *; }
-keep class cc.admaster.android.topon.secmtp.adapter.** { *; }
```
