default: run

restore:
  flutter run ./scripts/bootstrap.dart

run:
  flutter run --dart-define-from-file=.env
