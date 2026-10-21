# Verification

## Evidence levels

State results precisely:

1. **Planned** — no project modifications applied.
2. **Changes applied** — files changed, but not built.
3. **Build passed** — the approved Gradle task completed successfully.
4. **Device verified** — a tester observed the intended load/show/callback behavior on a device.

## Test credentials

Use official MediaGo test credentials only when the customer explicitly requests a test, demo, or validation and has not supplied appropriate credentials. Clearly label every use as test-only and remove or isolate it before a production build. Do not place credentials in committed source by default.

## Minimum format checks

For the selected format, verify initialization, load success or actionable failure, display eligibility, display/dismiss or native interaction callbacks, and host-app fallback behavior. Rewarded flows also require explicit confirmation that the reward is granted only by the reward callback.
