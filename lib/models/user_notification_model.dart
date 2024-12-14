import 'dart:convert';

UserNotificationModel userNotificationModelFromJson(String str) => UserNotificationModel.fromJson(json.decode(str));

String userNotificationModelToJson(UserNotificationModel data) => json.encode(data.toJson());

class UserNotificationModel {
  String? notificationId;
  String? notificationTitle;
  String? notificationBody;
  String? notificationDate;
  bool? isSeen;
  String? productImage;
  String? productPrice;
  String? productId;
  String? userId;

  UserNotificationModel({
    this.notificationId,
    this.notificationTitle,
    this.notificationBody,
    this.notificationDate,
    this.isSeen,
    this.productImage,
    this.productPrice,
    this.productId,
    this.userId,
  });

  factory UserNotificationModel.fromJson(Map<String, dynamic> json) => UserNotificationModel(
    notificationId: json["notificationId"],
    notificationTitle: json["notificationTitle"],
    notificationBody: json["notificationBody"],
    notificationDate: json["notificationDate"],
    isSeen: json["isSeen"],
    productImage: json["productImage"],
    productPrice: json["productPrice"],
    productId: json["productId"],
    userId: json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "notificationId": notificationId,
    "notificationTitle": notificationTitle,
    "notificationBody": notificationBody,
    "notificationDate": notificationDate,
    "isSeen": isSeen,
    "productImage": productImage,
    "productPrice": productPrice,
    "productId": productId,
    "userId": userId,
  };
}
