# Contributing to Catchlight AppleStorage

Thanks for taking a look. This package holds people's private notes on their own devices, and the key to them, so the constraints below aren't house style. They're the reason the app is worth having.

## Before you write anything

Read [`README.md`](README.md), and the encryption rules in [Catchlight-Core](https://github.com/Considus/Catchlight-Core), which this package builds on and never works around.

Some things here are already on people's phones, so changing them is never a tidy-up. That covers the database layout, the Keychain names the items are stored under and the way the stored key is laid out. A change to any of them needs a migration the apps have agreed before it ships, because existing Takes and keys are written that way.

## Development setup

```bash
BUILD_DIR="$HOME/CatchlightBuild"
swift test --scratch-path "$BUILD_DIR/appleStorage"
```

The Keychain tests skip outside a signed app. If your change touches the Keychain, say so in the PR, because it has to be proven in an app's signed test build before it merges.

## Pull requests

- Every PR has to pass `swift test` with no regressions, and say how many tests ran.
- No analytics, no telemetry, nothing sent off the device. Ever.
- Keychain items never sync to iCloud and only open while the device is unlocked.
- Follow the code style that's already there, comments included, since most of them record something that broke on a real device.
- No third-party dependencies without talking about it first.

## Security issues

Please don't open a public issue for a security vulnerability. [`SECURITY.md`](SECURITY.md) says how to report one privately.
