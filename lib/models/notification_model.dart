class NotificationModel {
  final String? id;
  final String? userID;
  final String? title;
  final String? description;
  final int? isRead;
  final String? createdAt;

  NotificationModel(
      {this.id,
      this.userID,
      this.title,
      this.description,
      this.isRead,
      this.createdAt});

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
          id: json["id"],
          userID: json['user_id'],
          title: json["title"],
          description: json["description"],
          isRead: int.parse(json['is_read']),
          createdAt: json['created_at']);
}
