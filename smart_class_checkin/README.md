# smart_class_checkin

Flutter application for the Smart Class Check-in prototype.

## Main Capabilities

- Check in with GPS and QR verification
- Record previous topic, expected topic, and pre-class mood
- Finish class with GPS and QR verification
- Record learned content, feedback, and post-class feeling
- Save attendance and reflection data locally with SQLite

## Run

```bash
flutter pub get
flutter run -d chrome --web-port 3000
```

## Notes

- For demo QR scanning, any non-empty QR code is accepted.
- Web camera permission is requested by the browser when the scanner opens.
- Firebase integration is prepared in code, but project configuration is not added yet.

## Repository Context

The repository root contains:

- `PRD.md`
- `README.md`
- `smart_class_checkin/`
