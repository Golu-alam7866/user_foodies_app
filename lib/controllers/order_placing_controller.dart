import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/order_address_model.dart';
import '../models/order_model.dart';
import '../views/utils/action_dialog/snackBar.dart';

class OrderPlacingController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  RxBool isLoading = false.obs;
  RxList<OrderModel> currentUserOrderList = <OrderModel>[].obs;

  Future<void> addToCartOrderPlace() async {
    try {
      isLoading.value = true;

      QuerySnapshot querySnapshot = await _db.collection("cart").doc(currentUser).collection("userCart").get();
      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      QuerySnapshot orderAddressSnapshot = await _db.collection("users").doc(currentUser).collection("orderAddress").where("addressStatus", isEqualTo: true).get();
      List<QueryDocumentSnapshot> orderAddressDocuments = orderAddressSnapshot.docs;

      if (documents.isEmpty) {
        snackBar(title: "Cart is empty", message: "Please add items to the cart.");
        return;
      }
      if (orderAddressDocuments.isEmpty) {
        snackBar(title: "No address found", message: "Please add an address to proceed.");
        return;
      }

      Map<String, dynamic> addressData = orderAddressDocuments.first.data() as Map<String, dynamic>;
      OrderAddressModel orderAddressModel = OrderAddressModel.fromJson(addressData);

      for (var doc in documents) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;

        OrderModel orderModel = OrderModel(
          productId: data["productId"]?.toString() ?? "",
          productName: data["productName"]?.toString() ?? "",
          productTitle: data["productTitle"]?.toString() ?? "",
          productImage: data["productImage"]?.toString() ?? "",
          productPrice: double.parse(data["productPrice"].toString()).toString(),
          productQuantity: data["productQuantity"]?.toString() ?? "",
          productDescription: data["productDescription"]?.toString() ?? "",
          productUnitTag: data["productUnitTag"]?.toString() ?? "",
          sellerId: data["sellerId"]?.toString() ?? "",
          sellerName: data["sellerName"]?.toString() ?? "",
          shopLocation: data["shopLocation"] as GeoPoint?,
          shopId: data["shopId"]?.toString() ?? "",
          shopName: data["shopName"]?.toString() ?? "",
          rating: data["rating"] ?? 0,
          ratingCreatedAt: data["ratingCreatedAt"]?.toString() ?? "",
          categoryId: data["categoryId"]?.toString() ?? "",
          categoryName: data["categoryName"]?.toString() ?? "",
          isFavourite: data["isFavourite"] ?? false,
          initialPrice: data["initialPrice"]?.toString() ?? "",
          updatedAt: data["updatedAt"]?.toString(),
          createdAt: DateTime.now().toString(),
          orderCancelled: false,
          orderConfirmed: false,
          orderDelivered: false,
          orderOutForDelivery: false,
          orderPending: false,
          orderProcessing: false,
          orderShipped: false,
        );

        DocumentReference orderRef = await _db.collection("orders").doc(currentUser).collection("confirmOrders").add(orderModel.toJson());
        var orderId = orderRef.id;

        await orderRef.update({"orderId": orderId});

        await _db.collection("orders").doc(currentUser).collection("confirmOrders").doc(orderId).update({
          "orderAddressModel": orderAddressModel.toJson(), // Ensure the model is converted to JSON
        });

        await _db.collection("cart").doc(currentUser).collection("userCart").doc(orderModel.productId).delete();

      }
      snackBar(title: "Order Confirmed", message: "Thank you for your order!");

    } catch (e) {
      print("Error: $e");
      snackBar(title: "Order Placement Failed", message: "An error occurred while placing the order.");
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> getCurrentUserOrderList()async{
    try{
      isLoading.value = true;
       _db
          .collection("orders")
          .doc(currentUser)
          .collection("confirmOrders")
          .orderBy("createdAt",descending: true)
          .snapshots().listen((snapshot) => currentUserOrderList.value = snapshot.docs
          .map((doc) => OrderModel.fromJson(doc.data()),).toList(),);
    }catch(e){
      print("Error $e");
    }finally{
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getCurrentUserOrderList();
  }
}
