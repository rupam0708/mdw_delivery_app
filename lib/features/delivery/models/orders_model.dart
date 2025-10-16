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
  OrderTimestamps? orderTimestamps;
  Customer customer;
  OrderCreatedby? orderCreatedby;
  PaymentCollection? paymentCollection;
  String id;
  String orderId;
  DateTime orderDate;
  String orderTime;
  List<Item> items;
  double amount;
  int discount;
  String deliveryStatus;
  String riderName;
  String? deliverycharges;
  String? raincharges;
  List<dynamic>? couponCodes;
  String riderId;
  String packerName;
  String packerId;
  String binColor;
  int binNumber;
  String paymentStatus;
  String status;
  int deliveryCode;
  String turnaroundTime;
  bool? scheduledDelivery;
  DateTime? scheduledDeliveryDate;
  String? scheduledDeliveryTimeRange;
  int deliveryEarnings;
  int otherEarnings;
  bool earningsCalculated;
  String? paymentMode;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String? scheduledDeliveryTime;
  DateTime? deliveryCompletedAt;

  Order({
    this.timestamps,
    this.orderTimestamps,
    required this.customer,
    this.orderCreatedby,
    this.paymentCollection,
    required this.id,
    required this.orderId,
    required this.orderDate,
    required this.orderTime,
    required this.items,
    required this.amount,
    required this.discount,
    required this.deliveryStatus,
    required this.riderName,
    this.deliverycharges,
    this.raincharges,
    this.couponCodes,
    required this.riderId,
    required this.packerName,
    required this.packerId,
    required this.binColor,
    required this.binNumber,
    required this.paymentStatus,
    required this.status,
    required this.deliveryCode,
    required this.turnaroundTime,
    this.scheduledDelivery,
    this.scheduledDeliveryDate,
    this.scheduledDeliveryTimeRange,
    required this.deliveryEarnings,
    required this.otherEarnings,
    required this.earningsCalculated,
    this.paymentMode,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.scheduledDeliveryTime,
    this.deliveryCompletedAt,
  });

  factory Order.fromRawJson(String str) => Order.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        timestamps: json["timestamps"] != null
            ? Timestamps.fromJson(json["timestamps"])
            : null,
        orderTimestamps: json["orderTimestamps"] != null
            ? OrderTimestamps.fromJson(json["orderTimestamps"])
            : null,
        customer: Customer.fromJson(json["customer"]),
        orderCreatedby: json["orderCreatedby"] != null
            ? OrderCreatedby.fromJson(json["orderCreatedby"])
            : null,
        paymentCollection: json["paymentCollection"] != null
            ? PaymentCollection.fromJson(json["paymentCollection"])
            : null,
        id: json["_id"],
        orderId: json["orderId"],
        orderDate: DateTime.parse(json["orderDate"]),
        orderTime: json["orderTime"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        amount: (json["amount"] ?? 0).toDouble(),
        discount: json["discount"] ?? 0,
        deliveryStatus: json["deliveryStatus"] ?? "",
        riderName: json["riderName"] ?? "",
        deliverycharges: json["deliverycharges"],
        raincharges: json["raincharges"],
        couponCodes: json["couponCodes"] != null
            ? List<dynamic>.from(json["couponCodes"].map((x) => x))
            : [],
        riderId: json["riderId"] ?? "",
        packerName: json["packerName"] ?? "",
        packerId: json["packerId"] ?? "",
        binColor: json["binColor"] ?? "",
        binNumber: json["binNumber"] ?? 0,
        paymentStatus: json["paymentStatus"] ?? "",
        status: json["status"] ?? "",
        deliveryCode: json["deliveryCode"] ?? 0,
        turnaroundTime: json["turnaroundTime"] ?? "",
        scheduledDelivery: json["scheduledDelivery"],
        scheduledDeliveryDate: json["scheduledDeliveryDate"] == null ||
                json["scheduledDeliveryDate"].toString().isEmpty
            ? null
            : DateTime.parse(json["scheduledDeliveryDate"]),
        scheduledDeliveryTimeRange: json["scheduledDeliveryTimeRange"],
        deliveryEarnings: json["deliveryEarnings"] ?? 0,
        otherEarnings: json["otherEarnings"] ?? 0,
        earningsCalculated: json["earningsCalculated"] ?? false,
        paymentMode: json["paymentMode"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        scheduledDeliveryTime: json["scheduledDeliveryTime"],
        deliveryCompletedAt: json["deliveryCompletedAt"] == null
            ? null
            : DateTime.parse(json["deliveryCompletedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "timestamps": timestamps?.toJson(),
        "orderTimestamps": orderTimestamps?.toJson(),
        "customer": customer.toJson(),
        "orderCreatedby": orderCreatedby?.toJson(),
        "paymentCollection": paymentCollection?.toJson(),
        "_id": id,
        "orderId": orderId,
        "orderDate": orderDate.toIso8601String(),
        "orderTime": orderTime,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "amount": amount,
        "discount": discount,
        "deliveryStatus": deliveryStatus,
        "riderName": riderName,
        "deliverycharges": deliverycharges,
        "raincharges": raincharges,
        "couponCodes": couponCodes,
        "riderId": riderId,
        "packerName": packerName,
        "packerId": packerId,
        "binColor": binColor,
        "binNumber": binNumber,
        "paymentStatus": paymentStatus,
        "status": status,
        "deliveryCode": deliveryCode,
        "turnaroundTime": turnaroundTime,
        "scheduledDelivery": scheduledDelivery,
        "scheduledDeliveryDate": scheduledDeliveryDate?.toIso8601String(),
        "scheduledDeliveryTimeRange": scheduledDeliveryTimeRange,
        "deliveryEarnings": deliveryEarnings,
        "otherEarnings": otherEarnings,
        "earningsCalculated": earningsCalculated,
        "paymentMode": paymentMode,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "scheduledDeliveryTime": scheduledDeliveryTime,
        "deliveryCompletedAt": deliveryCompletedAt?.toIso8601String(),
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
        name: json["name"] ?? "",
        phoneNumber: json["phoneNumber"] ?? 0,
        email: json["email"] ?? "",
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
    this.postalCode,
  });

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        street: json["street"] ?? "",
        city: json["city"] ?? "",
        state: json["state"] ?? "",
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
    return "$street, $city, $state${postalCode != null ? ' - $postalCode' : ''}";
  }
}

class Item {
  String productId;
  String productName;
  int quantity;
  double amount;
  double itemCost;
  String batchNumber;
  String expireAt;
  int discount;
  String id;

  Item({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.amount,
    required this.itemCost,
    required this.batchNumber,
    required this.expireAt,
    required this.discount,
    required this.id,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        productId: json["productId"] ?? "",
        productName: json["productName"] ?? "",
        quantity: json["quantity"] ?? 0,
        amount: (json["amount"] ?? 0).toDouble(),
        itemCost: (json["itemCost"] ?? 0).toDouble(),
        batchNumber: json["batchNumber"] ?? "",
        expireAt: json["expireAt"] ?? "",
        discount: json["discount"] ?? 0,
        id: json["_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productName": productName,
        "quantity": quantity,
        "amount": amount,
        "itemCost": itemCost,
        "batchNumber": batchNumber,
        "expireAt": expireAt,
        "discount": discount,
        "_id": id,
      };
}

class PaymentCollection {
  String? methodSelected;
  bool cashCollected;
  bool cashSubmitted;
  bool adminVerified;
  String collectionStatus;
  String upiQrUrl;

  PaymentCollection({
    this.methodSelected,
    required this.cashCollected,
    required this.cashSubmitted,
    required this.adminVerified,
    required this.collectionStatus,
    required this.upiQrUrl,
  });

  factory PaymentCollection.fromJson(Map<String, dynamic> json) =>
      PaymentCollection(
        methodSelected: json["methodSelected"],
        cashCollected: json["cashCollected"] ?? false,
        cashSubmitted: json["cashSubmitted"] ?? false,
        adminVerified: json["adminVerified"] ?? false,
        collectionStatus: json["collectionStatus"] ?? "",
        upiQrUrl: json["upiQrUrl"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "methodSelected": methodSelected,
        "cashCollected": cashCollected,
        "cashSubmitted": cashSubmitted,
        "adminVerified": adminVerified,
        "collectionStatus": collectionStatus,
        "upiQrUrl": upiQrUrl,
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

  factory OrderCreatedby.fromJson(Map<String, dynamic> json) => OrderCreatedby(
        name: json["name"] ?? "",
        role: json["role"] ?? "",
        email: json["email"] ?? "",
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
  DateTime? arrivedAtWarehouse;

  OrderTimestamps({
    required this.received,
    this.packing,
    this.packed,
    this.outForDelivery,
    this.delivered,
    this.arrivedAtWarehouse,
  });

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
        arrivedAtWarehouse: json["arrivedAtWarehouse"] == null
            ? null
            : DateTime.parse(json["arrivedAtWarehouse"]),
      );

  Map<String, dynamic> toJson() => {
        "received": received.toIso8601String(),
        "packing": packing?.toIso8601String(),
        "packed": packed?.toIso8601String(),
        "outForDelivery": outForDelivery?.toIso8601String(),
        "delivered": delivered?.toIso8601String(),
        "arrivedAtWarehouse": arrivedAtWarehouse?.toIso8601String(),
      };
}

class Timestamps {
  DateTime? orderReceivedAt;
  DateTime? packingStartedAt;
  DateTime? packedAt;
  DateTime? outForDeliveryAt;
  DateTime? deliveredAt;
  DateTime? arrivedAtWarehouse;

  Timestamps({
    this.orderReceivedAt,
    this.packingStartedAt,
    this.packedAt,
    this.outForDeliveryAt,
    this.deliveredAt,
    this.arrivedAtWarehouse,
  });

  factory Timestamps.fromJson(Map<String, dynamic> json) => Timestamps(
        orderReceivedAt: json["orderReceivedAt"] == null
            ? null
            : DateTime.parse(json["orderReceivedAt"]),
        packingStartedAt: json["packingStartedAt"] == null
            ? null
            : DateTime.parse(json["packingStartedAt"]),
        packedAt:
            json["packedAt"] == null ? null : DateTime.parse(json["packedAt"]),
        outForDeliveryAt: json["outForDeliveryAt"] == null
            ? null
            : DateTime.parse(json["outForDeliveryAt"]),
        deliveredAt: json["deliveredAt"] == null
            ? null
            : DateTime.parse(json["deliveredAt"]),
        arrivedAtWarehouse: json["arrivedAtWarehouse"] == null
            ? null
            : DateTime.parse(json["arrivedAtWarehouse"]),
      );

  Map<String, dynamic> toJson() => {
        "orderReceivedAt": orderReceivedAt?.toIso8601String(),
        "packingStartedAt": packingStartedAt?.toIso8601String(),
        "packedAt": packedAt?.toIso8601String(),
        "outForDeliveryAt": outForDeliveryAt?.toIso8601String(),
        "deliveredAt": deliveredAt?.toIso8601String(),
        "arrivedAtWarehouse": arrivedAtWarehouse?.toIso8601String(),
      };
}
