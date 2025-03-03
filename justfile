default: run

restore:
  dart run ./scripts/bootstrap.dart

run:
  flutter run --dart-define-from-file=.env
  
