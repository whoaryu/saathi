import 'package:flutter/foundation.dart';

@immutable
abstract class MatchmakerState {
  const MatchmakerState();
}

class MatchmakerInitial extends MatchmakerState {
  const MatchmakerInitial();
}

class MatchmakerLoading extends MatchmakerState {
  const MatchmakerLoading();
}

class MatchmakerSuccess extends MatchmakerState {
  final double score; // 0.0 to 1.0
  final List<String> reasons;
  const MatchmakerSuccess({required this.score, required this.reasons});
}

class MatchmakerFailure extends MatchmakerState {
  final String errorMessage;
  const MatchmakerFailure({required this.errorMessage});
}
