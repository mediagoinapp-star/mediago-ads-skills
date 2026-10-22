---
name: mediago-ads-android-integration
description: Integrate, upgrade, troubleshoot, audit, or validate the MediaGo Ads SDK in native Android Java or Kotlin projects, including direct integration, Client Bidding, and AdMob, AppLovin MAX, TradPlus, and TopOn adapters.
---

# MediaGo Ads Android Integration

Use this Skill for native Android MediaGo Ads work. It supports direct SDK integration, Client Bidding, and approved AdMob, AppLovin MAX, TradPlus, TopOn international, and TopOn legacy adapter paths. It does not support Unity, Flutter, React Native, iOS-only projects, or undocumented custom bridges.

## Non-negotiable rules

- Inspect the actual project first. Treat a claimed dependency, manifest entry, initialization, adapter, or version as unverified until project/build evidence confirms it.
- Do not modify Gradle files, manifests, source, ProGuard/R8 files, or run any Gradle command until the customer explicitly confirms the displayed plan.
- Do not use production App IDs/placement IDs from examples. Use official test configuration only after the customer explicitly asks for a test, demo, or validation.
- Do not claim success from source edits alone. Report only: **planned**, **changes applied**, **build passed**, or **device verified**.
- Do not claim legal/privacy/store compliance. Do not upload source, credentials, full logs, App IDs, placement IDs, or internal URLs.

Read [integration state and hard gates](references/integration-state.md) before implementation, migration, audit, or troubleshooting work.

## 1. Identify the request

Classify the request as one of:

- new direct SDK integration;
- add an ad format to a direct integration;
- AdMob, MAX, TradPlus, TopOn international, or TopOn legacy adapter integration;
- Client Bidding integration;
- migration or upgrade;
- build, manifest, initialization, load, show, callback, or no-fill troubleshooting;
- integration audit.

For a question, error-code lookup, or conceptual guidance, answer from approved references without modifying the project. For an explicit request to implement or repair code, continue with the gates below.

## 2. Inspect without changes

Read only the target module's Gradle settings/build files, version catalog if present, app manifest, application/initialization entry point, existing MediaGo references, and target language. Use `scripts/inspect_android_project.sh` only as a read-only supplement; constrain its scope to the selected module if the repository contains multiple apps.

Report a compact fact snapshot:

```text
Target module / Java or Kotlin / Gradle DSL
minSdk / compileSdk / AGP / Gradle / JDK when available
Direct SDK and adapter declarations and resolved-version evidence
Maven Central availability
Initialization owner and first-load timing evidence
Manifest activities, permissions, process overrides, and merger evidence
Selected integration path, missing prerequisite, conflict, or unknown fact
```

Read [official sources](references/official-sources.md) when a versioned fact is needed.

## 3. Verify the selected path

Select exactly one path before generating implementation code:

- **Direct SDK:** the app owns `AdMaster.initialize` and MediaGo ad APIs.
- **Adapter:** the selected mediation platform owns the documented adapter lifecycle. Do not add direct initialization merely by habit.
- **Client Bidding:** the app owns concurrent demand requests, expiration checks, price comparison, and win/loss reporting. Use this only when the customer explicitly owns the on-device auction; it is not an adapter path.

For TopOn, inspect the installed family before choosing an adapter:

- `com.thinkup.sdk:core-tpn` → international TopOn;
- `com.anythink.sdk:core-tpn` → legacy TopOn.

If the integration path, resolved dependency, approved version, or initialization ownership is unknown, explain the blocker and request only the evidence needed to resolve it. Do not write code yet.

Read [project prerequisites](references/project-prerequisites.md), [direct integration](references/direct-integration.md), [mediation adapters](references/mediation-adapters.md), [Client Bidding](references/client-bidding.md), and [compatibility](references/compatibility.md) as applicable.

## 4. Plan and obtain explicit confirmation

Present the exact file changes and the narrowest verification command. Include dependency/version changes, manifest impact, initialization ownership, test-vs-production configuration, and expected risks.

Ask one explicit confirmation question. Wait. If a newly discovered change is necessary after approval, explain it and ask again before making that change.

## 5. Implement the approved scope

Read the relevant reference before writing code:

- [ad formats](references/ad-formats.md)
- [multi-process](references/multi-process.md)
- [privacy](references/privacy.md)
- [migration](references/migration.md)
- [test credentials](references/test-credentials.md)

Keep a single in-flight load per logical placement unless the approved API documents otherwise. Retain ads only until consumption, clean them up at documented terminal points, and preserve a host-app fallback for every failed load/show.

## 6. Verify and report

After approval, run the narrowest meaningful Gradle task first. Inspect dependency resolution, compilation, and manifest-merger output. Use [acceptance checklist](references/acceptance-checklist.md) and [verification](references/verification.md) for the selected format/path.

State the highest evidence level actually obtained and any remaining customer-side step. For a diagnostic escalation, read [telemetry and support](references/telemetry-and-support.md) before requesting or sending evidence.

## Reference map

- Gates and evidence: [integration state](references/integration-state.md)
- Versioned fact precedence: [official sources](references/official-sources.md)
- Gradle, Maven Central, Manifest baseline: [project prerequisites](references/project-prerequisites.md)
- Direct initialization: [direct integration](references/direct-integration.md)
- Formats: [ad formats](references/ad-formats.md)
- Mediation: [mediation adapters](references/mediation-adapters.md)
- Client Bidding: [Client Bidding](references/client-bidding.md)
- Multi-process: [multi-process](references/multi-process.md)
- Privacy/permissions: [privacy](references/privacy.md)
- Upgrade/migration: [migration](references/migration.md)
- Test configuration: [test credentials](references/test-credentials.md)
- Errors: [troubleshooting](references/troubleshooting.md)
- Validation: [acceptance checklist](references/acceptance-checklist.md) and [verification](references/verification.md)
- Compatibility release data: [compatibility](references/compatibility.md)
