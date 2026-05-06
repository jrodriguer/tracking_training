# Copilot Instructions

 ## Start Here

 - Trust this file first. Only search the repo when these instructions are
	 incomplete or proven wrong.
 - Read these docs in order when you need product intent or setup context:
	 1. `tracking_training_flutter/docs/implementation_handoff.md`
	 2. `tracking_training_flutter/README.md`
	 3. `tracking_training_server/README.md`
	 4. `tracking_training_client/README.md`
 - If docs conflict, prefer the checked-in code for current behavior. Important
	 example: product docs still describe fake local auth, but the app currently
	 uses real Serverpod email auth wired in
	 `tracking_training_flutter/lib/main.dart` and
	 `tracking_training_server/lib/server.dart`.

 ## Repository Summary

 - Small Dart monorepo using a root workspace in `pubspec.yaml`.
 - Product: gym routine and workout tracking app with progress history.
 - Packages:
	 - `tracking_training_flutter/`: Flutter app for iOS, Android, and web.
	 - `tracking_training_server/`: Serverpod backend with Postgres-backed data,
		 email auth, and optional hosted Flutter web bundle.
	 - `tracking_training_client/`: generated Serverpod client shared by app code.
 - Languages and frameworks: Dart, Flutter, Riverpod, GoRouter, Drift,
	 Serverpod 3.4.5.
 - Toolchain constraints: Dart `>=3.9.0 <4.0.0`; Flutter package requires
	 Flutter `^3.32.0`. Validated locally with Flutter 3.41.4, Dart 3.11.1,
	 Serverpod CLI 3.4.5, Docker 25.0.2, Docker Compose 2.24.3.

 ## Layout That Matters

 - Root:
	 - `pubspec.yaml`: Dart workspace definition.
	 - `analysis_options.yaml`: workspace-wide Flutter lint baseline.
	 - `.github/workflows/`: CI entrypoints.
 - Flutter app:
	 - `tracking_training_flutter/lib/app/`: app bootstrap, router, theme,
		 providers.
	 - `tracking_training_flutter/lib/features/`: `auth`, `progress`, `routines`,
		 `workouts`.
	 - `tracking_training_flutter/lib/shared/`: shared data, widgets, utils.
	 - `tracking_training_flutter/assets/config.json`: runtime API URL.
 - Server:
	 - `tracking_training_server/lib/server.dart`: Serverpod startup, auth,
		 root routes, `/app` hosting.
	 - `tracking_training_server/lib/src/routines/` and `lib/src/workouts/`:
		 endpoint logic and `.spy.yaml` model sources.
	 - `tracking_training_server/lib/src/generated/`: generated only.
	 - `tracking_training_server/config/*.yaml`: dev/test/prod ports and DB config.
	 - `tracking_training_server/docker-compose.yaml`: local Postgres and Redis.
 - Client:
	 - `tracking_training_client/lib/src/protocol/`: generated only.
 - Tests:
	 - `tracking_training_flutter/test/`: widget and feature tests.
	 - `tracking_training_server/test/integration/`: endpoint and auth-backed
		 integration tests.

 ## Working Rules

 - Edit the owning source, not generated artifacts.
	 - Regenerate after changing Serverpod protocols, endpoints, or serializable
		 models with `serverpod generate` from `tracking_training_server/`.
	 - Do not hand-edit `tracking_training_client/lib/src/protocol/` or
		 `tracking_training_server/lib/src/generated/` unless explicitly required.
 - Preserve the domain boundary from the handoff: routine templates and workout
	 history are separate data sets.
 - Auth work must respect the current code, not only the older product note:
	 Flutter route protection lives in `tracking_training_flutter/lib/app/router.dart`;
	 email verification codes are logged by the server in local development.
 - In persistent shells, always `cd` to the owning package explicitly. Terminal
	 cwd is sticky and caused command misfires during validation.

 ## Validated Commands

 ### Bootstrap

 Prefer package-local commands for CI parity, but the root workspace bootstrap
 also works.

 ```sh
 cd <repo-root>
 dart pub get
 ```

 - Validated: succeeds and resolves all three workspace packages.
 - `flutter pub get` also works from the repo root because this is a Dart
	 workspace, but use package-local commands when you want to mirror CI exactly.

 ### Flutter Validate

 ```sh
 cd tracking_training_flutter
 flutter clean
 flutter pub get
 flutter analyze
 flutter test
 ```

 - Validated: passes.
 - Timings on this machine: `flutter analyze` about 2s; `flutter test` about 7s.
 - CI mirror: `.github/workflows/flutter_ci.yml` runs the same package-local
	 `flutter pub get`, `flutter analyze`, and `flutter test` sequence.

 ### Server Validate

 ```sh
 cd tracking_training_server
 dart pub get
 serverpod generate
 dart analyze --fatal-infos
 dart format --set-exit-if-changed .
 ```

 - Validated: passes.
 - Timings on this machine: `serverpod generate` about 8s; analyze under 1s.
 - Always run `serverpod generate` before server analysis or tests if you touched
	 protocols, `.spy.yaml` files, or endpoint signatures.

 ### Server Tests

 ```sh
 cd tracking_training_server
 docker compose up --quiet-pull --build -d
 dart test
 docker compose down -v
 ```

 - Validated: passes.
 - Docker is required for server tests; they depend on Postgres and Redis.
 - CI mirror: `.github/workflows/tests.yml` starts containers, runs
	 `serverpod generate`, then `dart test`.

 ### Web Build For Serverpod Hosting

 ```sh
 cd tracking_training_server
 serverpod generate
 cd ../tracking_training_flutter
 flutter build web --base-href /app/ --wasm --output ../tracking_training_server/web/app
 ```

 - Validated: passes.
 - Timing on this machine: about 28s.
 - This is the same path encoded in `tracking_training_server/pubspec.yaml`
	 under the `flutter_build` script.

 ### Local Run

 Server:

 ```sh
 cd tracking_training_server
 docker compose up -d
 dart run bin/main.dart --apply-migrations
 ```

 - Preconditions: `tracking_training_server/config/passwords.yaml` must exist
	 and define `emailSecretHashPepper`, `jwtHmacSha512PrivateKey`, and
	 `jwtRefreshTokenHashPepper`.
 - Validated command behavior: startup began and migrations applied.
 - Validation note: the command is long-running; the async runner hit its
	 15s idle wait while the server was still starting.
 - Failure observed: startup then failed because ports `8080`, `8081`, and
	 `8082` were already bound by another `dartvm` process. Safe workaround:
	 stop the existing local server you own, or change ports in
	 `tracking_training_server/config/development.yaml`. Do not kill unknown
	 processes blindly.

 Flutter app:

 - `tracking_training_flutter/lib/main.dart` reads
	 `tracking_training_flutter/assets/config.json` for `apiUrl`.
 - The checked-in value is `http://10.0.2.2:8080`, which is Android-emulator
	 friendly. For web, iOS simulator, macOS, or a physical device, update that
	 file to a reachable host or use the Serverpod-hosted `/app` bundle, which
	 serves a generated config file from the backend.

 ## CI And Check-In

 - Flutter CI: `.github/workflows/flutter_ci.yml`.
 - Server analyze: `.github/workflows/analyze.yml`.
 - Server format: `.github/workflows/format.yml`.
 - Server tests: `.github/workflows/tests.yml`.
 - PR checklist lives in `.github/PULL_REQUEST_TEMPLATE.md`; include test
	 evidence and screenshots for UI changes.

 ## Review Standards

 - Security: verify auth, authorization, input validation, and secret handling
	 across Flutter and Serverpod code. Flag exposed credentials, insecure API
	 usage, or missing permission checks.
 - Naming: require clear Dart, Flutter, and Serverpod naming for classes,
	 methods, routes, variables, and DB fields.
 - Testing: add or update meaningful automated coverage for business logic,
	 endpoints, and critical UI flows. Flag missing tests for new behavior.
 - Error handling: prefer explicit failures, user-facing error states, and
	 structured server logging. Flag silent failures or swallowed exceptions.
