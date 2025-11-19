import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Map<String, dynamic>? user;
  Map<String, dynamic>? authResponse;
  String? token;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadAuth();
  }

  Future<void> _loadAuth() async {
    setState(() => loading = true);
    token = await AuthService.getToken();
    user = await AuthService.getUser();
    authResponse = await AuthService.getAuthResponse();
    setState(() => loading = false);
  }

  Future<void> _logout() async {
    await AuthService.clearAuth();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAuth,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'User Info',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: ${user?['name'] ?? '—'}'),
                          const SizedBox(height: 6),
                          Text('Email: ${user?['email'] ?? '—'}'),
                          const SizedBox(height: 6),
                          Text('Role: ${user?['role'] ?? '—'}'),
                          const SizedBox(height: 6),
                          Text('Verified: ${user?['isVerified'] ?? '—'}'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    'Auth Token',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SelectableText(token ?? 'No token saved'),
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    'Full Auth Response',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SelectableText(
                        authResponse != null
                            ? authResponse.toString()
                            : 'No auth response saved',
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      await AuthService.logSavedAuth();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logged auth to console')),
                      );
                    },
                    icon: const Icon(Icons.bug_report),
                    label: const Text('Print saved auth to console'),
                  ),

                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    onPressed: () async {
                      await AuthService.clearAuth();
                      await _loadAuth();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cleared saved auth')),
                      );
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Clear saved auth'),
                  ),
                ],
              ),
            ),
    );
  }
}
