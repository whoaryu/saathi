import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:saathi/features/pet_training/domain/models/training_module.dart';
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
  late List<TrainingModule> _modules;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _modules = List.from(widget.modules);
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

  void _unlockNextModule(int completedIndex) {
    if (completedIndex < _modules.length - 1) {
      setState(() {
        final nextModule = _modules[completedIndex + 1];
        _modules[completedIndex + 1] = TrainingModule(
          id: nextModule.id,
          title: nextModule.title,
          description: nextModule.description,
          iconPath: nextModule.iconPath,
          steps: nextModule.steps,
          status: ModuleStatus.unlocked,
          order: nextModule.order,
          difficulty: nextModule.difficulty,
          estimatedTime: nextModule.estimatedTime,
        );
      });
    }
  }

  void _completeModule(int index) {
    setState(() {
      final module = _modules[index];
      _modules[index] = TrainingModule(
        id: module.id,
        title: module.title,
        description: module.description,
        iconPath: module.iconPath,
        steps: module.steps,
        status: ModuleStatus.completed,
        order: module.order,
        difficulty: module.difficulty,
        estimatedTime: module.estimatedTime,
      );
    });
    _unlockNextModule(index);
  }

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
                      widget.primaryColor,
                      widget.primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.petIcon,
                        size: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${widget.petType} Training',
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
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final module = _modules[index];
                  final isLast = index == _modules.length - 1;

                  return Column(
                    children: [
                      _buildModuleBubble(module, index),
                      if (!isLast) _buildConnector(module.status),
                    ],
                  );
                },
                childCount: _modules.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleBubble(TrainingModule module, int index) {
    final isLocked = module.status == ModuleStatus.locked;
    final isCompleted = module.status == ModuleStatus.completed;

    return GestureDetector(
      onTap: isLocked
          ? null
          : () async {
              final completed = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => TrainingLessonScreen(
                    module: module,
                    onComplete: () => _completeModule(index),
                  ),
                ),
              );
              if (completed == true) {
                _completeModule(index);
              }
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
      default:
        return Icons.pets;
    }
  }
} 