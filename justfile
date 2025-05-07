default: run-debug

alias b := bootstrap
alias sf := setup-firebase

bootstrap: && setup-dotenv
  flutter pub get
  dart run husky install

[private]
[unix]
setup-dotenv:
  if [ ! -f .env ]; then \
    cp .env.example .env; \
  fi

config-flutter:
  dart --disable-analytics
  flutter config --no-analytics
  flutter doctor --android-licenses

[private]
[windows]
setup-dotenv:
  IF NOT EXIST .env COPY .env.example .env

setup-firebase project_id:
  dart run flutterfire_cli:flutterfire configure --project='{{project_id}}'

run-debug:
  flutter run --dart-define-from-file=.env
