import 'dart:convert';

class LoginUserModel {
  int success;
  String message;
  String token;
  Rider rider;

  LoginUserModel({
    required this.success,
    required this.message,
    required this.token,
    required this.rider,
  });

  factory LoginUserModel.fromRawJson(String str) =>
      LoginUserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginUserModel.fromJson(Map<String, dynamic> json) => LoginUserModel(
        success: json["success"],
        message: json["message"],
        token: json["token"],
        rider: Rider.fromJson(json["rider"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "token": token,
        "rider": rider.toJson(),
      };
}

class Rider {
  String riderName;
  String riderId;
  String vehicleNumber;
  String vehicleType;
  String phoneNumber;
  int paymentReceived;
  DateTime createdAt;

  Rider({
    required this.riderName,
    required this.riderId,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.phoneNumber,
    required this.paymentReceived,
    required this.createdAt,
  });

  factory Rider.fromRawJson(String str) => Rider.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Rider.fromJson(Map<String, dynamic> json) => Rider(
        riderName: json["riderName"],
        riderId: json["riderId"],
        vehicleNumber: json["vehicleNumber"],
        vehicleType: json["vehicleType"],
        phoneNumber: json["phoneNumber"],
        paymentReceived: json["paymentReceived"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "riderName": riderName,
        "riderId": riderId,
        "vehicleNumber": vehicleNumber,
        "vehicleType": vehicleType,
        "phoneNumber": phoneNumber,
        "paymentReceived": paymentReceived,
        "createdAt": createdAt.toIso8601String(),
      };
}
