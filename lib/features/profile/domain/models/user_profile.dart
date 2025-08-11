class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? profileImage;
  final String? bio;
  final String? location;
  final UserPreferences? preferences;
  final String role;
  final bool isEmailVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profileImage,
    this.bio,
    this.location,
    this.preferences,
    required this.role,
    required this.isEmailVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profileImage: json['profileImage'],
      bio: json['bio'],
      location: json['location'],
      preferences: json['preferences'] != null 
          ? UserPreferences.fromJson(json['preferences']) 
          : null,
      role: json['role'],
      isEmailVerified: json['isEmailVerified'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'bio': bio,
      'location': location,
      'preferences': preferences?.toJson(),
      'role': role,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profileImage,
    String? bio,
    String? location,
    UserPreferences? preferences,
    String? role,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      preferences: preferences ?? this.preferences,
      role: role ?? this.role,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserPreferences {
  final List<String> petTypes;
  final int? maxAge;
  final NotificationSettings notifications;

  UserPreferences({
    required this.petTypes,
    this.maxAge,
    required this.notifications,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      petTypes: List<String>.from(json['petTypes'] ?? []),
      maxAge: json['maxAge'],
      notifications: NotificationSettings.fromJson(json['notifications'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'petTypes': petTypes,
      'maxAge': maxAge,
      'notifications': notifications.toJson(),
    };
  }

  UserPreferences copyWith({
    List<String>? petTypes,
    int? maxAge,
    NotificationSettings? notifications,
  }) {
    return UserPreferences(
      petTypes: petTypes ?? this.petTypes,
      maxAge: maxAge ?? this.maxAge,
      notifications: notifications ?? this.notifications,
    );
  }
}

class NotificationSettings {
  final bool email;
  final bool push;
  final bool adoptionUpdates;
  final bool newPets;

  NotificationSettings({
    required this.email,
    required this.push,
    required this.adoptionUpdates,
    required this.newPets,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      email: json['email'] ?? true,
      push: json['push'] ?? true,
      adoptionUpdates: json['adoptionUpdates'] ?? true,
      newPets: json['newPets'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'push': push,
      'adoptionUpdates': adoptionUpdates,
      'newPets': newPets,
    };
  }

  NotificationSettings copyWith({
    bool? email,
    bool? push,
    bool? adoptionUpdates,
    bool? newPets,
  }) {
    return NotificationSettings(
      email: email ?? this.email,
      push: push ?? this.push,
      adoptionUpdates: adoptionUpdates ?? this.adoptionUpdates,
      newPets: newPets ?? this.newPets,
    );
  }
} 