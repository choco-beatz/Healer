class UserModel {
  String id;
  String email;
  String role;
  String profileModel;
  String image;
  bool isVerified;
  DateTime createdAt;
  DateTime updatedAt;
  TherapistProfile profile;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.profileModel,
    required this.image,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
    required this.profile,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"],
      email: json["email"],
      role: json["role"],
      profileModel: json["profileModel"],
      image: json["image"],
      isVerified: json["isVerified"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      profile: TherapistProfile.fromJson(json["profile"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "email": email,
      "role": role,
      "profileModel": profileModel,
      "image": image,
      "isVerified": isVerified,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
      "profile": profile.toJson(),
    };
  }
}

class TherapistProfile {
  String id;
  String name;
  String qualification;
  String specialization;
  int experience;
  String bio;

  TherapistProfile({
    required this.id,
    required this.name,
    required this.qualification,
    required this.specialization,
    required this.experience,
    required this.bio,
  });

  factory TherapistProfile.fromJson(Map<String, dynamic> json) {
    return TherapistProfile(
      id: json["_id"],
      name: json["name"],
      qualification: json["qualification"],
      specialization: json["specialization"],
      experience: json["experience"],
      bio: json["bio"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "qualification": qualification,
      "specialization": specialization,
      "experience": experience,
      "bio": bio,
    };
  }
}