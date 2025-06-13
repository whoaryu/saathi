import 'package:flutter/material.dart';
import 'package:saathi/features/pet_training/domain/models/training_module.dart';
import 'package:saathi/features/pet_training/presentation/screens/base_training_screen.dart';

class BirdTrainingScreen extends BaseTrainingScreen {
  BirdTrainingScreen({super.key})
      : super(
          petType: 'Bird',
          modules: [
            TrainingModule(
              id: 'step_up',
              title: 'Step Up Training',
              description: 'Teach your bird to step up onto your hand or perch',
              iconPath: 'assets/icons/bird_step_up.png',
              order: 1,
              status: ModuleStatus.unlocked,
              difficulty: 'Beginner',
              estimatedTime: 30,
              steps: [
                const TrainingStep(
                  title: 'Getting Started',
                  description: 'Create a calm environment and have treats ready. Approach your bird slowly and speak softly.',
                  tips: [
                    'Choose a quiet room',
                    'Use high-value treats',
                    'Keep sessions short (5-10 minutes)',
                  ],
                  commonMistakes: [
                    'Moving too quickly',
                    'Not being patient',
                    'Training when bird is tired',
                  ],
                ),
                const TrainingStep(
                  title: 'Hand Introduction',
                  description: 'Place your hand near the bird\'s perch, palm up, and offer a treat. Let the bird get comfortable with your hand.',
                  tips: [
                    'Keep your hand steady',
                    'Don\'t force interaction',
                    'Reward any positive response',
                  ],
                  commonMistakes: [
                    'Moving hand suddenly',
                    'Not waiting for bird to be ready',
                    'Getting frustrated',
                  ],
                ),
                const TrainingStep(
                  title: 'Step Up Command',
                  description: 'Once comfortable, gently press your finger against the bird\'s lower chest while saying "step up". Reward when they step onto your hand.',
                  tips: [
                    'Use consistent command',
                    'Reward immediately',
                    'Practice daily',
                  ],
                  commonMistakes: [
                    'Inconsistent commands',
                    'Not rewarding properly',
                    'Rushing the process',
                  ],
                ),
              ],
            ),
            TrainingModule(
              id: 'target_training',
              title: 'Target Training',
              description: 'Teach your bird to touch a target stick with their beak',
              iconPath: 'assets/icons/bird_target.png',
              order: 2,
              status: ModuleStatus.locked,
              difficulty: 'Beginner',
              estimatedTime: 45,
              steps: [
                const TrainingStep(
                  title: 'Target Introduction',
                  description: 'Introduce a target stick (like a chopstick) to your bird. Let them explore it naturally.',
                  tips: [
                    'Use a colorful target',
                    'Keep sessions short',
                    'Stay positive',
                  ],
                  commonMistakes: [
                    'Moving target too quickly',
                    'Not being patient',
                    'Forcing interaction',
                  ],
                ),
                const TrainingStep(
                  title: 'Touch Training',
                  description: 'Hold the target near the bird and reward any interaction with it. Gradually shape the behavior to touch the target.',
                  tips: [
                    'Reward any interest',
                    'Move target slowly',
                    'Keep bird engaged',
                  ],
                  commonMistakes: [
                    'Expecting too much too soon',
                    'Not rewarding small steps',
                    'Getting frustrated',
                  ],
                ),
                const TrainingStep(
                  title: 'Follow the Target',
                  description: 'Once your bird touches the target, move it to different positions and reward them for following it.',
                  tips: [
                    'Start with small movements',
                    'Increase difficulty gradually',
                    'Keep sessions fun',
                  ],
                  commonMistakes: [
                    'Moving target too far',
                    'Not rewarding consistently',
                    'Making it too difficult',
                  ],
                ),
              ],
            ),
            TrainingModule(
              id: 'speech_training',
              title: 'Speech Training',
              description: 'Teach your bird to mimic words and sounds',
              iconPath: 'assets/icons/bird_speech.png',
              order: 3,
              status: ModuleStatus.locked,
              difficulty: 'Intermediate',
              estimatedTime: 60,
              steps: [
                const TrainingStep(
                  title: 'Sound Association',
                  description: 'Start with simple sounds and words. Repeat them clearly and consistently in a quiet environment.',
                  tips: [
                    'Choose simple words',
                    'Speak clearly',
                    'Be consistent',
                  ],
                  commonMistakes: [
                    'Using complex words',
                    'Speaking too quickly',
                    'Not being patient',
                  ],
                ),
                const TrainingStep(
                  title: 'Reward Attempts',
                  description: 'Reward any attempt to mimic sounds, even if not perfect. Gradually shape the behavior.',
                  tips: [
                    'Reward any sound',
                    'Stay positive',
                    'Keep sessions short',
                  ],
                  commonMistakes: [
                    'Not rewarding attempts',
                    'Getting frustrated',
                    'Expecting perfection',
                  ],
                ),
                const TrainingStep(
                  title: 'Word Association',
                  description: 'Associate words with actions or objects. For example, say "hello" when greeting your bird.',
                  tips: [
                    'Use context',
                    'Be consistent',
                    'Make it fun',
                  ],
                  commonMistakes: [
                    'Inconsistent usage',
                    'Not providing context',
                    'Rushing the process',
                  ],
                ),
              ],
            ),
          ],
          petIcon: Icons.flutter_dash,
          primaryColor: Colors.green,
        );
} 