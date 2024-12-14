import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

OrderModel orderModelFromJson(String str) => OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  String? orderId;
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

  bool? orderProcessing;
  bool? orderPending;
  bool? orderConfirmed;
  bool? orderShipped;
  bool? orderCancelled;
  bool? orderOutForDelivery;
  bool? orderDelivered;

  //This is OrderAddress Model
  // OrderAddressModel? orderAddressModel;




  OrderModel({
    this.orderId,
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

    this.orderProcessing,
    this.orderPending,
    this.orderConfirmed,
    this.orderShipped,
    this.orderCancelled,
    this.orderOutForDelivery,
    this.orderDelivered,

    //This is OrderAddress Model
    // this.orderAddressModel
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
    orderId: json["orderId"],
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

    orderProcessing: json["orderProcessing"],
    orderPending: json["orderPending"],
    orderConfirmed: json["orderConfirmed"],
    orderShipped: json["orderShipped"],
    orderCancelled: json["orderCancelled"],
    orderOutForDelivery: json["orderOutForDelivery"],
    orderDelivered: json["OrderDelivered"],

//This is OrderAddress Model
//     orderAddressModel: json["orderAddressModel"]

  );

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
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

    "orderProcessing": orderProcessing,
    "orderPending": orderPending,
    "orderConfirmed": orderConfirmed,
    "orderShipped": orderShipped,
    "orderCancelled": orderCancelled,
    "orderOutForDelivery": orderOutForDelivery,
    "OrderDelivered": orderDelivered,

    //This is OrderAddress Model
    // "orderAddressModel": orderAddressModel
  };
}
