# Smart Class Check-in & Learning Reflection App

Prototype Flutter application for classroom attendance and post-class reflection.

Students can check in with GPS and QR verification, record their learning expectations, then finish class with another QR scan and submit reflection data.

## Repository Structure

- `PRD.md` - product requirement document
- `smart_class_checkin/` - Flutter application source code

## Implemented Features

- Check-in flow with:
  - GPS capture
  - QR scan
  - timestamp recording
  - previous topic input
  - expected topic input
  - pre-class mood rating (1-5)
- Finish class flow with:
  - GPS capture
  - QR scan
  - timestamp recording
  - learned today input
  - feedback input
  - post-class feeling rating (1-5)
- Local persistence with SQLite
- Web support for QR camera access and SQLite via `sqflite_common_ffi_web`
- Clean Architecture structure with BLoC and GetIt

## Tech Stack

- Flutter
- Firebase (service wrapper prepared, project config not added yet)
- SQLite / sqflite
- flutter_bloc
- get_it
- mobile_scanner
- geolocator

## Run The App

### Prerequisites

- Flutter SDK installed
- Chrome installed for web testing

### Web

```bash
cd smart_class_checkin
flutter pub get
flutter run -d chrome --web-port 3000
```

### Mobile

```bash
cd smart_class_checkin
flutter pub get
flutter run
```

## Test Notes

- For QR testing, any non-empty QR code can be used.
- On web, the browser will request camera permission when the QR scanner page opens.
- Check-out requires an existing check-in record for the same student.

## Current Project Status

- Local-first app flow is working.
- GitHub source is ready.
- Firebase sync code exists, but `flutterfire configure` has not been completed yet.
- Firebase Hosting has not been configured yet.

## Next Recommended Steps

1. Configure Firebase with `flutterfire configure`.
2. Enable `Firebase.initializeApp(...)` in `smart_class_checkin/lib/main.dart`.
3. Set up Firebase Hosting if deployment is required by the PRD.
