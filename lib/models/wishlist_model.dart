import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

WishListModel wishListModelFromJson(String str) => WishListModel.fromJson(json.decode(str));

String wishListModelToJson(WishListModel data) => json.encode(data.toJson());

class WishListModel {
  String? productId;
  String? productName;
  String? productTitle;
  String? productDescription;
  String? productImage;
  String? initialPrice;
  String? productPrice;
  String? categoryId;
  String? categoryName;
  String? sellerId;
  String? sellerName;
  String? createdAt;
  String? updatedAt;
  bool? isFavourite;
  String? shopId;
  GeoPoint? shopLocation;
  String? shopName;
  String? productQuantity;
  String? productUnitTag;
  int? rating;
  String? ratingCreatedAt;

  WishListModel({
    this.productId,
    this.productName,
    this.productTitle,
    this.productDescription,
    this.productImage,
    this.initialPrice,
    this.productPrice,
    this.categoryId,
    this.categoryName,
    this.sellerId,
    this.sellerName,
    this.createdAt,
    this.updatedAt,
    this.isFavourite,
    this.shopId,
    this.shopLocation,
    this.shopName,
    this.productQuantity,
    this.productUnitTag,
    this.rating,
    this.ratingCreatedAt,
  });

  factory WishListModel.fromJson(Map<String, dynamic> json) => WishListModel(
    productId: json["productId"],
    productName: json["productName"],
    productTitle: json["productTitle"],
    productDescription: json["productDescription"],
    productImage: json["productImage"],
    initialPrice: json["initialPrice"],
    productPrice: json["productPrice"],
    categoryId: json["categoryId"],
    categoryName: json["categoryName"],
    sellerId: json["sellerId"],
    sellerName: json["sellerName"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
    isFavourite: json["isFavourite"],
    shopId: json["shopId"],
    shopLocation: json["shopLocation"],
    shopName: json["shopName"],
    productQuantity: json["productQuantity"],
    productUnitTag: json["productUnitTag"],
    rating: json["rating"],
    ratingCreatedAt: json["ratingCreatedAt"],

  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "productName": productName,
    "productTitle": productTitle,
    "productDescription": productDescription,
    "productImage": productImage,
    "initialPrice": initialPrice,
    "productPrice": productPrice,
    "categoryId": categoryId,
    "categoryName": categoryName,
    "sellerId": sellerId,
    "sellerName": sellerName,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
    "isFavourite": isFavourite,
    "shopId": shopId,
    "shopLocation": shopLocation,
    "shopName": shopName,
    "productQuantity": productQuantity,
    "productUnitTag": productUnitTag,
    "rating": rating,
    "ratingCreatedAt": ratingCreatedAt,

  };
}
