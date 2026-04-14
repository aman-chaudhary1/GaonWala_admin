class User {
  String? sId;
  String? name;
  String? email;
  String? phoneNo;
  String? profileImage;
  String? fcmToken;
  String? userStatus;
  String? createdAt;
  String? updatedAt;

  String? role;
  String? shopName;
  String? shopAddress;
  String? shopStatus;
  List<String>? assignedCategories;
  List<String>? assignedSubCategories;

  User(
      {this.sId,
      this.name,
      this.email,
      this.phoneNo,
      this.profileImage,
      this.fcmToken,
      this.userStatus,
      this.role,
      this.shopName,
      this.shopAddress,
      this.shopStatus,
      this.assignedCategories,
      this.assignedSubCategories,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    phoneNo = json['phoneNo'];
    profileImage = json['profileImage'];
    fcmToken = json['fcmToken'];
    userStatus = json['userStatus'];
    role = json['role'];
    shopName = json['shopName'];
    shopAddress = json['shopAddress'];
    shopStatus = json['shopStatus'];
    assignedCategories = json['assignedCategories'] != null ? List<String>.from(json['assignedCategories']) : null;
    assignedSubCategories = json['assignedSubCategories'] != null ? List<String>.from(json['assignedSubCategories']) : null;
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
    data['userStatus'] = this.userStatus;
    data['role'] = this.role;
    data['shopName'] = this.shopName;
    data['shopAddress'] = this.shopAddress;
    data['shopStatus'] = this.shopStatus;
    data['assignedCategories'] = this.assignedCategories;
    data['assignedSubCategories'] = this.assignedSubCategories;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
