import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/slider_image_model.dart';

class SliderImageController extends GetxController{
  final db = FirebaseFirestore.instance;
  
  var sliderImage = <SliderImageModel>[].obs;

  void getSliderImage(){
    db
        .collection("sliderImages")
        .snapshots()
        .listen((snapshot) => sliderImage.value = snapshot.docs
        .map((e) => SliderImageModel.fromJson(e.data()),).toList()
    );
  }

  @override
  void onInit() {
    super.onInit();
    getSliderImage();
  }


}