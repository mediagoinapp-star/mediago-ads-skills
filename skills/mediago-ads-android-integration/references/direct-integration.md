# Direct SDK integration

## Initialization gate

Initialize MediaGo before requesting any ad, normally once in `Application.onCreate`. A request before successful initialization can fail with a not-initialized error. Keep customer App IDs out of source control where the project already uses a configuration mechanism.

The public API uses `AdMaster.initialize(context, appId, callback)`. Load ads only after the initialization success callback. Read actual project code to choose Java or Kotlin and to avoid introducing a second `Application` or duplicate initialization.

Debug logging is test/development-only. Do not enable it in a production build without the customer's explicit request.

## Request ownership

Build an `AdRequest` for each load as required by the selected API. Keep a single in-flight load per logical placement unless the documented format/API explicitly supports another policy. Ensure a load failure returns control to the host app's normal UX.

## Direct vs adapter

Do not mix a direct integration implementation and a mediation adapter for the same inventory path unless the customer and platform documentation explicitly require it. In adapter workflows, adapter-owned initialization may supersede a direct initialization call.
