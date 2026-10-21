# Multi-process support

Interstitial and rewarded formats present Activities. If ads are requested outside the process in which MediaGo's display Activity is registered, inspect the actual process model before modifying the manifest.

For one stable ad process, the documented Activity process override may be appropriate. For variable request processes, a customer-owned subclass of the documented MediaGo display Activity plus `AdActivityController` may be required. Treat this as an advanced integration: show the manifest and source changes, ask for confirmation, and test in the target process. Never change `android:process` globally without evidence of the request process.
