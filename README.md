# canteen_frontend

This is the codebase for the Canteen mobile app, written in Flutter.

## Development Notes

*** PLEASE READ THIS BEFORE YOU GET STARTED ***

* The build time is extremely long because `cloud_firestore` is a piece of shit. Right now the build time is between 10-15 minutes when you first run the build in debug mode. Subsequent builds should be faster because cocoa pods cache the build artifacts if they haven't changed.
    * https://github.com/FirebaseExtended/flutterfire/issues/349

## Getting Started

1. Clone the repo.
2. Start the iOS simulator.
3. Run in debug mode in your IDE of choice.
    * In VSCode, press F5.
4. Create your own account in the app.

