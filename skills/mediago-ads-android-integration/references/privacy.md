# Privacy and Compliance Configuration (GDPR / CCPA / COPPA)

The MediaGo / AdMaster Android SDK supports major global privacy frameworks (GDPR IAB TCF v2, CCPA, COPPA) as well as fine-grained device signal controls. Configure these settings after user consent is collected and before calling `AdMaster.initialize(...)` or issuing your first ad request.

---

## 1. GDPR Configuration (Automatic IAB TCF v2 Lookup)

The SDK's internal `CMPGdprHelper` automatically reads standard **IAB TCF v2** keys from the host app's default `SharedPreferences` (`PreferenceManager.getDefaultSharedPreferences(context)`):

| `SharedPreferences` Key | Type | Default | Description |
| --- | --- | --- | --- |
| `IABTCF_gdprApplies` | `int` | `0` | Whether GDPR applies (`1` = applies, `0` = does not apply) |
| `IABTCF_TCString` | `String` | `""` | IAB TCF v2 Transparency and Consent String (TC String) |
| `IABTCF_AddtlConsent` | `String` | `""` | Google Additional Consent String (AC String) |

### 1.1 Using a Standard IAB TCF v2 CMP (Recommended)

If your app integrates a standard IAB TCF v2 CMP (such as Google UMP SDK `com.google.android.ump:user-messaging-platform` or OneTrust), the CMP automatically writes these keys into default `SharedPreferences`, and the SDK reads them automatically on every ad request.

### 1.2 Writing TCF Keys Manually from a Custom Consent Dialog

If your app uses a custom consent flow, write the standard keys to default `SharedPreferences`:

```java
import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

public static void saveGdprConsent(Context context, int gdprApplies, String tcString, String addtlConsent) {
    SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(context.getApplicationContext());
    prefs.edit()
            .putInt("IABTCF_gdprApplies", gdprApplies)       // 1 = GDPR applies, 0 = does not apply
            .putString("IABTCF_TCString", tcString)          // IAB TCF v2 consent string
            .putString("IABTCF_AddtlConsent", addtlConsent)  // Optional: Additional Consent string
            .apply();
}
```

---

## 2. CCPA / COPPA and Personalized Ads Restriction

When a user opts out of sale/sharing under CCPA (**"Do Not Sell or Share My Personal Information"**), when the app targets child users under COPPA, or when a user declines personalized ads, enable the **Limit Personalized Ads** flag.

### Core API Signatures

```java
package cc.admaster.android.proxy.api;

// 1. Global setting via AdMasterSetting singleton
AdMasterSetting.getInstance().setLimitPersonalAds(boolean limit);
boolean isLimited = AdMasterSetting.getInstance().isLimitPersonalAds();

// 2. Runtime container setting via MobadsPermissionSettings
MobadsPermissionSettings.setLimitPersonalAds(boolean limit);
boolean status = MobadsPermissionSettings.getLimitPersonalAdsStatus();
```

- Parameter values:
  - `true`: **Restrict** personalized ads (use for CCPA opt-out, COPPA child-directed mode, or non-personalized ads)
  - `false` (default): **Allow** personalized ads

### Code Example

```java
import cc.admaster.android.proxy.api.AdMasterSetting;
import cc.admaster.android.proxy.api.MobadsPermissionSettings;

public static void applyPrivacyRestriction(boolean restrictPersonalizedAds) {
    // Call both to ensure both the proxy layer and remote container apply the flag immediately
    AdMasterSetting.getInstance().setLimitPersonalAds(restrictPersonalizedAds);
    MobadsPermissionSettings.setLimitPersonalAds(restrictPersonalizedAds);
}
```

---

## 3. Fine-Grained Device Signal Controls (`MobadsPermissionSettings`)

If your app needs to restrict specific device signals for compliance, configure `cc.admaster.android.proxy.api.MobadsPermissionSettings` before initialization:

```java
import cc.admaster.android.proxy.api.MobadsPermissionSettings;

// Sensitive permissions (default = false; pass true only if granted and permitted by your privacy policy):
MobadsPermissionSettings.setPermissionReadDeviceID(false); // IMEI / PhoneState (default: false)
MobadsPermissionSettings.setPermissionLocation(false);     // Location access (default: false)
MobadsPermissionSettings.setPermissionStorage(false);      // External storage (default: false)
MobadsPermissionSettings.setPermissionAppList(false);      // Installed app list (default: false)

// General device signals (default = true; pass false to disable):
MobadsPermissionSettings.setPermissionOAID(true);          // OAID collection (default: true)
MobadsPermissionSettings.setPermissionDeviceInfo(true);    // Basic device info (default: true)
MobadsPermissionSettings.setPermissionAppUpdate(true);     // App update state (default: true)
MobadsPermissionSettings.setPermissionRunningApp(true);    // Running app state (default: true)
```
