import 'package:flutter/material.dart';

class AITherapyScreen extends StatelessWidget {
  const AITherapyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MindMate AI Therapy')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AI Therapy Session',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Chat with your AI therapist to discuss your thoughts and feelings.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 24),
              // Placeholder for chat interface
              Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('Chat Interface - Coming Soon'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
