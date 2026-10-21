# SDK 直连接入

## 初始化门禁

请求任何广告前必须初始化 MediaGo，通常在 `Application.onCreate` 中仅初始化一次。首次直连请求发生在初始化成功前可能导致未初始化错误。公共 API 为 `AdMaster.initialize(context, appId, callback)`；仅在初始化成功回调后加载广告。

根据真实工程决定 Java/Kotlin 写法；不要为方便而创建第二个 `Application` 或重复初始化。客户已有配置机制时，App ID 应沿用现有机制，避免写入源码或版本控制。

Debug 日志只适用于开发/测试；除非客户明确要求，否则不要在生产构建中启用。

## 请求归属

按照选择的 API 为每次加载构建 `AdRequest`。同一逻辑广告位通常只保留一个进行中的加载请求，除非文档明确支持其他策略。加载失败时必须回到宿主应用的正常 UX。

## 直连与 Adapter

除非客户和平台文档明确要求，否则不要在同一广告流量路径上混用直连实现与聚合 Adapter。Adapter 流程中，Adapter 所管理的初始化可能取代直连 `AdMaster.initialize` 调用。
