default: run-debug

alias s := setup-devenv
alias sf := setup-firebase

setup-devenv: && setup-dotenv
  flutter pub get
  dart run husky install

[private]
[unix]
setup-dotenv:
  if [ ! -f .env ]; then \
    cp .env.example .env; \
  fi

[private]
[windows]
setup-dotenv:
  IF NOT EXIST .env COPY .env.example .env

setup-firebase project_id:
  dart run flutterfire_cli:flutterfire configure --project='{{project_id}}'

run-debug:
  flutter run --dart-define-from-file=.env
