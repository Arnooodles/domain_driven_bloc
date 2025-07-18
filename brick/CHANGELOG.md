# 3.0.1
- chore: update brick metadata 
- fix: update README screenshots not displaying
- chore: downgrade mason to support latest mason cli version (brick/brick.yaml, brick/hooks/pubspec.yaml)
- chore: update workflow actions to latest version
- chore: update dependencies

# 3.0.0
- feat: update README docs, screenshots, and localization/i18n for new/renamed fields
- feat: update Flutter, Gradle, Android, and dependencies for improved compatibility
- feat: enhance theming, sizing, and UI consistency; add app text styles
- feat: switch user/auth endpoints to dummyjson.com, update login to username
- feat: add AuthInterceptor for token refresh/session timeout
- feat: add/extend context extensions (theme, navigation, text style, mediaQuery)
- feat: add .githooks/pre-commit, Makefile git hook/init_hooks targets
- feat: add/extend core widgets (buttons, avatars, icons, text fields, webview)
- feat: add/extend DTOs, entities, and repositories for user, auth, device
- feat: add/extend tests for new features and refactored logic
- refactor: unify Failure types to use `message` field, update all usages/tests
- refactor: ErrorActions/FailureHandler to use Failure, not Exception
- refactor: ValueObject throws Exception with failure message
- refactor: use context extensions for theme, navigation, text style
- refactor: update usages of GoRouter/Navigator to use context extensions
- refactor: update/optimize Makefile, workflows, .gitignore, and scripts
- fix: update/optimize goldens, test utils, and widget tests
- chore: clean up and merge related code, test, and asset changes for maintainability


# 2.0.0
- feat: implemented flex_color_scheme
- feat: replaced intl_utils with slang
- feat: added script for updating android project settings
- feat: added reusable text widget
- feat: added let extension
- feat: added persistency on theme modes
- feat: added app localization bloc
- feat: optimized build_runner with build.yaml
- feat: moved all generated mocks into one file
- feat: added MockDevice from the golden_toolkit package
- refactor: removed golden_toolkit dependency
- refactor: migrated android build config from Groovy to Kotlin
- refactor: merged flavor main files into one main file
- refactor: changed arb file into json for slang
- refactor: optimized using of media query extensions
- refactor: separated enum file into multiple files and moved to core/entity folder
- refactor: added pre-defined Paddings in app_spacing
- refactor: optimized logging in go_route_observer
- refactor: optimized app_router and separated it into multiple class/files
- refactor: added clauses on try catches
- refactor: implemented the use of the reusable icon widget
- fix: reset failed login status to initial state
- test: fixed tests that were affected by the updates
- test: remove  golden test for screens and webviews
- chore: deleted unused files and folders
- chore: updated dependencies to the latest version
- chore: updated workflow dependencies to the latest version
- chore: updated goldens files
- chore: updated screenshots
- docs: updated brick's README with regards to the updates
- docs: updated template's README with regards to the updates


# 1.2.0
- feat: add themeAnimation
- feat: migrate from webview_flutter to flutter_inappwebview
- feat: add device_info_plus
- feat: add package_info_plus
- feat: add flutter_svg
- feat: add app sizes class
- feat: add core icon widget that supports SVG or icon data
- feat: add core webview widget
- feat: add vulnerability_check workflow
- feat: implement url launcher utils
- feat: implement common app utils
- feat: implement SVG preloader 
- refactor: change some bloc builders to instead use context.watch()
- refactor: change local_storage setters from bool to void
- refactor: dependency injection folder structure 
- refactor: migrate deprecated imperative apply of Flutter's Gradle plugins
- refactor: service locator and modules 
- refactor: add sealed class modifier to freezed classes
- test: add widget test for core icon
- test: add unit test for device repository
- test: fix tests that were affected by the updates
- chore: update dependencies to the latest version
- chore: update workflow dependencies to the latest version
- chore: update minimum SDK to 3.3.0
- chore: update goldens files
- docs: update README with regards to the updates
# 1.1.3

- feat: upgrade to flutter 3.16.9
- chore: update dependencies to the latest version
- fix: responsive width conditions
- refactor: remove scroll_behavior_config

# 1.1.2

- feat: upgrade to flutter 3.16.9
- feat: add vulnerability check(osv_scanner)
- refactor: optimize some variables by making it private 
- refactor: rename data model folder to dto
- refactor: rename domain model folder to entity
- chore: update dependencies to the latest version
- test: implement reset on mocked repositories and services
- docs: update folder structure 

# 1.1.1

- feat: upgrade to flutter 3.16.8
- chore: update dependencies to the latest version
- refactor: minor code optimization
- test: added tear down on some tests
  

# 1.1.0

- feat: upgrade to flutter 3.16.5
- feat: implement skeletonizer
- feat: implement flutter_native_splash
- feat: implement icons_launcher
- chore: update dependencies to the latest version

# 1.0.0

- feat: upgrade to flutter 3.16.2
- feat: implement go_router's StatefulShellRoute
- feat: implement safe_device
- feat: implement SSL Certificate Pinning
- refactor: migrate responsive_framework to 1.1.1
- refactor: implement gap instead of using sizebox
- refactor: remove Hidable and use AnimatedAlign instead 
- refactor: update workflow to use fvm's flutter version
- fix: resolve test issues due to breaking changes
- fix: change launchMode on Android to singleTask
- test: tested pre_gen hook
- chore: rename screens->views
- chore: separate extensions.dart into multiple files
- chore: separate converters.dart into multiple files
- chore: update dependencies to the latest version
- chore: remove leak_tracking
- chore: remove unnecessary 'break' statement.
- chore: remove dart_code_metrics.

# 0.2.1

- chore: bump Dart SDK to 2.19.0
- chore: update dependencies to the latest version
- feat: bumped hook to min Dart Sdk 2.19.0
- feat: updated mason
- feat: update to flutter 3.10.0
- refactor: refactor tuples and implement records
- refactor: removed hideable and implemented it locally to support dart 3.0
- refactor: refactor switch and implement patterns
- refactor: replace dartz with fpdart
  
# 0.2.0

- refactor: refactor bloc states into multiple class
- refactor: fix tests issues related to the refactors  
- refactor: dialog utils(toast/flash/dialogs)
- feat: implement pretty_chopper_logger
- feat: implement new lint rules and remove redundant rules
- feat: add helpers folder
- feat: implement compute() in parsing json Response
- docs: update README file
- chore: update golden files
- chore: update packages to latest version

# 0.1.20

- feat: implement shimmer pages when loading
- feat: implement auth,theme and app_core bloc
- feat: implement app lifecycle bloc
- feat: implement hideable
- feat: replace pull_to_refresh with Refresh indicator
- fix: dark mode text colors
- chore: update golden files

# 0.1.19

- feat: change BlocBuilder to BlocSelector
- chore: update makefile to use fvm for flutter tests

# 0.1.18

- fix: update brick README.md

# 0.1.17

- docs: add architecture diagram
- chore: update pub packages
- chore: update unit test folder structure
- chore: update golden files
- feat: change info text field background color

# 0.1.16

- feat: implement material 3 widgets
- feat: add memory leak tracker
- chore: update pub packages

# 0.1.15

- chore: update to flutter 3.7.0

# 0.1.14

- feat: initial release 🎉
