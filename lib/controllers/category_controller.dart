import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';

class CategoryController extends GetxController{
  final db = FirebaseFirestore.instance;
  var categoryList = <CategoryModel>[].obs;
  var productsByCategoryList = <ProductModel>[].obs;
  var isFavourite = true.obs;

  @override
  void onInit() {
    super.onInit();
    getAllCategory();
  }

  void getAllCategory(){
      db
        .collection("category")
        .snapshots().listen((snapshot) => categoryList.value = snapshot.docs
        .map((doc) => CategoryModel.fromJson(doc.data()),).toList());
  }

  void getProductByCategory({required String categoryId}){
      db
        .collection("products")
        .where("categoryId",isEqualTo: categoryId)
        .snapshots()
        .listen((snapshot) {
          productsByCategoryList.value = snapshot.docs
              .map((doc) {
                return ProductModel.fromJson(doc.data());
              },).toList();
        },);
  }
}