#!/bin/sh
cd ..

flutter clean
flutter pub get
flutter build web --dart-define=build.stage=release --wasm

# downloading required files for drift to work on web

cd build/web

# download sqlite
curl -L -O https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-2.4.6/sqlite3.wasm
# download drift
curl -L -O https://github.com/simolus3/drift/releases/download/drift-2.20.1/drift_worker.js
