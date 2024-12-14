import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomWidgets{
  customBottomSheet({Widget? child}){
    return Get.bottomSheet(
      Container(
        color: Colors.white,
        child: child,
      ),
      isDismissible: false,
    );
  }
}

