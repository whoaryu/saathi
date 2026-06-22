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
  final String? ownerName;
  final String? ownerEmail;
  final String? ownerPhone;
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
    this.ownerName,
    this.ownerEmail,
    this.ownerPhone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    try {
      final ownerData = json['owner'];
      String parsedOwnerId = '';
      String? parsedOwnerName;
      String? parsedOwnerEmail;
      String? parsedOwnerPhone;

      if (ownerData is Map) {
        parsedOwnerId = ownerData['_id']?.toString() ?? ownerData['id']?.toString() ?? '';
        parsedOwnerName = ownerData['name']?.toString();
        parsedOwnerEmail = ownerData['email']?.toString();
        parsedOwnerPhone = ownerData['phone']?.toString();
      } else {
        parsedOwnerId = ownerData?.toString() ?? json['ownerId']?.toString() ?? '';
      }

      return Pet(
        id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        type: json['type']?.toString() ?? '',
        breed: json['breed']?.toString() ?? '',
        age: json['age'] is String ? int.tryParse(json['age']) ?? 0 : json['age'] is int ? json['age'] : 0,
        description: json['description']?.toString() ?? '',
        location: json['location']?.toString() ?? '',
        imageUrl: json['imageUrl']?.toString() ?? '',
        ownerId: parsedOwnerId,
        ownerName: parsedOwnerName,
        ownerEmail: parsedOwnerEmail,
        ownerPhone: parsedOwnerPhone,
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
      'ownerName': ownerName,
      'ownerEmail': ownerEmail,
      'ownerPhone': ownerPhone,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}