class Product {
  String? sId;
  String? name;
  String? description;
  int? quantity;
  double? price;
  double? offerPrice;
  bool? todaysSpecial;
  bool? isAvailable;
  ProRef? proCategoryId;
  ProRef? proSubCategoryId;
  ProRef? proBrandId;
  ProTypeRef? proVariantTypeId;
  List<String>? proVariantId;
  List<Images>? images;
  String? unit;
  double? productSize;
  ProRef? addedBy;
  String? status;
  double? shopkeeperPrice;
  double? shopkeeperOfferPrice;
  String? createdAt;
  String? updatedAt;
  String? rejectionReason;
  int? iV;

  Product(
      {this.sId,
        this.name,
        this.description,
        this.quantity,
        this.price,
        this.offerPrice,
        this.todaysSpecial,
        this.isAvailable,
        this.proCategoryId,
        this.proSubCategoryId,
        this.proBrandId,
        this.proVariantTypeId,
        this.proVariantId,
        this.images,
        this.unit,
        this.productSize,
        this.addedBy,
        this.status,
        this.shopkeeperPrice,
        this.shopkeeperOfferPrice,
        this.createdAt,
        this.updatedAt,
        this.rejectionReason,
        this.iV});

  Product.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    quantity = json['quantity'];
    price = json['price']?.toDouble();
    offerPrice = json['offerPrice']?.toDouble();
    todaysSpecial = json['todaysSpecial'];
    isAvailable = json['isAvailable'];
    proCategoryId = json['proCategoryId'] != null && json['proCategoryId'] is Map
        ? new ProRef.fromJson(json['proCategoryId'])
        : null;
    proSubCategoryId = json['proSubCategoryId'] != null && json['proSubCategoryId'] is Map
        ? new ProRef.fromJson(json['proSubCategoryId'])
        : null;
    proBrandId = json['proBrandId'] != null
        ? new ProRef.fromJson(json['proBrandId'])
        : null;
    proVariantTypeId = json['proVariantTypeId'] != null
        ? new ProTypeRef.fromJson(json['proVariantTypeId'])
        : null;
    proVariantId = json['proVariantId'].cast<String>();
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    unit = json['unit'];
    productSize = json['productSize']?.toDouble();
    addedBy = json['addedBy'] != null ? new ProRef.fromJson(json['addedBy']) : null;
    status = json['status'];
    shopkeeperPrice = json['shopkeeperPrice']?.toDouble();
    shopkeeperOfferPrice = json['shopkeeperOfferPrice']?.toDouble();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    rejectionReason = json['rejectionReason'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['offerPrice'] = this.offerPrice;
    data['todaysSpecial'] = this.todaysSpecial;
    data['isAvailable'] = this.isAvailable;
    if (this.proCategoryId != null) {
      data['proCategoryId'] = this.proCategoryId!.toJson();
    }
    if (this.proSubCategoryId != null) {
      data['proSubCategoryId'] = this.proSubCategoryId!.toJson();
    }
    if (this.proBrandId != null) {
      data['proBrandId'] = this.proBrandId!.toJson();
    }
    if (this.proVariantTypeId != null) {
      data['proVariantTypeId'] = this.proVariantTypeId!.toJson();
    }
    data['proVariantId'] = this.proVariantId;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    data['todaysSpecial'] = this.todaysSpecial;
    data['unit'] = this.unit;
    data['productSize'] = this.productSize;
    if (this.addedBy != null) {
      data['addedBy'] = this.addedBy!.toJson();
    }
    data['status'] = this.status;
    data['shopkeeperPrice'] = this.shopkeeperPrice;
    data['shopkeeperOfferPrice'] = this.shopkeeperOfferPrice;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['rejectionReason'] = this.rejectionReason;
    data['__v'] = this.iV;
    return data;
  }
}

class ProRef {
  String? sId;
  String? name;
  String? shopName;

  ProRef({this.sId, this.name, this.shopName});

  ProRef.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    shopName = json['shopName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['shopName'] = this.shopName;
    return data;
  }
}

class ProTypeRef {
  String? sId;
  String? type;

  ProTypeRef({this.sId, this.type});

  ProTypeRef.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['type'] = this.type;
    return data;
  }
}

class Images {
  int? image;
  String? url;
  String? sId;

  Images({this.image, this.url, this.sId});

  Images.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    url = json['url'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['url'] = this.url;
    data['_id'] = this.sId;
    return data;
  }
}