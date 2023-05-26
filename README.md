# ADBox Project

Welcome to your new adbox (Anonymous disscusion box) project and to the internet computer development community. By default, creating a new project adds this README and some template files to your project directory. You can edit these template files to customize your project and to include your own code to speed up the development cycle.

## Quick Start
1. `dfx` installed to your local machine, making sure you can deploy canister to your local machine.
2. `flutter` installed, and use `flutter doctor -v` make sure everything works
3. `flutter pub get` before running this example.
4. If you want to use MacOS to debug, make sure `macos/Runner/DebugProfile.entitlements` and `macos/Runner/Release.entitlements` have content below
    xml
    <dict>
        ...
        <key>com.apple.security.network.client</key>
        <true/>
    </dict>
    
5. Deploy canister use `dfx deploy`, the `ADBox` canister will be running on your local replica. Make sure you put the ADBoxCanister canister id inside `.dfx/local/canister_ids.json` to your `main.dart`, the json like this:
    json
    {
        "__Candid_UI": {
            "local": "x2dwq-7aaaa-aaaaa-aaaxq-cai"
        },
        "adbox_backend": {
            "local": "x5cqe-syaaa-aaaaa-aaaxa-cai"
        }
    }

6. inside `main.dart`, you should change settings with `canisterId` to your actual id.
   dart
    // initialize ADBoxCanister, change canister id here
    final adBoxCanister = ADBoxCanister(canisterId: "x5cqe-syaaa-aaaaa-aaaxa-cai", url: "http://localhost:8000",);

7. start
    bash
    flutter run
