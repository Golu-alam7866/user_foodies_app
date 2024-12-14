import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/order_address_model.dart';
import '../views/utils/action_dialog/snackBar.dart';

class OrderAddressController extends GetxController{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> phoneNumberController = TextEditingController().obs;
  Rx<TextEditingController> pincodeController = TextEditingController().obs;
  Rx<TextEditingController> stateController = TextEditingController().obs;
  Rx<TextEditingController> cityController = TextEditingController().obs;
  Rx<TextEditingController> houseNumberBuildingNameController = TextEditingController().obs;
  Rx<TextEditingController> roadNameAreaColonyController = TextEditingController().obs;
  RxInt orderAddressStatus = (-1).obs;
  List<String> statesNameList = [
    "Andaman & Nicobar Islands","Andhra Pradesh","Arunachal Pradesh","Assam","Bihar","Chandigarh","Chhattisgarh",
    "Dadra & Nagar Haveli & Daman & Diu","Delhi","Goa","Gujarat","Haryana","Himachal Pradesh","Jammu & Kashmir","Jharkhand",
    "Karnataka","Kerala","Ladakh","Lakshadweep","Madhya Pradesh","Maharashtra","Manipur","Meghalaya","Mizoram","Nagaland","Odisha",
    "Puducherry","Punjab","Rajasthan","Sikkim","Tamil Nadu","Telangana","Tripura","Uttar Pradesh","Uttarakhand","West Bengal"
  ];
  RxString selectedState = "".obs;
  RxString updateState = "".obs;
  RxList<OrderAddressModel> userSelectedOrderAddress = <OrderAddressModel>[].obs;
  RxList<OrderAddressModel> userOrderAddressList = <OrderAddressModel>[].obs;

  // for checkbox
  RxBool isCheckedOrderAddressStatus = false.obs;


  Future<void> addOrderAddress() async {
    try {
      isLoading.value = true;

      if(fullNameController.value.text.isEmpty ||
          phoneNumberController.value.text.isEmpty ||
          pincodeController.value.text.isEmpty ||
          selectedState.value.isEmpty ||
          cityController.value.text.isEmpty ||
          houseNumberBuildingNameController.value.text.isEmpty ||
          roadNameAreaColonyController.value.text.isEmpty){
        snackBar(title: "Error", message: "All fields are required");
        isLoading.value = false;
        return;
      }

      // Get the existing addresses from the database
      var doc = await _db.collection("users").doc(currentUser).collection("orderAddress").get();

      if (doc.docs.length >= 5) {
        snackBar(title: "Address Limit Reached", message: "You already have 5 order addresses. Delete one to add a new address.");
        return;
      }

      // Determine if this is the first address
      bool isFirstAddress = doc.docs.isEmpty;  // If the list is empty, this is the first address.

      // Create the new address with addressStatus based on the first address
      OrderAddressModel orderAddressModel = OrderAddressModel(
        userId: currentUser,
        city: cityController.value.text,
        houseNumberBuildingName: houseNumberBuildingNameController.value.text,
        pincode: pincodeController.value.text,
        state: selectedState.value,
        roadNameAreaColony: roadNameAreaColonyController.value.text,
        fullName: fullNameController.value.text,
        phoneNumber: phoneNumberController.value.text,
        addressStatus: isFirstAddress,  // First address is selected (true), others are false by default
        createdAt: DateTime.now().toString(),
      );

      // Add the new address to Firestore
      await _db.collection("users").doc(currentUser).collection("orderAddress").add(orderAddressModel.toJson()).then((value) async {
        var id = value.id;
        await _db.collection("users").doc(currentUser).collection("orderAddress").doc(id).update({"id": id}).then((value) {
          snackBar(title: "Order Address", message: "Successfully created");
          // Get.to(const ViewAllAddressesScreen());
        });

        // Clear input fields after adding address
        cityController.value.clear();
        houseNumberBuildingNameController.value.clear();
        pincodeController.value.clear();
        selectedState.value = "";
        roadNameAreaColonyController.value.clear();
        fullNameController.value.clear();
        phoneNumberController.value.clear();
      });

    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> getUserSelectedOrderAddress()async{
    try{
      isLoading.value = true;
      _db
          .collection("users")
          .doc(currentUser)
          .collection("orderAddress")
          .where("addressStatus",isEqualTo: true)
          .snapshots()
          .listen((snapshot) => userSelectedOrderAddress.value = snapshot.docs
          .map((doc) => OrderAddressModel.fromJson(doc.data()),).toList(),);

    }catch(e){
      print("Error :$e");
    }finally{
      isLoading.value = false;
    }
  }

  Future<void> getUserAllOrderAddressList()async{
    try{
      isLoading.value = true;
      _db
          .collection("users")
          .doc(currentUser)
          .collection("orderAddress").orderBy("createdAt",descending: true)
          .snapshots()
          .listen((snapshot) => userOrderAddressList.value = snapshot.docs
          .map((doc) => OrderAddressModel.fromJson(doc.data()),).toList(),);

    }catch(e){
      print("Error :$e");
    }finally{
      isLoading.value = false;
    }
  }

  Future<void> updateOrderAddress({required String id, required OrderAddressModel updateOrderAddressModel})async{
    try{
      isLoading.value = true;
      await _db.collection("users").doc(currentUser).collection("orderAddress").doc(id).update(updateOrderAddressModel.toJson()).then((value) {
        snackBar(title: "Order Address", message: "Successfully Updated");
        Navigator.pop(Get.context!);
      },);
    }catch(e){
      print("Error :$e");
    }finally{
      isLoading.value = false;
    }
  }

  Future<void> deleteOrderAddress({required String id})async{
    try{
      isLoading.value = true;
      await _db.collection("users").doc(currentUser).collection("orderAddress").doc(id).delete().then((value) {
        snackBar(title: "Order Address", message: "Successfully Deleted");
      },);
    }catch(e){
      print("Error :$e");
    }
    finally{
      isLoading.value = false;
    }
  }

  Future<void> updateOrderAddressStatus({
    required String orderAddressId,
    required int index,
    required bool status,
  }) async {
    try {
      isLoading.value = true;

      // Update the selected address to true
      await _db.collection("users").doc(currentUser).collection("orderAddress").doc(orderAddressId).update({"addressStatus": status}).then((value) {
        snackBar(title: "Order Address ${status ? "Selected" : "Unselected"}", message: "Updated Successfully");
      });

      // Reset the status of all other addresses to false
      for (int i = 0; i < userOrderAddressList.length; i++) {
        if (i != index) {
          var otherAddress = userOrderAddressList[i];
          await _db.collection("users").doc(currentUser).collection("orderAddress").doc(otherAddress.id.toString()).update({"addressStatus": false});
        }
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getUserSelectedOrderAddress();
    getUserAllOrderAddressList();
  }
}