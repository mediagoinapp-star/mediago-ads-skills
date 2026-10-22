# 多进程与自定义广告 Activity 配置（Multi-Process）

> **适用前提**：常规单进程应用**无需**阅读或修改本文件。仅当宿主 App 在子进程中触发广告、或需要将激励视频 / 插屏广告放到独立进程或自定义任务栈（`taskAffinity`）时，才需按本指南配置。

---

## 1. 多进程初始化原则

- **在哪个进程请求/展示广告，就在哪个进程完成初始化**：如果宿主在子进程（例如 `:game` 或 `:ad`）中调用广告 `load` / `show`，必须确保在该进程启动时同样调用了 `AdMaster.initialize(context, appId, callback)`。
- 若主进程和子进程都需要执行 `Application.onCreate()`，请通过进程名判断，在确实需要加载广告的进程中初始化 SDK。

---

## 2. 方案一：静态 `AndroidManifest.xml` 覆写进程属性

SDK 默认在 AAR 的 `AndroidManifest.xml` 中声明了以下组件：
- `cc.admaster.android.proxy.api.MobRewardVideoActivity`（激励视频与全屏插屏展示页）
- `cc.admaster.android.proxy.api.AppActivity`（内置落地页 WebView 容器）
- `cc.admaster.android.proxy.api.BdShellActivity`

若你的广告逻辑固定运行在指定子进程（如 `:ad_process`），可在宿主的 `app/src/main/AndroidManifest.xml` 中覆写 `android:process`：

```xml
<application>
    <activity
        android:name="cc.admaster.android.proxy.api.MobRewardVideoActivity"
        android:configChanges="screenSize|orientation|keyboardHidden|uiMode"
        android:theme="@style/bd_ad_fullscreen_opaque"
        android:process=":ad_process"
        android:exported="false"
        tools:replace="android:process,android:exported" />

    <activity
        android:name="cc.admaster.android.proxy.api.AppActivity"
        android:configChanges="screenSize|orientation|keyboardHidden|uiMode"
        android:theme="@android:style/Theme.Translucent.NoTitleBar"
        android:process=":ad_process" />
</application>
```

---

## 3. 方案二：通过 `AdActivityController` 动态绑定自定义广告 Activity

当宿主存在多个不同进程或不同 `taskAffinity` 的业务栈，需要在运行时动态指定激励视频或插屏广告所使用的 Activity 类时，可使用 `cc.admaster.android.proxy.api.AdActivityController`。

### 3.1 核心 API 签名

```java
package cc.admaster.android.proxy.api;

public class AdActivityController {
    // 自定义激励视频展示 Activity（必须继承自 MobVideoActivity）
    public static <T extends MobVideoActivity> void setRewardActivityClass(Class<T> clazz);

    // 自定义插屏展示 Activity（必须继承自 MobVideoActivity）
    public static <T extends MobVideoActivity> void setInterstitialActivityClass(Class<T> clazz);
}
```

### 3.2 实现步骤

#### 第一步：定义继承自 `MobVideoActivity` 的子类

```java
package com.example.app.ad;

import cc.admaster.android.proxy.api.MobVideoActivity;

public class CustomRewardAdActivity extends MobVideoActivity {
}
```

```java
package com.example.app.ad;

import cc.admaster.android.proxy.api.MobVideoActivity;

public class CustomInterstitialAdActivity extends MobVideoActivity {
}
```

#### 第二步：在 `AndroidManifest.xml` 中注册自定义 Activity

```xml
<application>
    <activity
        android:name="com.example.app.ad.CustomRewardAdActivity"
        android:configChanges="screenSize|orientation|keyboardHidden|uiMode"
        android:theme="@android:style/Theme.Translucent.NoTitleBar"
        android:process=":sub_process"
        android:exported="false" />

    <activity
        android:name="com.example.app.ad.CustomInterstitialAdActivity"
        android:configChanges="screenSize|orientation|keyboardHidden|uiMode"
        android:theme="@android:style/Theme.Translucent.NoTitleBar"
        android:process=":sub_process"
        android:exported="false" />
</application>
```

#### 第三步：在展示广告前注册到 `AdActivityController`

```java
import cc.admaster.android.proxy.api.AdActivityController;

// 在调用 RewardedAd.show(...) 或 ExpressInterstitialAd.show(...) 前设置：
AdActivityController.setRewardActivityClass(CustomRewardAdActivity.class);
AdActivityController.setInterstitialActivityClass(CustomInterstitialAdActivity.class);
```
