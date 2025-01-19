# Very Good Core

[![ci][ci_badge]][ci_badge_link]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

---

## Setting up 💻

### Installing FVM

- Windows
  1. Install chocolatey from [here][chocolatey_link].
  2. Then, `choco install fvm`
- MacOS
  1. `brew tap leoafarias/fvm`
  2. `brew install fvm`

### Installing Make

This project uses a makefile to easily run commands.

- Windows
  1. Install chocolatey from [here][chocolatey_link].
  2. Then, `choco install make`
- MacOS
  1. `brew install make`

**Note**: To learn more about the pre defined `make` commands, see the **Makefile** found in the root of the project directory.

## Getting Started 🚀

This project contains 3 flavors:

- development
- staging
- production

Before running the project, ensure that all dependencies are installed by running the command `make rebuild`. This step is necessary for all flavors. To run the desired flavor, either use the launch configuration in VSCode/Android Studio or use the following commands:

#### For Android and IOS
```sh
# Development
$ flutter run --flavor development --target lib/main.dart

# Staging
$ flutter run --flavor staging --target lib/main.dart

# Production
$ flutter run --flavor production --target lib/main.dart
```
#### For Web
```sh
# Development
$ flutter run --dart-define flavor=development --target lib/main.dart

# Staging
$ flutter run --dart-define flavor=staging --target lib/main.dart

# Production
$ flutter run --dart-define flavor=production --target lib/main.dart
```

## Updating App Icons 🎨

This project uses the [`icons_launcher`](https://pub.dev/packages/icons_launcher) package to generate app icons.

1. **Prepare Icon Images**:
     - Place your source icon images in the designated directory (e.g., `assets/icons`).
     - Ensure that the images are in the correct format and resolution as required by your project.

2. **Verify Configuration File**:
     - Ensure that the `icons_launcher.yaml` configuration file is correctly set up in the root directory of your project.
     - This file should contain the necessary configuration for generating the app icons.

3. **Run the `icons_launcher` Command**:
     - Open your terminal or command prompt.
     - Navigate to the root directory of your project.
     - Execute the following command:
     
       ```sh
       $ make icons_launcher
       ```

## Updating Splash Screen 🌊

This project uses the [`flutter_native_splash`](https://pub.dev/packages/flutter_native_splash) package to generate splash screens.

1. **Prepare Splash Screen Images**:
     - Place your source splash screen images in the designated directory (e.g., `assets/images`).
     - Ensure that the images are in the correct format and resolution as required by your project.

2. **Verify Configuration File**:
     - Ensure that the `flutter_native_splash.yaml` configuration file is correctly set up in the root directory of your project.
     - This file should contain the necessary configuration for generating the splash screens.

3. **Run the `native_splash` Command**:
     - Open your terminal or command prompt.
     - Navigate to the root directory of your project.
     - Execute the following command:
     
       ```sh
       $ make native_splash
       ```


## Working with Translations 🌐

  This project relies on [flutter_localizations][flutter_localizations_link] and [intl][intl_link] and uses [slang](https://pub.dev/packages/slang) to create a binding between your translations from .json files and your Flutter app.

  ### Localization Naming Conventions

  1. For common or general purpose strings:
   
      ```json
      "common": {
        "ok": "OK",
        "cancel": "Cancel"
      }
      ```
  2. For feature-specific strings:
   
      ```json
      "login": {
        "button_text": {
          "sign_in": "Sign In",
          "sign_up": "Sign Up"
        }
      },
      "registration": {
        "label_text": {
          "first_name": "First Name"
        }
      }
      ```

  ### Adding Strings

  1. To add a new localizable string, open the `en.i18n.json` file at `assets/i18n/` folder.

      ```json
      {
        "common": {
          "ok": "OK",
          "cancel": "Cancel"
        }
      }
      ```

  2. Then add a new key/value pair

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
        },
        "registration": {
          "label_text": {
            "first_name": "First Name"
          }
        }
      }
      ```

3. Use the new string
   
    **Note**: You need to run `build_runner` for the updates to reflect.

    ```dart
    import 'package:very_good_core/app/utils/extensions.dart';

    @override
    Widget build(BuildContext context) {
      return Text(context.i18n.registration.label_text.first_name);
    }
    ```

  ### Adding Supported Locales

  Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

  ```xml
    ...
    <key>CFBundleLocalizations</key>
    <array>
      <string>en</string>
      <string>es</string>
    </array>
    ...
  ```

  ### Adding Translations

  1. For each supported locale, add a new JSON file in `assets/l10n/`.

      ```
      ├── i18n
      │   ├── en.i18n.json
      │   └── es.i18n.json
      ```

  2. Add the translated strings to each `.json` file:

      `app_en.json`

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
        },
        "registration": {
        "label_text": {
          "first_name": "First Name"
        }
        }
      }
      ```

      `app_es.json`

      ```json
      {
        "common": {
        "ok": "OK",
        "cancel": "Cancelar"
        },
        "login": {
        "button_text": {
          "sign_in": "Registrarse",
          "sign_up": "Inscribirse"
        }
        },
        "registration": {
        "label_text": {
          "first_name": "Primer nombre"
        }
        }
      }
      ```


## Running Tests 🧪

To run all unit and widget tests use the following command:

**Note**: Before running your test, make sure that the golden files are already generated. If not, run the following commands to generate them: `make goldens_win` for Windows and `make goldens_mac` for macOS.

```sh
# Running Test for Windows
$ make lcov_win 
```
```sh
# Running Test for macOS
$ make lcov_mac 
```
## Generate Coverage Report
To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report for macOS
$ make lcov_report_mac
```

To setup lcov on windows check this [guide](https://fredgrott.medium.com/lcov-on-windows-7c58dda07080).

```sh
# Generate Coverage Report for Windows
$ make lcov_report_win
```

### Generating goldens file

```sh
# Generate goldens for macOS
$ make goldens_mac
```

```sh
# Generate goldens for Windows
$ make goldens_win
```

### Updating Goldens File

1. Update the `goldensVersion` variable found in `flutter_test_config.dart` under **TestConfig** class
2. Generate the goldens file (`make goldens_mac` or `make goldens_win`)

### Modifying Goldens Tests Threshold

The goldens tests threshold is a value that determines the acceptable level of pixel differences between the current and the golden (reference) images during visual testing. Modifying this threshold might be necessary when there are minor, acceptable changes in the UI that should not cause the tests to fail.

1. Modify the `goldenTestsThreshold` variable found in `flutter_test_config.dart` under **TestConfig** class.
2. Update the threshold value to the desired level.


[ci_badge]: https://github.com/VeryGoodOpenSource/very_good_coverage/workflows/ci/badge.svg
[ci_badge_link]: https://github.com/VeryGoodOpenSource/very_good_coverage/actions
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[intl_link]: https://pub.dev/packages/intl
[intl_utils_link]: https://pub.dev/packages/intl_utils
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
[chocolatey_link]: https://chocolatey.org/install
