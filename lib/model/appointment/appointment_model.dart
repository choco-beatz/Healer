class AppointmentModel {
  final String id;
  final ClientModel client;
  final String therapistId;
  final String startTime;
  final String endTime;
  final double amount;
  final String status;
  final String date;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppointmentModel({
    required this.id,
    required this.client,
    required this.therapistId,
    required this.startTime,
    required this.endTime,
    required this.amount,
    required this.status,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['_id'] as String,
      client: ClientModel.fromJson(json['client'] as Map<String, dynamic>),
      therapistId: json['therapist'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      date: json['date'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

class ClientModel {
  final String id;
  final String email;
  final ClientProfile profile;
  final String profileModel;
  final String image;

  ClientModel({
    required this.id,
    required this.email,
    required this.profile,
    required this.profileModel,
    required this.image,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['_id'] as String,
      email: json['email'] as String,
      profile: ClientProfile.fromJson(json['profile'] as Map<String, dynamic>),
      profileModel: json['profileModel'] as String,
      image: json['image'] as String,
    );
  }
}

class ClientProfile {
  final String id;
  final String name;

  ClientProfile({
    required this.id,
    required this.name,
  });

  factory ClientProfile.fromJson(Map<String, dynamic> json) {
    return ClientProfile(
      id: json['_id'] as String,
      name: json['name'] as String,
    );
  }
}
