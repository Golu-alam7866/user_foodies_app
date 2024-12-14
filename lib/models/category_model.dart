import 'dart:convert';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  String? id;
  String? categoryName;
  String? categoryImage;
  String? sellerId;
  String? sellerName;
  String? createdAt;
  String? updatedAt;

  CategoryModel({
    this.id,
    this.categoryName,
    this.categoryImage,
    this.sellerId,
    this.sellerName,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json["id"],
    categoryName: json["categoryName"],
    categoryImage: json["categoryImage"],
    sellerId: json["sellerId"],
    sellerName: json["sellerName"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "categoryName": categoryName,
    "categoryImage": categoryImage,
    "sellerId": sellerId,
    "sellerName": sellerName,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}
