import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:saathi/features/pet_training/presentation/screens/pet_training_screen.dart';
import 'package:saathi/features/pet_training/presentation/screens/cat_training_screen.dart';
import 'package:saathi/features/pet_training/presentation/screens/bird_training_screen.dart';
import 'package:saathi/features/pet_training/presentation/screens/coming_soon_screen.dart';

class PetSelectionScreen extends StatelessWidget {
  const PetSelectionScreen({super.key});

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
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.school,
                        size: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Choose Your Pet',
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
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              delegate: SliverChildListDelegate([
                _buildPetCard(
                  context,
                  'Dog',
                  Icons.pets,
                  Colors.blue,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PetTrainingScreen(),
                    ),
                  ),
                ),
                _buildPetCard(
                  context,
                  'Cat',
                  Icons.pets,
                  Colors.orange,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CatTrainingScreen(),
                    ),
                  ),
                ),
                _buildPetCard(
                  context,
                  'Bird',
                  Icons.flutter_dash,
                  Colors.green,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BirdTrainingScreen(),
                    ),
                  ),
                ),
                _buildPetCard(
                  context,
                  'Fish',
                  Icons.water,
                  Colors.cyan,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ComingSoonScreen(
                        petType: 'Fish',
                        petIcon: Icons.water,
                        primaryColor: Colors.cyan,
                      ),
                    ),
                  ),
                ),
                _buildPetCard(
                  context,
                  'Hamster',
                  Icons.pets,
                  Colors.brown,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ComingSoonScreen(
                        petType: 'Hamster',
                        petIcon: Icons.pets,
                        primaryColor: Colors.brown,
                      ),
                    ),
                  ),
                ),
                _buildPetCard(
                  context,
                  'More',
                  Icons.more_horiz,
                  Colors.purple,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ComingSoonScreen(
                        petType: 'More Pets',
                        petIcon: Icons.pets,
                        primaryColor: Colors.purple,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPetCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                color.withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().scale();
  }
} 