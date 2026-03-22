class Block {
  String? sId;
  String? name;

  Block({this.sId, this.name});

  Block.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}

class Panchayat {
  String? sId;
  String? name;
  String? blockId;

  Panchayat({this.sId, this.name, this.blockId});

  Panchayat.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    blockId = json['blockId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['blockId'] = this.blockId;
    return data;
  }
}

class Village {
  String? sId;
  String? name;
  String? panchayatId;
  double? deliveryFee;

  Village({this.sId, this.name, this.panchayatId, this.deliveryFee});

  Village.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    panchayatId = json['panchayatId'];
    deliveryFee = json['deliveryFee']?.toDouble() ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['panchayatId'] = this.panchayatId;
    data['deliveryFee'] = this.deliveryFee;
    return data;
  }
}
