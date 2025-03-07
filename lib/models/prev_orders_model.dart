import 'dart:convert';

class PrevOrdersListModel {
  String status;
  List<PreviousOrder> data;

  PrevOrdersListModel({
    required this.status,
    required this.data,
  });

  factory PrevOrdersListModel.fromRawJson(String str) =>
      PrevOrdersListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PrevOrdersListModel.fromJson(Map<String, dynamic> json) =>
      PrevOrdersListModel(
        status: json["status"],
        data: List<PreviousOrder>.from(
            json["data"].map((x) => PreviousOrder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class PreviousOrder {
  Timestamps timestamps;
  OrderTimestamps orderTimestamps;
  Customer customer;
  String id;
  String orderId;
  String orderDate;
  String orderTime;
  List<Item> items;
  int amount;
  DeliveryStatus deliveryStatus;
  double? weight;
  String riderName;
  String packerName;
  String binColor;
  int binNumber;
  Status status;
  TurnaroundTime? turnaroundTime;
  String createdAt;
  String updatedAt;
  int v;
  String? cancellationReason;
  OrderCreatedby? orderCreatedby;
  String? riderId;
  String? packerId;

  PreviousOrder({
    required this.timestamps,
    required this.orderTimestamps,
    required this.customer,
    required this.id,
    required this.orderId,
    required this.orderDate,
    required this.orderTime,
    required this.items,
    required this.amount,
    required this.deliveryStatus,
    this.weight,
    required this.riderName,
    required this.packerName,
    required this.binColor,
    required this.binNumber,
    required this.status,
    required this.turnaroundTime,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.cancellationReason,
    this.orderCreatedby,
    this.riderId,
    this.packerId,
  });

  factory PreviousOrder.fromRawJson(String str) =>
      PreviousOrder.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PreviousOrder.fromJson(Map<String, dynamic> json) => PreviousOrder(
        timestamps: Timestamps.fromJson(json["timestamps"]),
        orderTimestamps: OrderTimestamps.fromJson(json["orderTimestamps"]),
        customer: Customer.fromJson(json["customer"]),
        id: json["_id"],
        orderId: json["orderId"],
        orderDate: json["orderDate"],
        orderTime: json["orderTime"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        amount: json["amount"].toInt(),
        deliveryStatus: deliveryStatusValues.map[json["deliveryStatus"]]!,
        weight: json["weight"]?.toDouble(),
        riderName: json["riderName"] ?? "",
        packerName: json["packerName"] ?? "",
        binColor: json["binColor"],
        binNumber: json["binNumber"],
        status: statusValues.map[json["status"]] ?? Status.CANCELED,
        turnaroundTime: turnaroundTimeValues.map[json["turnaroundTime"]],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        v: json["__v"],
        cancellationReason: json["cancellationReason"],
        orderCreatedby: json["orderCreatedby"] == null
            ? null
            : OrderCreatedby.fromJson(json["orderCreatedby"]),
        riderId: json["riderId"],
        packerId: json["packerId"],
      );

  Map<String, dynamic> toJson() => {
        "timestamps": timestamps.toJson(),
        "orderTimestamps": orderTimestamps.toJson(),
        "customer": customer.toJson(),
        "_id": id,
        "orderId": orderId,
        "orderDate": orderDate,
        "orderTime": orderTime,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "amount": amount,
        "deliveryStatus": deliveryStatusValues.reverse[deliveryStatus],
        "weight": weight,
        "riderName": riderName,
        "packerName": packerName,
        "binColor": binColor,
        "binNumber": binNumber,
        "status": statusValues.reverse[status],
        "turnaroundTime": turnaroundTimeValues.reverse[turnaroundTime],
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
        "cancellationReason": cancellationReason,
        "orderCreatedby": orderCreatedby?.toJson(),
        "riderId": riderId,
        "packerId": packerId,
      };
}

class Customer {
  Address address;
  String name;
  int phoneNumber;
  String email;

  Customer({
    required this.address,
    required this.name,
    required this.phoneNumber,
    required this.email,
  });

  factory Customer.fromRawJson(String str) =>
      Customer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        address: Address.fromJson(json["address"]),
        name: json["name"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "address": address.toJson(),
        "name": name,
        "phoneNumber": phoneNumber,
        "email": email,
      };
}

class Address {
  String street;
  String city;
  String state;
  int postalCode;
  String? country;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    this.country,
  });

  @override
  String toString() {
    return 'Street: $street, city: $city, state: $state, postalCode: $postalCode';
  }

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        street: json["street"],
        city: json["city"],
        state: json["state"],
        postalCode: json["postalCode"],
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "street": street,
        "city": city,
        "state": state,
        "postalCode": postalCode,
        "country": country,
      };
}

enum DeliveryStatus { PENDING }

final deliveryStatusValues = EnumValues({"Pending": DeliveryStatus.PENDING});

class Item {
  String productName;
  int quantity;
  double amount;
  String id;
  String? productId;
  double itemCost;

  Item({
    required this.productName,
    required this.quantity,
    required this.amount,
    required this.id,
    this.productId,
    required this.itemCost,
  });

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        productName: json["productName"],
        quantity: json["quantity"],
        amount: json["amount"]?.toDouble() ?? 0.0,
        itemCost: json["itemCost"]?.toDouble() ?? 0.0,
        id: json["_id"],
        productId: json["productId"],
      );

  Map<String, dynamic> toJson() => {
        "productName": productName,
        "quantity": quantity,
        "amount": amount,
        "_id": id,
        "productId": productId,
        "itemCost": itemCost,
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

  factory OrderCreatedby.fromRawJson(String str) =>
      OrderCreatedby.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderCreatedby.fromJson(Map<String, dynamic> json) => OrderCreatedby(
        name: json["name"],
        role: json["role"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "role": role,
        "email": email,
      };
}

class OrderTimestamps {
  String received;
  DateTime? packed;
  DateTime? outForDelivery;

  OrderTimestamps({
    required this.received,
    this.packed,
    this.outForDelivery,
  });

  factory OrderTimestamps.fromRawJson(String str) =>
      OrderTimestamps.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderTimestamps.fromJson(Map<String, dynamic> json) =>
      OrderTimestamps(
        received: json["received"],
        packed: json["packed"] == null ? null : DateTime.parse(json["packed"]),
        outForDelivery: json["outForDelivery"] == null
            ? null
            : DateTime.parse(json["outForDelivery"]),
      );

  Map<String, dynamic> toJson() => {
        "received": received,
        "packed": packed?.toIso8601String(),
        "outForDelivery": outForDelivery?.toIso8601String(),
      };
}

enum Status { CANCELED, OUT_FOR_DELIVERY, RECEIVED }

final statusValues = EnumValues({
  "Canceled": Status.CANCELED,
  "Out for Delivery": Status.OUT_FOR_DELIVERY,
  "Received": Status.RECEIVED
});

class Timestamps {
  String orderReceivedAt;
  String? packedAt;
  String? outForDeliveryAt;

  Timestamps({
    required this.orderReceivedAt,
    this.packedAt,
    this.outForDeliveryAt,
  });

  factory Timestamps.fromRawJson(String str) =>
      Timestamps.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Timestamps.fromJson(Map<String, dynamic> json) => Timestamps(
        orderReceivedAt: json["orderReceivedAt"],
        packedAt: json["packedAt"],
        outForDeliveryAt: json["outForDeliveryAt"],
      );

  Map<String, dynamic> toJson() => {
        "orderReceivedAt": orderReceivedAt,
        "packedAt": packedAt,
        "outForDeliveryAt": outForDeliveryAt,
      };
}

enum TurnaroundTime { THE_0_S }

final turnaroundTimeValues = EnumValues({"0s": TurnaroundTime.THE_0_S});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
