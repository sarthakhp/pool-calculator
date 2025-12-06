# Pool Calculator

A standalone Android app built with Flutter/Dart featuring a click counter with persistent local storage.

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Android Studio or VS Code with Flutter extensions
- Android device or emulator

## Setup Instructions

### 1. Install Flutter

Follow the official Flutter installation guide:
https://docs.flutter.dev/get-started/install

### 2. Install Dependencies

```bash
cd frontend
flutter pub get
```

### 3. Run the App

**On Android Emulator/Device:**
```bash
cd frontend
flutter run
```

**Build APK for Android:**
```bash
cd frontend
flutter build apk --release
```

The APK will be located at: `frontend/build/app/outputs/flutter-apk/app-release.apk`

### 4. Install APK on Android Device

Transfer the APK to your Android device and install it, or use:
```bash
flutter install
```
## Development

**Check for issues:**
```bash
cd frontend
flutter analyze
```

## Troubleshooting

**Issue: "Waiting for another flutter command to release the startup lock"**
```bash
killall -9 dart
```

**Issue: Dependencies not resolving**
```bash
cd frontend
flutter clean
flutter pub get
```

**Issue: Android build fails**
- Ensure Android SDK is properly installed
- Check `android/local.properties` has correct SDK path
- Try: `flutter doctor` to diagnose issues

