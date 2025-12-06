# Quick Setup Guide

## First Time Setup

### 1. Install Flutter
```bash
# macOS (using Homebrew)
brew install --cask flutter

# Or download from: https://docs.flutter.dev/get-started/install
```

### 2. Verify Flutter Installation
```bash
flutter doctor
```

Fix any issues reported by `flutter doctor`.

### 3. Install Dependencies
```bash
cd frontend
flutter pub get
```

## Running the App

### On Android Emulator
```bash
# Start an Android emulator first, then:
cd app
flutter run
```

### On Physical Android Device
1. Enable Developer Options on your Android device
2. Enable USB Debugging
3. Connect device via USB
4. Run:
```bash
cd app
flutter run
```

## Building APK

### Debug APK (for testing)
```bash
cd app
flutter build apk --debug
```

### Release APK (for distribution)
```bash
cd app
flutter build apk --release
```

APK location: `app/build/app/outputs/flutter-apk/app-release.apk`

## Project Architecture

## Common Commands

```bash
# Clean build artifacts
flutter clean

# Get dependencies
flutter pub get

# Run app
flutter run

# Build release APK
flutter build apk --release

# Check for issues
flutter analyze

# Format code
flutter format .
```

## Troubleshooting

**App crashes on startup:**
- Check `flutter doctor` for issues
- Try `flutter clean && flutter pub get`

**Build errors:**
- Ensure Android SDK is installed
- Check `android/local.properties` exists
- Run `flutter doctor --android-licenses`

