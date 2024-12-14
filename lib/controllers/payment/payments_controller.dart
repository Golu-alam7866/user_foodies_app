import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

import '../../views/utils/action_dialog/snackBar.dart';
import '../order_placing_controller.dart';
import '../profile_controller.dart';

class PaymentsController extends GetxController {
  ProfileController profileController = Get.put(ProfileController());
  OrderPlacingController orderPlacingController = Get.put(OrderPlacingController());
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var currentUserId = FirebaseAuth.instance.currentUser!.uid;
  RxBool isLoading = false.obs;
  RxList<String> paymentsMethods = <String>["Cash on delivery"].obs;
  final Razorpay _razorpay = Razorpay();
  Rx<TextEditingController> amountController = TextEditingController().obs;
  Map<String, dynamic>? paymentIntentData;
  var getCurrentUserPaymentMethod = [].obs;

  bool isProductDirectBy = false;



  Future<void> addPaymentMethod({required String paymentMethod}) async {
    isLoading.value = true;
    try {
      bool isAdded;
      if (paymentsMethods.contains(paymentMethod)) {
        paymentsMethods.remove(paymentMethod); // Remove if already exists
        isAdded = false;
      } else {
        paymentsMethods.add(paymentMethod); // Add if it doesn't exist
        isAdded = true;
      }

      var data = {
        "paymentMethod": paymentsMethods,
      };

      await _db.collection("users").doc(currentUserId).update(data).then((value) {
        String message = isAdded
            ? "$paymentMethod added to payment methods."
            : "$paymentMethod removed from payment methods.";
        snackBar(title: "Payment Method Updated Successfully", message: message);
      });
    } catch (e) {
      snackBar(title: "Error", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getPaymentMethod() async {
    await _db.collection("users").doc(currentUserId).snapshots().listen((snapshot) async {
      if (snapshot.exists) {
        var paymentMethods = snapshot["paymentMethod"];
        if (paymentMethods is List && paymentMethods.every((element) => element is String)) {
          getCurrentUserPaymentMethod.value = List<String>.from(paymentMethods);
        } else {
          getCurrentUserPaymentMethod.clear();
        }
        print("Payment Methods => $getCurrentUserPaymentMethod");
      }
    });
  }


//1. Razorpay Gateway integration

  void initializeRazorpay(){
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response)async {
    snackBar(title: "Payment successful", message: response.paymentId.toString());
    await orderPlacingController.addToCartOrderPlace();
    print("Buy Product By AddToCart");
    snackBar(title: "Buy Product By AddToCart", message: "");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    snackBar(title: "Payment fail", message: response.message.toString());

  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    snackBar(title: "External Wallet", message: response.walletName.toString());

  }

  Future<void> openCheckout({required String price})async{
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

  final razorPayKey = "rzp_test_371C9xe6Cod48A";
  final razorPaySecret = "kfYJMLYZwQ4TKNh79laVdhYe";

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



//2. Stripe Payment Gateway Integration

  var publisherKey = "pk_test_51QFCJxK6eaGWPjZTAkGW5o5ieqnkFAGosqmbFzMfyNy0Ni196T2XtrJt9iabbcpElIQ9B8mSHUWucM0HEfzjRi7a00272fNOYy";
  var secretKey = "sk_test_51QFCJxK6eaGWPjZTIGVYZKjMvzhcJowqNPfEe4SDuhqObrqmSNBvOwJkKr2NyjlQfwvzPhugdxDRBscngIhDTSpn006RhFrj4k";


  Future<void> makePayment(BuildContext context,{required String price}) async {
    var amount = double.parse(price).toInt();

    try {
      // Create a payment intent on the backend
      paymentIntentData = await createPaymentIntent(amount: amount.toString(), currency: 'INR');
      if (paymentIntentData == null) return; // Exit if payment intent creation failed

      // Initialize the payment sheet with the created payment intent data
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData!["client_secret"],
          style: ThemeMode.dark,
          merchantDisplayName: profileController.userData.value.userName,
          billingDetails: BillingDetails(
            email: profileController.userData.value.email,
            name: profileController.userData.value.userName,
          ),
        ),
      );

      // Display the payment sheet
      await displayPaymentSheet(context: context);
    } catch (e) {
      snackBar(title: "Error", message: e.toString());
      print("Error =>$e");
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent({
    required String amount,
    required String currency,
  }) async {
    try {
      Map<String, dynamic> body = {
        "amount": calculateAmount(amount: amount),
        "currency": currency,
        "payment_method_types[]": "card"
      };

      var response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        body: body,
        headers: {
          "Authorization": "Bearer $secretKey",
          "Content-Type": "application/x-www-form-urlencoded"
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      snackBar(title: "Error", message: e.toString());
      print("Error =>$e");
      return null; // Return null if there's an error
    }
  }

  String calculateAmount({required String amount}) {
    final price = int.parse(amount) * 100; // Convert to cents
    return price.toString();
  }

  Future<void> displayPaymentSheet({required BuildContext context}) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      paymentIntentData = null; // Reset payment intent data after successful payment
      snackBar(title: "Success", message: "Payment completed successfully");

    } on StripeException catch (e) {
      snackBar(title: "Error", message: e.toString());
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text('Payment cancelled'),
        ),
      );
      print("Error =>$e");
    } catch (e) {
      snackBar(title: "Error", message: e.toString());
      print("Error =>$e");
    }
  }


//3. Paypal Payment Gateway Integration

  String clientId = "Aa25PD1wWabk4KSbjzLo4Kc_Ry19Q8pIDc1TWRZreqRbVnSXs5oxTjqA9lhBI2VOowVr_bY4Kac7MPAw";
  String secret = "EBY3fzz2kawV8j9ZltpiL1vz9Ir6r8ID2_XmZXHJhdCE9QySESjahdr2sENyeN7CgC77F1_6ggufkmXo";
  // String clientId2 = "AZAywtW2tTZHWRmohxBOnIP_hF6eIp40nkAzlmMsv6sa-ilSe4kDPR5wJFXZYrh7zDwdd_wxt18UGLMJ";
  // String secret2 = "ELSkJ70aAvnEMDc0yx_VWK807FgZp0q6gwL3I2rfKvLytzKcTlkpNg0rPsnNTijctzqRjtVIAvVcHIhn";

  String email = "sb-g1yrr33706367@business.example.com";
  String password = "bOx@jg_4";

  String httpUrl = "https://api.sandbox.paypal.com";

  Future<void> getAccessToken()async{
    try{

    }catch(e){
      snackBar(title: "Error", message: e.toString());
    }finally{

    }
  }

  @override
  void onInit() {
    super.onInit();
    initializeRazorpay();
    getPaymentMethod();
  }

 @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

}
