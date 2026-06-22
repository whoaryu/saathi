import 'package:flutter/foundation.dart';

@immutable
abstract class TrainingEvent {
  const TrainingEvent();
}

class LoadTrainingProgress extends TrainingEvent {
  final String petType;
  const LoadTrainingProgress({required this.petType});
}

class CompleteTrainingModule extends TrainingEvent {
  final String petType;
  final String moduleId;
  const CompleteTrainingModule({required this.petType, required this.moduleId});
}
