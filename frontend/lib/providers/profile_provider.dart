import 'dart:io';
import 'package:flutter/material.dart';
import '../services/profile_service.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService _service = ProfileService();

  Map<String, dynamic>? user;
  bool loading = false;

  // LOAD PROFILE
  Future<void> loadProfile() async {
    try {
      loading = true;
      notifyListeners();

      final data = await _service.getProfile();

      user = data["data"]?["user"] ?? data["user"] ?? data;
    } catch (e) {
      debugPrint("PROFILE LOAD ERROR: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // UPDATE NAME & EMAIL
  Future<void> updateProfile(String name, String email) async {
    try {
      loading = true;
      notifyListeners();

      final data = await _service.updateProfile(name, email);
      user = data["data"]?["user"] ?? data["user"] ?? user;
    } catch (e) {
      debugPrint("PROFILE UPDATE ERROR: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // UPDATE PROFILE PICTURE
  Future<void> updateProfilePicture(File file) async {
    try {
      loading = true;
      notifyListeners();

      final data = await _service.uploadProfilePicture(file);
      user = data["data"]?["user"] ?? data["user"] ?? user;
    } catch (e) {
      debugPrint("PROFILE PIC ERROR: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  // DELETE ACCOUNT
  Future<void> deleteMyAccount() async {
    try {
      loading = true;
      notifyListeners();

      await _service.deleteAccount();

      user = null;
    } catch (e) {
      debugPrint("DELETE ERROR: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
