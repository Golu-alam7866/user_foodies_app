import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchItemsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var searchKey = "".obs;
  Rx<TextEditingController> searchItemController = TextEditingController().obs;

  Stream<List<Map<String, dynamic>>> searchInStream() {
    final String lowerCaseSearchKey = searchKey.value.toLowerCase();
    return _firestore
        .collection("products")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data())
          .where((product) {
        String productName = product['productName'].toString().toLowerCase();
        return productName.contains(lowerCaseSearchKey);
      })
          .toList();
    });
  }


}
