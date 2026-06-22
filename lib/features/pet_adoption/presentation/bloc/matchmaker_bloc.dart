import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:saathi/core/services/api_service.dart';
import 'package:saathi/features/pet_adoption/domain/models/pet.dart';
import 'matchmaker_event.dart';
import 'matchmaker_state.dart';

class MatchmakerBloc extends Bloc<MatchmakerEvent, MatchmakerState> {
  MatchmakerBloc() : super(const MatchmakerInitial()) {
    on<MatchmakerScoreRequested>(_onScoreRequested);
  }

  String get _aiBaseUrl {
    try {
      final uri = Uri.parse(ApiService.baseUrl);
      return '${uri.scheme}://${uri.host}:8000';
    } catch (e) {
      print('⚠️ Failed parsing ApiService.baseUrl: $e. Falling back to default IP.');
      return 'http://192.168.29.188:8000';
    }
  }

  Future<void> _onScoreRequested(
    MatchmakerScoreRequested event,
    Emitter<MatchmakerState> emit,
  ) async {
    emit(const MatchmakerLoading());
    try {
      final pet = event.pet;
      
      // Determine attributes based on pet metadata dynamically
      double energy = 0.5;
      double space = 0.5;
      double attention = 0.5;

      final type = pet.type.toLowerCase();
      if (type.contains('dog')) {
        energy = 0.8;
        space = 0.7;
        attention = 0.8;
      } else if (type.contains('cat')) {
        energy = 0.4;
        space = 0.3;
        attention = 0.5;
      } else if (type.contains('bird')) {
        energy = 0.3;
        space = 0.2;
        attention = 0.4;
      }

      final url = '$_aiBaseUrl/api/matchmaker/score';
      print('📤 Requesting Matchmaker score from: $url');
      
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'user_pref': {
            'activity_level': 0.7, // Simulated user preference values
            'space_available': 0.6,
            'time_commitment': 0.7,
          },
          'pet_attr': {
            'pet_id': pet.id,
            'energy_level': energy,
            'space_needed': space,
            'attention_needed': attention,
          }
        }),
      );

      print('📥 Matchmaker response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final score = (data['score'] as num).toDouble();
        final reasons = List<String>.from(data['reasons']);
        emit(MatchmakerSuccess(score: score, reasons: reasons));
      } else {
        print('❌ FastAPI server error: ${response.statusCode} - ${response.body}');
        emit(const MatchmakerFailure(errorMessage: 'Failed to retrieve AI matching score.'));
      }
    } catch (e) {
      print('❌ MatchmakerBloc Exception: $e');
      emit(MatchmakerFailure(errorMessage: e.toString()));
    }
  }
}
