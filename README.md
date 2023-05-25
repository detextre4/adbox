# adbox

Welcome to your new adbox (Anonymous disscusion box) project and to the internet computer development community. By default, creating a new project adds this README and some template files to your project directory. You can edit these template files to customize your project and to include your own code to speed up the development cycle.

Quick Start
dfx installed to your local machine, making sure you can deploy canister to your local machine.
flutter installed, and use flutter doctor -v make sure everything works
flutter pub get before running this example.
If you want to use MacOS to debug, make sure macos/Runner/DebugProfile.entitlements and macos/Runner/Release.entitlements have content below
<dict>
    ...
    <key>com.apple.security.network.client</key>
    <true/>
</dict>
Deploy canister use dfx deploy, the adbox canister will be running on your local replica. Make sure you put the adbox canister id inside .dfx/local/canister_ids.json to your main.dart, the json like this:
{
    "__Candid_UI": {
        "local": "x2dwq-7aaaa-aaaaa-aaaxq-cai"
    },
    "adbox": {
        "local": "x5cqe-syaaa-aaaaa-aaaxa-cai"
    }
}
inside main.dart, you should change settings with canisterId to your actual id.
 Future<void> initCanister({Identity? identity}) async {
     
     // initialize adbox, change canister id here
     adbox = ADBoxCanister(canisterId: 'x5cqe-syaaa-aaaaa-aaaxa-cai', url: 'http://localhost:8000');
     // set agent when other paramater comes in like new Identity
     await adboxCanister?.setAgent(newIdentity: identity);
     
 }
start
flutter run
