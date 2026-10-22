# Bridge state and hard gates

Maintain:

```text
project: Unity/Unity-China version / Android target
path: direct-bridge | client-bidding-bridge | approved-adapter-bridge
dependency: EDM declaration / generated evidence / approved version
templates: dependency XML / mainTemplate / settingsTemplate / manifest / androidlib
bridge: C# owner / Java classes / callback interfaces / main-thread dispatch
verification: planned | changes-applied | build-passed | device-verified
```

Hard gates: confirm Unity Android target; identify editable source-of-truth files; confirm one integration path; verify an approved SDK/adapter version before version-specific bridge code; obtain plan approval before resolve/export/build/edit.

Never edit `Library/` or generated Gradle output. If a generated export differs from templates, report the difference and inspect the generator configuration before proposing a source change.
