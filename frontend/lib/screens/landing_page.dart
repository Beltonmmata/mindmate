import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top section with image
          Expanded(
            flex: 6,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/landing_page.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.broken_image, size: 72, color: Colors.grey),
                        SizedBox(height: 8),
                        Text(
                          'Image not found',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),

                // Smooth gradient fade
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 220,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.06),
                          Theme.of(context).scaffoldBackgroundColor,
                        ],
                        stops: [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom section — now scrollable, overflow-proof
          Expanded(
            flex: 4,
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to MindMate',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'We will help you manage your mental health.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),

                      const SizedBox(height: 22),

                      // Sign In button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/login'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Register button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/register'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'Create an account',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
