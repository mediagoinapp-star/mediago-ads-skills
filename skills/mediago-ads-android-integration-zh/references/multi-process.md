# 多进程

插屏和激励视频会展示 Activity。如果广告请求发生在 MediaGo 展示 Activity 注册进程之外，修改 Manifest 前必须先检查实际进程模型。

若广告稳定在一个进程请求，可考虑文档规定的 Activity 进程覆盖；若请求进程不固定，可能需要客户继承文档指定的 MediaGo 展示 Activity，并通过 `AdActivityController` 动态设置。此为高级接入：必须展示 Manifest 和源码变更、获得确认，并在目标进程验证。没有请求进程证据时，不得全局修改 `android:process`。
