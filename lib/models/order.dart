class Order {
  ShippingAddress? shippingAddress;
  OrderTotal? orderTotal;
  String? sId;
  UserID? userID;
  String? orderStatus;
  List<Items>? items;
  double? totalPrice;
  String? paymentMethod;
  CouponCode? couponCode;
  String? trackingUrl;
  String? orderDate;
  int? iV;

  Order(
      {this.shippingAddress,
        this.orderTotal,
        this.sId,
        this.userID,
        this.orderStatus,
        this.items,
        this.totalPrice,
        this.paymentMethod,
        this.couponCode,
        this.trackingUrl,
        this.orderDate,
        this.iV});

  Order.fromJson(Map<String, dynamic> json) {
    shippingAddress = json['shippingAddress'] != null
        ? new ShippingAddress.fromJson(json['shippingAddress'])
        : null;
    orderTotal = json['orderTotal'] != null
        ? new OrderTotal.fromJson(json['orderTotal'])
        : null;
    sId = json['_id'];
    userID =
    json['userID'] != null ? new UserID.fromJson(json['userID']) : null;
    orderStatus = json['orderStatus'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    totalPrice = json['totalPrice']?.toDouble();;
    paymentMethod = json['paymentMethod'];
    couponCode = json['couponCode'] != null
        ? new CouponCode.fromJson(json['couponCode'])
        : null;
    trackingUrl = json['trackingUrl'];
    orderDate = json['orderDate'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shippingAddress != null) {
      data['shippingAddress'] = this.shippingAddress!.toJson();
    }
    if (this.orderTotal != null) {
      data['orderTotal'] = this.orderTotal!.toJson();
    }
    data['_id'] = this.sId;
    if (this.userID != null) {
      data['userID'] = this.userID!.toJson();
    }
    data['orderStatus'] = this.orderStatus;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['totalPrice'] = this.totalPrice;
    data['paymentMethod'] = this.paymentMethod;
    if (this.couponCode != null) {
      data['couponCode'] = this.couponCode!.toJson();
    }
    data['trackingUrl'] = this.trackingUrl;
    data['orderDate'] = this.orderDate;
    data['__v'] = this.iV;
    return data;
  }
}

class ShippingAddress {
  String? phone;
  String? landmark;
  String? village;
  String? panchayat;
  String? block;
  double? deliveryFee;

  ShippingAddress(
      {this.phone,
        this.landmark,
        this.village,
        this.panchayat,
        this.block,
        this.deliveryFee});

  ShippingAddress.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    landmark = json['landmark'];
    village = json['village'];
    panchayat = json['panchayat'];
    block = json['block'];
    deliveryFee = json['deliveryFee']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['landmark'] = this.landmark;
    data['village'] = this.village;
    data['panchayat'] = this.panchayat;
    data['block'] = this.block;
    data['deliveryFee'] = this.deliveryFee;
    return data;
  }
}

class OrderTotal {
  double? subtotal;
  double? discount;
  double? shipping;
  double? total;

  OrderTotal({this.subtotal, this.discount, this.shipping, this.total});

  OrderTotal.fromJson(Map<String, dynamic> json) {
    subtotal = json['subtotal']?.toDouble();
    discount = json['discount']?.toDouble();
    shipping = json['shipping']?.toDouble();
    total = json['total']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subtotal'] = this.subtotal;
    data['discount'] = this.discount;
    data['shipping'] = this.shipping;
    data['total'] = this.total;
    return data;
  }
}

class UserID {
  String? sId;
  String? name;

  UserID({this.sId, this.name});

  UserID.fromJson(Map<String, dynamic> json) {
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

class Items {
  String? productID;
  String? productName;
  int? quantity;
  double? price;
  String? variant;
  String? sId;
  String? unit;
  String? vendorId;
  double? shopkeeperPrice;

  Items(
      {this.productID,
        this.productName,
        this.quantity,
        this.price,
        this.variant,
        this.sId,
        this.unit,
        this.vendorId,
        this.shopkeeperPrice});

  Items.fromJson(Map<String, dynamic> json) {
    productID = json['productID'];
    productName = json['productName'];
    quantity = json['quantity'];
    price = json['price']?.toDouble();
    variant = json['variant'];
    sId = json['_id'];
    unit = json['unit'];
    vendorId = json['vendorId'];
    shopkeeperPrice = json['shopkeeperPrice']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productID'] = this.productID;
    data['productName'] = this.productName;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['variant'] = this.variant;
    data['_id'] = this.sId;
    data['unit'] = this.unit;
    data['vendorId'] = this.vendorId;
    data['shopkeeperPrice'] = this.shopkeeperPrice;
    return data;
  }
}

class CouponCode {
  String? sId;
  String? couponCode;
  String? discountType;
  int? discountAmount;

  CouponCode(
      {this.sId, this.couponCode, this.discountType, this.discountAmount});

  CouponCode.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    couponCode = json['couponCode'];
    discountType = json['discountType'];
    discountAmount = json['discountAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['couponCode'] = this.couponCode;
    data['discountType'] = this.discountType;
    data['discountAmount'] = this.discountAmount;
    return data;
  }
}