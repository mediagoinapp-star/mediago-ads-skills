# Mediation adapters

Inspect the installed mediation SDK and its version before changing dependencies. Explain the intended adapter and configuration path, then request confirmation before editing Gradle or code.

## AdMob

Use the MediaGo AdMob adapter version compatible with the installed Google Mobile Ads SDK and MediaGo SDK. Extra MediaGo values are passed via AdMob network extras. The adapter manages the adapter integration lifecycle; do not automatically add a second direct MediaGo ad request path.

## AppLovin MAX

Use the MediaGo MAX adapter version compatible with the customer's MAX SDK. Format-specific local extras use MAX's local extra parameter mechanism. Use the MAX lifecycle and callback APIs for the loaded inventory.

## TradPlus

Use the MediaGo TradPlus adapter and configure the documented MediaGo adapter class per ad format in the TradPlus dashboard. MediaGo app and placement identifiers are adapter credentials, not the TradPlus ad unit ID. Preserve the customer's existing TradPlus initialization and format callbacks.

## TopOn

Choose one adapter only after detecting the installed TopOn family:

- International: `com.thinkup.sdk:core-tpn` with the MediaGo TopOn adapter.
- Legacy: `com.anythink.sdk:core-tpn` with the MediaGo TopOn legacy/SecMTP adapter.

Configure the format-specific adapter class and MediaGo app/placement credentials in the appropriate TopOn console. Do not substitute adapter class names from memory; validate them against the versioned public MediaGo adapter documentation before publishing or modifying an integration.

## Common adapter checks

- avoid duplicate base SDK/adapters;
- align MediaGo and adapter versions through the approved compatibility matrix;
- do not make direct `AdMaster.initialize` calls solely by habit in an adapter flow;
- preserve the mediation platform's callback, consent, bidding, and dashboard configuration requirements;
- build after dependency changes and inspect dependency resolution conflicts.
