# Privacy and permissions

This reference describes technical integration points, not legal advice. Ask the customer whether an existing consent/age-gating flow owns these settings; do not create one unilaterally.

- On Android 13+, request/declaration of `AD_ID` is optional and should match the customer's Advertising ID and policy requirements.
- For GDPR/EEA, MediaGo can use standard IAB TCF values stored in the documented preferences. Set consent state before advertising requests.
- For CCPA/CPRA and child-directed/mixed-audience handling, use the documented MediaGo permission settings only according to the customer's policy decision and before requests.
- Do not state that adding an API call makes an app compliant. Remind the customer to complete required notices, consent, disclosure, and store forms.
