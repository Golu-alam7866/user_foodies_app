import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodies/controllers/profile_controller.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import '../models/order_address_model.dart';
import '../models/order_model.dart';
import '../views/utils/action_dialog/snackBar.dart';
import 'order_address_controller.dart';

class OrderBuyController extends GetxController{
  ProfileController profileController = Get.put(ProfileController());
  OrderAddressController orderAddressController = Get.put(OrderAddressController());
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Razorpay _razorpay = Razorpay();
  RxBool isLoading = false.obs;
  final razorPayKey = "rzp_test_371C9xe6Cod48A";
  final razorPaySecret = "kfYJMLYZwQ4TKNh79laVdhYe";
  var currentUserId = FirebaseAuth.instance.currentUser!.uid;


  //1. Razorpay Gateway integration


  Future<void> buyProductInsertInDatabase({required OrderModel orderModel})async{
    OrderAddressModel orderAddressModel = OrderAddressModel(
      userId: orderAddressController.userSelectedOrderAddress.first.userId,
      id: orderAddressController.userSelectedOrderAddress.first.id,
      fullName: orderAddressController.userSelectedOrderAddress.first.fullName,
      phoneNumber: orderAddressController.userSelectedOrderAddress.first.phoneNumber,
      addressStatus: orderAddressController.userSelectedOrderAddress.first.addressStatus,
      state: orderAddressController.userSelectedOrderAddress.first.state,
      city: orderAddressController.userSelectedOrderAddress.first.city,
      pincode: orderAddressController.userSelectedOrderAddress.first.pincode,
      houseNumberBuildingName: orderAddressController.userSelectedOrderAddress.first.houseNumberBuildingName,
      roadNameAreaColony: orderAddressController.userSelectedOrderAddress.first.roadNameAreaColony,
      createdAt: DateTime.now().toString()

    );
    var orderDoc = await _db.collection("orders").doc(currentUserId).collection("confirmOrders").add(orderModel.toJson());
    var orderId = orderDoc.id;
    await _db.collection("orders").doc(currentUserId).collection("confirmOrders").doc(orderId).update(
        {
          "orderId" : orderId,
          "orderAddress": orderAddressModel.toJson()
        }
    );
    snackBar(title: "Successfully Buy", message: "Successfully Order Booked");
  }

  void initializeRazorpay(){
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response)async {
    snackBar(title: "Payment successful", message: response.paymentId.toString());
    buyProductInsertInDatabase;
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    snackBar(title: "Payment fail", message: response.message.toString());

  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    snackBar(title: "External Wallet", message: response.walletName.toString());

  }

  Future<void> buyOpenCheckout({required String price})async{
    var amount = double.parse(price).toInt();
    var options = {
      "key" : razorPayKey,
      "amount" : amount * 100,
      "name" : profileController.userData.value.userName,
      "prefill" : {
        "contact" : profileController.userData.value.userId,
        "email" : profileController.userData.value.email,
        "paymentMethod" : "Razorpay"
      },
      "external" : {
        "wallets" : ['paytm']
      }
    };

    isLoading.value = true;
    try{
      _razorpay.open(options);
    }catch(e){
      snackBar(title: "Error", message: e.toString());
    }finally{
      isLoading.value = false;
    }

  }



  razorPayApi({required int amount,required String receiptId})async{
    var auth = 'Basic${base64Encode(utf8.encode('$razorPayKey:$razorPaySecret'))}';
    var header = {
      'content-type' : 'application/json',
      'Authorization' : auth
    };

    var request = http.Request('POST', Uri.parse("https://api.razorpay.com/v1/orders"));
    request.body = json.encode({
      "amount" : amount*100,
      "currency" : "INR",
      "receiptId" : receiptId
    });

    request.headers.addAll(header);

    http.StreamedResponse response = await request.send();
    print("StatusCode => ${response.statusCode}");
    if(response.statusCode == 200){
      return {
        "status" : "success",
        "body" : jsonDecode(await response.stream.bytesToString())
      };
    }else{
      return {
        "status" : "fail",
        "message" : (response.reasonPhrase)
      };
    }

  }


}