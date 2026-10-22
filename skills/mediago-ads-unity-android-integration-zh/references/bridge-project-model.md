# Unity Android Bridge 工程模型

常见事实源：`Assets/**/Editor/*Dependencies.xml`、`Assets/Plugins/Android/mainTemplate.gradle`、`settingsTemplate.gradle`、`AndroidManifest.xml`、`*.androidlib` 与使用 `AndroidJavaObject`/`AndroidJavaProxy` 的 C# Bridge。

`Library/Bee/` 和导出的 Gradle 目录仅为生成证据，不得直接修改。经确认的 Resolve/导出后可用于与 Template 对比。

Java 回调可能不在 Unity 主线程；Bridge 在操作 Unity UI、场景或游戏状态前必须调度。全屏广告涉及 Unity 生命周期和独立 Android Activity；Native 广告涉及 Unity 容器和 Android View，两侧均需终态清理。
