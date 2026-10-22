# 隐私合规设置指南（GDPR / CCPA / COPPA）

MediaGo / AdMaster Android SDK 支持海外主流隐私合规框架（GDPR IAB TCF v2、CCPA、COPPA）及细粒度设备信息采集控制。建议在用户完成合规授权后、`AdMaster.initialize(...)` 或首次发起广告请求前完成设置。

---

## 1. GDPR 合规配置（IAB TCF v2 自动读取）

SDK 内置 `CMPGdprHelper`，会自动从宿主应用的默认 `SharedPreferences`（`PreferenceManager.getDefaultSharedPreferences(context)`）中读取标准 **IAB TCF v2** 字段，无需额外调用专有方法：

| `SharedPreferences` Key | 类型 | 默认值 | 含义说明 |
| --- | --- | --- | --- |
| `IABTCF_gdprApplies` | `int` | `0` | GDPR 是否适用（`1` = 适用，`0` = 不适用） |
| `IABTCF_TCString` | `String` | `""` | IAB TCF v2 透明与同意字符串（TC String） |
| `IABTCF_AddtlConsent` | `String` | `""` | Google Additional Consent 附加同意字符串（AC String） |

### 1.1 使用标准 CMP SDK（推荐）

若宿主已接入符合 IAB TCF v2 标准的 CMP（例如 Google UMP SDK `com.google.android.ump:user-messaging-platform`、OneTrust 等），CMP 会在用户授权后自动将上述三个字段写入默认 `SharedPreferences`，SDK 会在请求广告时自动读取并透传。

### 1.2 自研弹窗手动写入示例

若宿主使用自研隐私弹窗同步状态，可按标准 Key 写入默认 `SharedPreferences`：

```java
import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

public static void saveGdprConsent(Context context, int gdprApplies, String tcString, String addtlConsent) {
    SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(context.getApplicationContext());
    prefs.edit()
            .putInt("IABTCF_gdprApplies", gdprApplies)       // 1 = 适用 GDPR, 0 = 不适用
            .putString("IABTCF_TCString", tcString)          // IAB TCF v2 字符串
            .putString("IABTCF_AddtlConsent", addtlConsent)  // 可选：AC 字符串
            .apply();
}
```

---

## 2. CCPA / COPPA 与限制个性化广告推荐

当用户位于美国加州等适用 CCPA 地区并选择 **“Do Not Sell or Share My Personal Information”**，或应用面向受 COPPA 保护的儿童用户群体、或用户在应用内拒绝个性化广告时，请开启**限制个性化广告开关**。

### 核心 API 签名

```java
package cc.admaster.android.proxy.api;

// 方式一：通过 AdMasterSetting 全局单例设置
AdMasterSetting.getInstance().setLimitPersonalAds(boolean limit);
boolean isLimited = AdMasterSetting.getInstance().isLimitPersonalAds();

// 方式二：通过 MobadsPermissionSettings 静态方法设置（同步通知底层容器）
MobadsPermissionSettings.setLimitPersonalAds(boolean limit);
boolean status = MobadsPermissionSettings.getLimitPersonalAdsStatus();
```

- 参数说明：
  - `true`：**限制**个性化广告推荐（适用于 CCPA 拒绝出售/共享、COPPA 儿童保护模式、GDPR 拒绝个性化）
  - `false`（默认）：**允许**个性化广告推荐

### 代码示例

```java
import cc.admaster.android.proxy.api.AdMasterSetting;
import cc.admaster.android.proxy.api.MobadsPermissionSettings;

public static void applyPrivacyRestriction(boolean restrictPersonalizedAds) {
    // 建议同时设置两处，确保主包与底层容器立即同步生效
    AdMasterSetting.getInstance().setLimitPersonalAds(restrictPersonalizedAds);
    MobadsPermissionSettings.setLimitPersonalAds(restrictPersonalizedAds);
}
```

---

## 3. 细粒度设备权限与信号开关（`MobadsPermissionSettings`）

若宿主对特定设备信号采集有合规裁剪诉求，可在初始化前通过 `cc.admaster.android.proxy.api.MobadsPermissionSettings` 控制：

```java
import cc.admaster.android.proxy.api.MobadsPermissionSettings;

// 默认值为 false 的敏感权限（仅在宿主已获授权且需要开启时传 true）：
MobadsPermissionSettings.setPermissionReadDeviceID(false); // 是否允许读取 IMEI/PhoneState（默认 false）
MobadsPermissionSettings.setPermissionLocation(false);     // 是否允许读取地理位置（默认 false）
MobadsPermissionSettings.setPermissionStorage(false);      // 是否允许读写外部存储（默认 false）
MobadsPermissionSettings.setPermissionAppList(false);      // 是否允许读取安装应用列表（默认 false）

// 默认值为 true 的常规信号（如需主动关闭可传 false）：
MobadsPermissionSettings.setPermissionOAID(true);          // 是否允许读取 OAID（默认 true）
MobadsPermissionSettings.setPermissionDeviceInfo(true);    // 是否允许读取常规设备信息（默认 true）
MobadsPermissionSettings.setPermissionAppUpdate(true);     // 是否允许读取应用更新状态（默认 true）
MobadsPermissionSettings.setPermissionRunningApp(true);    // 是否允许读取运行中应用状态（默认 true）
```
