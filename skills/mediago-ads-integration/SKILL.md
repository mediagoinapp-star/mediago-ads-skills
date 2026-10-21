---
name: mediago-ads-integration
description: Identify a customer project and route MediaGo Ads SDK integration, upgrade, troubleshooting, or validation requests to the supported platform workflow. Use when the app framework is unspecified or unclear.
---

# MediaGo Ads Integration Router

Use this skill only to identify the customer's project and select the supported workflow. Do not generate MediaGo SDK calls, modify files, or perform an integration in this router.

## Inspect before asking

At the project root, inspect filenames and directories without modifying anything.

- **Native Android:** `settings.gradle`, `settings.gradle.kts`, an Android application module, or `AndroidManifest.xml`.
- **Unity:** both `Assets/` and `ProjectSettings/`.
- **Mixed project:** Unity markers plus one or more independent native Android modules.

Read [platform routing](references/platform-routing.md) when the project is mixed or cannot be identified reliably.

## Route

- Native Android only: load and follow `mediago-ads-android-integration`.
- Unity only: state that MediaGo does not currently provide an official Unity SDK. Do not propose embedding the Android AAR, fabricate C# APIs, or claim Unity support.
- Mixed Unity + native Android: ask which module should receive the integration. Route only if the customer chooses the independent Android module.
- Unknown: ask one concise question: “Is this a native Android project, a Unity project, or a project with an independent Android module?”

When routing, state the selected workflow and preserve the user's original request. The Android workflow will inspect the project and seek confirmation before any modification or build.
