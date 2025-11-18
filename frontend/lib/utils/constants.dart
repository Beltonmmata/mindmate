import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

// Determine the correct backend base URL depending on the platform.
// - Android emulator (Android Studio AVD): use 10.0.2.2 to reach host localhost
// - iOS simulator and desktop builds: use localhost
// - Web builds should point to the deployed backend or match the web server origin
final String BASE_URL = (() {
  if (kIsWeb) {
    // For web, use deployed backend by default. Change to your dev URL if needed.
    return 'https://mindmate-384v.onrender.com/api/auth';
  }

  if (Platform.isAndroid) {
    return 'http://10.0.2.2:5000/api/auth';
  }

  // iOS simulator, Linux, macOS, Windows, etc. can use localhost when backend runs locally
  return 'http://localhost:5000/api/auth';
})();

const String TOKEN_KEY = "auth_token";
