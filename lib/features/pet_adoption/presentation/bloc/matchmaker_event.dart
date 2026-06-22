import 'package:flutter/foundation.dart';
import 'package:saathi/features/pet_adoption/domain/models/pet.dart';

@immutable
abstract class MatchmakerEvent {
  const MatchmakerEvent();
}

class MatchmakerScoreRequested extends MatchmakerEvent {
  final Pet pet;
  const MatchmakerScoreRequested({required this.pet});
}
