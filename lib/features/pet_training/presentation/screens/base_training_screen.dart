import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saathi/features/pet_training/domain/models/training_module.dart';
import 'package:saathi/features/pet_training/domain/models/training_progress.dart';
import 'package:saathi/features/pet_training/presentation/bloc/training_bloc.dart';
import 'package:saathi/features/pet_training/presentation/bloc/training_event.dart';
import 'package:saathi/features/pet_training/presentation/bloc/training_state.dart';
import 'package:saathi/features/pet_training/presentation/screens/training_lesson_screen.dart';

class BaseTrainingScreen extends StatefulWidget {
  final String petType;
  final List<TrainingModule> modules;
  final IconData petIcon;
  final Color primaryColor;

  const BaseTrainingScreen({
    super.key,
    required this.petType,
    required this.modules,
    required this.petIcon,
    required this.primaryColor,
  });

  @override
  State<BaseTrainingScreen> createState() => _BaseTrainingScreenState();
}

class _BaseTrainingScreenState extends State<BaseTrainingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showBadgeDialog(BuildContext context, TrainingBadge badge) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 16,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.amber.shade700,
                  Colors.orange.shade800,
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '🎉 BADGE UNLOCKED! 🎉',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.extrabold,
                    fontSize: 22,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    size: 64,
                    color: Colors.white,
                  ),
                ).animate().scale(delay: 200.ms).shimmer(duration: 1.5.seconds),
                const SizedBox(height: 20),
                Text(
                  badge.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  badge.description,
                  style: const TextStyle(
                    color: Colors.white90,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.orange.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Awesome!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).animate().scale(duration: 300.ms);
      },
    );
  }

  Widget _buildStreakAction(int streak) {
    final hasStreak = streak > 0;
    return Container(
      margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: hasStreak ? Colors.orange.shade800 : Colors.grey.shade700,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
        boxShadow: hasStreak
            ? [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.4),
                  blurRadius: 8,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          Text(
            '$streak days',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    ).animate(
      target: hasStreak ? 1.0 : 0.0,
    ).shimmer(
      duration: const Duration(seconds: 2),
      delay: const Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TrainingBloc>(
      create: (context) => TrainingBloc()..add(LoadTrainingProgress(petType: widget.petType)),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: BlocListener<TrainingBloc, TrainingState>(
              listener: (context, state) {
                if (state is TrainingFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMessage)),
                  );
                } else if (state is TrainingLoaded && state.newlyUnlockedBadges.isNotEmpty) {
                  for (final badge in state.newlyUnlockedBadges) {
                    _showBadgeDialog(context, badge);
                  }
                }
              },
              child: BlocBuilder<TrainingBloc, TrainingState>(
                builder: (context, state) {
                  if (state is TrainingLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is TrainingFailure) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: ${state.errorMessage}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<TrainingBloc>().add(
                                    LoadTrainingProgress(petType: widget.petType),
                                  );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is TrainingLoaded) {
                    final progress = state.progress;
                    
                    // Map local modules with progress from database
                    final activeModules = widget.modules.map((m) {
                      ModuleStatus status = ModuleStatus.locked;
                      if (progress.completedModules.contains(m.id)) {
                        status = ModuleStatus.completed;
                      } else if (progress.unlockedModules.contains(m.id)) {
                        status = ModuleStatus.unlocked;
                      }
                      return TrainingModule(
                        id: m.id,
                        title: m.title,
                        description: m.description,
                        iconPath: m.iconPath,
                        steps: m.steps,
                        status: status,
                        order: m.order,
                        difficulty: m.difficulty,
                        estimatedTime: m.estimatedTime,
                      );
                    }).toList();

                    final completedCount = activeModules.where((m) => m.status == ModuleStatus.completed).length;
                    final percent = activeModules.isEmpty ? 0.0 : completedCount / activeModules.length;

                    return CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          expandedHeight: 250,
                          pinned: true,
                          actions: [
                            _buildStreakAction(progress.streak),
                          ],
                          flexibleSpace: FlexibleSpaceBar(
                            background: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    widget.primaryColor,
                                    widget.primaryColor.withOpacity(0.8),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: SafeArea(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 20),
                                      Icon(
                                        widget.petIcon,
                                        size: 44,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '${widget.petType} Training',
                                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(height: 12),
                                      // Progress bar
                                      Container(
                                        width: 220,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: FractionallySizedBox(
                                          alignment: Alignment.centerLeft,
                                          widthFactor: percent,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(4),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white.withOpacity(0.6),
                                                  blurRadius: 4,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ).animate().scaleX(duration: 800.ms, curve: Curves.easeOutBack),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${(percent * 100).toStringAsFixed(0)}% Completed',
                                        style: const TextStyle(
                                          color: Colors.white90,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (progress.badges.isNotEmpty) ...[
                                        const SizedBox(height: 12),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: progress.badges.map((badge) {
                                              return Container(
                                                margin: const EdgeInsets.only(right: 8),
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(0.2),
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(color: Colors.amber.shade200.withOpacity(0.5), width: 1),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    const Icon(Icons.stars, color: Colors.amber, size: 14),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      badge.title,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ).animate().fadeIn(delay: 300.ms),
                                      ]
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final module = activeModules[index];
                                final isLast = index == activeModules.length - 1;

                                return Column(
                                  children: [
                                    _buildModuleBubble(context, module, index),
                                    if (!isLast) _buildConnector(module.status),
                                  ],
                                );
                              },
                              childCount: activeModules.length,
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildModuleBubble(BuildContext context, TrainingModule module, int index) {
    final isLocked = module.status == ModuleStatus.locked;
    final isCompleted = module.status == ModuleStatus.completed;

    return GestureDetector(
      onTap: isLocked
          ? null
          : () async {
              await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (innerContext) => TrainingLessonScreen(
                    module: module,
                    onComplete: () {
                      context.read<TrainingBloc>().add(
                            CompleteTrainingModule(
                              petType: widget.petType,
                              moduleId: module.id,
                            ),
                          );
                    },
                  ),
                ),
              );
            },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _getStatusColor(module.status).withOpacity(0.1),
                border: Border.all(
                  color: _getStatusColor(module.status),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _getStatusColor(module.status).withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    _getModuleIcon(module.id),
                    size: 40,
                    color: _getStatusColor(module.status),
                  ),
                  if (isCompleted)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  if (isLocked)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.lock,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    module.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    module.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          module.difficulty,
                          style: TextStyle(
                            color: widget.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer,
                              size: 14,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${module.estimatedTime} min',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX();
  }

  Widget _buildConnector(ModuleStatus status) {
    return Container(
      width: 2,
      height: 40,
      margin: const EdgeInsets.only(left: 50),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.3),
        borderRadius: BorderRadius.circular(1),
      ),
    ).animate().scaleY(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
  }

  Color _getStatusColor(ModuleStatus status) {
    switch (status) {
      case ModuleStatus.locked:
        return Colors.grey;
      case ModuleStatus.unlocked:
        return widget.primaryColor;
      case ModuleStatus.completed:
        return Colors.green;
    }
  }

  IconData _getModuleIcon(String moduleId) {
    switch (moduleId) {
      case 'basic_commands':
        return Icons.pets;
      case 'leash_training':
        return Icons.directions_walk;
      case 'house_training':
        return Icons.home;
      case 'socialization':
        return Icons.people;
      case 'advanced_commands':
        return Icons.star;
      case 'trick_training':
        return Icons.emoji_events;
      case 'behavior_modification':
        return Icons.psychology;
      case 'litter_training':
        return Icons.cleaning_services;
      case 'scratching_post':
        return Icons.architecture;
      case 'step_up':
        return Icons.front_hand;
      case 'target_training':
        return Icons.track_changes;
      case 'speech_training':
        return Icons.record_voice_over;
      default:
        return Icons.pets;
    }
  }
}