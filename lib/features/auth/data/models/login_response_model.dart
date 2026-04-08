class LoginResponseModel {
  final bool success;
  final UserModel user;
  final String token;

  LoginResponseModel({
    required this.success,
    required this.user,
    required this.token,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      success: json['success'],
      user: UserModel.fromJson(json['data']['user']),
      token: json['data']['token'],
    );
  }
}

class UserModel {
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

  UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
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
