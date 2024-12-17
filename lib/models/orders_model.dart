import 'dart:convert';

class OrdersListModel {
  final List<OrdersModel> orders;

  OrdersListModel({required this.orders});

  factory OrdersListModel.fromRawJson(String str) =>
      OrdersListModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrdersListModel.fromJson(List<dynamic> jsonList) => OrdersListModel(
        orders: List<OrdersModel>.from(
            jsonList.map((x) => OrdersModel.fromJson(x))),
      );

  List<dynamic> toJson() => List<dynamic>.from(orders.map((x) => x.toJson()));
}

class OrdersModel {
  Timestamps timestamps;
  OrderTimestamps orderTimestamps;
  Customer customer;
  String id;
  String orderId;
  DateTime orderDate;
  String orderTime;
  List<Item> items;
  String amount;
  String deliveryStatus;
  double weight;
  String riderName;
  String packerName;
  String binColor;
  int binNumber;
  String status;
  String turnaroundTime;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  OrdersModel({
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
    required this.weight,
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

  factory OrdersModel.fromRawJson(String str) =>
      OrdersModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrdersModel.fromJson(Map<String, dynamic> json) => OrdersModel(
        timestamps: Timestamps.fromJson(json["timestamps"]),
        orderTimestamps: OrderTimestamps.fromJson(json["orderTimestamps"]),
        customer: Customer.fromJson(json["customer"]),
        id: json["_id"],
        orderId: json["orderId"],
        orderDate: DateTime.parse(json["orderDate"]),
        orderTime: json["orderTime"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        amount: json["amount"],
        deliveryStatus: json["deliveryStatus"],
        weight: json["weight"]?.toDouble(),
        riderName: json["riderName"],
        packerName: json["packerName"],
        binColor: json["binColor"],
        binNumber: json["binNumber"],
        status: json["status"],
        turnaroundTime: json["turnaroundTime"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

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
        "weight": weight,
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
  Address address;
  String name;
  int phoneNumber; // Kept as int
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
  String street;
  String city;
  String state;
  int postalCode;
  String country;

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
  String productName;
  int quantity;
  int amount;
  String id;

  Item({
    required this.productName,
    required this.quantity,
    required this.amount,
    required this.id,
  });

  factory Item.fromRawJson(String str) => Item.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        productName: json["productName"],
        quantity: json["quantity"],
        amount: json["amount"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "productName": productName,
        "quantity": quantity,
        "amount": amount,
        "_id": id,
      };
}

class OrderTimestamps {
  DateTime received;

  OrderTimestamps({
    required this.received,
  });

  factory OrderTimestamps.fromRawJson(String str) =>
      OrderTimestamps.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderTimestamps.fromJson(Map<String, dynamic> json) =>
      OrderTimestamps(
        received: DateTime.parse(json["received"]),
      );

  Map<String, dynamic> toJson() => {
        "received": received.toIso8601String(),
      };
}

class Timestamps {
  String orderReceivedAt;

  Timestamps({
    required this.orderReceivedAt,
  });

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
