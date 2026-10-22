---
name: mediago-ads-unity-android-integration
description: Integrate, audit, upgrade, troubleshoot, or validate MediaGo Ads through a Unity or Unity-China Android bridge using EDM4U, Android Gradle/Manifest templates, and reviewed C# JNI bridge code. Use for Unity projects with Android-target or AndroidJavaObject/AndroidJavaProxy bridge evidence.
---

# MediaGo Ads Unity Android Bridge Integration

Use this Skill for Unity/Unity-China customer projects that target Android through a C#-to-Android bridge. This is not an official standalone Unity SDK. Do not invent C# APIs, derive Android signatures from memory, or edit generated `Library/` output.

## Non-negotiable rules

- Inspect the real Unity project first. Treat a declared EDM dependency, Gradle template, manifest entry, JNI class, callback interface, or SDK version as unverified until project/export evidence confirms it.
- Before changing an EDM XML file, Gradle/Manifest template, C# bridge, native Android library, Player setting, or before Force Resolve, export, Unity build, or Gradle command, show the plan and obtain explicit confirmation.
- Never modify `Library/`, generated Gradle projects, or generated merged manifests as source-of-truth files. Use them only as generated evidence.
- Do not use production App IDs, placement IDs, credentials, auction values, or complete logs from examples. Do not upload source, identifiers, credentials, full logs, or internal URLs.
- Report only **planned**, **changes applied**, **build passed**, or **device verified**. A successful C# compile or generated Gradle output alone is not device verification.

Read [bridge state and hard gates](references/bridge-state.md) before implementation, migration, audit, or troubleshooting.

## 1. Identify the request

Classify it as:

- new Unity Android bridge feasibility/integration;
- audit or repair of an existing bridge;
- direct SDK lifecycle/format addition through a bridge;
- EDM4U dependency, Gradle template, manifest, export, or build problem;
- Android Activity/full-screen/native-view lifecycle problem;
- migration or upgrade.

For a conceptual question, use approved references without changing the project. For an implementation or repair request, continue with the gates.

## 2. Inspect without changes

Read only the selected project's:

- `ProjectSettings/ProjectVersion.txt` and Android Player settings;
- `Packages/manifest.json` and `packages-lock.json`;
- EDM `*Dependencies.xml` files and generated dependency declarations;
- `Assets/Plugins/Android/` Gradle/settings/Manifest templates and `.androidlib` sources;
- C# `AndroidJavaObject` / `AndroidJavaProxy` bridge code, initialization owner, callback dispatch, and ad lifecycle owner;
- generated Gradle/manifest output only as corroborating evidence, if already present.

Report:

```text
Unity/Unity-China version and Android build target
EDM4U/version and dependency source of truth
SDK declared version, repository source, and generated/resolved evidence
Gradle/settings/Manifest template ownership and generated-output comparison
C# bridge classes, Java class/interface names, initialization owner, and callback-thread handling
Formats, Activity/native-view integration, cleanup, and unresolved facts
```

## 3. Verify the bridge path

Select exactly one inventory path: direct bridge, Client Bidding bridge, or an approved mediation adapter bridge. An existing mediation SDK elsewhere does not make a MediaGo direct bridge a mediation path.

For direct and Client Bidding bridges, verify one initialization owner and ensure MediaGo loads happen only after initialization success. For adapters, verify the adapter owns the documented lifecycle and do not add direct initialization by habit.

Exact Java class names, method signatures, callback interfaces, SDK versions, and adapter versions must come from an approved release entry. If the exported project uses a SNAPSHOT or lacks an approved compatibility entry, report it as a release blocker; do not invent compatibility.

Read [bridge project model](references/bridge-project-model.md), plus the Android Skill references for [direct integration](../mediago-ads-android-integration/references/direct-integration.md), [formats](../mediago-ads-android-integration/references/ad-formats.md), [mediation](../mediago-ads-android-integration/references/mediation-adapters.md), [Client Bidding](../mediago-ads-android-integration/references/client-bidding.md), and [compatibility](../mediago-ads-android-integration/references/compatibility.md) as applicable.

## 4. Plan and obtain explicit confirmation

Present the exact source-of-truth files, whether EDM Force Resolve/export/build is required, generated evidence to inspect, dependency/repository/manifest impact, JNI lifecycle impact, and narrowest verification command.

Bind approval to a plan identifier and digest. Any added file, command, dependency/version, permission, external data, or Android Player setting invalidates approval and requires a new plan.

## 5. Implement the approved scope

Keep C# bridge callbacks on the Unity main thread before touching Unity objects. Preserve a single in-flight load per logical placement unless the approved SDK API documents another policy. For full-screen ads, reconcile Unity pause/resume and Android Activity lifecycle without awarding rewards except on the documented reward callback. For native ads, clean up both the Android view/ad object and Unity-side holder at terminal disposal.

## 6. Verify and report

After approval, run the narrowest approved operation: Force Resolve, Android export, generated Gradle/manifest inspection, Unity Android build, then device test as needed. Generated Gradle output proves only export-time resolution; report device verification only after observing actual load/show/callback behavior on Android.

## Reference map

- Gates: [bridge state](references/bridge-state.md)
- Unity/EDM/templates/generated output: [bridge project model](references/bridge-project-model.md)
- Android SDK lifecycle and formats: [Android integration references](../mediago-ads-android-integration/references/)
