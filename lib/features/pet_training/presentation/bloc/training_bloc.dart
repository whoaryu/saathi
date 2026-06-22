import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saathi/core/services/service_provider.dart';
import 'package:saathi/core/services/api_service.dart';
import 'package:saathi/features/pet_training/domain/models/training_progress.dart';
import 'training_event.dart';
import 'training_state.dart';

class TrainingBloc extends Bloc<TrainingEvent, TrainingState> {
  final ApiService _apiService = ServiceProvider().apiService;

  TrainingBloc() : super(const TrainingInitial()) {
    on<LoadTrainingProgress>(_onLoadProgress);
    on<CompleteTrainingModule>(_onCompleteModule);
  }

  Future<void> _onLoadProgress(
    LoadTrainingProgress event,
    Emitter<TrainingState> emit,
  ) async {
    emit(const TrainingLoading());
    try {
      final response = await _apiService.get('/training/progress/${event.petType}');
      final data = json.decode(response.body);
      
      if (data['success'] == true) {
        final progress = TrainingProgress.fromJson(data['data']);
        emit(TrainingLoaded(progress: progress));
      } else {
        emit(TrainingFailure(errorMessage: data['message'] ?? 'Failed to load training progress.'));
      }
    } catch (e) {
      print('❌ TrainingBloc Load Exception: $e');
      emit(TrainingFailure(errorMessage: e.toString()));
    }
  }

  Future<void> _onCompleteModule(
    CompleteTrainingModule event,
    Emitter<TrainingState> emit,
  ) async {
    emit(const TrainingLoading());
    try {
      final response = await _apiService.post(
        '/training/complete/${event.petType}',
        body: {'moduleId': event.moduleId},
      );
      final data = json.decode(response.body);

      if (data['success'] == true) {
        final progress = TrainingProgress.fromJson(data['data']);
        final List badgesJson = data['newlyUnlockedBadges'] ?? [];
        final newBadges = badgesJson.map((b) => TrainingBadge.fromJson(b)).toList();
        
        emit(TrainingLoaded(
          progress: progress,
          newlyUnlockedBadges: newBadges,
        ));
      } else {
        emit(TrainingFailure(errorMessage: data['message'] ?? 'Failed to complete module.'));
      }
    } catch (e) {
      print('❌ TrainingBloc Complete Exception: $e');
      emit(TrainingFailure(errorMessage: e.toString()));
    }
  }
}
