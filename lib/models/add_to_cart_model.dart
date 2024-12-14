import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

AddToCartModel addToCartModelFromJson(String str) => AddToCartModel.fromJson(json.decode(str));

String addToCartModelToJson(AddToCartModel data) => json.encode(data.toJson());


class AddToCartModel {
  String? userId;
  String? cartId;
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
  int? productQuantity;
  String? productUnitTag;
  double? productTotalPrice;

  AddToCartModel({
    this.userId,
    this.cartId,
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
    this.productTotalPrice,
  });

  factory AddToCartModel.fromJson(Map<String, dynamic> json) =>
      AddToCartModel(
        userId: json["userId"],
        cartId: json["cartId"],
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
        productTotalPrice: (json["productTotalPrice"] is int) ? (json["productTotalPrice"] as int).toDouble() : (json["productTotalPrice"] as double),
      );

  Map<String, dynamic> toJson() =>
      {
        "userId": userId,
        "cartId": cartId,
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
        "productTotalPrice": productTotalPrice,
      };
}




