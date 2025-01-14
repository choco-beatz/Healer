class ChatMessageModel {
  String id;
  String from;
  String to;
  String text;
  String status;
  String conversation;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  ChatMessageModel({
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

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json["_id"],
      from: json["from"],
      to: json["to"],
      text: json["text"],
      status: json["status"],
      conversation: json["conversation"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      v: json["__v"],
    );
  }
}