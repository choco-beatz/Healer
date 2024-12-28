class ClientModel {
  final String requestId;
  final String id;
  final String email;
  final String name;
  final String image;

  ClientModel({
    required this.requestId,
    required this.id,
    required this.name,
    required this.email,
    required this.image,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    final client = json['client'] ?? {};
    final profile = client['profile'] ?? {};
    return ClientModel(
      requestId: json['_id'] ?? '',
      id: client['_id'] ?? '',
      email: client['email'] ?? '',
      name: profile['name'] ?? '',
      image: client['image'] ?? '',
    );
  }
}
