import 'dart:convert';

class EarningsModel {
  int success;
  String? message;
  Data data;

  EarningsModel({
    required this.success,
    required this.message,
    required this.data,
  });

  EarningsModel copyWith({
    int? success,
    String? message,
    Data? data,
  }) =>
      EarningsModel(
        success: success ?? this.success,
        message: message ?? this.message,
        data: data ?? this.data,
      );

  factory EarningsModel.fromRawJson(String str) =>
      EarningsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EarningsModel.fromJson(Map<String, dynamic> json) => EarningsModel(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  DateTime date;
  int ordersDelivered;
  int totalEarnings;
  int deliveryCharges;
  int otherCharges;
  List<dynamic> orders;

  Data({
    required this.date,
    required this.ordersDelivered,
    required this.totalEarnings,
    required this.deliveryCharges,
    required this.otherCharges,
    required this.orders,
  });

  Data copyWith({
    DateTime? date,
    int? ordersDelivered,
    int? totalEarnings,
    int? deliveryCharges,
    int? otherCharges,
    List<dynamic>? orders,
  }) =>
      Data(
        date: date ?? this.date,
        ordersDelivered: ordersDelivered ?? this.ordersDelivered,
        totalEarnings: totalEarnings ?? this.totalEarnings,
        deliveryCharges: deliveryCharges ?? this.deliveryCharges,
        otherCharges: otherCharges ?? this.otherCharges,
        orders: orders ?? this.orders,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        date: DateTime.parse(json["date"]),
        ordersDelivered: json["ordersDelivered"],
        totalEarnings: json["totalEarnings"],
        deliveryCharges: json["deliveryCharges"],
        otherCharges: json["otherCharges"],
        orders: List<dynamic>.from(json["orders"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "ordersDelivered": ordersDelivered,
        "totalEarnings": totalEarnings,
        "deliveryCharges": deliveryCharges,
        "otherCharges": otherCharges,
        "orders": List<dynamic>.from(orders.map((x) => x)),
      };
}
