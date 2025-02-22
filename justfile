default: run

restore:
  flutter run ./bootstrap.dart

run:
  flutter run --dart-define-from-file=.env
