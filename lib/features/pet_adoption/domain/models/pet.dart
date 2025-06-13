class Pet {
  final String id;
  final String name;
  final String type;
  final String breed;
  final int age;
  final String description;
  final String location;
  final String imageUrl;
  final String ownerId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.age,
    required this.description,
    required this.location,
    required this.imageUrl,
    required this.ownerId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    try {
      return Pet(
        id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        type: json['type']?.toString() ?? '',
        breed: json['breed']?.toString() ?? '',
        age: json['age'] is String ? int.tryParse(json['age']) ?? 0 : json['age'] is int ? json['age'] : 0,
        description: json['description']?.toString() ?? '',
        location: json['location']?.toString() ?? '',
        imageUrl: json['imageUrl']?.toString() ?? '',
        ownerId: json['owner']?.toString() ?? json['ownerId']?.toString() ?? '',
        createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'].toString()) : DateTime.now(),
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'].toString()) : DateTime.now(),
      );
    } catch (e) {
      print('Error parsing pet: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'breed': breed,
      'age': age,
      'description': description,
      'location': location,
      'imageUrl': imageUrl,
      'ownerId': ownerId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
} 