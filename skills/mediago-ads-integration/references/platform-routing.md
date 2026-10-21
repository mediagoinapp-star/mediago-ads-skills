# Platform routing

## Native Android indicators

A Gradle project is not necessarily an Android application. Confirm an application module (`com.android.application`), an Android manifest, or Android source before selecting the Android workflow.

## Unity boundary

A Unity project contains both `Assets/` and `ProjectSettings/`. There is no supported MediaGo Unity SDK at this time. The correct response is to identify the limitation and direct the customer to MediaGo support for product availability; it is not safe to derive a Unity integration from native Android APIs.

## Mixed repositories

Some Unity projects export or contain a native Android module. Do not assume that module is the supported integration target. Ask the customer to choose it. Once chosen, use the Android Skill only within that module's build boundaries.
