#!/bin/sh
cd ..

ROOT=$(PWD)

flutter clean
flutter pub get
flutter build web --dart-define=build.stage=beta --wasm

cd build/web || exit

# modifying service worker to exclude the backend url file from getting cached
sed -i '' '/"assets\/assets\/web\/backend_url.txt"/d' flutter_service_worker.js

# downloading required files for drift to work on web
# download sqlite
curl -L -O https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-2.4.6/sqlite3.wasm
# download drift
curl -L -O https://github.com/simolus3/drift/releases/download/drift-2.20.1/drift_worker.js

cd "$ROOT" || exit

docker buildx build --no-cache -t ghcr.io/flavormate/flavormate-webapp:latest --platform linux/amd64,linux/arm64 --push -f ./build_assets/docker/Dockerfile .
