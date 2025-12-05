# freq

A Digital Radio App for CSEN 268 by Karthik Tamil, Dana Steinke, Noelle Evanich.

# What is freq

Freq is a modern, clutter-free radio app built for a clean and intuitive listening experience, letting you browse thousands of stations worldwide while prioritizing nearby options for faster, more reliable playback. With smooth streaming, smart fallback visuals when stations lack icons, and a UI aligned with contemporary design standards, Freq makes discovering music effortless. It includes a searchable integrated radio database, system-theme alignment, the ability to save favorite stations to your home screen, and detailed station info such as tags and descriptions. Premium users can also remove sponsored listings to keep their listening space entirely distraction-free.

# Firebase Setup (For Anyone Cloning This Repo)

This project uses Firebase, but your own Firebase project must be connected when you clone the repo. For security reasons, the file `firebase_options.dart` is not included in the repository.

Follow these steps to generate your own configuration file.

## 1. Install Firebase CLI if you don’t already have it:
```sh
npm install -g firebase-tools
```
Login:
```sh
firebase login
```
## 2. Install FlutterFire CLI
```sh
dart pub global activate flutterfire_cli
```
Verify the installation:
```sh
flutterfire --version
```
## 3. Create a Firebase Project if you don’t have one
Go to: https://console.firebase.google.com/
Create a new project, then add an iOS, Android, or Web app depending on your project requirements.

## 4. Generate firebase_options.dart
From the root of the Flutter project, run:
```sh
flutterfire configure
```
This will:
- Detect your Firebase project
- Ask which platforms you want to configure
- Generate lib/firebase_options.dart
## 5. Run the App
```sh
flutter pub get
flutter run
```
Your project is now connected to your own Firebase backend.