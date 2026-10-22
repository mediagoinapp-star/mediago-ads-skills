# Compatibility Rules and Verified Matrix

## 1. Verification Principles (Hard Gate)

- Always check [`compatibility/compatibility.json`](../../../compatibility/compatibility.json) before editing `build.gradle(.kts)` or `libs.versions.toml`.
- Only recommend dependency combinations inside the support window with `verification_level: "release_verified"`.
- Never assume an arbitrary mediation SDK version and an older adapter version are compatible without checking.
- For TopOn, always inspect the project's existing dependencies to distinguish TopOn International (`com.thinkup.sdk:*`) from TopOn Legacy (`com.anythink.sdk:*`) before adding an adapter.

## 2. Current Verified Baseline (`release_verified`)

| Integration Route | Core SDK (`cc.admaster.android:sdk`) | Mediation Adapter Coordinate & Version | Host Mediation SDK Baseline | Verification Level |
| --- | --- | --- | --- | --- |
| **Direct / Client Bidding** | `2.0.38` (window: `>=2.0.20 <=2.0.38`) | None (uses `cc.admaster.android.proxy.api.*` directly) | None | `release_verified` |
| **AdMob Mediation** | `2.0.38` | `cc.admaster.android:adapter:1.0.0` | `com.google.android.gms:play-services-ads:23.0.0` | `release_verified` |
| **AppLovin MAX Mediation** | `2.0.38` | `cc.admaster.android:max-adapter:1.0.1` | `com.applovin:applovin-sdk:13.0.1` | `release_verified` |
| **TradPlus Mediation** | `2.0.38` | `cc.admaster.android:tradplus-adapter:0.0.6` | `com.tradplusad:tradplus:15.7.0.1` | `release_verified` |
| **TopOn International** | `2.0.38` | `cc.admaster.android:topon-adapter:0.0.4` | `com.thinkup.sdk:core-tpn:6.5.36` (compatible with `6.6.x`) | `release_verified` |
| **TopOn Legacy** | `2.0.38` | `cc.admaster.android:topon-secmtp-adapter:0.0.3` | `com.anythink.sdk:core-tpn:6.5.10` | `release_verified` |

## 3. Build & Runtime Compatibility Requirements

- **`minSdkVersion`**: Minimum supported by the SDK is `19` (`21+` recommended for native Android apps; `23+` typical for Unity/Tuanjie exports with Firebase).
- **`compileSdkVersion` / `targetSdkVersion`**: `34` or `35` recommended.
- **Transitive Dependencies**:
  - The SDK uses `androidx.media3:media3-exoplayer:1.4.0` and `com.google.guava:guava:33.3.1-android`.
  - If the host app pins a conflicting `media3-exoplayer` version, align the version in Gradle resolution strategies.
