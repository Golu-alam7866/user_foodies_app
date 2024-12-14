import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../views/screens/auth_screen/email/sign_in_screen.dart';
import '../../views/screens/bottom_nav_bar_screen.dart';
import '../../views/screens/congrats_screen/your_profile_is_done_screen.dart';
import '../../views/screens/user_details/payment_method_screen.dart';
import '../../views/utils/action_dialog/snackBar.dart';

class UserAuthController extends GetxController{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  var currentUserId = FirebaseAuth.instance.currentUser?.uid;
  RxBool isLoading = false.obs;
  String? deviceToken = "";

  // for creating user

  Rx<TextEditingController> userFirstNameController = TextEditingController().obs;
  Rx<TextEditingController> userLastNameController = TextEditingController().obs;
  Rx<TextEditingController> userContactController = TextEditingController().obs;
  Rx<TextEditingController> userEmailController = TextEditingController().obs;
  Rx<TextEditingController> userPasswordController = TextEditingController().obs;

  // for user signIn
  Rx<TextEditingController> userSignEmailController = TextEditingController().obs;
  Rx<TextEditingController> userSignPasswordController = TextEditingController().obs;

  // for change password
  Rx<TextEditingController> oldEmailController = TextEditingController().obs;
  Rx<TextEditingController> oldPasswordController = TextEditingController().obs;
  Rx<TextEditingController> newPasswordController = TextEditingController().obs;

  // for forgot password
  Rx<TextEditingController> usingEmailForForgotPasswordController = TextEditingController().obs;

  // for delivering order address
  Rx<TextEditingController> villageNameController = TextEditingController().obs;
  Rx<TextEditingController> pinCodeNumberController = TextEditingController().obs;
  Rx<TextEditingController> districtNameController = TextEditingController().obs;
  Rx<TextEditingController> stateNameController = TextEditingController().obs;


  Future<void> getDeviceToken()async{
    var token = await _messaging.getToken();
    deviceToken = token;
  }

  Future<void> createUserWithEmailAndPassword() async {
    isLoading.value = true;

    if(deviceToken == null){
      Get.snackbar("Error", "Your Device Token Not Found");
      isLoading.value = false;
      return;
    }

    if (userFirstNameController.value.text.isEmpty ||
        userLastNameController.value.text.isEmpty ||
        userContactController.value.text.isEmpty||
        userEmailController.value.text.isEmpty ||
        userPasswordController.value.text.isEmpty) {
      Get.snackbar("Error", "All fields are required!");
      isLoading.value = false;
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(
          email: userEmailController.value.text,
          password: userPasswordController.value.text
      ).then((value) {
        var data = {
          "firstName" : userFirstNameController.value.text.trim(),
          "lastName" : userLastNameController.value.text.trim(),
          "contact" : userContactController.value.text.trim(),
          "email" : userEmailController.value.text.trim(),
          "password" : userPasswordController.value.text.trim(),
          "userId" : value.user!.uid
        };
        _db.collection("users").doc(_auth.currentUser!.uid).set(data).then((value) {
          Get.snackbar("User Created Successfully", "User UID : ${_auth.currentUser!.uid}");
          Get.offAll(() => const PaymentMethodScreen());
          // Get.to(() => const PaymentMethodScreen());
        });
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        Get.snackbar("The password provided is too weak", e.code);
      } else if (e.code == "email-already-in-use") {
        Get.snackbar("The account already exists for that email.", e.code);
      } else if (e.code == "invalid-email") {
        Get.snackbar("Email invalid please enter a valid email.", e.code);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    isLoading.value = false;
  }

  Future<void> signInUserWithEmailAndPassword()async{
    isLoading.value = true;
    try {
      if(userSignEmailController.value.text.isEmpty || userSignPasswordController.value.text.isEmpty){
        snackBar(title: "Error", message: "All fields are required");
        isLoading.value = false;
        return;
      }
      await _auth.signInWithEmailAndPassword(email: userSignEmailController.value.text, password: userSignPasswordController.value.text).then((value) async{
        Get.snackbar("User Signin Successfully", "User UID : ${_auth.currentUser!.uid}");
        Get.offAll(const BottomNavBarScreen());
      },);
    } on FirebaseAuthException catch(e){
      if (e.code == 'user-not-found') {
        Get.snackbar("No user found for that email.", e.code);
      } else if (e.code == 'wrong-password') {
        Get.snackbar("Wrong password provided for that user.", e.code);
      }else if(e.code == "invalid-email"){
        Get.snackbar("Email invalid please enter a valid email.", e.code);
      }
    } catch(e){
      Get.snackbar("Error : $e",e.toString());
      print("Error : $e");
    }
    isLoading.value = false;
  }

  Future<void> changePassword()async{
    try{
      User? user = _auth.currentUser;
      AuthCredential credential = EmailAuthProvider.credential(email: oldEmailController.value.text, password: oldPasswordController.value.text);
      await user?.reauthenticateWithCredential(credential).then((value) async{
        await user.updatePassword(newPasswordController.value.text).then((value) {
          Get.snackbar("Password change successfully", newPasswordController.value.text);
        },);
      },);
    }catch (e){
      print(e);
      Get.snackbar("Error", e.toString());

    }

  }

  Future<void> forgotPassword()async{
    try{
      await _auth.sendPasswordResetEmail(email: usingEmailForForgotPasswordController.value.text.trim());
      Get.snackbar("Please check your email:",_auth.currentUser!.email.toString());
    }on FirebaseAuthException catch(e){
      Get.snackbar("Error:", e.message.toString());
    }
    catch(e){
      Get.snackbar("Error:", e.toString());
    }
  }

  Future<void> logOut()async{
    await _auth.signOut().then((value) {
      Get.snackbar("Logout Successfully", "");
      Get.offAll(()=>const SignInScreen());
    },);
  }



  //Google Auth
  Future<void> signInWithGoogle()async{
    final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication?.accessToken,
      idToken: googleSignInAuthentication?.idToken
    );
     await _auth.signInWithCredential(credential).then((value) async{
      // Get.offAll(()=>const BottomNavBarScreen());
    },);
  }

  Future<void> googleLogOut()async{
      _auth.signOut().then((value) async{
        await GoogleSignIn().signOut().then((value) {
          Get.snackbar("Logout Successfully", "");
          Get.offAll(()=>const SignInScreen());
        },);
      },);
  }

  // User Address
  Future<void> userAddress()async{
    isLoading.value = true;
    try{
      var data = {
        "villageName" : villageNameController.value.text.trim(),
        "pinCode" : pinCodeNumberController.value.text.trim(),
        "districtName" : districtNameController.value.text.trim(),
        "stateName" : stateNameController.value.text.trim(),
      };

      await _db.collection("users").doc(currentUserId).update(data).then((value) async{
        snackBar(title: "Address Added Successfully", message: "");
      },).then((value) async{Get.offAll(()=>const YourProfileIsDoneScreen());},);
    }catch(e){
      snackBar(title: "Error", message: e.toString());
    }finally{
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    getDeviceToken();
    super.onInit();
  }


}