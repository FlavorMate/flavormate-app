# FlavorMate

This is the Project for the FlavorMate frontend, which is written in Flutter.

## Getting Started

### Android

Want to join the closed beta? Send me your mail to be added to the test group.
[Mail me](mailto:android-beta@flavormate.de?subject=Apply for android closed beta)

Download the apk from the releases tab.

### iOS

Join the [public beta](https://testflight.apple.com/join/yp5BtJGx) via testflight.

### Web

Self host your web app with docker by simply creating a `docker-compose.yaml` (or download one from
the [examples](https://github.com/FlavorMate/flavormate-app/tree/main/examples)).

Alternatively download the web archive from the releases page and self host it manually.

#### Environment

*RECOMMENDED*

To permanently bind your frontend to your backend url add, the `BACKEND_URL` entry to your docker environment.

The user will then no longer be able to connect to other FlavorMate servers.
This improves the user experience and increases security.

| Key         | Required | Description                        | Example               | Default |
|-------------|----------|------------------------------------|-----------------------|---------|
| BACKEND_URL | No       | The url of your FlavorMate backend | `https://example.com` | `null`  |
