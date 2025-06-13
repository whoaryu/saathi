import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ComingSoonScreen extends StatelessWidget {
  final String petType;
  final IconData petIcon;
  final Color primaryColor;

  const ComingSoonScreen({
    super.key,
    required this.petType,
    required this.petIcon,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      primaryColor,
                      primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        petIcon,
                        size: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '$petType Training',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.construction,
                    size: 80,
                    color: primaryColor,
                  ).animate()
                    .scale(duration: const Duration(seconds: 2))
                    .then()
                    .shake(duration: const Duration(milliseconds: 500)),
                  const SizedBox(height: 24),
                  Text(
                    'Coming Soon!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                  ).animate().fadeIn().slideY(),
                  const SizedBox(height: 16),
                  Text(
                    'We\'re working hard to bring you amazing $petType training modules.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ).animate().fadeIn().slideY(),
                  const SizedBox(height: 32),
                  _buildFeatureCard(
                    context,
                    'Expert Training',
                    'Professional trainers and behaviorists',
                    Icons.school,
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureCard(
                    context,
                    'Step-by-Step Guides',
                    'Easy to follow instructions',
                    Icons.format_list_numbered,
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureCard(
                    context,
                    'Progress Tracking',
                    'Monitor your pet\'s development',
                    Icons.trending_up,
                  ),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Back to Pet Selection'),
                    style: FilledButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX();
  }
} 