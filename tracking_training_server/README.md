# tracking_training_server

This is the starting point for your Serverpod server.

## Local Development

To run your server, you first need to start Postgres and Redis. It's easiest to do with Docker.

    docker compose up --build --detach

Then you can start the Serverpod server.

    dart bin/main.dart

When you are finished, you can shut down Serverpod with `Ctrl-C`, then stop Postgres and Redis.

    docker compose stop

## Local Auth (Email Verification)

In local development, SMTP is not required. The email identity provider prints
verification codes to the server terminal instead of sending real emails.

Example terminal output:

    [EmailIdp] Registration code (user@example.com): 123456

End-to-end local flow:

1. In `tracking_training_server/`, start dependencies: `docker compose up -d`
2. Run the server: `dart run bin/main.dart --apply-migrations`
3. Open the Flutter app and go to Create Account.
4. Enter an email and tap Continue.
5. Watch the server terminal for `[EmailIdp] Registration code (...)`.
6. Copy the 6-digit code into the app.
7. Set a password to finish account creation.
8. Sign in with the same email and password.

`config/passwords.yaml` must exist and include these required keys:
`emailSecretHashPepper`, `jwtHmacSha512PrivateKey`, and
`jwtRefreshTokenHashPepper`.

## Validation

Before opening a pull request for backend work, run these commands from
`tracking_training_server/`:

1. `dart pub get`
2. `serverpod generate` when you changed protocols, endpoints, or models
3. `dart analyze --fatal-infos`
4. `dart format --set-exit-if-changed .`
5. `dart test`

The repository CI workflows mirror this split:

1. `.github/workflows/analyze.yml` checks analysis.
2. `.github/workflows/format.yml` checks formatting.
3. `.github/workflows/tests.yml` starts Docker services, runs `serverpod generate`, and executes tests.

## Working With Copilot

For Copilot to work well in this Serverpod workspace:

1. Make changes in the source package that owns the behavior: Flutter UI in `../tracking_training_flutter/lib/`, backend logic in `lib/` here, and generated client artifacts only through regeneration.
2. Do not manually maintain generated protocol code in `../tracking_training_client/lib/src/protocol/` unless there is a specific reason to patch generated output.
3. After changing API contracts or serializable models, run `serverpod generate` so the server and client stay in sync.
4. Keep backend test runs Docker-ready because the CI test workflow depends on Postgres and Redis.
