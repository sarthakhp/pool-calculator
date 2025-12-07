# Pool Calculator

A Flutter web/mobile app for calculating pool/billiards shot angles and ball-to-ball contact fractions with cut-induced throw correction.

**Live Demo:** https://sarthakhp.github.io/pool-calculator/

## Features

- **Interactive Pool Table** - Drag and position cue ball, object ball, and target on a pool table
- **Draggable Target** - Move the target anywhere on the table to set your desired pocket or position
- **Angle Calculation** - Real-time calculation of the cut angle and fraction required for the shot
- **Cut-Induced Throw Correction** - Adjust friction and cue ball speed to compensate for throw effects
- **Sarthak Fraction** - Alternative fraction calculation method for aiming
- **Visual Overlap Indicator** - Shows two overlapping balls representing the contact fraction
- **Ghost Ball Visualization** - Displays the adjusted ghost ball position for accurate aiming
- **Shot Guide Overlay** - Visual lines showing the shot path from cue ball through object ball to target
- **Adjustable Ball Size** - Slider to adjust ball diameter (1-5 inches)
- **Adjustable Cue Ball Speed** - Control speed for throw calculation
- **Adjustable Friction** - Fine-tune friction coefficient for throw correction
- **Table Grid Overlay** - 6x3 grid overlay for position reference
- **Collapsible Side Panel** - Expandable/collapsible side deck with scrollable controls
- **Info Dialog** - Built-in help dialog explaining how to use the calculator
- **Persistent Storage** - Ball positions and settings are saved locally
- **Responsive Design** - Optimized for landscape mode on all screen sizes

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

