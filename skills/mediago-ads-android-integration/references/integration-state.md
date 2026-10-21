# Integration state and hard gates

Treat each fact as **unknown** until it is verified from the customer project or an approved versioned source.

## State record

Maintain this compact record while working:

```text
project: Android app module / language / Gradle DSL
path: direct | admob | max | tradplus | topon-international | topon-legacy
sdk: requested / resolved / approved version
adapter: requested / resolved / approved version
initialization: absent | present-unverified | verified
credentials: absent | test-only | customer-provided
verification: planned | changes-applied | build-passed | device-verified
```

Do not infer a resolved dependency from a declared dependency. Do not infer initialization success from finding an `AdMaster.initialize` call.

## Hard gates

### Gate A — supported project

Proceed only after confirming an Android application module. If a Unity-only project is found, stop and use the router boundary.

### Gate B — selected path

Before code generation, confirm one path: direct SDK, AdMob, MAX, TradPlus, TopOn international, or TopOn legacy. Do not mix direct and adapter lifecycles for the same inventory without an approved documented exception.

### Gate C — resolved dependencies

Before writing MediaGo API code, verify the relevant SDK/adapter is actually resolved by the target app variant. Prefer an approved Gradle dependency-report/build result. Reading a Gradle declaration is a preliminary signal only.

If verification needs a Gradle command, show the exact command and request confirmation first.

### Gate D — initialization

For direct integration, verify a single application-level initialization path and that the first load happens only after initialization success. For adapter integration, follow the adapter's documented initialization ownership; do not add direct initialization by default.

### Gate E — change approval

After Gates A-D, show file changes and the verification command. Wait for explicit approval before editing, building, or resolving dependencies.

## Stop conditions

Stop and explain the missing evidence when: the Android module is unclear; the adapter family is ambiguous; no approved compatibility entry exists; the customer has not approved a required edit/build; or a requested platform is unsupported.
