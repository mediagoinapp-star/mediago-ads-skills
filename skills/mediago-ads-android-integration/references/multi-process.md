# Multi-Process and Custom Ad Activity Configuration

> **When to Use**: Standard single-process apps do **not** need any configuration from this file. Only follow this guide if your app loads/shows ads in a non-default process or requires custom `taskAffinity` / activity routing for fullscreen ads.

---

## 1. Multi-Process Initialization Rule

- **Initialize in the process that requests and displays ads**: If your app loads or shows ads inside a secondary process (such as `:game` or `:ad`), you must call `AdMaster.initialize(context, appId, callback)` inside that process before issuing ad requests.
- When `Application.onCreate()` runs for multiple processes, check the current process name and initialize the SDK in every process that directly invokes ad APIs.

---

## 2. Option 1: Static `AndroidManifest.xml` Process Override

By default, the SDK AAR declares its fullscreen and landing-page activities in the default process:
- `cc.admaster.android.proxy.api.MobRewardVideoActivity` (used for Rewarded and Interstitial video playback)
- `cc.admaster.android.proxy.api.AppActivity` (used for built-in WebView landing pages)
- `cc.admaster.android.proxy.api.BdShellActivity`

If all ad calls occur inside a dedicated process (e.g., `:ad_process`), override `android:process` in your app's `AndroidManifest.xml`:

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

## 3. Option 2: Dynamic Activity Routing via `AdActivityController`

If your app runs ads across multiple processes or custom task stacks (`taskAffinity`) and needs to route Rewarded or Interstitial ads to custom `Activity` subclasses at runtime, use `cc.admaster.android.proxy.api.AdActivityController`.

### 3.1 API Signatures

```java
package cc.admaster.android.proxy.api;

public class AdActivityController {
    // Custom activity for RewardedAd (must extend MobVideoActivity)
    public static <T extends MobVideoActivity> void setRewardActivityClass(Class<T> clazz);

    // Custom activity for ExpressInterstitialAd (must extend MobVideoActivity)
    public static <T extends MobVideoActivity> void setInterstitialActivityClass(Class<T> clazz);
}
```

### 3.2 Implementation Steps

#### Step 1: Subclass `MobVideoActivity`

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

#### Step 2: Declare the Custom Activities in `AndroidManifest.xml`

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

#### Step 3: Register Before Calling `show(...)`

```java
import cc.admaster.android.proxy.api.AdActivityController;

// Configure before calling RewardedAd.show(...) or ExpressInterstitialAd.show(...):
AdActivityController.setRewardActivityClass(CustomRewardAdActivity.class);
AdActivityController.setInterstitialActivityClass(CustomInterstitialAdActivity.class);
```
