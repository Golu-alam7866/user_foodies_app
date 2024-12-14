import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SendUserNotificationController extends GetxController{

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addUserNotificationInDatabase()async{
    await _db.collection("userNotification").doc(_auth.currentUser!.uid).collection("notification").add(
      {

      }
    ).then((value) async{
      var id = value.id;
      await _db.collection("userNotification").doc(_auth.currentUser!.uid).collection("notification").doc(id).update(
        {

        }
      );
    },);
  }

}