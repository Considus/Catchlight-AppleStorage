# Agent notes

For a coding agent working in this repo. People start with [`README.md`](README.md) and [`CONTRIBUTING.md`](CONTRIBUTING.md); this file does not repeat them.

## Build

This code holds people's notes and the only key to them. Each rule below comes from a measured failure on a real device; the comment at each site says which.

- **Treat the database schema (`PRAGMA user_version`), the Keychain service (`com.considus.catchlight`), the accounts (`master-key`, `privacy-phrase`), the access group and the stored key format (the `0x01` / `0x02` prefix) as on-device contracts.** Changing one needs a migration both apps agree before it ships.
- **Make every Keychain item `kSecAttrSynchronizable: false` and `kSecAttrAccessibleWhenUnlockedThisDeviceOnly`.**
- **Put `kSecUseDataProtectionKeychain: true` on every Keychain query.** Without it a Mac query goes to the legacy file keychain, which ignores access groups and access control. iOS ignores the attribute.
- **Write Keychain items update-then-add.** Delete-then-add only on `errSecInteractionNotAllowed`, because a kill between the two leaves no key on disk.
- **Leave out `kSecUseAuthenticationUISkip`.** It has caused three separate defects here (see `MnemonicKeychain.exists()`).
- **Take the database folder from the caller:** the App Group container on the iPhone, Application Support on the Mac.
- **Keep Core as `upToNextMajor` in `Package.swift`.** Each app's exact Core pin then decides which Core it builds against, so a Core 1.x release needs no release here; a Core 2.0 would. The tests run against the newest Core 1.x, so a Core change that breaks this package shows up here too.

The Mac app pins an exact version in its `project.yml`, so a change here is live only after that pin moves. The iPhone app still has its own copy of this code (Catchlight-iOS `Catchlight/Database/`, `Catchlight/Security/`, `Catchlight/Sync/FileCloudFolder.swift`).

## Test

```bash
BUILD_DIR="$HOME/CatchlightBuild"
swift test --scratch-path "$BUILD_DIR/appleStorage"
```

Read the test **count**, not the word "passed". The suite includes Core's `TakeStoreContractTests` run against `EncryptedTakeStore`.

The Keychain suite skips under `swift test` and on CI with OSStatus -34018: the data-protection keychain needs a signed process holding the `keychain-access-groups` entitlement. Each app runs it in its signed, app-hosted test bundle, so a Keychain change is proven there before it merges here: say so in the PR.

CI (`.github/workflows/ci.yml`) runs the suite on macOS and on the iOS simulator, oldest and newest runtimes.

## Ship

1. Switch on the committed hooks once per clone: `git config core.hooksPath hooks`. `hooks/pre-commit` refuses a commit on `main`; `hooks/commit-msg` refuses a Claude attribution footer.
2. Check nobody is already on the work, then branch from `origin/main` by name:

   ```bash
   git fetch origin
   gh pr list -R Considus/Catchlight-AppleStorage
   git checkout -b <type>/<short-name> origin/main
   ```

3. Stage by explicit path, not with `git add -A`.
4. Open the PR against `main` and fill [`.github/pull_request_template.md`](.github/pull_request_template.md), with the test count as evidence.
