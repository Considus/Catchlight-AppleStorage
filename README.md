# Catchlight AppleStorage

This is where Catchlight keeps your Takes and your key on an iPhone or a Mac. The encryption itself lives in [Catchlight-Core](https://github.com/Considus/Catchlight-Core), and this package is the part that puts the result on disk and the key in the Keychain. The [iPhone](https://github.com/Considus/Catchlight-iOS) and [Mac](https://github.com/Considus/Catchlight-MacOS) apps both build against it, so the two can't quietly end up storing things differently.

It's public for the same reason Core is. Catchlight promises that you hold the key to your Takes and nobody else does, me included, and the code that decides where that key sits is the code you'd want to read before believing me.

## What's in it

The database. It's SQLite, and every Take goes in sealed on its own with AES-256-GCM, using Core's per-Take keys, so the text, the checklists and the reminders never touch the disk as plain-text. All that's left readable is the id, the two timestamps and whether a Take is your Obie, which the database needs to sort and find things and which say nothing about what you wrote. The file is marked to stay out of backups, and on the iPhone it's protected until you first unlock after a restart.

The key. Your master key goes in the Keychain, never syncs to iCloud, and never leaves the device. Where the hardware has a Secure Enclave, the key is wrapped by one that only that chip can unwrap, so reading it means Face ID, Touch ID or your passcode. Where there isn't one, the Keychain item itself asks for you before it hands the key over. Your Privacy phrase sits beside it under the same rule.

The wordlist. The 2048 English words a Privacy phrase is made from, the standard BIP-39 list, checked against a pinned SHA-256 every time it loads, because a single wrong word would make phrases that no other BIP-39 tool can read back.

The sync folder. The code that reads and writes the folder you pick for sync, iCloud Drive or anything else that shows up as a folder. It only ever moves sealed Takes and the signed index of them, and it can't open either. The app keeps a bookmark so it can find the folder again after a relaunch, and the system hands that bookmark back to Catchlight and nothing else.

Nothing in here talks to a network. Core stays free of storage and Keychain code, which is why it can build for other platforms, and this package is where the Apple-only parts went.

## Building it

```bash
BUILD_DIR="$HOME/CatchlightBuild"
swift test --scratch-path "$BUILD_DIR/appleStorage"
```

That runs the database tests, including Core's own store contract against the real SQLite store. The Keychain tests skip, and that's expected. The Keychain only opens up to a signed app carrying the right entitlement, and `swift test` isn't one. Each app runs them in its own signed test build.

## Using it in an app

Add it as a Swift package and pin an exact version:

```swift
.package(url: "https://github.com/Considus/Catchlight-AppleStorage", exact: "1.0.0")
```

It takes Core within a minor version, so the exact Core version your app pins is the one it builds against. Tell the store where its folder lives, an App Group container on the iPhone, Application Support on the Mac, and it never goes looking for one itself.

## Licence

Apache 2.0, in [`LICENSE`](LICENSE), with the notice in [`NOTICE`](NOTICE). If you've found a way to read a Take or a key you shouldn't be able to, please tell me privately, as [`SECURITY.md`](SECURITY.md) describes, rather than in an issue.
