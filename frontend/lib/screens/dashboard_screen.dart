// MindMate Dashboard - Clean, Modern, Hierarchical Layout
// Material 3, Big CTA, Insights, Actions, Recommendations

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _DashboardView();
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: provider.loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 700;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _Header(user: provider.user, theme: theme),
                        const SizedBox(height: 20),

                        const _MainCTA(),
                        const SizedBox(height: 20),

                        const _MoodInsight(),
                        const SizedBox(height: 20),

                        _QuickActions(),
                        const SizedBox(height: 20),

                        isWide
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Expanded(child: _Recommendations()),
                                  const SizedBox(width: 16),
                                  const SizedBox(
                                    width: 300,
                                    child: _SideColumn(),
                                  ),
                                ],
                              )
                            : const _Recommendations(),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}

// ---------------------- HEADER ----------------------
class _Header extends StatelessWidget {
  final Map<String, dynamic>? user;
  final ThemeData theme;

  const _Header({required this.user, required this.theme});

  @override
  Widget build(BuildContext context) {
    final name = (user?['name'] ?? 'User').toString();
    final initial = name.trim().isNotEmpty
        ? name.trim().split(' ').first[0].toUpperCase()
        : 'U';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Text(
              initial,
              style: TextStyle(
                fontSize: 24,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 2),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
    );
  }
}

// ---------------------- MAIN CTA ----------------------
class _MainCTA extends StatelessWidget {
  const _MainCTA();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/ai-therapy'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.psychology, size: 40, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Talk to MindMate AI',
                style: theme.textTheme.headlineSmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// ---------------------- MOOD INSIGHT ----------------------
class _MoodInsight extends StatelessWidget {
  const _MoodInsight();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Mood Trend',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            height: 120,
            alignment: Alignment.center,
            child: const Text('Line Chart Placeholder'),
          ),
        ],
      ),
    );
  }
}

// ---------------------- QUICK ACTIONS ----------------------
class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionItem(
        icon: Icons.schedule,
        label: 'Book Session',
        route: '/therapy-sessions',
      ),
      _ActionItem(
        icon: Icons.mood,
        label: 'Check Mood',
        route: '/mood-tracker',
      ),
      _ActionItem(icon: Icons.book, label: 'Journal', route: '/journals'),
      _ActionItem(icon: Icons.people, label: 'Community', route: '/community'),
    ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) => actions[i],
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: actions.length,
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: theme.colorScheme.primary),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

// ---------------------- RECOMMENDATIONS ----------------------
class _Recommendations extends StatelessWidget {
  const _Recommendations();

  @override
  Widget build(BuildContext context) {
    final recs = [
      _RecItem(
        icon: Icons.female,
        title: 'Find a Female Therapist',
        subtitle: 'Matched based on your preferences',
        route: '/therapists',
      ),
      _RecItem(
        icon: Icons.psychology_alt,
        title: 'AI Therapy Tools',
        subtitle: 'Guided exercises for stress and anxiety',
        route: '/ai-tools',
      ),
      _RecItem(
        icon: Icons.lightbulb,
        title: 'Daily Tip',
        subtitle: 'A small step to improve your wellbeing',
        route: '/tips',
      ),
    ];

    return Column(
      children: [
        for (var item in recs) ...[item, const SizedBox(height: 12)],
      ],
    );
  }
}

class _RecItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;

  const _RecItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 32, color: theme.colorScheme.primary),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}

// ---------------------- SIDE COLUMN ----------------------
class _SideColumn extends StatelessWidget {
  const _SideColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _sideCard('Today', 'No sessions scheduled'),
        const SizedBox(height: 12),
        _sideCard('Tip', 'Take 5 deep breaths right now'),
      ],
    );
  }

  Widget _sideCard(String title, String desc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(desc, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
