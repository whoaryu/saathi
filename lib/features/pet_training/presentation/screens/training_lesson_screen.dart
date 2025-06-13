import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:saathi/features/pet_training/domain/models/training_module.dart';
import 'package:url_launcher/url_launcher.dart';

class TrainingLessonScreen extends StatefulWidget {
  final TrainingModule module;
  final VoidCallback onComplete;

  const TrainingLessonScreen({
    super.key,
    required this.module,
    required this.onComplete,
  });

  @override
  State<TrainingLessonScreen> createState() => _TrainingLessonScreenState();
}

class _TrainingLessonScreenState extends State<TrainingLessonScreen> {
  int _currentStep = 0;

  void _nextStep() {
    if (_currentStep < widget.module.steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      widget.onComplete();
      Navigator.pop(context, true);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the link')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final step = widget.module.steps[_currentStep];
    final isLastStep = _currentStep == widget.module.steps.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.module.title),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                'Step ${_currentStep + 1}/${widget.module.steps.length}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentStep + 1) / widget.module.steps.length,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildModuleInfo(),
                const SizedBox(height: 16),
                _buildStepCard(step),
                const SizedBox(height: 16),
                if (step.imageUrl != null) _buildStepImage(step),
                const SizedBox(height: 16),
                if (step.tips.isNotEmpty) _buildTipsList(step),
                const SizedBox(height: 16),
                if (step.commonMistakes.isNotEmpty) _buildCommonMistakesList(step),
                const SizedBox(height: 16),
                if (step.videoUrl != null) _buildVideoLink(step),
                if (step.blogUrl != null) _buildBlogLink(step),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (_currentStep > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousStep,
                    child: const Text('Previous'),
                  ),
                ),
              if (_currentStep > 0) const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: _nextStep,
                  child: Text(isLastStep ? 'Complete' : 'Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModuleInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.timer,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              '${widget.module.estimatedTime} min',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.module.difficulty,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX();
  }

  Widget _buildStepCard(TrainingStep step) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              step.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              step.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX();
  }

  Widget _buildStepImage(TrainingStep step) {
    if (step.imageUrl == null) return const SizedBox.shrink();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        step.imageUrl!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Icon(
              Icons.image_not_supported,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        },
      ),
    ).animate().fadeIn().slideY();
  }

  Widget _buildTipsList(TrainingStep step) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Pro Tips',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...step.tips.map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(tip)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    ).animate().fadeIn().slideX();
  }

  Widget _buildCommonMistakesList(TrainingStep step) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 8),
                Text(
                  'Common Mistakes',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...step.commonMistakes.map((mistake) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.error_outline, size: 20, color: Theme.of(context).colorScheme.error),
                      const SizedBox(width: 8),
                      Expanded(child: Text(mistake)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    ).animate().fadeIn().slideX();
  }

  Widget _buildVideoLink(TrainingStep step) {
    return Card(
      child: InkWell(
        onTap: () => _launchUrl(step.videoUrl!),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.play_circle_filled,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Watch Video Tutorial',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideX();
  }

  Widget _buildBlogLink(TrainingStep step) {
    return Card(
      child: InkWell(
        onTap: () => _launchUrl(step.blogUrl!),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.article,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Read Detailed Guide',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideX();
  }
} 