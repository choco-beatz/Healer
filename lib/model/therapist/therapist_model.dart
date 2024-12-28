class TherapistModel {
  final String? id;
  final String email;
  final String? role;
  final String? image;
  final String name;
  final String password;
  final String qualification;
  final String specialization;
  final int? experience;
  final String bio;

  TherapistModel({
    required this.password,
     this.id,
    required this.email,
     this.role,
     this.image,
    required this.name,
    required this.qualification,
    required this.specialization,
     this.experience,
     this.bio = '',
  });

  factory TherapistModel.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] ?? {};
    return TherapistModel(
      password: json['password'] ?? '',
      id: profile['_id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      image: json['image'] ?? '',
      name: profile['name'] ?? '',
      qualification: profile['qualification'] ?? '',
      specialization: profile['specialization'] ?? '',
      experience: profile['experience'] ?? 0,
      bio: profile['bio'] ?? '',
    );
  }
}
