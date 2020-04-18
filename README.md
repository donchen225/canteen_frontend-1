# canteen_frontend

This is the codebase for the Canteen mobile app, written in Flutter.

## Development Notes

*** PLEASE READ THIS BEFORE YOU GET STARTED ***

* The build time is extremely long because `cloud_firestore` is a piece of shit. Right now the build time is between 10-15 minutes when you first run the build in debug mode. Subsequent builds should be faster (50-100s) because cocoa pods cache the build artifacts if they haven't changed.
    * https://github.com/FirebaseExtended/flutterfire/issues/349

## Getting Started

1. Clone the repo.
2. Set environment variables in `.env`.
3. Start the iOS simulator.
4. Run in debug mode in your IDE of choice.
    * In VSCode, press F5.
5. Create your own account in the app.

## Firestore collections

### Users

* `about`: `string` - The description of the user.
* `creation_time`: `timestamp` - When the user was created. The value is copied from Firebase Authentication.
* `display_name`: `string` - The display name of the user.
* `email`: `string` - The email address of the user.
* `is_anonymous`: `boolean` - Whether the user is anonymous.
* `is_email_verified`: `boolean` - Whether the user email address is verified.
* `last_sign_in_time`: `timestamp` - When the user last signed in.
* `learn_skill`: `map<string, Skill>` - The list of skills the user wants to learn.
* `phone_number`: `string` - The phone number of the user.
* `photo_url`: `string` - The URL of the user photo. Photo is stored in Firebase storage.
* `provider_id`: `string` - The method used for Firebase Authentication.
* `teach_skill`: `map<string, Skill>` - The list of skills the user wants to teach.

### Matches

* `user_id`: `map<string, int>` - The users in the match.
* `status`: `string` - The status of the match. Possible values:
    * `initialized`
    * `accepted`
    * `declined`

## Setting up algolia
1. Get `ALGOLIA_APP_ID` and `ALGOLIA_ADMIN_API_KEY` from Algolia and set in `.env`.
2. Create index on algolia.

## Developing functions locally

1. Set `.env` file.
2. Export environment variables from `.env` file `source .en

## Notes

* If using the Firebase Admin SDK in cloud functions, Firestore security rules are ignored.