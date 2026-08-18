# LEGASH — Mobile (Donor App)

LEGASH is a blood donor connectivity platform built for Ethiopia, connecting blood donors with hospitals and blood banks. This repository, **legash-mobile**, is the Flutter application used **only by donors** — hospitals and the super admin operate through the separate web app (`legash-web`).

## What's being built (Sprint 1)

Sprint 1 scope is authentication only:

- **Registration** — donor sign-up with SMS OTP verification
- **Login** — phone + password
- **Password reset** — OTP-based, via a dialog on the login screen (not a separate screen)

The exact request/response shape for every API call lives in `legash-docs/API_CONTRACT.md` — that is the source of truth this app is built against.

### Screens & flow

| Screen / Widget | Purpose | Endpoint |
|---|---|---|
| `register_screen.dart` | Donor registration form | `POST /donor/register` |
| `otp_verification_screen.dart` | OTP entry after registration | `POST /donor/verify-otp` |
| `login_screen.dart` | Phone + password login | `POST /donor/login` |
| `forgot_password_dialog.dart` | Two-step popup (request code → verify + reset) on the login screen | `POST /donor/forgot-password`, `POST /donor/reset-password` |
| `terms_policy_screen.dart` | Static Terms & Privacy text, linked from the registration checkbox | — |

Key rules:
- **No email field anywhere** in this app — donors never provide or use email.
- **No auto-login** — register → OTP verify → login are three separate steps.
- **No separate password-reset screen** — it's a dialog on top of the login screen only.
- This app is **donor-only** — no hospital or super admin screens, no real dashboard yet (Sprint 1 ends at a placeholder home screen after login).

## Tech stack

- **Flutter + Dart**
- **provider** for state management (kept simple — no Riverpod/Bloc needed for an auth-only sprint)
- **http** package for API calls (no `dio` at this scope)

## Getting started

```bash
flutter pub get
flutter run
```


## Folder structure

```
legash-mobile/
├── pubspec.yaml
├── lib/
│   ├── main.dart
│   ├── services/
│   │   ├── api_service.dart       # shared HTTP wrapper, base URL, JWT header
│   │   └── auth_service.dart      # shared, one function per contract endpoint
│   ├── providers/
│   │   └── auth_provider.dart     # shared, holds JWT + donor session state
│   ├── screens/
│   │   ├── register_screen.dart
│   │   ├── otp_verification_screen.dart
│   │   ├── login_screen.dart
│   │   └── terms_policy_screen.dart
│   ├── widgets/
│   │   ├── custom_text_field.dart # shared reusable input field
│   │   └── forgot_password_dialog.dart
│   ├── models/
│   │   └── donor_model.dart       # mirrors registration fields, no email
│   └── utils/
│       └── validators.dart        # phone + password rules, mirrors backend
```


Shared files (`api_service.dart`, `auth_service.dart`, `auth_provider.dart`, `custom_text_field.dart`, `donor_model.dart`, `validators.dart`) are built collaboratively so both flows stay consistent.

## Git workflow

- Branch per task off.
- Open a PR, reviewed same-day by the other mobile dev before merging.

---

## Our Team

| Name | Student ID |
|---|---|
| Firaol Tsegaye | CTC-7007-26 |
| Falmi Abdi | CTC-927-26 |
