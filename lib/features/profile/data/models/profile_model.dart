// lib/features/profile/data/models/profile_model.dart

class ProfileModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final String role;
  final String preferredLanguage;
  final int tripsCount;
  final int favouritesCount;
  final String createdAt;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    required this.role,
    required this.preferredLanguage,
    required this.tripsCount,
    required this.favouritesCount,
    required this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'],
      role: json['role'] ?? '',
      preferredLanguage: json['preferred_language'] ?? 'ar',
      tripsCount: json['trips_count'] ?? 0,
      favouritesCount: json['favourites_count'] ?? 0,
      createdAt: json['created_at'] ?? '',
    );
  }
}
