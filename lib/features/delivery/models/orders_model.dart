import 'dart:convert';

class OrdersListModel {
  int success;
  List<Order> orders;

  OrdersListModel({
    required this.success,
    required this.orders,
  });

  factory OrdersListModel.fromRawJson(String str) =>
      OrdersListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrdersListModel.fromJson(Map<String, dynamic> json) =>
      OrdersListModel(
        success: json["success"],
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}

class Order {
  Timestamps? timestamps;
  OrderTimestamps orderTimestamps;
  Customer customer;
  OrderCreatedby? orderCreatedby;
  String id;
  String orderId;
  DateTime orderDate;
  String orderTime;
  List<Item> items;
  int amount;
  String deliveryStatus;
  String riderName;
  String riderId;
  String packerName;
  String packerId;
  String binColor;
  int binNumber;
  String status;
  String turnaroundTime;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Order({
    required this.timestamps,
    required this.orderTimestamps,
    required this.customer,
    required this.orderCreatedby,
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
    required this.packerId,
    required this.binColor,
    required this.binNumber,
    required this.status,
    required this.turnaroundTime,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Order.fromRawJson(String str) => Order.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        timestamps: Timestamps.fromJson(json["timestamps"]),
        orderTimestamps: OrderTimestamps.fromJson(json["orderTimestamps"]),
        customer: Customer.fromJson(json["customer"]),
        orderCreatedby: json["orderCreatedby"] != null
            ? OrderCreatedby.fromJson(json["orderCreatedby"])
            : null,
        // Handle null safely
        id: json["_id"],
        orderId: json["orderId"],
        orderDate: DateTime.parse(json["orderDate"]),
        orderTime: json["orderTime"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        amount: json["amount"].toInt(),
        deliveryStatus: json["deliveryStatus"],
        riderName: json["riderName"],
        riderId: json["riderId"],
        packerName: json["packerName"] ?? "",
        packerId: json["packerId"] ?? "",
        binColor: json["binColor"],
        binNumber: json["binNumber"],
        status: json["status"],
        turnaroundTime: json["turnaroundTime"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "timestamps": timestamps?.toJson(),
        "orderTimestamps": orderTimestamps.toJson(),
        "customer": customer.toJson(),
        "orderCreatedby": orderCreatedby!.toJson(),
        "_id": id,
        "orderId": orderId,
        "orderDate": orderDate.toIso8601String(),
        "orderTime": orderTime,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "amount": amount,
        "deliveryStatus": deliveryStatus,
        "riderName": riderName,
        "riderId": riderId,
        "packerName": packerName,
        "packerId": packerId,
        "binColor": binColor,
        "binNumber": binNumber,
        "status": status,
        "turnaroundTime": turnaroundTime,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
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
  int? postalCode;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
  });

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  @override
  String toString() {
    return 'Street: $street, city: $city, state: $state, postalCode: $postalCode';
  }

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
        amount: json["amount"]?.toDouble() ?? 0.0,
        itemCost: json["itemCost"]?.toDouble() ?? 0.0,
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
  DateTime received;
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

  factory OrderTimestamps.fromRawJson(String str) =>
      OrderTimestamps.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderTimestamps.fromJson(Map<String, dynamic> json) =>
      OrderTimestamps(
        received: DateTime.parse(json["received"]),
        packing:
            json["packing"] == null ? null : DateTime.parse(json["packing"]),
        packed: json["packed"] == null ? null : DateTime.parse(json["packed"]),
        outForDelivery: json["outForDelivery"] == null
            ? null
            : DateTime.parse(json["outForDelivery"]),
        delivered: json["delivered"] == null
            ? null
            : DateTime.parse(json["delivered"]),
      );

  Map<String, dynamic> toJson() => {
        "received": received.toIso8601String(),
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

  factory Timestamps.fromRawJson(String str) =>
      Timestamps.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Timestamps.fromJson(Map<String, dynamic>? json) => Timestamps(
        orderReceivedAt: json?["orderReceivedAt"] ?? "",
        packingStartedAt: json?["packingStartedAt"] ?? "",
        packedAt: json?["packedAt"] ?? "",
        outForDeliveryAt: json?["outForDeliveryAt"] ?? "",
        deliveredAt: json?["deliveredAt"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "orderReceivedAt": orderReceivedAt,
        "packingStartedAt": packingStartedAt,
        "packedAt": packedAt,
        "outForDeliveryAt": outForDeliveryAt,
        "deliveredAt": deliveredAt,
      };
}
