import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/popular_products_model.dart';
import '../models/product_model.dart';

class RatingController extends GetxController {
  RxInt starCount = 0.obs;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  var todayHighestProductRating = <ProductModel>[].obs;
  var productList = <ProductModel>[].obs;
  RxBool isLoading = false.obs;
  var currentUserId = FirebaseAuth.instance.currentUser?.uid;
  var allPopularMenuProductList = <PopularProductsModel>[].obs;
  var topFivePopularMenu = <PopularProductsModel>[].obs;


  Future<void> addInPopular({required PopularProductsModel popularProductsModel, required String productId, required String userId,}) async {
    var productRef = _firebaseFirestore.collection("popularProducts").doc(productId);
    var userRatingRef = productRef.collection("ratings").doc(userId);

    // Check if the product document exists
    var productSnapshot = await productRef.get();

    if (!productSnapshot.exists) {
      // Create the product document if it doesn't exist and initialize TotalRating as 1
      await productRef.set(popularProductsModel.toJson());
      await productRef.update({"totalRating": 1});
    } else {
      // Check if the user has already rated this product
      var userRatingSnapshot = await userRatingRef.get();
      if (!userRatingSnapshot.exists) {
        // First-time rating by this user, increment TotalRating
        await userRatingRef.set(popularProductsModel.toJson());

        int currentTotalRating = productSnapshot.data()?['totalRating'] ?? 0;
        await productRef.update({
          "rating": starCount.value,
          "totalRating": currentTotalRating + 1,
        });
      } else {
        // If the user has already rated, update their rating without changing TotalRating
        await userRatingRef.update(popularProductsModel.toJson());
        await productRef.update({
          "rating": starCount.value,
        });
      }
    }

    Get.snackbar("Success", "Rating added successfully!");
  }

  Future<void> getAllPopularMenu()async{
    _firebaseFirestore.collection("popularProducts").snapshots()
        .listen((event) => allPopularMenuProductList.value = event.docs
        .map((doc) => PopularProductsModel.fromJson(doc.data()),).toList(),);
    
  }


  Future<void> getTopFivePopularProducts() async {
    _firebaseFirestore.collection("popularProducts")
        .orderBy("totalRating", descending: true)
        .limit(5)
        .snapshots()
        .listen((snapshot) {
      print("Fetched documents count: ${snapshot.docs.length}");
      if (snapshot.docs.isNotEmpty) {
        topFivePopularMenu.value = snapshot.docs
            .map((doc) => PopularProductsModel.fromJson(doc.data()))
            .toList();
      } else {
        print("No documents found.");
      }
      isLoading.value = false;
    });

  }

  Future<void> getProductsBasedOnTodayHighestRating() async {
    DateTime now = DateTime.now();
    Timestamp startOfDay = Timestamp.fromDate(DateTime(now.year, now.month, now.day));
    Timestamp endOfDay = Timestamp.fromDate(DateTime(now.year, now.month, now.day, 23, 59, 59));

    isLoading.value = true;
    try {
      print("Fetching products with rating 5 between $startOfDay and $endOfDay");

      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection("products")
          .where("rating", isEqualTo: 5)
          .where("ratingCreatedAt", isGreaterThanOrEqualTo: startOfDay)
          .where("ratingCreatedAt", isLessThanOrEqualTo: endOfDay)
          .orderBy("ratingCreatedAt", descending: true)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        todayHighestProductRating.value = querySnapshot.docs
            .map((doc) => ProductModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

        print("Fetched ${todayHighestProductRating.length} products.");
      } else {
        print("No products found with today's highest rating.");
        todayHighestProductRating.value = [];
      }
    } catch (e) {
      print("Error fetching products: $e");
    } finally {
      isLoading.value = false;
    }
  }






  @override
  void onInit() {
    getProductsBasedOnTodayHighestRating();
    getTopFivePopularProducts();
    getAllPopularMenu();
    super.onInit();
  }
}
