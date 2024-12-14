import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodies/controllers/rating_controller.dart';
import 'package:get/get.dart';

import '../models/wishlist_model.dart';
import '../views/utils/action_dialog/snackBar.dart';
import 'category_controller.dart';
import 'current_location_based_products_controller.dart';

class WishListController extends GetxController {
  final CategoryController categoryController = Get.put(CategoryController());
  CurrentBasedLocationProductsController currentBasedLocationProductsController = Get.put(CurrentBasedLocationProductsController());
  RatingController ratingController = Get.put(RatingController());
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isFavorite = false.obs;
  RxBool isLoading = false.obs;
  RxList<WishListModel> wishListProduct = <WishListModel>[].obs;

  Future<void> addInWishList({required String productId, required WishListModel wishListModel,}) async {
    isLoading.value = true;
    try {
      final userWishlistCollection = _db.collection("wishlist").doc(_auth.currentUser!.uid).collection("userWishlist").doc(productId);
      final snapshot = await userWishlistCollection.get();
      if (snapshot.exists) {
        await userWishlistCollection.delete();
        snackBar(title: "Removed from wishlist", message: "Successfully removed!");
        await _db.collection("wishlist").doc(_auth.currentUser!.uid).collection("userWishlist").doc(productId).update({'isFavourite': false,});
      } else {
        await userWishlistCollection.set(wishListModel.toJson());
        snackBar(title: "Added to wishlist", message: "Successfully added!");
        await _db.collection("wishlist").doc(_auth.currentUser!.uid).collection("userWishlist").doc(productId).update({'isFavourite': true,});
      }
    } catch (e) {
      snackBar(title: "Error", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  void toggleFavouriteProduct({
    required String productId,
    required bool currentStatus,
    required WishListModel wishListModel,
  }) {
    if (currentStatus) {
      wishListProduct.removeWhere((product) => product.productId == productId);
      removeFromWishList(productId);
      isFavorite.value = false;
    } else {
      wishListProduct.add(wishListModel);
      addInWishList(productId: productId, wishListModel: wishListModel);
      isFavorite.value = true;
    }
    updateFavouriteStateInAllList();
  }
  Future<void> removeFromWishList(String productId) async {
    try {
      await _db.collection("wishlist").doc(_auth.currentUser!.uid).collection("userWishlist").doc(productId).delete();
      snackBar(title: "Success", message: "Removed from wishlist");
    } catch (e) {
      snackBar(title: "Error", message: "Failed to remove from wishlist: $e");
    }
  }
  void getCurrentUserWishListItems() {
    _db
        .collection("wishlist")
        .doc(_auth.currentUser!.uid)
        .collection("userWishlist")
        .snapshots()
        .listen((snapshot) {
      wishListProduct.value = snapshot.docs.map((doc) => WishListModel.fromJson(doc.data())).toList();

      updateFavouriteStateInAllList();

      currentBasedLocationProductsController.locationBasedProductsList.refresh();
      ratingController.allPopularMenuProductList.refresh();
      categoryController.productsByCategoryList.refresh();
      //   // Update the favorite status in productsByCategoryList
      //   for (var product in categoryController.productsByCategoryList) {
      //     product.isFavourite = wishListProduct.any((item) => item.productId == product.productId);
      //   }
      //   for(var locationProduct in currentBasedLocationProductsController.locationBasedProductsList){
      //     locationProduct.isFavourite = wishListProduct.any((element) => element.productId == locationProduct.productId,);
      //   }
      //   for(var ratingProduct in ratingController.allPopularMenuProductList){
      //     ratingProduct.isFavorite = wishListProduct.any((ratProducts) => ratProducts.productId == ratingProduct.productId,);
      //   }
      //   currentBasedLocationProductsController.locationBasedProductsList.refresh();
      //   ratingController.allPopularMenuProductList.refresh();
      //   categoryController.productsByCategoryList.refresh(); // Refresh to update the UI
      // });
    });
  }

  void updateFavouriteStateInAllList(){
    for (var product in categoryController.productsByCategoryList) {
      product.isFavourite = wishListProduct.any((item) => item.productId == product.productId);
    }

    for (var locationProduct in currentBasedLocationProductsController.locationBasedProductsList) {
      locationProduct.isFavourite = wishListProduct.any((item) => item.productId == locationProduct.productId);
    }

    for (var ratingProduct in ratingController.allPopularMenuProductList) {
      ratingProduct.isFavorite = wishListProduct.any((item) => item.productId == ratingProduct.productId);
    }

    // Trigger the UI to refresh
    currentBasedLocationProductsController.locationBasedProductsList.refresh();
    ratingController.allPopularMenuProductList.refresh();
    categoryController.productsByCategoryList.refresh();
  }

  @override
  void onInit() {
    getCurrentUserWishListItems();
    super.onInit();
  }
}

