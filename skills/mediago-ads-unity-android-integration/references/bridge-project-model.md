# Unity Android bridge project model

Typical source-of-truth locations are:

- EDM dependency declaration: `Assets/**/Editor/*Dependencies.xml`;
- Gradle dependency template: `Assets/Plugins/Android/mainTemplate.gradle`;
- repository template: `Assets/Plugins/Android/settingsTemplate.gradle`;
- manifest template: `Assets/Plugins/Android/AndroidManifest.xml`;
- native glue: `Assets/Plugins/Android/*.androidlib`;
- bridge implementation: C# files using `AndroidJavaObject` or `AndroidJavaProxy`.

`Library/Bee/` or other exported Gradle directories are generated evidence only. Compare them against templates after an approved resolve/export; never patch them directly.

Check callback ownership carefully: Java callbacks may not execute on Unity's main thread. The bridge must dispatch before interacting with Unity UI, scenes, or game state. Full-screen Ads can involve both Unity lifecycle changes and a separate Android Activity; native ads can involve both a Unity holder and Android Views. Both sides need explicit terminal cleanup.
