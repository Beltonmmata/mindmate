import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

// Base URL for backend API
// Always use your production URL unless developing locally
final String BASE_URL = (() {
  // Web builds: point to production
  if (kIsWeb) {
    return 'https://mindmate-production-92e0.up.railway.app/api';
  }

  // Android emulator during local development (optional)
  if (Platform.isAndroid) {
    return 'https://mindmate-production-92e0.up.railway.app/api';
  }

  // iOS simulator or other platforms: production
  return 'https://mindmate-production-92e0.up.railway.app/api';
})();

// Key for storing JWT token
const String TOKEN_KEY = "auth_token";
