import 'package:saathi/features/pet_grooming/domain/models/grooming_service.dart';

class GroomingBooking {
  final GroomingService service;
  final DateTime date;
  final String timeSlot;
  final double price;

  const GroomingBooking({
    required this.service,
    required this.date,
    required this.timeSlot,
    required this.price,
  });

  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }
} 