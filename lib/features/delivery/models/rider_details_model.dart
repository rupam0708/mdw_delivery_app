import 'dart:convert';

class RiderDetailsModel {
  int success;
  String message;
  Rider rider;

  RiderDetailsModel({
    required this.success,
    required this.message,
    required this.rider,
  });

  RiderDetailsModel copyWith({
    int? success,
    String? message,
    Rider? rider,
  }) =>
      RiderDetailsModel(
        success: success ?? this.success,
        message: message ?? this.message,
        rider: rider ?? this.rider,
      );

  factory RiderDetailsModel.fromRawJson(String str) =>
      RiderDetailsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RiderDetailsModel.fromJson(Map<String, dynamic> json) =>
      RiderDetailsModel(
        success: json["success"],
        message: json["message"],
        rider: Rider.fromJson(json["rider"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "rider": rider.toJson(),
      };
}

class Rider {
  String id;
  String name;
  String riderId;
  String riderIdProof;
  String vehicleNumber;
  String vehicleType;
  String phoneNumber;
  int paymentReceived;
  String riderLoginPassword;
  bool isBlocked;
  DateTime createdAt;
  int v;

  Rider({
    required this.id,
    required this.name,
    required this.riderId,
    required this.riderIdProof,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.phoneNumber,
    required this.paymentReceived,
    required this.riderLoginPassword,
    required this.isBlocked,
    required this.createdAt,
    required this.v,
  });

  Rider copyWith({
    String? id,
    String? name,
    String? riderId,
    String? riderIdProof,
    String? vehicleNumber,
    String? vehicleType,
    String? phoneNumber,
    int? paymentReceived,
    String? riderLoginPassword,
    bool? isBlocked,
    DateTime? createdAt,
    int? v,
  }) =>
      Rider(
        id: id ?? this.id,
        name: name ?? this.name,
        riderId: riderId ?? this.riderId,
        riderIdProof: riderIdProof ?? this.riderIdProof,
        vehicleNumber: vehicleNumber ?? this.vehicleNumber,
        vehicleType: vehicleType ?? this.vehicleType,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        paymentReceived: paymentReceived ?? this.paymentReceived,
        riderLoginPassword: riderLoginPassword ?? this.riderLoginPassword,
        isBlocked: isBlocked ?? this.isBlocked,
        createdAt: createdAt ?? this.createdAt,
        v: v ?? this.v,
      );

  factory Rider.fromRawJson(String str) => Rider.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Rider.fromJson(Map<String, dynamic> json) => Rider(
        id: json["_id"],
        name: json["name"],
        riderId: json["riderId"],
        riderIdProof: json["riderIdProof"],
        vehicleNumber: json["vehicleNumber"],
        vehicleType: json["vehicleType"],
        phoneNumber: json["phoneNumber"],
        paymentReceived: json["paymentReceived"],
        riderLoginPassword: json["riderLoginPassword"],
        isBlocked: json["isBlocked"],
        createdAt: DateTime.parse(json["createdAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "riderId": riderId,
        "riderIdProof": riderIdProof,
        "vehicleNumber": vehicleNumber,
        "vehicleType": vehicleType,
        "phoneNumber": phoneNumber,
        "paymentReceived": paymentReceived,
        "riderLoginPassword": riderLoginPassword,
        "isBlocked": isBlocked,
        "createdAt": createdAt.toIso8601String(),
        "__v": v,
      };
}
