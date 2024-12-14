import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

class ProfileController extends GetxController{
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  var userData = UserModel().obs;

  void getCurrentUserDetails(){
    _db.collection("users").doc(_auth.currentUser!.uid).snapshots().listen((snapshot) {
      if(snapshot.exists && snapshot.data() != null){
        userData.value = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      }
    },);
  }

  @override
  void onInit() {
    super.onInit();
    getCurrentUserDetails();
  }

}