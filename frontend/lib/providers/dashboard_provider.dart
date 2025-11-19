import 'package:flutter/material.dart';
import '../services/auth_service.dart';

/// DashboardProvider loads user/auth data for the dashboard and exposes it to the UI.
class DashboardProvider extends ChangeNotifier {
  bool _loading = true;
  bool get loading => _loading;

  Map<String, dynamic>? _user;
  Map<String, dynamic>? get user => _user;

  Map<String, dynamic>? _authResponse;
  Map<String, dynamic>? get authResponse => _authResponse;

  String? _token;
  String? get token => _token;

  DashboardProvider() {
    load();
  }

  Future<void> load() async {
    _loading = true;
    notifyListeners();

    _token = await AuthService.getToken();
    _user = await AuthService.getUser();
    _authResponse = await AuthService.getAuthResponse();

    _loading = false;
    notifyListeners();
  }

  Future<void> refresh() => load();

  Future<void> clearAuth() async {
    await AuthService.clearAuth();
    await load();
  }
}
