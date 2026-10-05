# Agent notes

For a coding agent working in this repo. `README.md` and `CONTRIBUTING.md` are the human documents.

Every task moves through four beats: isolate on a branch, build, prove with evidence, ship a PR carrying that evidence.

## What this repo is

`CatchlightAppleStorage`, the Apple-platform storage both Catchlight apps use:

- `EncryptedTakeStore`: the production `TakeStore`. SQLite (the system `SQLite3` module) with every Take and Sequence sealed per item by CatchlightCore's `TakeCrypto`. Schema v2, `PRAGMA user_version = 2`.
- `MasterKeyKeychain` and `MnemonicKeychain`: the master key and the Privacy phrase in the Keychain.
- `EnglishWordlist`: the BIP-39 English list, bundled and checked by SHA-256 before use.

It moved here from `Considus/Catchlight-iOS` on 2026-10-03 with its history, so the iPhone and the Mac share one copy instead of two that drift. CatchlightCore stays free of storage and Keychain code; this package is where the Apple-only parts live.

Consumers pin an exact version in their `project.yml`. This package takes Core as `upToNextMinor`, so the app's exact Core pin decides which Core it builds against. A Core minor bump needs a release here first.

## Isolate

```bash
git fetch origin
gh pr list -R Considus/Catchlight-AppleStorage
git checkout -b <type>/<short-name> origin/main
```

Stage by explicit path. A fresh clone needs the committed hooks wired up once:

```bash
git config core.hooksPath hooks
```

## Build

🚨 **This code holds the owner's real notes and the only key to them.** The rules below each come from a measured failure on a real device; the comments at each site say which.

- The database schema, the Keychain service (`com.considus.catchlight`), the accounts (`master-key`, `privacy-phrase`), the access group and the stored key format (the `0x01` / `0x02` prefix) are on-device contracts. Changing one needs a migration both apps agree before it ships.
- Every Keychain item is `kSecAttrSynchronizable: false` and `kSecAttrAccessibleWhenUnlockedThisDeviceOnly`.
- Every Keychain query carries `kSecUseDataProtectionKeychain: true`. Without it a Mac query goes to the legacy file keychain, which ignores access groups and access control. iOS ignores the attribute.
- Keychain writes are update-then-add. Delete-then-add only on `errSecInteractionNotAllowed`, because a kill between the two leaves no key on disk.
- `kSecUseAuthenticationUISkip` is not used anywhere. It has caused three separate defects here (see `MnemonicKeychain.exists()`).
- The caller passes the database folder: the iPhone its App Group container, the Mac its Application Support folder. Nothing here reaches for a container itself.

No network code. No third-party dependencies without agreeing it first.

## Prove

```bash
BUILD_DIR="$HOME/CatchlightBuild"
swift test --scratch-path "$BUILD_DIR/appleStorage"
```

Read the test count, never the word "passed". The suite includes Core's `TakeStoreContractTests` run against `EncryptedTakeStore` (from `CatchlightCoreTestSupport`).

The Keychain suite skips under `swift test` and on CI with OSStatus -34018: the data-protection keychain needs a signed process holding the `keychain-access-groups` entitlement. Each app runs it in its signed, app-hosted test bundle, so a Keychain change is proven there before it merges here.

CI runs the suite on macOS (`swift test`) and on the iOS simulator (`xcodebuild test -scheme CatchlightAppleStorage`), oldest and newest runtimes.

## Ship

Run `/code-review` locally before opening the PR. Every PR gets one automatic Claude review (`.github/workflows/claude-review.yml`); after a push, add the `re-review` label so the review covers the new head (remove it first if it is on). Closing and reopening also works but re-runs Greptile, which spends a credit. A release is a tag (`X.Y.Z`) on `main` after the PR merges; each app then takes it through its own pin bump.
