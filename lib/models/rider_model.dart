import 'dart:convert';

class RiderModel {
  int success;
  String message;
  Rider rider;

  RiderModel({
    required this.success,
    required this.message,
    required this.rider,
  });

  factory RiderModel.fromRawJson(String str) =>
      RiderModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RiderModel.fromJson(Map<String, dynamic> json) => RiderModel(
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
  String riderName;
  String riderId;
  String riderIdProof;
  String vehicleNumber;
  String vehicleType;
  String phoneNumber;
  int paymentReceived;
  String riderPassword;
  DateTime createdAt;
  int v;
  String idProofUrl;

  Rider({
    required this.id,
    required this.riderName,
    required this.riderId,
    required this.riderIdProof,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.phoneNumber,
    required this.paymentReceived,
    required this.riderPassword,
    required this.createdAt,
    required this.v,
    required this.idProofUrl,
  });

  factory Rider.fromRawJson(String str) => Rider.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Rider.fromJson(Map<String, dynamic> json) => Rider(
        id: json["_id"],
        riderName: json["riderName"] ?? "",
        riderId: json["riderId"],
        riderIdProof: json["riderIdProof"],
        vehicleNumber: json["vehicleNumber"],
        vehicleType: json["vehicleType"],
        phoneNumber: json["phoneNumber"],
        paymentReceived: json["paymentReceived"],
        riderPassword: json["riderPassword"]??"",
        createdAt: DateTime.parse(json["createdAt"]),
        v: json["__v"],
        idProofUrl: json["idProofUrl"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "riderName": riderName,
        "riderId": riderId,
        "riderIdProof": riderIdProof,
        "vehicleNumber": vehicleNumber,
        "vehicleType": vehicleType,
        "phoneNumber": phoneNumber,
        "paymentReceived": paymentReceived,
        "riderPassword": riderPassword,
        "createdAt": createdAt.toIso8601String(),
        "__v": v,
        "idProofUrl": idProofUrl,
      };
}
