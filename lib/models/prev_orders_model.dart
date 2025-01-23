import 'dart:convert';
import 'dart:developer';

class PrevOrdersListModel {
  final List<PrevOrdersModel> orders;

  PrevOrdersListModel({required this.orders});

  factory PrevOrdersListModel.fromRawJson(String str) =>
      PrevOrdersListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PrevOrdersListModel.fromJson(List<dynamic> jsonList) =>
      PrevOrdersListModel(
        orders: List<PrevOrdersModel>.from(
            jsonList.map((x) => PrevOrdersModel.fromJson(x))),
      );

  List<dynamic> toJson() => List<dynamic>.from(orders.map((x) => x.toJson()));
}

class PrevOrdersModel {
  final Timestamps timestamps;
  final OrderTimestamps orderTimestamps;
  final Customer customer;
  final String id;
  final String orderId;
  final DateTime orderDate;
  final String orderTime;
  final List<Item> items;
  final String amount;
  final String deliveryStatus;
  final String riderName;
  final String packerName;
  final String binColor;
  final int binNumber;
  final String status;
  final String turnaroundTime;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  PrevOrdersModel({
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
    required this.riderName,
    required this.packerName,
    required this.binColor,
    required this.binNumber,
    required this.status,
    required this.turnaroundTime,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory PrevOrdersModel.fromRawJson(String str) =>
      PrevOrdersModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PrevOrdersModel.fromJson(Map<String, dynamic> json) {
    log(json["items"].toString() + " Log");
    return PrevOrdersModel(
      timestamps: Timestamps.fromJson(json["timestamps"]),
      orderTimestamps: OrderTimestamps.fromJson(json["orderTimestamps"]),
      customer: Customer.fromJson(json["customer"]),
      id: json["_id"],
      orderId: json["orderId"],
      orderDate: DateTime.parse(json["orderDate"]),
      orderTime: json["orderTime"],
      items: List<Item>.from(json["items"].map((x) {
        log(x.toString());
        return Item.fromJson(x);
      })),
      amount: json["amount"],
      deliveryStatus: json["deliveryStatus"],
      riderName: json["riderName"] ?? "",
      packerName: json["packerName"] ?? "",
      binColor: json["binColor"] ?? "",
      binNumber: json["binNumber"] ?? 0,
      status: json["status"],
      turnaroundTime: json["turnaroundTime"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
        "timestamps": timestamps.toJson(),
        "orderTimestamps": orderTimestamps.toJson(),
        "customer": customer.toJson(),
        "_id": id,
        "orderId": orderId,
        "orderDate": orderDate.toIso8601String(),
        "orderTime": orderTime,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "amount": amount,
        "deliveryStatus": deliveryStatus,
        "riderName": riderName,
        "packerName": packerName,
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
  final Address address;
  final String name;
  final int phoneNumber;
  final String email;

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

  @override
  String toString() {
    String phoneStr =
        phoneNumber.toString(); // Convert int to String for formatting
    if (phoneStr.length == 10) {
      return '+91 ${phoneStr.substring(0, 5)} ${phoneStr.substring(5)}';
    }
    return phoneStr; // Return as-is if formatting fails
  }
}

class Address {
  final String street;
  final String city;
  final String state;
  final int postalCode;
  final String country;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
  });

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

  @override
  String toString() {
    return "$street, $city: $postalCode, $state, $country";
  }
}

class Item {
  final String productId;
  final String productName;
  final int quantity;
  final int amount;
  final String id;

  Item({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.amount,
    required this.id,
  });

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        productId: json["productId"] ?? "",
        productName: json["productName"],
        quantity: json["quantity"],
        amount: json["amount"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "productName": productName,
        "quantity": quantity,
        "amount": amount,
        "_id": id,
      };
}

class OrderTimestamps {
  final DateTime received;

  OrderTimestamps({required this.received});

  factory OrderTimestamps.fromRawJson(String str) =>
      OrderTimestamps.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderTimestamps.fromJson(Map<String, dynamic> json) =>
      OrderTimestamps(received: DateTime.parse(json["received"]));

  Map<String, dynamic> toJson() => {
        "received": received.toIso8601String(),
      };
}

class Timestamps {
  final String orderReceivedAt;

  Timestamps({required this.orderReceivedAt});

  factory Timestamps.fromRawJson(String str) =>
      Timestamps.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Timestamps.fromJson(Map<String, dynamic> json) => Timestamps(
        orderReceivedAt: json["orderReceivedAt"],
      );

  Map<String, dynamic> toJson() => {
        "orderReceivedAt": orderReceivedAt,
      };
}
