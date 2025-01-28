class UserResponse {
  final UserModel user;

  UserResponse({
    required this.user,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    // Safely access the user object
    final userJson = json["user"];
    if (userJson == null) {
      throw Exception('User data is null');
    }
    return UserResponse(
      user: UserModel.fromJson(userJson as Map<String, dynamic>),
    );
  }
}

class UserModel {
  final String id;
  final String email;
  final String role;
  final TherapistProfile profile; // Made nullable
  final String profileModel;
  final String image;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.profile, // No longer required
    required this.profileModel,
    required this.image,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Safely handle the profile data
    final profileData = json["profile"];
    return UserModel(
      id: json["_id"] ?? '',
      email: json["email"] ?? '',
      role: json["role"] ?? '',
      profile: TherapistProfile.fromJson(profileData as Map<String, dynamic>),
      // Return null if no profile data
      profileModel: json["profileModel"] ?? '',
      image: json["image"] ?? '',
      isVerified: json["isVerified"] ?? false,
      createdAt:
          DateTime.parse(json["createdAt"] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json["updatedAt"] ?? DateTime.now().toIso8601String()),
      v: json["__v"] ?? 0,
    );
  }
}

class TherapistProfile {
  final String id;
  final String name;
  final String qualification;
  final String specialization;
  final int experience;
  final String bio;
  final int v;

  TherapistProfile({
    required this.id,
    required this.name,
    required this.qualification,
    required this.specialization,
    required this.experience,
    required this.bio,
    required this.v,
  });

  factory TherapistProfile.fromJson(Map<String, dynamic> json) {
    return TherapistProfile(
      id: json["_id"] ?? '',
      name: json["name"] ?? '',
      qualification: json["qualification"] ?? '',
      specialization: json["specialization"] ?? '',
      experience: json["experience"] ?? 0,
      bio: json["bio"] ?? '',
      v: json["__v"] ?? 0,
    );
  }
}
