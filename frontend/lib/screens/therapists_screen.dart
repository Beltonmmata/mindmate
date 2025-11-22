import 'package:flutter/material.dart';

class TherapistsScreen extends StatelessWidget {
  const TherapistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Find a Therapist')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Find a Female Therapist',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Matched based on your preferences',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              _buildTherapistCard(
                name: 'Dr. Sarah Johnson',
                specialty: 'Anxiety & Depression',
                experience: '8 years',
              ),
              const SizedBox(height: 12),
              _buildTherapistCard(
                name: 'Dr. Emily Davis',
                specialty: 'Trauma & PTSD',
                experience: '10 years',
              ),
              const SizedBox(height: 12),
              _buildTherapistCard(
                name: 'Dr. Rachel Smith',
                specialty: 'Relationships & Family',
                experience: '7 years',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTherapistCard({
    required String name,
    required String specialty,
    required String experience,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text('Specialty: $specialty'),
            const SizedBox(height: 4),
            Text('Experience: $experience'),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () {}, child: const Text('Book Session')),
          ],
        ),
      ),
    );
  }
}
