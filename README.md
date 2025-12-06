# Pool Calculator

A Flutter web/mobile app for calculating pool/billiards shot angles and ball-to-ball contact fractions.

**Live Demo:** https://sarthakhp.github.io/pool-calculator/

## Features

- **Interactive Pool Table** - Drag and position cue ball and object ball on a pool table
- **Pocket Selection** - Click on any of the 6 pockets to set the target
- **Angle Calculation** - Real-time calculation of the cut fraction required for the shot
- **Fraction Display** - Shows the ball-to-ball contact fraction as a percentage
- **Sarthak Fraction** - Alternative fraction calculation method
- **Visual Overlap Indicator** - Shows two overlapping balls representing the contact fraction, with the cue ball position changing.
- **Ghost Ball Visualization** - Displays the ghost ball position for aiming reference
- **Shot Guide Overlay** - Visual lines showing the shot path from cue ball through object ball to pocket
- **Adjustable Ball Size** - Slider to adjust ball diameter (1-5 inches)
- **Adjustable Border Thickness** - Slider to adjust table border thickness
- **Table Grid Overlay** - 6x3 grid overlay for position reference
- **Persistent Storage** - Ball positions and settings are saved locally
- **Responsive Design** - Adapts to different screen sizes

## Prerequisites

- Flutter SDK (3.32.2 or higher)
- Android Studio or VS Code with Flutter extensions
- Web browser (for web version) or Android device/emulator

## Setup Instructions

### 1. Install Flutter

Follow the official Flutter installation guide:
https://docs.flutter.dev/get-started/install

### 2. Install Dependencies

```bash
cd app
flutter pub get
```

### 3. Run the App

**On Web:**
```bash
cd app
flutter run -d chrome
```

**On Android Emulator/Device:**
```bash
cd app
flutter run
```

**Build for Web:**
```bash
cd app
flutter build web --release
```

**Build APK for Android:**
```bash
cd app
flutter build apk --release
```

## Development

**Check for issues:**
```bash
cd app
flutter analyze
```

## Deployment

The app is automatically deployed to GitHub Pages on push to the `main` branch via GitHub Actions.

## Troubleshooting

**Issue: "Waiting for another flutter command to release the startup lock"**
```bash
killall -9 dart
```

**Issue: Dependencies not resolving**
```bash
cd app
flutter clean
flutter pub get
```

**Issue: Android build fails**
- Ensure Android SDK is properly installed
- Check `android/local.properties` has correct SDK path
- Try: `flutter doctor` to diagnose issues

