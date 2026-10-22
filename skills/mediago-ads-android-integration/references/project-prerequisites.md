# Project Prerequisites and Dependencies

## 1. Environment and Build Requirements

- **Minimum Android API Level**: `minSdkVersion 19` (`minSdk 21+` recommended for host apps; the SDK manifest includes `tools:overrideLibrary` for Google Play Services Ads Identifier / AppSet to remain compatible with API 19/20)
- **Compile / Target SDK**: `compileSdkVersion 34+` and `targetSdkVersion 34+` recommended
- **Java Compatibility**: `JavaVersion.VERSION_1_8` or higher
- **AndroidX**: Enable `android.useAndroidX=true` in `gradle.properties`

## 2. Maven Repository Configuration

Both the core SDK and official mediation adapters are published to `mavenCentral()`. Ensure `google()` and `mavenCentral()` are configured in your root `settings.gradle(.kts)` or top-level `build.gradle(.kts)`:

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

## 3. Gradle Dependency Coordinates

> Always verify target versions against [`compatibility/compatibility.json`](../../../compatibility/compatibility.json) (latest `release_verified` core SDK version: `2.0.38`; minimum recommended baseline: `2.0.20`).

| Module Type | Maven Coordinate | Verified Version | Use Case |
| --- | --- | --- | --- |
| **Core SDK (Required)** | `cc.admaster.android:sdk` | `2.0.38` | Direct integration, in-house Client Bidding, and base dependency for all mediation adapters |
| **AdMob Adapter** | `cc.admaster.android:adapter` | `1.0.0` | Google AdMob Custom Event mediation |
| **AppLovin MAX Adapter** | `cc.admaster.android:max-adapter` | `1.0.1` | AppLovin MAX Custom Network mediation |
| **TradPlus Adapter** | `cc.admaster.android:tradplus-adapter` | `0.0.6` | TradPlus Custom Network mediation (Waterfall & C2S Bidding) |
| **TopOn International Adapter** | `cc.admaster.android:topon-adapter` | `0.0.4` | TopOn International (`com.thinkup.sdk:*`) custom network mediation |
| **TopOn Legacy Adapter** | `cc.admaster.android:topon-secmtp-adapter` | `0.0.3` | TopOn Legacy (`com.anythink.sdk:*`) custom network mediation |

### App Module Dependency Example (`app/build.gradle`)

```groovy
android {
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}

dependencies {
    // Core SDK (required for direct integration and all mediation modes)
    implementation 'cc.admaster.android:sdk:2.0.38'

    // Optional: add ONLY the adapter matching your host mediation platform:
    // implementation 'cc.admaster.android:adapter:1.0.0'               // AdMob
    // implementation 'cc.admaster.android:max-adapter:1.0.1'           // AppLovin MAX
    // implementation 'cc.admaster.android:tradplus-adapter:0.0.6'      // TradPlus
    // implementation 'cc.admaster.android:topon-adapter:0.0.4'         // TopOn International (com.thinkup.sdk)
    // implementation 'cc.admaster.android:topon-secmtp-adapter:0.0.3'  // TopOn Legacy (com.anythink.sdk)
}
```

## 4. AndroidManifest and Permissions

The SDK AAR merges `INTERNET` permission and its built-in activities (`cc.admaster.android.proxy.api.MobRewardVideoActivity`, `cc.admaster.android.proxy.api.AppActivity`, `cc.admaster.android.proxy.api.BdShellActivity`) automatically. Standard single-process apps do not need to redeclare these activities manually.

For Android 13 (API 33+) overseas devices, declare the `com.google.android.gms.permission.AD_ID` permission in your host `app/src/main/AndroidManifest.xml` to allow Google Advertising ID (GAID) collection for better fill rates and eCPM:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <!-- Recommended: allows GAID collection on Android 13+ for better ad fill and eCPM -->
    <uses-permission android:name="com.google.android.gms.permission.AD_ID" />

</manifest>
```

## 5. ProGuard / R8 Rules

The SDK AAR ships with `consumer-rules.pro` which is applied automatically during R8/ProGuard minification. If your project uses aggressive custom shrinking rules, ensure the public API and adapter packages are kept:

```proguard
-keep class cc.admaster.android.proxy.api.** { *; }
-keep class com.google.ads.mediation.admaster.** { *; }
-keep class cc.admaster.android.max.adapter.** { *; }
-keep class cc.admaster.android.tradplus.adapter.** { *; }
-keep class cc.admaster.android.topon.adapter.** { *; }
-keep class cc.admaster.android.topon.secmtp.adapter.** { *; }
```
