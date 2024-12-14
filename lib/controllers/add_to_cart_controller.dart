import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/add_to_cart_model.dart';
import '../views/utils/action_dialog/snackBar.dart';

class AddToCartController extends GetxController{

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;
  var allCartProducts = <AddToCartModel>[].obs;
  RxDouble totalPrice = 0.0.obs;
  var ratingInCart = 0.0.obs;


  Future<void> checkProductExistence({
    required String productId,
    int quantityIncrement = 1,
    required String productPrice,
    required AddToCartModel addToCartModel})async{
    isLoading.value = true;
    try{
      final DocumentReference documentReference = _db.collection("cart").doc(_auth.currentUser!.uid).collection("userCart").doc(productId);
      DocumentSnapshot snapshot = await documentReference.get();

      if(snapshot.exists){
        int currentQuantity = snapshot['productQuantity'];
        int updatedQuantity = currentQuantity + quantityIncrement;
        double totalPrice = double.parse(productPrice) * updatedQuantity;

        await documentReference.update(
            {
              "productQuantity" : updatedQuantity,
              "productTotalPrice" : totalPrice
            }
        );
        print("Product exist");
      }else{
        await documentReference.set(addToCartModel.toJson());
        print("product added successfully");

      }
    }catch(e){
      print(e.toString());
    }finally{
      isLoading.value = false;
    }

  }

  Future<void> getAllCartProducts()async{
    isLoading.value = true;
    try{
      _db.collection("cart").doc(_auth.currentUser!.uid).collection("userCart").snapshots().listen((event) {
        allCartProducts.value = event.docs.map((e) => AddToCartModel.fromJson(e.data()),).toList();
      },);
      print("cart length => ${allCartProducts.length}");
    }catch(e){
      print(e.toString());
    }finally{
      isLoading.value = false;
    }
  }

  // double calculateTotalPrice() {
  //   // double totalPrice = 0.0;
  //   for (var product in allCartProducts) {
  //     if (product.productPrice != null && product.productQuantity != null) {
  //       var price = double.parse(product.productPrice! * product.productQuantity!);
  //       totalPrice.value = price;
  //     }
  //   }
  //   return totalPrice.value;
  // }
  //
  // // Calculate the sale price with a discount
  // double calculateSalePrice({double discountRate = 0.10}) {
  //   double totalPrice = calculateTotalPrice();
  //   double discount = totalPrice * discountRate;
  //   return totalPrice - discount;
  // }

  // Increment quantity of a specific product
  void incrementQuantity({required int productQuantity,required String productId,required String productPrice}) async{
    if (productQuantity < 10) {
        await _db.collection("cart").doc(_auth.currentUser!.uid).collection("userCart").doc(productId).update(
            {
              "productQuantity" : productQuantity +1,
              "productTotalPrice" : (double.parse(productPrice.toString()) * (productQuantity +1))
            }
        );
    }else{
      snackBar(title: "Max Quantity Is Full", message: "");
    }
  }

  // Decrement quantity of a specific product (minimum quantity is 1)
  void decrementQuantity({required int productQuantity,required String productId,required String productPrice}) async{
    if (productQuantity > 1) {
        await _db.collection("cart").doc(_auth.currentUser!.uid).collection("userCart").doc(productId).update(
          {
            "productQuantity" : productQuantity -1,
            "productTotalPrice" : (double.parse(productPrice.toString()) * (productQuantity -1))
          }
        );
    }
  }

  Future<void> fetchProductPrice() async {
    var snapshot = await _db.collection("cart").doc(_auth.currentUser!.uid).collection("userCart").get();
    double sum = 0.0;
    for (var doc in snapshot.docs) {
      final data = doc.data();
      if(data.containsKey("productTotalPrice")) {
        sum += (data["productTotalPrice"] as num).toDouble();
      }
    }
    totalPrice.value = sum;
  }

  Future<void> deleteAddToCartProduct({required String productId})async{
    await _db.collection("cart").doc(_auth.currentUser!.uid).collection("userCart").doc(productId).delete().then((value) {
      snackBar(title: "Delete", message: "Item delete successfully");
      Navigator.pop(Get.context!);
    },);

  }

  @override
  void onInit() {
    getAllCartProducts();
    fetchProductPrice();
    super.onInit();
  }


}