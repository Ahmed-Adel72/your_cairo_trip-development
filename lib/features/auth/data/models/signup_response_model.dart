class SignUpResponseModel {
  final bool success;
  final SignUpMessageModel message;
  final SignUpUserModel user;
  final String token;

  SignUpResponseModel({
    required this.success,
    required this.message,
    required this.user,
    required this.token,
  });

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    return SignUpResponseModel(
      success: json['success'],
      message: SignUpMessageModel.fromJson(json['message']),
      user: SignUpUserModel.fromJson(json['data']['user']),
      token: json['data']['token'],
    );
  }
}

// ── Message Model عشان الـ response فيه ar و en ──
class SignUpMessageModel {
  final String ar;
  final String en;

  SignUpMessageModel({required this.ar, required this.en});

  factory SignUpMessageModel.fromJson(Map<String, dynamic> json) {
    return SignUpMessageModel(ar: json['ar'] ?? '', en: json['en'] ?? '');
  }
}

class SignUpUserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final String? role;
  final String? preferredLanguage;
  final int? tripsCount;
  final int? favouritesCount;
  final String createdAt;

  SignUpUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    this.role,
    this.preferredLanguage,
    this.tripsCount,
    this.favouritesCount,
    required this.createdAt,
  });

  factory SignUpUserModel.fromJson(Map<String, dynamic> json) {
    return SignUpUserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatar: json['avatar'],
      role: json['role'],
      preferredLanguage: json['preferred_language'],
      tripsCount: json['trips_count'],
      favouritesCount: json['favourites_count'],
      createdAt: json['created_at'],
    );
  }
}
