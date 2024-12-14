import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../views/screens/user_details/user_location_screen.dart';
import '../views/utils/action_dialog/snackBar.dart';

class UserImageController extends GetxController{
  RxString imagePath = "".obs;
  RxBool isLoading = false.obs;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  var currentUserId = FirebaseAuth.instance.currentUser?.uid;


  bool _isPickerActive = false; // Flag to check if the picker is active

  Future<void> getImage({required ImageSource source}) async {
    if (_isPickerActive) return; // Prevent concurrent calls
    _isPickerActive = true;
    isLoading.value = true;

    final ImagePicker imagePicker = ImagePicker();
    try {
      var image = await imagePicker.pickImage(source: source);
      if (image != null) {
        imagePath.value = image.path;
      }
    } finally {
      isLoading.value = false;
      _isPickerActive = false; // Reset the flag
    }
  }

  Future<String> uploadImageOnFirebaseStorage({required String imageCollectionName})async{
    isLoading.value = true;
    try{
      var imageName = DateTime.now().microsecondsSinceEpoch.toString();
      var storageRef = _storage.ref().child("$imageCollectionName/$imageName.jpg");
      var uploadTask = storageRef.putFile(File(imagePath.value));
      var downloadUrl = await (await uploadTask).ref.getDownloadURL();
      print("Image Url => $downloadUrl");
      return downloadUrl;
    }catch(e){
      snackBar(title: "Error", message: e.toString());
      return "";
    }finally{
      isLoading.value = false;
    }
  }
  
  Future<void> uploadImageOnFirebaseFirestore()async{
    isLoading.value = true;
    try{
      var userProfileImageUrl = await uploadImageOnFirebaseStorage(imageCollectionName: "userProfileImage");
      if(userProfileImageUrl.isNotEmpty){
        var data = {
          "userProfileImage" : userProfileImageUrl
        };

        await _db.collection("users").doc(currentUserId).update(data).then((value) async{
          snackBar(title: "Profile Added Successfully", message: "");
        },).then((value) async{Get.to(()=>const UserLocationScreen());},);
      }

    }catch(e){
      snackBar(title: "Error", message: e.toString());
    }finally{
      isLoading.value = false;
    }
  }


}