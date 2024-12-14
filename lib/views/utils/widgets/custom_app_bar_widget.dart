import 'package:flutter/material.dart';
import 'package:get/get.dart';

PreferredSizeWidget customAppBar(){
  return AppBar(
  automaticallyImplyLeading: false,
  leading: IconButton(onPressed: (){Get.back();}, icon: const Icon(Icons.arrow_back_ios_new,size: 20,)),
  backgroundColor: Colors.white,
  );
}
