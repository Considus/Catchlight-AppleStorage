# Security

Catchlight AppleStorage is where an iPhone or a Mac keeps Catchlight's encrypted Takes and the key that opens them. The database holds every Take sealed on its own with AES-256-GCM, and the key sits in the Keychain, wrapped by the Secure Enclave where the device has one, never synced and never sent anywhere. There's no backend and there are no analytics, so if this goes wrong there's nothing else standing between someone's notes and whoever is looking. If you've found a way past it, I want to hear about it.

## Reporting a vulnerability

Please report security issues **privately**, and don't open a public issue or a pull request.

Email **security@considus.com**, or, if you'd rather keep it on GitHub, use the **Report a vulnerability** button on this repository's [Security tab](https://github.com/Considus/Catchlight-AppleStorage/security), which opens GitHub's private reporting. GitHub asks you to sign in first, and only you and I can see the report.

Tell me what you found, how to reproduce it, which version or commit it affects, and what it lets an attacker do. A proof of concept helps, but a clear description is plenty.

I'll acknowledge your report within **3 business days** and keep you posted while I look into it. This is coordinated disclosure, so please give me a reasonable amount of time to ship a fix before you make it public. You're welcome to the credit once it's out, or to stay anonymous, whichever you'd prefer.

The same terms cover every Considus project and both websites, catchlight.app and considus.com, and the policy page for this project is at [catchlight.app/security](https://catchlight.app/security/).

## What's in scope

Everything in this package, which means the database and what it leaves readable, file protection and backup exclusion, the Keychain items for the master key and the Privacy phrase, and the wordlist. The encryption design itself lives in [Catchlight-Core](https://github.com/Considus/Catchlight-Core) and is reported the same way.

Report a problem with the catchlight.app website by email, to security@considus.com.

Generally out of scope, anything that needs a jailbroken or otherwise compromised device, or physical access to a device that's already unlocked. Social engineering and denial of service are out too, along with findings in Apple's own platforms, because those aren't mine to fix.

## Safe harbour

You won't face legal action from me or from Considus for research done in good faith, so long as you avoid violating anyone's privacy, avoid destroying data, and follow this policy.

## Supported versions

The `main` branch gets security fixes, and so does the latest tagged release, which is the version the apps pin.
