import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

PopularProductsModel popularProductsModelFromJson(String str) => PopularProductsModel.fromJson(json.decode(str));

String popularProductsModelToJson(PopularProductsModel data) => json.encode(data.toJson());

class PopularProductsModel {
  String? ratingCreatedAt;
  int? rating;
  String? productTitle;
  String? shopId;
  String? shopName;
  String? productId;
  String? categoryId;
  String? categoryName;
  String? productName;
  String? productPrice;
  String? productImage;
  String? userId;
  int? totalRating;
  bool? isFavorite;
  GeoPoint? shopLocation;


  PopularProductsModel({
    this.ratingCreatedAt,
    this.rating,
    this.productTitle,
    this.shopId,
    this.shopName,
    this.productId,
    this.categoryId,
    this.categoryName,
    this.productName,
    this.productPrice,
    this.productImage,
    this.userId,
    this.totalRating,
    this.isFavorite,
    this.shopLocation
  });

  factory PopularProductsModel.fromJson(Map<String, dynamic> json) => PopularProductsModel(
    ratingCreatedAt: json["ratingCreatedAt"],
    rating: json["rating"],
    productTitle: json["productTitle"],
    shopId: json["shopId"],
    shopName: json["shopName"],
    productId: json["productId"],
    categoryId: json["categoryId"],
    categoryName: json["categoryName"],
    productName: json["productName"],
    productPrice: json["productPrice"],
    productImage: json["productImage"],
    userId: json["userId"],
    totalRating: json["totalRating"],
    isFavorite: json["isFavorite"],
    shopLocation: json["shopLocation"],

  );

  Map<String, dynamic> toJson() => {
    'ratingCreatedAt': ratingCreatedAt,
    'rating': rating,
    'productTitle': productTitle,
    'shopId': shopId,
    'shopName': shopName,
    'productId': productId,
    'categoryId': categoryId,
    'categoryName': categoryName,
    'productName': productName,
    'productPrice': productPrice,
    'productImage': productImage,
    'userId': userId,
    'TotalRating': totalRating,
    'isFavorite': isFavorite,
    'shopLocation': shopLocation,
  };
}
