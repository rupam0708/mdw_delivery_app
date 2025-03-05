import 'dart:convert';

class OrdersListModel {
  bool success;
  List<TodayOrder> data;

  OrdersListModel({
    required this.success,
    required this.data,
  });

  factory OrdersListModel.fromRawJson(String str) => OrdersListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrdersListModel.fromJson(Map<String, dynamic> json) => OrdersListModel(
    success: json["success"],
    data: List<TodayOrder>.from(json["data"].map((x) => TodayOrder.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class TodayOrder {
  String id;
  String orderId;
  String orderDate;
  String orderTime;
  List<Item> items;
  double amount;
  String deliveryStatus;
  String riderName;
  String riderId;
  String packerName;
  String binColor;
  int binNumber;
  String status;
  Timestamps timestamps;
  String turnaroundTime;
  OrderTimestamps orderTimestamps;
  Customer customer;
  OrderCreatedby orderCreatedby;
  String createdAt;
  String updatedAt;
  int v;
  int statusOrder;
  String? packerId;
  String? cancellationReason;

  TodayOrder({
    required this.id,
    required this.orderId,
    required this.orderDate,
    required this.orderTime,
    required this.items,
    required this.amount,
    required this.deliveryStatus,
    required this.riderName,
    required this.riderId,
    required this.packerName,
    required this.binColor,
    required this.binNumber,
    required this.status,
    required this.timestamps,
    required this.turnaroundTime,
    required this.orderTimestamps,
    required this.customer,
    required this.orderCreatedby,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.statusOrder,
    this.packerId,
    this.cancellationReason,
  });

  factory TodayOrder.fromRawJson(String str) => TodayOrder.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TodayOrder.fromJson(Map<String, dynamic> json) => TodayOrder(
    id: json["_id"],
    orderId: json["orderId"],
    orderDate: json["orderDate"],
    orderTime: json["orderTime"],
    items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
    amount: json["amount"]?.toDouble(),
    deliveryStatus: json["deliveryStatus"],
    riderName: json["riderName"],
    riderId: json["riderId"]??"",
    packerName: json["packerName"],
    binColor: json["binColor"],
    binNumber: json["binNumber"],
    status: json["status"],
    timestamps: Timestamps.fromJson(json["timestamps"]),
    turnaroundTime: json["turnaroundTime"],
    orderTimestamps: OrderTimestamps.fromJson(json["orderTimestamps"]),
    customer: Customer.fromJson(json["customer"]),
    orderCreatedby: OrderCreatedby.fromJson(json["orderCreatedby"]??{}),
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    v: json["__v"],
    statusOrder: json["statusOrder"],
    packerId: json["packerId"],
    cancellationReason: json["cancellationReason"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "orderId": orderId,
    "orderDate": orderDate,
    "orderTime": orderTime,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "amount": amount,
    "deliveryStatus": deliveryStatus,
    "riderName": riderName,
    "riderId": riderId,
    "packerName": packerName,
    "binColor": binColor,
    "binNumber": binNumber,
    "status": status,
    "timestamps": timestamps.toJson(),
    "turnaroundTime": turnaroundTime,
    "orderTimestamps": orderTimestamps.toJson(),
    "customer": customer.toJson(),
    "orderCreatedby": orderCreatedby.toJson(),
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "__v": v,
    "statusOrder": statusOrder,
    "packerId": packerId,
    "cancellationReason": cancellationReason,
  };
}

class Customer {
  String name;
  int phoneNumber;
  String email;
  Address address;

  Customer({
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.address,
  });

  factory Customer.fromRawJson(String str) => Customer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    name: json["name"],
    phoneNumber: json["phoneNumber"],
    email: json["email"],
    address: Address.fromJson(json["address"]),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "phoneNumber": phoneNumber,
    "email": email,
    "address": address.toJson(),
  };
}


class Address {
  String street;
  String city;
  String state;
  int postalCode;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
  });

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    street: json["street"],
    city: json["city"],
    state: json["state"],
    postalCode: json["postalCode"],
  );

  Map<String, dynamic> toJson() => {
    "street": street,
    "city": city,
    "state": state,
    "postalCode": postalCode,
  };

  @override
  String toString() {
    return 'Street: $street, city: $city, state: $state, postalCode: $postalCode';
  }
}


class Item {
  String productId;
  String productName;
  int quantity;
  double amount;
  double itemCost;
  String id;

  Item({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.amount,
    required this.itemCost,
    required this.id,
  });

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    productId: json["productId"] ?? "",
    productName: json["productName"],
    quantity: json["quantity"],
    amount: json["amount"]?.toDouble(),
    itemCost: json["itemCost"]?.toDouble()??0,
    id: json["_id"],
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "productName": productName,
    "quantity": quantity,
    "amount": amount,
    "itemCost": itemCost,
    "_id": id,
  };
}

class OrderCreatedby {
  String name;
  String role;
  String email;

  OrderCreatedby({
    required this.name,
    required this.role,
    required this.email,
  });

  factory OrderCreatedby.fromRawJson(String str) => OrderCreatedby.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderCreatedby.fromJson(Map<String, dynamic> json) => OrderCreatedby(
    name: json["name"]??"",
    role: json["role"]??"",
    email: json["email"]??"",
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "role": role,
    "email": email,
  };
}

class OrderTimestamps {
  String received;
  DateTime? packing;
  DateTime? packed;
  DateTime? outForDelivery;
  DateTime? delivered;

  OrderTimestamps({
    required this.received,
    this.packing,
    this.packed,
    this.outForDelivery,
    this.delivered,
  });

  factory OrderTimestamps.fromRawJson(String str) => OrderTimestamps.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderTimestamps.fromJson(Map<String, dynamic> json) => OrderTimestamps(
    received: json["received"],
    packing: json["packing"] == null ? null : DateTime.parse(json["packing"]),
    packed: json["packed"] == null ? null : DateTime.parse(json["packed"]),
    outForDelivery: json["outForDelivery"] == null ? null : DateTime.parse(json["outForDelivery"]),
    delivered: json["delivered"] == null ? null : DateTime.parse(json["delivered"]),
  );

  Map<String, dynamic> toJson() => {
    "received": received,
    "packing": packing?.toIso8601String(),
    "packed": packed?.toIso8601String(),
    "outForDelivery": outForDelivery?.toIso8601String(),
    "delivered": delivered?.toIso8601String(),
  };
}

class Timestamps {
  String orderReceivedAt;
  String? packingStartedAt;
  String? packedAt;
  String? outForDeliveryAt;
  String? deliveredAt;

  Timestamps({
    required this.orderReceivedAt,
    this.packingStartedAt,
    this.packedAt,
    this.outForDeliveryAt,
    this.deliveredAt,
  });

  factory Timestamps.fromRawJson(String str) => Timestamps.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Timestamps.fromJson(Map<String, dynamic> json) => Timestamps(
    orderReceivedAt: json["orderReceivedAt"],
    packingStartedAt: json["packingStartedAt"],
    packedAt: json["packedAt"],
    outForDeliveryAt: json["outForDeliveryAt"],
    deliveredAt: json["deliveredAt"],
  );

  Map<String, dynamic> toJson() => {
    "orderReceivedAt": orderReceivedAt,
    "packingStartedAt": packingStartedAt,
    "packedAt": packedAt,
    "outForDeliveryAt": outForDeliveryAt,
    "deliveredAt": deliveredAt,
  };
}
