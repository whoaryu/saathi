import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:saathi/features/pet_training/presentation/screens/pet_training_screen.dart';
import 'package:saathi/features/pet_training/presentation/screens/cat_training_screen.dart';
import 'package:saathi/features/pet_training/presentation/screens/bird_training_screen.dart';
import 'package:saathi/features/pet_training/presentation/screens/coming_soon_screen.dart';
import 'package:saathi/features/chatbot/presentation/screens/chatbot_screen.dart';

class PetSelectionScreen extends StatefulWidget {
  const PetSelectionScreen({super.key});

  @override
  State<PetSelectionScreen> createState() => _PetSelectionScreenState();
}

class _PetSelectionScreenState extends State<PetSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with gradient
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF667EEA),
                      const Color(0xFF764BA2),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Animated icon
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.school,
                            size: 40,
                            color: Colors.white,
                          ),
                        ).animate().scale(delay: const Duration(milliseconds: 200)),
                        
                        const SizedBox(height: 24),
                        
                        Text(
                          'Choose Your Pet',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                              ),
                        ).animate().slideY(begin: 0.3, end: 0, delay: const Duration(milliseconds: 400)),
                        
                        const SizedBox(height: 8),
                        
                        Text(
                          'Start your training journey',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 16,
                              ),
                        ).animate().slideY(begin: 0.3, end: 0, delay: const Duration(milliseconds: 600)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Pet Cards Grid
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              delegate: SliverChildListDelegate([
                _buildModernPetCard(
                  context,
                  'Dog',
                  '🐕',
                  'Train your loyal companion',
                  const Color(0xFF4F46E5),
                  const Color(0xFF7C3AED),
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PetTrainingScreen()),
                  ),
                ),
                _buildModernPetCard(
                  context,
                  'Cat',
                  '🐱',
                  'Teach your feline friend',
                  const Color(0xFFF59E0B),
                  const Color(0xFFD97706),
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CatTrainingScreen()),
                  ),
                ),
                _buildModernPetCard(
                  context,
                  'Bird',
                  '🦜',
                  'Train your feathered friend',
                  const Color(0xFF10B981),
                  const Color(0xFF059669),
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BirdTrainingScreen()),
                  ),
                ),
                _buildModernPetCard(
                  context,
                  'Fish',
                  '🐠',
                  'Coming soon!',
                  const Color(0xFF06B6D4),
                  const Color(0xFF0891B2),
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
                _buildModernPetCard(
                  context,
                  'Hamster',
                  '🐹',
                  'Coming soon!',
                  const Color(0xFF8B5CF6),
                  const Color(0xFF7C3AED),
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
                _buildModernPetCard(
                  context,
                  'More',
                  '✨',
                  'More pets coming!',
                  const Color(0xFFEC4899),
                  const Color(0xFFDB2777),
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
          
          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
      
      // Floating Action Button for Chatbot
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleChatbot,
        backgroundColor: const Color(0xFF667EEA),
        elevation: 8,
        child: const Icon(
          Icons.chat_bubble,
          color: Colors.white,
        ),
      ),
      
      // Chatbot Panel
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildModernPetCard(
    BuildContext context,
    String title,
    String emoji,
    String subtitle,
    Color color1,
    Color color2,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color1.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color1, color2],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Emoji with background
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Title
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 6),
                  
                  // Subtitle
                  Expanded(
                    child: Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 11,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Arrow indicator
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.3, end: 0).scale(begin: const Offset(0.8, 0.8));
  }

  void _toggleChatbot() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChatbotScreen(),
      ),
    );
  }
} 