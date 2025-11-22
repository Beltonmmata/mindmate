import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Tips')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Daily Tips for Wellbeing',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Small steps to improve your mental health',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              _buildTipCard(
                title: 'Practice Gratitude',
                description: 'Write down 3 things you\'re grateful for today.',
                icon: Icons.favorite,
              ),
              const SizedBox(height: 12),
              _buildTipCard(
                title: 'Stay Active',
                description: 'Take a 20-minute walk or do light exercise.',
                icon: Icons.directions_walk,
              ),
              const SizedBox(height: 12),
              _buildTipCard(
                title: 'Sleep Well',
                description: 'Aim for 7-8 hours of quality sleep.',
                icon: Icons.bedtime,
              ),
              const SizedBox(height: 12),
              _buildTipCard(
                title: 'Connect with Others',
                description: 'Reach out to a friend or loved one.',
                icon: Icons.people,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 32, color: Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(description, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
