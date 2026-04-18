class SignUpRequestModel {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String phone;

  SignUpRequestModel({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'phone': phone,
    };
  }
}
