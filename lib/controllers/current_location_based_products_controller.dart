import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/product_model.dart';

class CurrentBasedLocationProductsController extends GetxController{

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  var locationBasedProductsList = <ProductModel>[].obs;
  RxBool isLoading = false.obs;


  Future<void> currentLocationBasedProductsData({required String shopId})async{
    isLoading.value = true;
    try{
       _firebaseFirestore
           .collection("products")
           .where("shopId",isEqualTo: shopId)
           .snapshots().listen((event) => locationBasedProductsList.value = event.docs
           .map((doc) => ProductModel.fromJson(doc.data())).toList(),);
       print("locationBasedProductsList :=> ${locationBasedProductsList.length}");
    }catch(e){
      print(e);
    }finally{
      isLoading.value = false;
    }
  }

  // void updateProductFavoriteStatus({required String productId, required bool newStatus}){
  //   var product = locationBasedProductsList.firstWhere((product) => product.productId == productId);
  //   product.isFavourite = newStatus;
  //   update();
  // }

}