import 'package:saathi/features/pet_adoption/domain/models/pet.dart';

class Favorite {
  final String id;
  final String userId;
  final String petId;
  final DateTime addedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Pet? pet; // Populated when fetching favorites

  Favorite({
    required this.id,
    required this.userId,
    required this.petId,
    required this.addedAt,
    required this.createdAt,
    required this.updatedAt,
    this.pet,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'] ?? json['_id'] ?? '',
      userId: json['userId'] ?? '',
      petId: json['petId'] ?? '',
      addedAt: DateTime.parse(json['addedAt'] ?? json['createdAt'] ?? DateTime.now().toIso8601String()),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      pet: json['pet'] != null ? Pet.fromJson(json['pet']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'petId': petId,
      'addedAt': addedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'pet': pet?.toJson(),
    };
  }

  Favorite copyWith({
    String? id,
    String? userId,
    String? petId,
    DateTime? addedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    Pet? pet,
  }) {
    return Favorite(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      petId: petId ?? this.petId,
      addedAt: addedAt ?? this.addedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      pet: pet ?? this.pet,
    );
  }

  @override
  String toString() {
    return 'Favorite(id: $id, userId: $userId, petId: $petId, addedAt: $addedAt, pet: $pet)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Favorite && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
} 