# MediaGo Ads Skills

[English](README.md) | [简体中文](README_zh.md)

Official AI Agent Skills for integrating, upgrading, auditing, and troubleshooting the **MediaGo Ads SDK** (`cc.admaster.android:sdk`) in customer applications. Designed for **Claude Code, Cursor, OpenAI Codex, GitHub Copilot, Windsurf, Cline, Roo Code, Antigravity**, and other `SKILL.md`-compatible coding agents.

---

## What Can These Skills Do?

### 1. Automatic Project Detection & Routing (`mediago-ads-integration`)
- Inspects your repository structure read-only and routes your request to the right workflow:
  - **Native Android projects** (`settings.gradle[.kts]`, `com.android.application`, `AndroidManifest.xml`) → routed to `mediago-ads-android-integration`.
  - **Unity / Tuanjie Android Bridge projects** (`Assets/Plugins/Android/`, `*Dependencies.xml`, `mainTemplate.gradle`, `AndroidJavaObject` / `AndroidJavaProxy`) → routed to `mediago-ads-unity-android-integration`.
  - **Mixed repositories** → identifies modules and confirms the target module before making changes.

### 2. Native Android Full-Lifecycle Integration (`mediago-ads-android-integration`)

#### A. Three Integration Modes
| Mode | Supported Capabilities |
|---|---|
| **Direct SDK Integration** | Configures `mavenCentral()` and `cc.admaster.android:sdk:2.0.38`, generates single-owner `AdMaster.initialize(...)` + `AdMasterSetting` in `Application`, and ensures ads load only after `InitCallback.onInitialized()`. |
| **Client Bidding (In-App Bidding)** | Implements concurrent demand requests, real-time eCPM retrieval (`getResponseInfo().getEcpmLevel()`), readiness validation (`isReady()`), win/loss notifications (`notifyWin` before `show`, `notifyLoss` with integer `ecpm` and `reason` such as `102` before `destroy()`). |
| **Mediation Adapters (5 Platforms)** | Integrates **Google AdMob**, **AppLovin MAX**, **TradPlus**, **TopOn International (`com.thinkup`)**, and **TopOn Legacy (`com.anythink`)**. Automatically selects the right Maven artifact, outputs dashboard Custom Event class names & JSON parameter keys (`app_id` + `ad_unit_id` for AdMob; `app_id` + `placement_id` for others). |

#### B. All 5 Ad Formats (Java & Kotlin Ready)
| Ad Format | Core SDK Classes (`cc.admaster.android.proxy.api.*`) | What the Skill Implements |
|---|---|---|
| **Rewarded Video** | `RewardedAd`, `AdLoadCallback<RewardedAd>`, `FullScreenContentCallback`, `OnUserEarnedRewardListener` | Preloading, valid `Activity` checks (`!isFinishing() && !isDestroyed()`), single-grant reward delivery in `onUserEarnedReward(RewardItem)`, and terminal `destroy()` cleanup. |
| **Interstitial** | `ExpressInterstitialAd`, `AdLoadCallback<ExpressInterstitialAd>`, `FullScreenContentCallback` | Full-screen interstitial loading, readiness checks (`isReady()`), display callbacks, and host-app fallback when ads fail to load or show. |
| **Splash Ad** | `SplashAd`, `AdLoadCallback<SplashAd>`, `FullScreenContentCallback` | Supports preload + `show(ViewGroup)` or one-step `SplashAd.loadAndShow(...)`, container visibility validation, timeout guard, and safe navigation to the main screen. |
| **Native Ad (Self-Render)** | `NativeAdLoader`, `NativeAd`, `NativeAdLoadListener`, `NativeAdInteractionListener` | Custom layout binding (title, description, icon, media/image views), interactive view registration (`registerViewForInteraction`), and list/page recycling cleanup. |
| **Banner Ad** | `BannerAdLoader`, `BannerAd`, `AdMBannerView`, `BannerAdListener` | Loads `BannerAd` asynchronously, binds it to `AdMBannerView` (`setAdSize(widthDp, heightDp)` + `setBannerAd(ad)`), attaches to container, and cleans up on destroy. |

#### C. Advanced Configuration, Auditing & Troubleshooting
- **Manifest & Component Verification**: Verifies merged `MainProcessAdActivity` and `FileProvider` declarations in Manifest Merger outputs.
- **Privacy & Regional Consent APIs**: Configures **GDPR IAB TCF v2** (`IABTCF_gdprApplies`, `IABTCF_TCString`, `IABTCF_AddtlConsent` in default `SharedPreferences`), **CCPA / COPPA personalized ad restrictions** (`AdMasterSetting.getInstance().setLimitPersonalAds(boolean)` and `MobadsPermissionSettings.setLimitPersonalAds(boolean)`), and fine-grained device signal permissions (`MobadsPermissionSettings`).
- **Error Code Lookup & Diagnosis**: Built-in lookup table for 7-digit client `AdError` codes (`1010001`–`4030007`), 4-digit server codes (`2000`, `3000~3004`, `4000~4004`, `1000~1999`), and Mediation Adapter codes (AdMob `100~104`, TopOn `1001~1007`).
- **Official Test Credentials**: Built-in official test App ID (`ad2fd73dca2ccffd312495bcd8a33d29`) and placement IDs for all 5 ad formats (Rewarded `100090001`, Interstitial `100090002`, Native `100090003`, Splash `100090004`, Banner `100090005`) for immediate demo/QA verification.
- **Upgrade, Migration & Integration Audit**: Verifies Gradle/AGP/JDK/SDK compatibility (`compatibility/compatibility.json`), R8/ProGuard keep rules, manifest merger outputs, and memory-leak risks.

### 3. Unity / Tuanjie Android Bridge (`mediago-ads-unity-android-integration`)
- Audits and integrates MediaGo Ads in Unity Android projects across four evidence layers:
  1. **EDM4U dependency declarations** (`*Dependencies.xml`)
  2. **Android Gradle & Manifest templates** (`Assets/Plugins/Android/mainTemplate.gradle`, `settingsTemplate.gradle`, `AndroidManifest.xml`)
  3. **C# JNI bridge code** (`AndroidJavaClass`, `AndroidJavaObject`, `AndroidJavaProxy`, and main-thread callback dispatching)
  4. **Exported Gradle / build verification** (never directly edits generated `Library/Bee/Android/` outputs)

---

## How the Workflow Protects Your Project

1. **Read-Only Inspection First**: Scans your Gradle files, version catalogs (`libs.versions.toml`), manifests, and existing code before proposing changes.
2. **File-Level Plan & Explicit Confirmation**: Displays exact file modifications, dependency versions, and verification commands, and **waits for your explicit approval** before editing any file or running Gradle.
3. **Evidence-Based Reporting**: Never claims "integration succeeded" from code edits alone—reports exact verification stages: **Planned → Changes Applied → Build Passed → Device Verified**.

---

## Quick Installation

> **Tip**: Install **either** the English skill set or the Chinese (`-zh`) skill set in a project to avoid duplicate routing.

### Option 1: Universal `npx skills` CLI (Recommended)
Works with **Cursor, Claude Code, Codex, GitHub Copilot, Windsurf, Cline, Roo Code, Antigravity**, and 20+ agents:

```bash
# Interactive install (choose skills & target IDE)
npx skills add mediagoinapp-star/mediago-ads-skills

# Or install English Android skills directly
npx skills add mediagoinapp-star/mediago-ads-skills \
  --skill mediago-ads-integration \
  --skill mediago-ads-android-integration

# Or install Chinese Android skills directly
npx skills add mediagoinapp-star/mediago-ads-skills \
  --skill mediago-ads-integration-zh \
  --skill mediago-ads-android-integration-zh
```

### Option 2: Claude Code Plugin Marketplace
Run inside Claude Code:

```text
/plugin marketplace add mediagoinapp-star/mediago-ads-skills
# Install English skills:
/plugin install mediago-ads@mediago-ads-skills
# Or install Chinese skills:
/plugin install mediago-ads-zh@mediago-ads-skills
```

### Option 3: Manual Installation
Clone this repository and copy the desired folders under `skills/` into your project's agent skill directory:
- **Cursor**: `.cursor/skills/`
- **Claude Code**: `.claude/skills/`
- **Codex / Universal Agents**: `.agents/skills/`

### Option 4: Companion MCP Server (Recommended alongside Skills)
Pair these skills with the official [**`mediago-ads-mcp`**](https://github.com/mediagoinapp-star/mediago-ads-mcp) MCP server for deterministic SDK compatibility queries, code template generation, mediation parameter JSON generation, 3-layer error code diagnosis, and 10-stage Logcat funnel trace analysis:

```json
{
  "mcpServers": {
    "mediago-ads-mcp": {
      "command": "npx",
      "args": ["-y", "github:mediagoinapp-star/mediago-ads-mcp"]
    }
  }
}
```

---

## Skill Directory Index

| Skill Directory | Language | Description |
|---|---|---|
| `skills/mediago-ads-integration` | English | Project type detector and workflow router |
| `skills/mediago-ads-android-integration` | English | Native Android Java/Kotlin integration, adapters, Client Bidding, and troubleshooting |
| `skills/mediago-ads-unity-android-integration` | English | Unity / Tuanjie Android bridge via EDM4U, Gradle templates, and C# JNI |
| `skills/mediago-ads-integration-zh` | 简体中文 | 识别客户工程类型并路由至受支持的工作流 |
| `skills/mediago-ads-android-integration-zh` | 简体中文 | Android 原生 Java/Kotlin 直连、Client Bidding、聚合 Adapter 接入与排障 |
| `skills/mediago-ads-unity-android-integration-zh` | 简体中文 | Unity / 团结引擎 Android 桥接（EDM4U + Gradle 模板 + C# JNI）接入与审查 |

---

## Example Prompts by Scenario

- **New Direct SDK Integration**:
  > "Use the MediaGo Android skill to inspect my project and plan a direct SDK integration for Rewarded and Interstitial ads using official test credentials."
- **Add a Specific Ad Format (Native / Banner / Splash)**:
  > "Help me integrate a MediaGo self-rendered NativeAd (`NativeAdLoader` + `NativeAd` + `registerViewForInteraction`) in my Kotlin feed fragment."
- **Mediation Adapter Setup (AdMob / MAX / TradPlus / TopOn)**:
  > "Check my Android app module, integrate the MediaGo AppLovin MAX adapter, and tell me the exact Custom Network class name and parameters to configure in the MAX dashboard."
- **Client Bidding Integration**:
  > "Add MediaGo Client Bidding (`getResponseInfo().getEcpmLevel()`, `isReady()`, `notifyWin`, `notifyLoss`) to our existing `RewardedAd` manager."
- **Error Code & No-Fill Troubleshooting**:
  > "We are getting MediaGo error code `1030003` (or `1040004` / `2000` / `4000`) when loading an interstitial ad. Diagnose the cause in our codebase."
- **Integration Audit / SDK Upgrade**:
  > "Audit our current MediaGo SDK integration for lifecycle leaks, missing R8 rules, or initialization timing issues."

---

## Safety and Support Boundaries

- Does **not** upload source code, production credentials, App IDs, placement IDs, or full logs.
- Never overwrites production App IDs / placement IDs with test credentials unless explicitly requested for demo/testing.
- Technical SDK guidance is not legal advice. App owners remain responsible for privacy notices, consent flows (CMP), data disclosures, and store-policy compliance.
