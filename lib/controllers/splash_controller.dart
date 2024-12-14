import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/screens/auth_screen/email/sign_in_screen.dart';
import '../views/screens/bottom_nav_bar_screen.dart';
import '../views/screens/introduction_screen/comfort_food_screen.dart';

class SplashController extends GetxController{
  final _auth = FirebaseAuth.instance;

  Future<void> checkUserStatus()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool userComesFirstTime = preferences.getBool("isFirstTime") ?? true;
    Future.delayed(const Duration(seconds: 3),()async{
      if(userComesFirstTime){
        await preferences.setBool("isFirstTime", false);
        Get.offAll(()=>const ComfortFoodScreen());
      }else if(_auth.currentUser?.uid != null){
        Get.offAll(()=>const BottomNavBarScreen());
      }else{
        Get.offAll(()=>const SignInScreen());
      }
    });
  }

  @override
  void onInit() {
    checkUserStatus();
    super.onInit();
  }
}