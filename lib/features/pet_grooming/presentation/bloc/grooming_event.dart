import 'package:flutter/foundation.dart';
import 'package:saathi/features/pet_grooming/domain/models/grooming_service.dart';

@immutable
abstract class GroomingEvent {
  const GroomingEvent();
}

class GroomingLoadRequested extends GroomingEvent {
  const GroomingLoadRequested();
}

class GroomingAddBookingRequested extends GroomingEvent {
  final GroomingService service;
  final DateTime date;
  final String timeSlot;

  const GroomingAddBookingRequested({
    required this.service,
    required this.date,
    required this.timeSlot,
  });
}

class GroomingDeleteBookingRequested extends GroomingEvent {
  final String bookingId;
  const GroomingDeleteBookingRequested({required this.bookingId});
}
