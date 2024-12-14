import 'dart:convert';

OrderAddressModel orderAddressModelFromJson(String str) => OrderAddressModel.fromJson(json.decode(str));

String orderAddressModelToJson(OrderAddressModel data) => json.encode(data.toJson());

class OrderAddressModel {
  String? id;
  String? userId;
  String? fullName;
  String? phoneNumber;
  String? pincode;
  String? state;
  String? city;
  String? houseNumberBuildingName;
  String? roadNameAreaColony;
  bool? addressStatus;
  String? createdAt;

  OrderAddressModel({
    this.id,
    this.userId,
    this.fullName,
    this.phoneNumber,
    this.pincode,
    this.state,
    this.city,
    this.houseNumberBuildingName,
    this.roadNameAreaColony,
    this.addressStatus,
    this.createdAt,
  });

  factory OrderAddressModel.fromJson(Map<String, dynamic> json) => OrderAddressModel(
    id: json["id"],
    userId: json["userId"],
    fullName: json["fullName"],
    phoneNumber: json["phoneNumber"],
    pincode: json["pincode"],
    state: json["state"],
    city: json["city"],
    houseNumberBuildingName: json["houseNumberBuildingName"],
    roadNameAreaColony: json["roadNameAreaColony"],
    addressStatus: json["addressStatus"],
    createdAt: json["createdAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "fullName": fullName,
    "phoneNumber": phoneNumber,
    "pincode": pincode,
    "state": state,
    "city": city,
    "houseNumberBuildingName": houseNumberBuildingName,
    "roadNameAreaColony": roadNameAreaColony,
    "addressStatus": addressStatus,
    "createdAt": createdAt,
  };
}
