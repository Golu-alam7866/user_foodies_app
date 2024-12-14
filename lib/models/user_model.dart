import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? userId;
  String? lastName;
  String? firstName;
  String? email;
  String? password;
  String? userName;
  String? contact;
  String? address;
  String? userProfileImage;
  GeoPoint? location;

  UserModel({
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.userName,
    this.contact,
    this.address,
    this.userProfileImage,
    this.location,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    userId: json["userId"],
    firstName: json["firstName"],
    email: json["email"],
    lastName: json["lastName"],
    password: json["password"],
    userName: json["userName"],
    contact: json["contact"],
    address: json["address"],
    userProfileImage: json["userProfileImage"],
    location: json["location"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "password": password,
    "userName": userName,
    "contact": contact,
    "address": address,
    "userProfileImage": userProfileImage,
    "location": location,
  };
}
