class RequestsResponse {
  final List<RequestModel> requests;
  RequestsResponse({
    required this.requests,
  });
  factory RequestsResponse.fromJson(Map<String, dynamic> json) {
    try {
      var requestsList = json['requests'];
      if (requestsList == null || requestsList is! List) {
        return RequestsResponse(requests: []);
      }
      return RequestsResponse(
        requests: requestsList
            .map((request) => RequestModel.fromJson(request))
            .toList(),
      );
    } catch (e) {
      print('Error parsing RequestsResponse: $e');
      return RequestsResponse(requests: []);
    }
  }
}

class RequestModel {
  String id;
  ClientModel client;
  String therapist;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  RequestModel({
    required this.id,
    required this.client,
    required this.therapist,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.v = 0,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    try {
      return RequestModel(
        id: json["_id"],
        client: ClientModel.fromJson(json["client"]),
        therapist: json["therapist"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"] ?? 0,
      );
    } catch (e) {
      print('Error parsing RequestModel: $e');
      return RequestModel(
        id: '',
        client: ClientModel.empty(),
        therapist: '',
        status: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }
}

class ClientModel {
  String id;
  String email;
  String role;
  ClientProfile profile;
  String profileModel;
  String image;
  bool isVerified;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  ClientModel({
    required this.id,
    required this.email,
    required this.role,
    required this.profile,
    required this.profileModel,
    required this.image,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
    this.v = 0,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    try {
      return ClientModel(
        id: json["_id"],
        email: json["email"],
        role: json["role"],
        profile: ClientProfile.fromJson(json["profile"]),
        profileModel: json["profileModel"],
        image: json["image"],
        isVerified: json["isVerified"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"] ?? 0,
      );
    } catch (e) {
      print('Error parsing ClientModel: $e');
      return ClientModel.empty();
    }
  }

  factory ClientModel.empty() {
    return ClientModel(
      id: '',
      email: '',
      role: '',
      profile: ClientProfile.empty(),
      profileModel: '',
      image: '',
      isVerified: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

class ClientProfile {
  String id;
  String name;
  String? gender;
  int? age;
  int v;

  ClientProfile({
    required this.id,
    required this.name,
    this.gender,
    this.age,
    this.v = 0,
  });

factory ClientProfile.fromJson(Map<String, dynamic> json) {
  try {
    return ClientProfile(
      id: json["_id"],
      name: json["name"],
      gender: json["gender"] ?? '', 
      age: json["age"] is int ? json["age"] : null, 
      v: json["__v"] ?? 0,
    );
  } catch (e) {
    print('Error parsing ClientProfile: $e');
    return ClientProfile.empty();
  }
}

  factory ClientProfile.empty() {
    return ClientProfile(
      id: '',
      name: '',
    );
  }
}