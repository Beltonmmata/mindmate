import 'package:flutter/material.dart';

class AIToolsScreen extends StatelessWidget {
  const AIToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Tools')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AI Therapy Tools',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Guided exercises for stress and anxiety management',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              _buildToolCard(
                title: 'Breathing Exercise',
                description: 'Guided breathing techniques',
                icon: Icons.air,
              ),
              const SizedBox(height: 12),
              _buildToolCard(
                title: 'Mindfulness Meditation',
                description: 'Calm your mind and body',
                icon: Icons.spa,
              ),
              const SizedBox(height: 12),
              _buildToolCard(
                title: 'Cognitive Exercises',
                description: 'Challenge negative thoughts',
                icon: Icons.psychology,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolCard({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
