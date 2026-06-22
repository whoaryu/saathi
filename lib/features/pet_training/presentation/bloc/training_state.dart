import 'package:flutter/foundation.dart';
import 'package:saathi/features/pet_training/domain/models/training_progress.dart';

@immutable
abstract class TrainingState {
  const TrainingState();
}

class TrainingInitial extends TrainingState {
  const TrainingInitial();
}

class TrainingLoading extends TrainingState {
  const TrainingLoading();
}

class TrainingLoaded extends TrainingState {
  final TrainingProgress progress;
  final List<TrainingBadge> newlyUnlockedBadges;

  const TrainingLoaded({
    required this.progress,
    this.newlyUnlockedBadges = const [],
  });
}

class TrainingFailure extends TrainingState {
  final String errorMessage;
  const TrainingFailure({required this.errorMessage});
}
