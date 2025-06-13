enum ModuleStatus { locked, unlocked, completed }

class TrainingStep {
  final String title;
  final String description;
  final String? imageUrl;
  final String? videoUrl;
  final String? blogUrl;
  final List<String> tips;
  final List<String> commonMistakes;

  const TrainingStep({
    required this.title,
    required this.description,
    this.imageUrl,
    this.videoUrl,
    this.blogUrl,
    this.tips = const [],
    this.commonMistakes = const [],
  });
}

class TrainingModule {
  final String id;
  final String title;
  final String description;
  final String iconPath;
  final List<TrainingStep> steps;
  final ModuleStatus status;
  final int order;
  final String difficulty;
  final int estimatedTime; // in minutes

  const TrainingModule({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.steps,
    this.status = ModuleStatus.locked,
    required this.order,
    required this.difficulty,
    required this.estimatedTime,
  });

  static List<TrainingModule> get modules => [
        TrainingModule(
          id: 'basic_commands',
          title: 'Basic Commands',
          description: 'Master essential commands like Sit, Stay, and Come',
          iconPath: 'assets/icons/sit_command.png',
          order: 1,
          status: ModuleStatus.unlocked,
          difficulty: 'Beginner',
          estimatedTime: 30,
          steps: [
            const TrainingStep(
              title: 'The Sit Command',
              description: 'Teaching your dog to sit is the foundation of obedience training. Start by holding a treat close to your dog\'s nose, then move your hand up, allowing their head to follow the treat and causing their bottom to lower.',
              videoUrl: 'https://www.youtube.com/watch?v=DPKtPo5zU4Y',
              tips: [
                'Use high-value treats for better motivation',
                'Keep training sessions short (5-10 minutes)',
                'Practice in different locations for better generalization',
                'Use a clear, consistent hand signal along with the verbal command',
              ],
              commonMistakes: [
                'Moving the treat too quickly',
                'Not rewarding immediately after the correct behavior',
                'Repeating the command multiple times',
                'Training when the dog is too excited or tired',
              ],
            ),
            const TrainingStep(
              title: 'The Stay Command',
              description: 'Once your dog has mastered sitting, teach them to stay. Ask your dog to sit, then open your palm in front of you and say "Stay." Take a few steps back and reward them if they stay.',
              videoUrl: 'https://www.youtube.com/watch?v=DPKtPo5zU4Y',
              tips: [
                'Start with very short durations',
                'Gradually increase distance and duration',
                'Always return to your dog to give the reward',
                'Use a release word like "Okay" or "Free"',
              ],
              commonMistakes: [
                'Moving too far too quickly',
                'Not using a release word',
                'Rewarding while the dog is moving',
                'Expecting too much too soon',
              ],
            ),
            const TrainingStep(
              title: 'The Come Command',
              description: 'Put a leash on your dog and get down to their level. Say "Come" while gently pulling on the leash. When they come to you, reward them with affection and a treat.',
              videoUrl: 'https://www.youtube.com/watch?v=DPKtPo5zU4Y',
              tips: [
                'Make coming to you the most rewarding thing',
                'Use an excited, happy voice',
                'Practice in a safe, enclosed area first',
                'Never punish your dog for coming to you',
              ],
              commonMistakes: [
                'Calling the dog when you can\'t enforce the command',
                'Using the command for negative things',
                'Not making the reward valuable enough',
                'Calling the dog repeatedly without response',
              ],
            ),
          ],
        ),
        TrainingModule(
          id: 'leash_training',
          title: 'Leash Training',
          description: 'Learn to walk your dog without pulling',
          iconPath: 'assets/icons/leash_training.png',
          order: 2,
          status: ModuleStatus.locked,
          difficulty: 'Beginner',
          estimatedTime: 45,
          steps: [
            const TrainingStep(
              title: 'Getting Used to the Leash',
              description: 'Let your dog get comfortable with the leash by letting them wear it around the house. Reward them for calm behavior while wearing it.',
              videoUrl: 'https://www.youtube.com/watch?v=DPKtPo5zU4Y',
              tips: [
                'Start with a lightweight leash',
                'Let the dog drag the leash indoors first',
                'Reward calm behavior around the leash',
                'Practice in short sessions',
              ],
              commonMistakes: [
                'Starting with a heavy or restrictive leash',
                'Moving too quickly to outdoor training',
                'Not addressing leash anxiety',
                'Using the wrong type of collar or harness',
              ],
            ),
            const TrainingStep(
              title: 'Walking Without Pulling',
              description: 'When your dog pulls, stop walking. Wait until they return to your side, then continue walking. Reward them for walking beside you.',
              videoUrl: 'https://www.youtube.com/watch?v=DPKtPo5zU4Y',
              tips: [
                'Use a front-clip harness for better control',
                'Change direction when the dog pulls',
                'Reward the dog for checking in with you',
                'Keep the leash loose at all times',
              ],
              commonMistakes: [
                'Pulling back on the leash',
                'Using punishment or corrections',
                'Not being consistent with the rules',
                'Walking when the dog is too excited',
              ],
            ),
            const TrainingStep(
              title: 'Changing Directions',
              description: 'Practice changing directions frequently. This teaches your dog to pay attention to you and stay close.',
              videoUrl: 'https://www.youtube.com/watch?v=DPKtPo5zU4Y',
              tips: [
                'Make direction changes fun and rewarding',
                'Use a cue word before changing direction',
                'Reward the dog for following you',
                'Practice in different environments',
              ],
              commonMistakes: [
                'Changing directions too abruptly',
                'Not rewarding successful following',
                'Practicing only in familiar places',
                'Moving too quickly for the dog to follow',
              ],
            ),
          ],
        ),
        TrainingModule(
          id: 'house_training',
          title: 'House Training',
          description: 'Teach your pet proper bathroom habits',
          iconPath: 'assets/icons/house_training.png',
          order: 3,
          status: ModuleStatus.locked,
          difficulty: 'Beginner',
          estimatedTime: 60,
          steps: [
            const TrainingStep(
              title: 'Establish a Routine',
              description: 'Take your dog out at the same times every day. Puppies need to go out more frequently, especially after eating, playing, or waking up.',
              videoUrl: 'https://www.youtube.com/watch?v=DPKtPo5zU4Y',
              tips: [
                'Take the dog out first thing in the morning',
                'Schedule regular potty breaks',
                'Watch for signs that the dog needs to go',
                'Keep a consistent feeding schedule',
              ],
              commonMistakes: [
                'Not taking the dog out frequently enough',
                'Inconsistent schedule',
                'Not supervising the dog indoors',
                'Punishing accidents after the fact',
              ],
            ),
            const TrainingStep(
              title: 'Choose a Spot',
              description: 'Pick a specific spot outside for bathroom breaks. The scent will help your dog understand where to go.',
              videoUrl: 'https://www.youtube.com/watch?v=DPKtPo5zU4Y',
              tips: [
                'Choose an easily accessible spot',
                'Use a consistent command',
                'Reward immediately after going',
                'Clean up accidents thoroughly',
              ],
              commonMistakes: [
                'Not cleaning accidents properly',
                'Using different spots',
                'Not using a command',
                'Rushing the dog to finish',
              ],
            ),
            const TrainingStep(
              title: 'Reward Success',
              description: 'Immediately reward your dog with treats and praise when they go in the right spot. This reinforces the desired behavior.',
              videoUrl: 'https://www.youtube.com/watch?v=DPKtPo5zU4Y',
              tips: [
                'Use high-value treats',
                'Praise enthusiastically',
                'Reward immediately after going',
                'Be consistent with rewards',
              ],
              commonMistakes: [
                'Delaying the reward',
                'Not being enthusiastic enough',
                'Inconsistent rewarding',
                'Using low-value treats',
              ],
            ),
          ],
        ),
        TrainingModule(
          id: 'socialization',
          title: 'Socialization',
          description: 'Help your pet become comfortable with others',
          iconPath: 'assets/icons/socialization.png',
          order: 4,
          status: ModuleStatus.locked,
          difficulty: 'Intermediate',
          estimatedTime: 45,
          steps: [
            const TrainingStep(
              title: 'Meeting New People',
              description: 'Introduce your dog to different types of people in controlled settings. Reward calm behavior and gradually increase the complexity of situations.',
              videoUrl: 'https://www.youtube.com/watch?v=DPKtPo5zU4Y',
              tips: [
                'Start with one person at a time',
                'Let the dog approach people',
                'Reward calm behavior',
                'Expose to different types of people',
              ],
              commonMistakes: [
                'Forcing interactions',
                'Not reading dog\'s body language',
                'Moving too quickly',
                'Not rewarding calm behavior',
              ],
            ),
            const TrainingStep(
              title: 'Meeting Other Dogs',
              description: 'Start with one-on-one playdates with well-behaved dogs. Always supervise interactions and be ready to intervene if needed.',
              videoUrl: 'https://www.youtube.com/watch?v=DPKtPo5zU4Y',
              tips: [
                'Choose calm, friendly dogs',
                'Meet in neutral territory',
                'Keep initial meetings short',
                'Watch for signs of stress',
              ],
              commonMistakes: [
                'Not supervising interactions',
                'Meeting too many dogs at once',
                'Ignoring warning signs',
                'Not having an escape plan',
              ],
            ),
            const TrainingStep(
              title: 'Handling Different Situations',
              description: 'Expose your dog to various environments, sounds, and experiences. Make each new experience positive with treats and praise.',
              videoUrl: 'https://www.youtube.com/watch?v=DPKtPo5zU4Y',
              tips: [
                'Start with less stimulating environments',
                'Use high-value treats',
                'Keep sessions short',
                'Watch for signs of stress',
              ],
              commonMistakes: [
                'Moving too quickly',
                'Not reading body language',
                'Forcing the dog to stay',
                'Not having an escape plan',
              ],
            ),
          ],
        ),
        TrainingModule(
          id: 'advanced_commands',
          title: 'Advanced Commands',
          description: 'Take your training to the next level',
          iconPath: 'assets/icons/advanced_commands.png',
          order: 5,
          status: ModuleStatus.locked,
          difficulty: 'Advanced',
          estimatedTime: 60,
          steps: [
            const TrainingStep(
              title: 'The Down Command',
              description: 'Start with your dog in a sitting position. Hold a treat in front of their nose, then move it down to the ground. Reward them when they lie down.',
              videoUrl: 'https://www.youtube.com/watch?v=DPKtPo5zU4Y',
              tips: [
                'Use a clear hand signal',
                'Keep the treat close to the nose',
                'Reward the final position',
                'Practice on different surfaces',
              ],
              commonMistakes: [
                'Moving the treat too quickly',
                'Not rewarding the final position',
                'Using unclear signals',
                'Practicing only on comfortable surfaces',
              ],
            ),
            const TrainingStep(
              title: 'The Leave It Command',
              description: 'Place a treat in your closed hand. When your dog tries to get it, say "Leave it." Reward them when they stop trying.',
              videoUrl: 'https://www.youtube.com/watch?v=DPKtPo5zU4Y',
              tips: [
                'Start with less tempting items',
                'Use a different reward than the item',
                'Be consistent with the command',
                'Practice with different items',
              ],
              commonMistakes: [
                'Using too tempting items',
                'Not being consistent',
                'Moving too quickly',
                'Not having a good reward',
              ],
            ),
            const TrainingStep(
              title: 'The Drop It Command',
              description: 'When your dog has a toy, offer a treat and say "Drop it." When they release the toy, give them the treat and praise.',
              videoUrl: 'https://www.youtube.com/watch?v=DPKtPo5zU4Y',
              tips: [
                'Start with less valuable items',
                'Use high-value treats',
                'Practice with different items',
                'Make it a fun game',
              ],
              commonMistakes: [
                'Using too valuable items',
                'Not having a good reward',
                'Moving too quickly',
                'Not making it fun',
              ],
            ),
          ],
        ),
        TrainingModule(
          id: 'trick_training',
          title: 'Fun Tricks',
          description: 'Teach your dog impressive tricks',
          iconPath: 'assets/icons/trick_training.png',
          order: 6,
          status: ModuleStatus.locked,
          difficulty: 'Intermediate',
          estimatedTime: 45,
          steps: [
            const TrainingStep(
              title: 'Shake Hands',
              description: 'Teach your dog to offer their paw for a handshake. Start by gently lifting their paw and rewarding them.',
              videoUrl: 'https://www.youtube.com/watch?v=DPKtPo5zU4Y',
              tips: [
                'Start with a sitting position',
                'Use a clear hand signal',
                'Reward the paw lift',
                'Add the verbal cue gradually',
              ],
              commonMistakes: [
                'Moving too quickly',
                'Not rewarding the initial paw lift',
                'Using unclear signals',
                'Practicing when the dog is tired',
              ],
            ),
            const TrainingStep(
              title: 'Spin',
              description: 'Teach your dog to spin in a circle. Use a treat to guide them in a circle and reward the complete spin.',
              videoUrl: 'https://www.youtube.com/watch?v=DPKtPo5zU4Y',
              tips: [
                'Start with small circles',
                'Use a clear hand signal',
                'Reward the complete spin',
                'Practice both directions',
              ],
              commonMistakes: [
                'Moving the treat too quickly',
                'Not rewarding the complete spin',
                'Practicing only one direction',
                'Using unclear signals',
              ],
            ),
            const TrainingStep(
              title: 'Play Dead',
              description: 'Teach your dog to lie on their side and stay still. Start with the down position and gradually shape the behavior.',
              videoUrl: 'https://www.youtube.com/watch?v=DPKtPo5zU4Y',
              tips: [
                'Start with the down command',
                'Use a clear hand signal',
                'Reward the side position',
                'Add duration gradually',
              ],
              commonMistakes: [
                'Moving too quickly',
                'Not rewarding the side position',
                'Using unclear signals',
                'Expecting too much too soon',
              ],
            ),
          ],
        ),
        TrainingModule(
          id: 'behavior_modification',
          title: 'Behavior Modification',
          description: 'Address common behavior issues',
          iconPath: 'assets/icons/behavior_modification.png',
          order: 7,
          status: ModuleStatus.locked,
          difficulty: 'Advanced',
          estimatedTime: 90,
          steps: [
            const TrainingStep(
              title: 'Separation Anxiety',
              description: 'Help your dog feel comfortable when alone. Start with very short absences and gradually increase duration.',
              videoUrl: 'https://www.youtube.com/watch?v=DPKtPo5zU4Y',
              tips: [
                'Start with very short absences',
                'Create a safe space',
                'Use calming aids',
                'Practice departure cues',
              ],
              commonMistakes: [
                'Moving too quickly',
                'Not creating a safe space',
                'Making departures emotional',
                'Not practicing regularly',
              ],
            ),
            const TrainingStep(
              title: 'Barking Control',
              description: 'Teach your dog when it\'s appropriate to bark. Reward quiet behavior and redirect excessive barking.',
              videoUrl: 'https://www.youtube.com/watch?v=DPKtPo5zU4Y',
              tips: [
                'Identify the trigger',
                'Reward quiet behavior',
                'Use a quiet command',
                'Provide mental stimulation',
              ],
              commonMistakes: [
                'Punishing barking',
                'Not addressing the cause',
                'Inconsistent training',
                'Not providing alternatives',
              ],
            ),
            const TrainingStep(
              title: 'Jumping Control',
              description: 'Teach your dog to greet people politely without jumping. Reward four-on-the-floor behavior.',
              videoUrl: 'https://www.youtube.com/watch?v=DPKtPo5zU4Y',
              tips: [
                'Reward calm greetings',
                'Ignore jumping behavior',
                'Teach an alternative behavior',
                'Be consistent with all visitors',
              ],
              commonMistakes: [
                'Pushing the dog away',
                'Inconsistent training',
                'Not teaching an alternative',
                'Not being patient',
              ],
            ),
          ],
        ),
      ];
} 