# A Secure Expense Tracking Android App for Small groups

Read the related [article](https://medium.com) (TBD) for this Repository.

## Requirements

* Flutter
* Firebase
* Node.js

## Running it yourself

### First Steps

#### Installing & Setting up

* Install Flutter and Start a Flutter Project
* Log into [Firebase Console](http://console.firebase.google.com) and start a Firebase Project
* Connect Flutter with Firebase
* Change Firebase Pricing Plan from Spark to Blaze to Enable Cloud Functions*

*This app uses cloud functions to implement custom authentication, using Firebase Cloud Functions. They are only available in the Blaze plan.

_Note: Even using Blaze you can deploy this app without expecting any substantial fees. Just do basic monitoring, code optimization and be alert of the usage fees._

#### Getting Started

1. Copy and replace the lib folder from this repository to your flutter project.
2. Make sure the following services are activated in Firebase Console:
   * Authentication
   * Firestore
   * Cloud Functions
3. Initialize firebase folder using Node inside your Flutter project, [See the How to.](https://firebase.google.com/docs/functions/get-started), we can update cloud functions, database rules from here.
4. Copy contents of firebase_ and (re)place them to `<your_project>/firebase`

#### Initialize Data and Functions

**Do the following in your Firebase Project's Console:**

1. In the Authenitcation panel:
   * Activate email/password sign-in.
   * Add (one or as many needed) new login credentials using the console GUI.
2. In Firestore:
   * ***Add PIN for each USER:***
   Create a new collection named finalAccessPins use the userID from Auth as the document ID and add a string field named *"pin"*, give it any value 4 digit value you want.
   * ***Add additional info for each USER:***
   Create a new collection named *"users"* use the last 7 characters of the userID from Auth as the document ID and add string field named *"displayName"*, which would be the display name for this user, add another string field named *"uniqueInitials"*, to give the user some special initials that makes it a unique string (like: Rm for Ramesh, Rk for Rakesh).
3. For Functions:
   * You can either run them via [local emulator](https://firebase.google.com/docs/functions/local-emulator) first (recommended) or just deploy them directly.

Now just run the application on your android emulator!

Design & Usage:

<img src="https://github.com/hrshtt/expense-tracking-flutter-firebase/blob/main/app_gifs/expense_tracker_landing.gif" width="300" height="600"/>

<img src="https://github.com/hrshtt/expense-tracking-flutter-firebase/blob/main/app_gifs/expense_tracker_unauth_pin.gif" width="300" height="600"/>

<img src="https://github.com/hrshtt/expense-tracking-flutter-firebase/blob/main/app_gifs/expense_tracker_add_payment.gif" width="300" height="600"/>
