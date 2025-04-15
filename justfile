default: run

restore:
  flutter pub get
  npm i
  dart run husky install
  just setup-dotenv

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

run:
  flutter run --dart-define-from-file=.env
