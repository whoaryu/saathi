import 'package:saathi/features/pet_grooming/domain/models/grooming_service.dart';

class GroomingBooking {
  final String? id;
  final GroomingService service;
  final DateTime date;
  final String timeSlot;
  final double price;

  const GroomingBooking({
    this.id,
    required this.service,
    required this.date,
    required this.timeSlot,
    required this.price,
  });

  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }

  factory GroomingBooking.fromJson(Map<String, dynamic> json) {
    // Attempt to match with static services list
    final serviceName = json['serviceName']?.toString() ?? '';
    final service = GroomingService.services.firstWhere(
      (s) => s.name == serviceName,
      orElse: () => GroomingService(
        name: serviceName,
        description: 'Grooming service reserved',
        duration: '1 hour',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        animalType: json['animalType']?.toString() ?? 'Dog',
        imageUrl: '',
      ),
    );

    return GroomingBooking(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      service: service,
      date: json['date'] != null ? DateTime.tryParse(json['date'].toString()) ?? DateTime.now() : DateTime.now(),
      timeSlot: json['timeSlot']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? service.price,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'serviceName': service.name,
      'animalType': service.animalType,
      'date': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      'timeSlot': timeSlot,
      'price': price,
    };
  }
}