class MyNotification {
  String? sId;
  String? notificationId;
  String? title;
  String? description;
  String? imageUrl;
  String? createdAt;
  String? updatedAt;
  int? iV;
  Map<String, dynamic>? userId;
  List<String>? readBy;

  MyNotification(
      {this.sId,
        this.notificationId,
        this.title,
        this.description,
        this.imageUrl,
        this.userId,
        this.readBy,
        this.createdAt,
        this.updatedAt,
        this.iV});

  MyNotification.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    notificationId = json['notificationId'];
    title = json['title'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    userId = json['userId'] is Map<String, dynamic> ? json['userId'] : null;
    readBy = json['readBy'] != null ? List<String>.from(json['readBy']) : [];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['notificationId'] = this.notificationId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['imageUrl'] = this.imageUrl;
    data['userId'] = this.userId;
    data['readBy'] = this.readBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}