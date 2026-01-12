# Deployment Guide

## Overview

This guide covers the deployment process for the Art of Evolve application to Android and iOS platforms.

## Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / Xcode
- Developer Accounts (Google Play Console, Apple Developer Program)

## Android Deployment

### 1. Update Version

Update the version in `pubspec.yaml`:

```yaml
version: 1.0.0+1
```

### 2. Signing Configuration

Ensure you have a `key.properties` file in `android/` referencing your keystore:

```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=your_key_alias
storeFile=../upload-keystore.jks
```

### 3. Build Release APK/Bundle

Generate the release bundle (preferred for Play Store):

```bash
flutter build appbundle --release
```

Or generate APK:

```bash
flutter build apk --release
```

### 4. Testing Release Build

Install the release build on a connected device:

```bash
flutter run --release
```

## iOS Deployment

### 1. Certificate & Provisioning

- Open `ios/Runner.xcworkspace` in Xcode.
- Go to **Signing & Capabilities**.
- Select your Team.
- Ensure a valid Distribution Certificate and Provisioning Profile are selected.

### 2. Update Version

Update version in Xcode or via `pubspec.yaml` (ensure `flutter pub get` is run).

### 3. Build Archive

1. Select **Product > Archive** in Xcode.
2. Once archived, the Organizer window will open.
3. Validate App.
4. Distribute App (Upload to App Store Connect).

## Web Deployment

### 1. Build for Web

```bash
flutter build web --release
```

### 2. Deploy

Deploy the contents of `build/web` to your hosting provider (Firebase Hosting, Vercel, Netlify, etc.).
For Firebase:
```bash
firebase deploy
```



## Release Checklist

- [ ] Update version in `pubspec.yaml`
- [ ] Update `CHANGELOG.md`
- [ ] Run all tests (`flutter test`)
- [ ] Verify no lint errors (`flutter analyze`)
- [ ] Check dependencies (`flutter pub outdated`)
- [ ] Build release binaries
- [ ] Test release build on physical device
- [ ] Tag release in git (`git tag -a v1.0.0 -m "Release v1.0.0"`)
