# {{project_name.titleCase()}}

[![ci][ci_badge]][ci_badge_link]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

---

## Table of Contents

- [{{project_name.titleCase()}}](#{{project_name.paramCase()}})
  - [Table of Contents](#table-of-contents)
  - [Setup](#setup)
    - [Prerequisites](#prerequisites)
    - [Install Dependencies](#install-dependencies)
  - [Running the App](#running-the-app)
    - [Android/iOS](#androidios)
    - [Web](#web)
  - [Code Quality \& Metrics](#code-quality--metrics)
    - [Install DCM](#install-dcm)
    - [Activate License](#activate-license)
    - [Analyze Code](#analyze-code)
  - [App Icons \& Splash Screen](#app-icons--splash-screen)
    - [App Icons](#app-icons)
    - [Splash Screen](#splash-screen)
  - [Localization (i18n)](#localization-i18n)
    - [Adding/Editing Strings](#addingediting-strings)
    - [Adding a New Locale](#adding-a-new-locale)
  - [Testing \& Goldens](#testing--goldens)
    - [Run All Tests](#run-all-tests)
    - [Golden Tests](#golden-tests)
  - [Coverage](#coverage)

---

## Setup

### Prerequisites

- **FVM** (Flutter Version Management)
  - macOS: `brew tap leoafarias/fvm && brew install fvm`
  - Windows: `choco install fvm`
- **Make**
  - macOS: `brew install make`
  - Windows: `choco install make`

> **Tip:** The included `Makefile` provides shortcuts for common tasks.

### Install Dependencies

```sh
make rebuild
```

---

## Running the App

This project supports three flavors: `development`, `staging`, and `production`.

### Android/iOS

```sh
flutter run --flavor development --target lib/main.dart
flutter run --flavor staging --target lib/main.dart
flutter run --flavor production --target lib/main.dart
```

### Web

```sh
flutter run --dart-define flavor=development --target lib/main.dart
flutter run --dart-define flavor=staging --target lib/main.dart
flutter run --dart-define flavor=production --target lib/main.dart
```

---

## Code Quality & Metrics

This project uses [Dart Code Metrics (DCM)](https://dcm.dev/docs/quick-start/#install-dcm) for static analysis.

### Install DCM

- **macOS:**
  ```sh
  brew tap CQLabs/dcm
  brew install dcm
  ```
- **Linux:**
  ```sh
  sudo apt-get update
  wget -qO- https://dcm.dev/pgp-key.public | sudo gpg --dearmor -o /usr/share/keyrings/dcm.gpg
  echo 'deb [signed-by=/usr/share/keyrings/dcm.gpg arch=amd64] https://dcm.dev/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list
  sudo apt-get update
  sudo apt-get install dcm
  ```
- **Windows:**
  ```sh
  choco install dcm
  ```

### Activate License

1. Get a free license at [dcm.dev](https://dcm.dev/docs/quick-start/#get-a-license).
2. Activate:
   ```sh
   dcm activate --license-key=YOUR_KEY
   ```

### Analyze Code

```sh
dcm analyze lib
```

---

## App Icons & Splash Screen

### App Icons

- Place icon images in `assets/icons/`.
- Configure `icons_launcher.yaml` in the project root.
- Generate icons:
  ```sh
  make icons_launcher
  ```

### Splash Screen

- Place splash images in `assets/images/`.
- Configure `flutter_native_splash.yaml` in the project root.
- Generate splash screens:
  ```sh
  make native_splash
  ```

---

## Localization (i18n)

This project uses [slang](https://pub.dev/packages/slang) with `flutter_localizations` and `intl`.

### Adding/Editing Strings

1. Edit `assets/i18n/en.i18n.json`:
   ```json
   {
     "common": {
       "ok": "OK",
       "cancel": "Cancel"
     },
     "login": {
       "button_text": {
         "sign_in": "Sign In",
         "sign_up": "Sign Up"
       }
     }
   }
   ```
2. Run code generation:
   ```sh
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
3. Use in code:
   ```dart
   Text(context.i18n.login.button_text.sign_in)
   ```

### Adding a New Locale

1. Copy `en.i18n.json` to `assets/i18n/{locale}.i18n.json` (e.g., `es.i18n.json`).
2. Translate values.
3. Update `ios/Runner/Info.plist`:
   ```xml
   <key>CFBundleLocalizations</key>
   <array>
     <string>en</string>
     <string>es</string>
   </array>
   ```

---

## Testing & Goldens

### Run All Tests

```sh
# macOS
make lcov_mac

# Windows
make lcov_win
```

### Golden Tests

- Generate goldens:
  ```sh
  # macOS
  make goldens_mac
  # Windows
  make goldens_win
  ```
- Update goldens threshold:
  - Edit `goldenTestsThreshold` in `test/flutter_test_config.dart` (`TestConfig` class).

---

## Coverage

- Generate coverage report:
  ```sh
  # macOS
  make lcov_report_mac
  # Windows
  make lcov_report_win
  ```

---


[ci_badge]: https://github.com/VeryGoodOpenSource/very_good_coverage/workflows/ci/badge.svg
[ci_badge_link]: https://github.com/VeryGoodOpenSource/very_good_coverage/actions
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[intl_link]: https://pub.dev/packages/intl
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[dcm_link]: https://dcm.dev/docs/quick-start/#install-dcm
