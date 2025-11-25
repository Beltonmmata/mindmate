import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProfileProvider>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    if (provider.user == null || provider.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    nameController = TextEditingController(text: provider.user!["name"] ?? "");
    emailController = TextEditingController(
      text: provider.user!["email"] ?? "",
    );

    final themeBlue = Colors.blue.shade600;
    final themeOrange = Colors.orange.shade600;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: themeBlue,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ==========================
            //     PROFILE PHOTO CARD
            // ==========================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                    color: Colors.black.withOpacity(0.1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundImage:
                            provider.user!["profilePicture"] != null
                            ? NetworkImage(provider.user!["profilePicture"])
                            : null,
                        child: provider.user!["profilePicture"] == null
                            ? const Icon(Icons.person, size: 55)
                            : null,
                      ),

                      // Camera icon (edit button)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () async {
                            File? file;
                            final result = await FilePicker.platform.pickFiles(
                              type: FileType.image,
                              withData: true,
                            );

                            if (result != null && !kIsWeb) {
                              final path = result.files.single.path;
                              if (path != null) file = File(path);
                            }

                            if (file != null) {
                              await provider.updateProfilePicture(file);
                            }
                          },
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: themeOrange,
                            child: const Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Text(
                    provider.user!["name"] ?? "",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    provider.user!["email"] ?? "",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ==========================
            //         EDIT FIELDS
            // ==========================
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                    color: Colors.black.withOpacity(0.08),
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeBlue,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      provider.updateProfile(
                        nameController.text.trim(),
                        emailController.text.trim(),
                      );
                    },
                    child: const Text(
                      "Save Changes",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ==========================
            //      ACTION BUTTONS
            // ==========================
            _actionBtn(
              icon: Icons.logout,
              label: "Logout",
              color: Colors.red,
              onTap: () {
                // TODO: handle logout
              },
            ),

            _actionBtn(
              icon: Icons.verified_user,
              label: "Be a Therapist",
              color: themeOrange,
              onTap: () {
                // Navigate to apply screen
              },
            ),

            _actionBtn(
              icon: Icons.settings,
              label: "Settings",
              color: themeBlue,
              onTap: () {
                // Navigate to settings screen
              },
            ),

            _actionBtn(
              icon: Icons.lock_reset,
              label: "Change Password",
              color: Colors.deepPurple,
              onTap: () {
                // Go to Change Password
              },
            ),

            const SizedBox(height: 30),

            // Delete account with confirmation
            TextButton(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Confirm Delete"),
                    content: const Text(
                      "Are you sure you want to delete your account? This action cannot be undone.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(context, false), // Cancel
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () =>
                            Navigator.pop(context, true), // Confirm
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await provider.deleteMyAccount();
                  // TODO: navigate back to login or landing page
                }
              },
              child: const Text(
                "Delete My Account",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =================================================
  //   MODERN ACTION BUTTON COMPONENT
  // =================================================
  Widget _actionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required Function() onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        elevation: 3,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(.15),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 15),
                Text(label, style: const TextStyle(fontSize: 16)),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
