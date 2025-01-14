class ChatModel {
  String id;
  List<Participant> participants;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  LastMessage lastMessage;

  ChatModel({
    required this.id,
    required this.participants,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.lastMessage,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json["_id"] ?? '',
      participants: List<Participant>.from(
          (json["participants"] ?? []).map((x) => Participant.fromJson(x))),
      createdAt: DateTime.tryParse(json["createdAt"] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? '') ?? DateTime.now(),
      v: json["__v"] ?? 0,
      lastMessage: json["lastMessage"] != null
          ? LastMessage.fromJson(json["lastMessage"])
          : LastMessage.defaultValue(),
    );
  }
}

class Participant {
  String id;
  String profileModel;
  String image;
  Profile profile;

  Participant({
    required this.id,
    required this.profileModel,
    required this.image,
    required this.profile,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json["_id"] ?? '',
      profileModel: json["profileModel"] ?? 'Unknown',
      image: json["image"] ?? '',
      profile: json["profile"] != null
          ? Profile.fromJson(json["profile"])
          : Profile.defaultValue(),
    );
  }
}

class Profile {
  String id;
  String name;
  String qualification;
  String specialization;
  int experience;
  String bio;
  int v;

  Profile({
    required this.id,
    required this.name,
    required this.qualification,
    required this.specialization,
    required this.experience,
    required this.bio,
    required this.v,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json["_id"] ?? '',
      name: json["name"] ?? 'Unknown',
      qualification: json["qualification"] ?? 'N/A',
      specialization: json["specialization"] ?? 'General',
      experience: json["experience"] ?? 0,
      bio: json["bio"] ?? '',
      v: json["__v"] ?? 0,
    );
  }

  factory Profile.defaultValue() {
    return Profile(
      id: '',
      name: 'Unknown',
      qualification: 'N/A',
      specialization: 'General',
      experience: 0,
      bio: '',
      v: 0,
    );
  }
}

class LastMessage {
  String id;
  String from;
  String to;
  String text;
  String status;
  String conversation;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  LastMessage({
    required this.id,
    required this.from,
    required this.to,
    required this.text,
    required this.status,
    required this.conversation,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      id: json["_id"] ?? '',
      from: json["from"] ?? '',
      to: json["to"] ?? '',
      text: json["text"] ?? '',
      status: json["status"] ?? 'unknown',
      conversation: json["conversation"] ?? '',
      createdAt: DateTime.tryParse(json["createdAt"] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? '') ?? DateTime.now(),
      v: json["__v"] ?? 0,
    );
  }

  factory LastMessage.defaultValue() {
    return LastMessage(
      id: '',
      from: '',
      to: '',
      text: '',
      status: 'unknown',
      conversation: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      v: 0,
    );
  }
}
