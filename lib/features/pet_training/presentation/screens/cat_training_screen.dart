import 'package:flutter/material.dart';
import 'package:saathi/features/pet_training/domain/models/training_module.dart';
import 'package:saathi/features/pet_training/presentation/screens/base_training_screen.dart';

class CatTrainingScreen extends BaseTrainingScreen {
  CatTrainingScreen({super.key})
      : super(
          petType: 'Cat',
          modules: [
            TrainingModule(
              id: 'litter_training',
              title: 'Litter Box Training',
              description: 'Teach your cat to use the litter box properly',
              iconPath: 'assets/icons/litter_box.png',
              order: 1,
              status: ModuleStatus.unlocked,
              difficulty: 'Beginner',
              estimatedTime: 30,
              steps: [
                const TrainingStep(
                  title: 'Choose the Right Litter Box',
                  description: 'Select a litter box that\'s appropriate for your cat\'s size and age. Make sure it\'s easily accessible.',
                  tips: [
                    'Choose a box 1.5 times the length of your cat',
                    'Consider an open box for kittens',
                    'Place it in a quiet, accessible location',
                  ],
                  commonMistakes: [
                    'Using a box that\'s too small',
                    'Placing it in a noisy area',
                    'Using scented litter initially',
                  ],
                ),
                const TrainingStep(
                  title: 'Introduce the Litter Box',
                  description: 'Show your cat the litter box and let them explore it. Place them in it after meals and naps.',
                  tips: [
                    'Let your cat explore the box',
                    'Place them in it after meals',
                    'Keep it clean and accessible',
                  ],
                  commonMistakes: [
                    'Forcing the cat to use it',
                    'Not cleaning it regularly',
                    'Moving it frequently',
                  ],
                ),
              ],
            ),
            TrainingModule(
              id: 'scratching_post',
              title: 'Scratching Post Training',
              description: 'Teach your cat to use scratching posts instead of furniture',
              iconPath: 'assets/icons/scratching_post.png',
              order: 2,
              status: ModuleStatus.locked,
              difficulty: 'Beginner',
              estimatedTime: 45,
              steps: [
                const TrainingStep(
                  title: 'Choose the Right Scratching Post',
                  description: 'Select a scratching post that matches your cat\'s preferences and place it strategically.',
                  tips: [
                    'Choose a sturdy, tall post',
                    'Consider different materials',
                    'Place it near furniture they scratch',
                  ],
                  commonMistakes: [
                    'Using an unstable post',
                    'Placing it in a corner',
                    'Not considering cat\'s preferences',
                  ],
                ),
                const TrainingStep(
                  title: 'Encourage Use',
                  description: 'Use positive reinforcement to encourage your cat to use the scratching post.',
                  tips: [
                    'Use catnip to attract them',
                    'Reward with treats',
                    'Play near the post',
                  ],
                  commonMistakes: [
                    'Punishing for wrong behavior',
                    'Not being consistent',
                    'Moving the post frequently',
                  ],
                ),
              ],
            ),
            TrainingModule(
              id: 'basic_commands',
              title: 'Basic Commands',
              description: 'Teach your cat basic commands like come, sit, and stay',
              iconPath: 'assets/icons/cat_commands.png',
              order: 3,
              status: ModuleStatus.locked,
              difficulty: 'Intermediate',
              estimatedTime: 60,
              steps: [
                const TrainingStep(
                  title: 'Come Command',
                  description: 'Teach your cat to come when called using treats and positive reinforcement.',
                  tips: [
                    'Use high-value treats',
                    'Start in a quiet environment',
                    'Be consistent with the command',
                  ],
                  commonMistakes: [
                    'Using the command too often',
                    'Not rewarding consistently',
                    'Starting in a distracting environment',
                  ],
                ),
                const TrainingStep(
                  title: 'Sit Command',
                  description: 'Teach your cat to sit on command using a treat lure.',
                  tips: [
                    'Use a treat to lure the cat',
                    'Reward immediately',
                    'Keep sessions short',
                  ],
                  commonMistakes: [
                    'Moving the treat too quickly',
                    'Not being patient',
                    'Training when cat is not interested',
                  ],
                ),
              ],
            ),
          ],
          petIcon: Icons.pets,
          primaryColor: Colors.orange,
        );
} 