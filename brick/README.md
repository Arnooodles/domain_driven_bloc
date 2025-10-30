# Domain-Driven Bloc

[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)

Domain-Driven Bloc jumpstarts your Flutter projects with a clean, modular foundation. Get instant best practices—Bloc, Clean Architecture, DI, and feature isolation—so you can focus on building, not boilerplate. Everything you need for fast, confident app development is ready out of the box.

---


## Credits 🙏

This project was originally developed by [Very Good Ventures][very_good_ventures_link] 🦄

It has been forked and adapted for creating different app templates with a clean architecture based on domain driven design

This fork is not officially maintained or affiliated with Very Good Ventures.

---

## Getting Started 🚀

This app template can be generated using [mason_cli][mason_cli_link] with customized variables.

Ensure you have [mason_cli][mason_cli_link] installed.

```sh
# Activate mason_cli from https://pub.dev
dart pub global activate mason_cli
```

```sh
# Or install from https://brew.sh
brew tap felangel/mason
brew install mason
```

Installation

```sh
# Install locally
mason add domain_driven_bloc
```

```sh
# Or install globally
mason add -g domain_driven_bloc
```

Usage 🚀

```sh
# Generate the domain_driven_bloc app template
mason make domain_driven_bloc
```

---

## What's Included ✨

Everything you need for a modern, production-grade Flutter app:

- 🏛️ **Clean Architecture:** Modular, scalable architecture inspired by DDD—separation of concerns, testability, and maintainability.
- 🧩 **Feature Isolation:** Each feature is fully modular for easy scaling and testing.
- 🧠 **Bloc State Management:** Clean separation of business logic and UI using Bloc.
- 🧬 **Dependency Injection:** Built-in DI with [injectable], [get_it] for testability and loose coupling.
- 🛠 **Configurable Build Flavors:** Effortless switching between dev, staging, and prod environments.
- 🌍 **Internationalization:** Streamlined i18n with codegen—add new languages in minutes, no manual boilerplate.
- 🛡 **Null Safety:** 100% sound null safety for safer, more reliable code.
- 🔒 **Secure Storage:** Secure sensitive data with [flutter_secure_storage].
- 🧪 **Testing Suite:** Extensive unit, widget, and golden tests; includes mocks, fakes, and golden tests for robust, reliable test suites.
- 📝 **Extensible Logging:** Catch and log uncaught exceptions, plug in your own loggers, or use pretty logging for debugging and production.
- 🏎 **Performance Ready:** Responsive layouts and best practices for smooth UX on all platforms.
- 🧑‍💻 **Developer Experience:** Makefile, FVM, and pre-configured analysis for fast onboarding and consistent code quality.
- 🤖 **CI/CD Ready:** Lint, format, test, and coverage checks via GitHub Actions.
- 🔄 **Automated Dependency Updates:** Dependabot keeps your dependencies fresh and secure.


### Key Packages 🗃

- 🧠 **State Management:** [flutter_bloc](https://pub.dev/packages/flutter_bloc), [flutter_hooks](https://pub.dev/packages/flutter_hooks)
- 🧮 **Functional Programming:** [fpdart](https://pub.dev/packages/fpdart), [fpvalidate](https://pub.dev/packages/fpvalidate)
- 🗄️ **Model:** [freezed](https://pub.dev/packages/freezed), [json_serializable](https://pub.dev/packages/json_serializable)
- 🧭 **Navigation:** [go_router](https://pub.dev/packages/go_router)
- 🧬 **DI:** [injectable](https://pub.dev/packages/injectable), [get_it](https://pub.dev/packages/get_it)
- 📱 **Responsive:** [responsive_framework](https://pub.dev/packages/responsive_framework)
- 🌱 **Env:** [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)
- 🌐 **HTTP:** [chopper](https://pub.dev/packages/chopper)
- 💾 **Storage:** [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage), [shared_preferences](https://pub.dev/packages/shared_preferences)
- 🛡 **Security:** [safe_device](https://pub.dev/packages/safe_device)
- 📝 **Logging:** [logger](https://pub.dev/packages/logger), [pretty_chopper_logger](https://pub.dev/packages/pretty_chopper_logger)
- 🌍 **Localization:** [intl](https://pub.dev/packages/intl), [slang](https://pub.dev/packages/slang)
- 🧾 **Device Info:** [package_info_plus](https://pub.dev/packages/package_info_plus), [device_info_plus](https://pub.dev/packages/device_info_plus)
- 🖼 **Assets:** [flutter_svg](https://pub.dev/packages/flutter_svg), [flutter_gen](https://pub.dev/packages/flutter_gen)
- 🧪 **Testing:** [alchemist](https://pub.dev/packages/alchemist), [bloc_test](https://pub.dev/packages/bloc_test)
- 🦾 **Mocking:** [mockito](https://pub.dev/packages/mockito), [mocktail_image_network](https://pub.dev/packages/mocktail_image_network), [faker](https://pub.dev/packages/faker)
- 🧹 **Code Quality:** [very_good_analysis](https://pub.dev/packages/very_good_analysis), [dart_code_metrics](https://pub.dev/packages/dart_code_metrics)

## Output 🗂️

### Core Functionality 🏅

- 🏠 **Home:** Live Reddit [FlutterDev][flutter_dev_link] feed integration—real-world API, pagination, error handling.
- 🔐 **Auth:** Mock login using [DummyJSON](https://dummyjson.com/docs/auth)—prototype real auth flows with any [user](https://dummyjson.com/users).
- 👤 **Profile:** Mock user profile via [DummyJSON](https://dummyjson.com/docs/auth#auth-me)—user state management and editing patterns.
- 🌙 **Dark Mode:** Seamless theme switching with persistent user preference.

### Architecture 🏗️

![Architecture Diagram](https://raw.github.com/Arnooodles/domain_driven_bloc/main/screenshots/diagram.png "Architecture Diagram")

---

## Folder Structure 📁

> Output after running the template:

```sh
├── .github
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── dependabot.yaml
│   └── workflows
│       └── main.yaml
├── .idea
│   └── runConfigurations
│       ├── development.xml
│       ├── production.xml
│       └── staging.xml
├── .vscode
│   ├── extensions.json
│   └── launch.json
├── android
├── assets
│   ├── env
│   ├── fonts
│   ├── icons
│   ├── images
│   └── i18n
│       └── en.i18n.json
├── ios
├── lib
│   ├── app
│   │   ├── config
│   │   ├── constants
│   │   ├── generated
│   │   ├── helpers
│   │   │   ├── converters
│   │   │   ├── extensions
│   │   │   └── injection
│   │   ├── observers
│   │   ├── routes
│   │   ├── themes
│   │   ├── utils
│   │   └── app.dart
│   ├── core
│   │   ├── data
│   │   │   ├── dto
│   │   │   ├── repository
│   │   │   └── service
│   │   ├── domain
│   │   │   ├── bloc
│   │   │   ├── interface
│   │   │   └── entity
│   │   │       └── enum
│   │   └── presentation
│   │       ├── views
│   │       └── widgets
│   │           └── dialogs
│   │           └── wrappers
│   ├── features
│   │   ├── auth
│   │   │   ├── data
│   │   │   │   ├── dto
│   │   │   │   ├── repository
│   │   │   │   └── service
│   │   │   ├── domain
│   │   │   │   ├── bloc
│   │   │   │   ├── interface
│   │   │   │   └── entity
│   │   │   └── presentation
│   │   │       ├── views
│   │   │       └── widgets
│   │   ├── home
│   │   │   ├── data
│   │   │   │   ├── dto
│   │   │   │   ├── repository
│   │   │   │   └── service
│   │   │   ├── domain
│   │   │   │   ├── bloc
│   │   │   │   ├── interface
│   │   │   │   └── entity
│   │   │   └── presentation
│   │   │       ├── views
│   │   │       └── widgets
│   │   └── profile
│   │       ├── data
│   │       │   ├── dto
│   │       │   ├── repository
│   │       │   └── service
│   │       ├── domain
│   │       │   ├── bloc
│   │       │   ├── interface
│   │       │   └── entity
│   │       └── presentation
│   │           ├── views
│   │           └── widgets
│   │
│   ├── main.dart
├── scripts
├── test
│   ├── utils
│   ├── unit
│   │   ├── core
│   │   │   ├── bloc
│   │   │   └── repository
│   │   └── features
│   │       ├── auth
│   │       │   ├── bloc
│   │       │   └── repository
│   │       └── home
│   │           ├── bloc
│   │           └── repository
│   ├── widget
│   │   ├── core
│   │   │   ├── dialogs
│   │   │   │   ├── goldens(generated)
│   │   │   │   └── failures(generated)
│   │   │   └── widgets
│   │   │       ├── goldens(generated)
│   │   │       └── failures(generated)
│   │   └── features
│   │       ├── auth
│   │       │   └── widgets
│   │       │       ├── goldens(generated)
│   │       │       └── failures(generated)
│   │       ├── home
│   │       │   └── widgets
│   │       │       ├── goldens(generated)
│   │       │       └── failures(generated)
│   │       └── profile
│   │           └── widgets
│   │               ├── goldens(generated)
│   │               └── failures(generated)
│   └── flutter_test_config.dart
├── web
├── .gitignore
├── analysis_options.yaml
├── coverage_badge.svg
├── LICENSE
├── Makefile
├── pubspec.lock
├── pubspec.yaml
└── README.md
```

---

## Screenshots 📷

<table>
  <tr>
    <td>Login Screen</td>
    <td>Home Screen</td>
    <td>Profile Screen</td>
  </tr>
  <tr>
    <td><img src="https://raw.github.com/Arnooodles/domain_driven_bloc/main/screenshots/login_screen.png" width=270 height=520></td>
    <td><img src="https://raw.github.com/Arnooodles/domain_driven_bloc/main/screenshots/home_screen.png" width=270 height=520></td>
    <td><img src="https://raw.github.com/Arnooodles/domain_driven_bloc/main/screenshots/profile_screen.png" width=270 height=520></td>
  </tr>
  <tr>
    <td><img src="https://raw.github.com/Arnooodles/domain_driven_bloc/main/screenshots/dark_login_screen.png" width=270 height=520></td>
    <td><img src="https://raw.github.com/Arnooodles/domain_driven_bloc/main/screenshots/dark_home_screen.png" width=270 height=520></td>
    <td><img src="https://raw.github.com/Arnooodles/domain_driven_bloc/main/screenshots/dark_profile_screen.png" width=270 height=520></td>
  </tr>
</table>

## Contributing 🤝

Contributions are welcome! To get started:

1. Fork the repo and create your branch from `main`.
2. Make your changes, following the existing code style and conventions.
3. Add tests for any new features or bug fixes.
4. Run the linter and tests to ensure everything passes:
   ```sh
   make lint         # for static analysis
   make lcov_*      # for running tests and generating coverage (see Makefile for available targets)
   ```
5. Open a pull request with a clear description of your changes.

For major changes, please open an issue first to discuss what you'd like to change.

If you have questions, suggestions, or want to discuss ideas, feel free to open an issue or start a discussion.

---

[bloc_link]: https://bloclibrary.dev
[flutter_cross_platform_link]: https://flutter.dev/docs/development/tools/sdk/release-notes/supported-platforms
[flutter_flavors_link]: https://flutter.dev/docs/deployment/flavors
[flutter_dev_link]: https://www.reddit.com/r/FlutterDev/
[fvm_link]: https://fvm.app/
[github_actions_link]: https://github.com/features/actions
[github_dependabot_link]: https://github.com/dependabot
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logging_link]: https://api.flutter.dev/flutter/dart-developer/log.html
[makefile_link]: https://www.gnu.org/software/make/manual/make.html#Reading
[mason_cli_link]: https://pub.dev/packages/mason_cli
[null_safety_link]: https://flutter.dev/docs/null-safety
[reqres_link]: https://reqres.in/
[testing_link]: https://flutter.dev/docs/testing
[very_good_ventures_link]: https://verygood.ventures
[flutter_bloc]: https://pub.dev/packages/flutter_bloc
[flutter_hooks]: https://pub.dev/packages/flutter_hooks
[fpdart]: https://pub.dev/packages/fpdart
[freezed]: https://pub.dev/packages/freezed
[json_serializable]: https://pub.dev/packages/json_serializable
[go_router]: https://pub.dev/packages/go_router
[injectable]: https://pub.dev/packages/injectable
[get_it]: https://pub.dev/packages/get_it
[responsive_framework]: https://pub.dev/packages/responsive_framework
[flutter_dotenv]: https://pub.dev/packages/flutter_dotenv
[chopper]: https://pub.dev/packages/chopper
[flutter_secure_storage]: https://pub.dev/packages/flutter_secure_storage
[shared_preferences]: https://pub.dev/packages/shared_preferences
[safe_device]: https://pub.dev/packages/safe_device
[logger]: https://pub.dev/packages/logger
[pretty_chopper_logger]: https://pub.dev/packages/pretty_chopper_logger
[flex_color_scheme]: https://pub.dev/packages/flex_color_scheme
[intl]: https://pub.dev/packages/intl
[slang]: https://pub.dev/packages/slang
[package_info_plus]: https://pub.dev/packages/package_info_plus
[device_info_plus]: https://pub.dev/packages/device_info_plus
[flutter_svg]: https://pub.dev/packages/flutter_svg
[flutter_gen]: https://pub.dev/packages/flutter_gen
[alchemist]: https://pub.dev/packages/alchemist
[golden_toolkit]: https://pub.dev/packages/golden_toolkit
[bloc_test]: https://pub.dev/packages/bloc_test
[mockito]: https://pub.dev/packages/mockito
[mocktail_image_network]: https://pub.dev/packages/mocktail_image_network
[faker]: https://pub.dev/packages/faker
[very_good_analysis]: https://pub.dev/packages/very_good_analysis
[dart_code_metrics]: https://pub.dev/packages/dart_code_metrics
