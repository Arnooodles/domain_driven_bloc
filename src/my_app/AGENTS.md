# Agent Instructions

> This file provides directives for AI agents operating in the `very_good_core` workspace. It should be mirrored across `CLAUDE.md`, `AGENTS.md`, and `GEMINI.md` so the same instructions load in any AI environment.

## The Agent 3-Layer Architecture

You operate within an architecture that separates concerns to maximize reliability:

- **Layer 1: Directive (What to do):** Natural language instructions and goals (SOPs).
- **Layer 2: Orchestration (Decision making):** This is you. Read directives, call execution tools, handle errors, ask for clarification, and update directives.
- **Layer 3: Execution (Doing the work):** Deterministic tools and scripts that handle actual operations. Push complexity into deterministic code rather than doing it all manually.

## Project Architecture

Flutter application using **Clean Architecture** (Feature-driven isolation: `core/` for shared utilities, `features/` for isolated modules) and **BLoC/Cubit**. Strict layer separation:

**Presentation Layer(UI)**

- Keep business logic out. Use stateless widgets + `flutter_hooks` over stateful widgets.
  - **When to use StatefulWidget:** Only use `StatefulWidget` in rare edge cases where `flutter_hooks` cannot easily replicate the native `State` lifecycle. For example, when using `AutomaticKeepAliveClientMixin` (to preserve state in a `TabBarView`/`PageView`) or when building highly complex custom animations that require a standard `TickerProviderStateMixin` (multiple tickers).
- **Reusable Components:** Extract reusable widgets, dialogs, and wrappers into `core/presentation/`. **Emphasize using these reusables as much as possible.**
- **Views (Screens vs Pages):** Place top-level UI components under the `views/` folder. If a distinction is needed, a **Screen** is typically a full-screen layout, while a **Page** might be a sub-route, tab view, or nested layout. If both exist, clearly separate them into `pages/` and `screens/` folders.
- Use `BlocBuilder`, `BlocConsumer`, and `BlocSelector` for reactive UI, and `BlocPresentationListener` for side effects.
- **Loading States:** Use `skeletonizer` for sleek loading states instead of plain progress indicators when waiting for data, and utilize the reusable wrapper (shimmer).
- **Never** perform direct data fetching, direct repository interactions, or complex data transformations here.
- **Responsiveness:** Always make UIs responsive. Take advantage of `responsive_framework`, `LayoutBuilder`, `MediaQuery`, or any other tools/packages to ensure the app adapts well to different screen sizes and orientations.

**Domain Layer(Business Logic)**

- Use `bloc` or `cubit` for state management (prefer cubits). Utilize `freezed` for union types in states (e.g., `const factory MyState.loading()`).
- **State Emission:** Use `safeEmit` when emitting states and `safeEmitPresentation` for presentation events to prevent emitting after the bloc/cubit is closed.
- **Async Execution:** Use `safeRun` to safely execute and manage asynchronous operations within a bloc/cubit.
- **Entities (`*/domain/entities/*`):** Add validations and value objects to entities. Entities must remain pure Dart, completely decoupled from any framework, serialization, or JSON logic. Use `@freezed` to generate immutable entity classes.
- **Value Objects & Validation:** Encapsulate validation logic inside value objects. Utilize the `trust_but_verify` package for fluent validation chains (e.g., `input.trust('field').isNotEmpty().verifyEither()`).
- **Enums:** Define domain-specific enums within the entities layer (e.g., `*/domain/entities/enum/`).
- Define the abstract repository interfaces and centralize all your business rules here.

**Data Layer(Infrastructure)**

- **Services:** Handle API communication, third-party integrations, external hardware interfaces, or independent external operations.
- **Repositories:** Deterministic data handling. They are mostly dependent on services and handle mapping external data to domain entities. Functions in repositories should use functional programming as return types, returning only a `Failure` or a value `T`.
- **DTOs (`*.dto.dart`):** Models/DTOs mirror entities but handle serialization. Use `@freezed` and `json_serializable` annotations and rely on generated `_$ClassNameFromJson` functions. Use `toDomain()` and `fromDomain()` methods to seamlessly convert between DTOs and domain entities.
- Repositories must catch all external exceptions, securely map them to appropriate domain `Failure`s, and return them safely without leaking unhandled exceptions upwards.
- **Always log failures:** Any caught exception or failure within a repository must be logged using the designated logging mechanism before returning the `Failure`.

## Rules & Tooling

- **Zero sibling dependencies** in the same layer.
- **Naming Conventions:** Follow standard Dart naming conventions: `UpperCamelCase` for classes, enums, and typedefs. `lowerCamelCase` for variables, methods, and parameters. `snake_case` for file names and directories. Suffix classes correctly (e.g., `UserRepository`, `AuthCubit`, `UserEntity`, `UserDto`). Avoid single-character names such as "e", "i", "l", etc.
- **No Magic Numbers:** Avoid using "magic numbers" (hardcoded unnamed numerical values) in code. Extract them to named constants with descriptive names. If a magic number must be used and cannot be extracted (very rare), it **must** be accompanied by an explanatory comment.
- **Variable/Constant Extraction:** If there are similar values used across files or components (widgets, services, etc.), extract them into variables or constants so they can be reused.
- **Dependency Injection:** Use constructor injection with `GetIt` and `injectable`.
- **Environment & Config:** Never hardcode API URLs or sensitive keys. Strictly use `.env` files located in `assets/env/` alongside the `envied` generated environment classes or centralized configurations.
- **Functional Programming:** Heavily rely on functional programming principles using the `fpdart` package. Use pure functions, immutability, and handle side effects and exceptions using monadic types like `TaskEither`, `Either`, or `Option` rather than throwing and catching errors.
- **Typedefs:** Take advantage of `typedef`s (like custom `Result` types built on `Either`) to securely handle success/failure states without throwing runtime exceptions.
- **Error Handling:** Map all external exceptions to domain-specific `Failure` classes. Use a `FailureHandler` to process failures and clearly define `ErrorActions` for consistent error UI rendering, retries, and logging. `FailureHandler` should only be used in the Domain Layer.
- **Class Modifiers:** Implement Dart class modifiers (e.g., `sealed`, `final`, `abstract interface class`) to explicitly define class capabilities and prevent unintended inheritance or implementation.
- **HTTP (`chopper`):** Use Chopper for building type-safe HTTP API clients. Define API interfaces and generate the corresponding implementations.
- **Utils:** Create reusable pure functional utilities in the `utils/` folder.
- **Helpers:** Extract reusable extensions and methods into the `helpers/` folder.
- **Constants:** Centralize constant values into the `constants/` folder.
- **Navigation (`go_router`):** Use declarative routing with `go_router` and type-safe routes generated via `go_router_builder`.
- **Assets (`flutter_gen`):** Never hardcode asset paths. Use the generated `Assets` class (e.g., `Assets.images.logo.svg()`).
- **Localization (`slang`):** Do not hardcode strings in UI. Add and modify translations in the JSON files located within `assets/i18n/`, and use generated translation getters via the `slang` package.
- **Theming:** Use the centralized app theme. Do not hardcode colors, text styles, spacings, or paddings in widgets; strictly rely on `Theme.of(context)` and predefined theme constants.
- **Testing:**
  - Strive for **100% test coverage** in unit tests, but total code coverage can at least be at **~90%**.
  - **Unit Tests:** Focus on `bloc`/`cubit` logic and `repository` implementations.
  - **Widget Tests:** Use **Golden testing** heavily via `alchemist` to catch UI regressions.

## Project Structure

Understand where to place and organize files:

- `lib/app/`: App-level configurations, routes, themes, `constants/`, `utils/`, and `helpers/`.
- `lib/core/`: Shared architectural pieces used across multiple features (`core/data`, `core/domain`, `core/presentation`). Reusable UI goes in `core/presentation/widgets/`, `dialogs/`, and `wrappers/`.
- `lib/features/<feature_name>/`: Isolated feature modules following strict 3-Layer architecture (`data/`, `domain/`, `presentation/`).
- `test/`:
  - `utils/`: Test utilities and mock helpers.
  - `unit/`: Unit tests organized by `core/` and `features/`.
  - `widget/`: Widget/Golden tests organized by `core/` and `features/`.

## Agent Instructions & Operating Principles

1. **Check for tools first:** Use available MCP tools or `.agent/skills/` (e.g., `flutter-add-widget-preview`) before creating new scripts. If you do everything yourself, errors compound. Push complexity into deterministic tools when possible.
2. **Self-annealing loop when things break:**
   1. Read error message and stack trace.
   2. Fix the implementation.
   3. Test the code to make sure it works.
   4. Update directives/docs with your learnings (API limits, timing, edge cases).
   5. The system is now stronger.
3. **Update directives as you learn:** Directives are living documents. When you discover constraints or better approaches—update them. But don't overwrite directives without asking unless explicitly told to.
4. **Deliverables vs Intermediates:** Local files or `.tmp/` directories are only for your intermediate processing. Deliverables (the actual Flutter code, tests, etc.) should be placed in their correct project structure so the user can access and run them. If you create temporary files, you must delete them after use.
5. **Keep it minimal:** Do not add redundant documentation, automatically generated context files, or extra instructions that increase work without improving success.

## Common Commands

```bash
make pub_get          # Get dependencies
make slang            # Generate localization strings
make build_runner     # Run code generation (injectable, freezed, json_serializable, go_router)
make format           # Format codebase
make lint             # Run static analysis
make lcov_mac         # Run tests & generate coverage (macOS)
make goldens_mac      # Generate/update UI goldens (macOS)
make clean_rebuild    # Clean cache and fully rebuild generated files
```

## Summary

You sit between human intent (directives) and deterministic execution (tools and codebase). Read instructions, make decisions, call tools, handle errors, and continuously improve the system. Be pragmatic. Be reliable. Self-anneal.
