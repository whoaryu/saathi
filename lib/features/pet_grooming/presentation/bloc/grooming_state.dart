import 'package:flutter/foundation.dart';
import 'package:saathi/features/pet_grooming/domain/models/grooming_booking.dart';

@immutable
abstract class GroomingState {
  const GroomingState();
}

class GroomingInitial extends GroomingState {
  const GroomingInitial();
}

class GroomingLoading extends GroomingState {
  const GroomingLoading();
}

class GroomingLoadSuccess extends GroomingState {
  final List<GroomingBooking> bookings;
  const GroomingLoadSuccess({required this.bookings});
}

class GroomingAddSuccess extends GroomingState {
  const GroomingAddSuccess();
}

class GroomingFailure extends GroomingState {
  final String errorMessage;
  const GroomingFailure({required this.errorMessage});
}
