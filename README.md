# MediaGo Ads Skills

[English](README.md) | [简体中文](README_zh.md)

Official Agent Skills for integrating, upgrading, auditing, and troubleshooting the **MediaGo Ads SDK** (`cc.admaster.android:sdk`) in customer applications.

## Supported Capabilities (SDK `2.4.0`)

- **Native Android (Java & Kotlin)**:
  - **Direct SDK Integration**: `AdMaster.initialize`, `RewardedAd`, `ExpressInterstitialAd`, `SplashAd`, `NativeAdLoader` (`NativeAdView` / `AdMediaView`), and `BannerAdLoader` (`AdMBannerView`).
  - **Client Bidding**: Concurrent auction rules, expiration check (`isExpired()`), `notifyWin` / `notifyLoss` reporting, and `LossReason` (`102` for higher competing bid).
  - **Mediation Adapters**: Google AdMob (`cc.admaster.android:adapter`), AppLovin MAX (`cc.admaster.android:max-adapter`), TradPlus (`cc.admaster.android:tradplus-adapter`), TopOn International (`cc.admaster.android:topon-adapter`), and TopOn Legacy (`cc.admaster.android:topon-secmtp-adapter`).
  - **Multi-process, Privacy & Troubleshooting**: `AdActivityController`, GDPR / US Privacy (CCPA) / COPPA APIs, and complete `AdError` lookup tables.
- **Unity / Tuanjie Android Bridge**:
  - Audits and integrates MediaGo through EDM4U (`*Dependencies.xml`), Android Gradle/Manifest templates, and C# `AndroidJavaObject` / `AndroidJavaProxy` bridge code.

---

## Quick Installation

> **Tip**: Install **either** the English skill set or the Chinese (`-zh`) skill set for a project to avoid duplicate routing.

### Option 1: Universal `npx skills` CLI (Cursor, Claude Code, Codex, Copilot, Windsurf, Cline, Antigravity)

```bash
# Interactive install
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

---

## Available Skills

| Skill Directory | Language | Purpose |
|---|---|---|
| `skills/mediago-ads-integration` | English | Detects project type and routes to the supported workflow |
| `skills/mediago-ads-android-integration` | English | Native Android Java/Kotlin integration, adapters, Client Bidding, and troubleshooting |
| `skills/mediago-ads-unity-android-integration` | English | Unity/Unity-China Android bridge via EDM4U, Gradle templates, and JNI |
| `skills/mediago-ads-integration-zh` | 简体中文 | 识别客户工程类型并路由至对应工作流 |
| `skills/mediago-ads-android-integration-zh` | 简体中文 | Android 原生 Java/Kotlin 直连、Client Bidding、聚合 Adapter 接入与排障 |
| `skills/mediago-ads-unity-android-integration-zh` | 简体中文 | Unity/团结引擎 Android 桥接（EDM4U + Gradle 模板 + C# JNI）接入与审查 |

---

## Example Prompts

- **Direct Integration**:
  > "Use the MediaGo Android skill to inspect my project and plan a direct SDK integration for Rewarded and Interstitial ads using test credentials."
- **Mediation Adapter**:
  > "Check my Android app module and help me integrate the MediaGo AppLovin MAX adapter."
- **Client Bidding**:
  > "Help me add MediaGo Client Bidding (`notifyWin` / `notifyLoss`) to my existing RewardedAd loader."
- **Troubleshooting**:
  > "We are getting MediaGo error code `1030003` when loading an ad. Diagnose the cause in our codebase."

---

## Safety and Support Boundaries

The Android Skill inspects a project first, presents a file-level change plan, and requires explicit confirmation before modifying Gradle files, Android manifests, application source code, or running a build. It never uploads source code, customer credentials, or full logs.

Technical SDK guidance is not legal advice. App owners remain responsible for privacy notices, consent flows, data disclosures, and store-policy compliance.
