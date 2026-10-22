# Platform routing

## Native Android indicators

A Gradle project is not necessarily an Android application. Confirm an application module (`com.android.application`), an Android manifest, or Android source before selecting the Android workflow.

## Unity Android bridge boundary

A Unity project contains both `Assets/` and `ProjectSettings/`. MediaGo does not provide a standalone Unity SDK/package. However, a Unity/Unity-China project with Android-target evidence may use the supported **Unity Android bridge workflow**: EDM4U/Gradle templates supply the Android SDK, while reviewed C# `AndroidJavaObject`/`AndroidJavaProxy` bridge code owns calls and callbacks.

Route to `mediago-ads-unity-android-integration` when `Assets/Plugins/Android/`, an EDM `*Dependencies.xml`, Android Gradle/Manifest templates, or bridge code is present. Do not call this an official Unity SDK, fabricate C# API signatures, or edit generated `Library/` Gradle output.

## Mixed repositories

Some Unity projects export or contain a native Android module. Do not assume that module is the supported integration target. Ask the customer to choose it. Once chosen, use the Android Skill only within that module's build boundaries.
