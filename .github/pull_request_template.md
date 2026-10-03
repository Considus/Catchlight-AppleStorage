<!-- Thanks for the pull request. Please fill in what applies and delete what doesn't. -->

## What this changes

<!-- The behaviour that is different after this merges, and why it needed doing. -->

## How it was tested

- [ ] `swift test`
- [ ] The apps that pin this package still pass their own tests against this change

## Non-negotiables

<!-- These are the constraints from README.md and CONTRIBUTING.md. A pull request that
     breaks one of them cannot be merged whatever else it does. Tick to confirm, or
     say below which one this touches and why. -->

- [ ] No analytics, no telemetry, no off-device data transmission
- [ ] Zero-knowledge and encryption-always-on still hold
- [ ] No change to the database schema, the Keychain service/account/access group, or the stored key format without a migration the apps have agreed
- [ ] No change to the on-disk format without a migration the apps have agreed
- [ ] No new third-party dependencies

## Anything else
