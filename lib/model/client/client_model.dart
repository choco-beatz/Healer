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
      print('Error parsing RequestsResponse: $e'); // Debug log
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

  RequestModel({
    required this.id,
    required this.client,
    required this.therapist,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
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
      );
    } catch (e) {
      print('Error parsing RequestModel: $e'); // Debug log
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
      );
    } catch (e) {
      print('Error parsing ClientModel: $e'); // Debug log
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

  // Empty constructor for fallback
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

  ClientProfile({
    required this.id,
    required this.name,
  });

  factory ClientProfile.fromJson(Map<String, dynamic> json) {
    try {
      return ClientProfile(
        id: json["_id"],
        name: json["name"],
      );
    } catch (e) {
      print('Error parsing ClientProfile: $e'); // Debug log
      return ClientProfile(
        id: '',
        name: '',
      );
    }
  }

  // Empty constructor for fallback
  factory ClientProfile.empty() {
    return ClientProfile(
      id: '',
      name: '',
    );
  }
}
