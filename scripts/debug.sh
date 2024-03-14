#!/bin/bash

# Start Flutter application in the background
flutter run -d web-server --web-port=58000 &

# Wait for Flutter application to start
sleep 10

# Start Dart DevTools
flutter pub global run devtools -p 9100