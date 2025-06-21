class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json["id"] as String,
      title: json["title"] as String,
      body: json["body"] as String,
      createdAt: DateTime.parse(json["createdAt"] as String),
      isRead: json["isRead"] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "body": body,
      "createdAt": createdAt.toIso8601String(),
      "isRead": isRead,
    };
  }
}
