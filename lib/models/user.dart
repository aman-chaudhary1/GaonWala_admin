class User {
  String? sId;
  String? name;
  String? email;
  String? phoneNo;
  String? profileImage;
  String? fcmToken;
  String? createdAt;
  String? updatedAt;

  User(
      {this.sId,
      this.name,
      this.email,
      this.phoneNo,
      this.profileImage,
      this.fcmToken,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    phoneNo = json['phoneNo'];
    profileImage = json['profileImage'];
    fcmToken = json['fcmToken'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phoneNo'] = this.phoneNo;
    data['profileImage'] = this.profileImage;
    data['fcmToken'] = this.fcmToken;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
