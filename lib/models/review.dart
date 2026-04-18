import 'user.dart';

class Review {
  String? sId;
  User? userId;
  int? rating;
  String? feedback;
  String? createdAt;

  Review({this.sId, this.userId, this.rating, this.feedback, this.createdAt});

  Review.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'] != null ? User.fromJson(json['userId']) : null;
    rating = json['rating'];
    feedback = json['feedback'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.userId != null) {
      data['userId'] = this.userId!.toJson();
    }
    data['rating'] = this.rating;
    data['feedback'] = this.feedback;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
