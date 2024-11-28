class LoginResponseModel {
  final String token;
  final String userId;
  final String role;

  LoginResponseModel(
      {required this.token, required this.userId, required this.role});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
        token: json['token'], userId: json['userId'], role: json['role']);
  }
}
