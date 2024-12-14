import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({super.key,
    required this.onTap,
    required this.data,
    required this.controller
  });

  final void Function()? onTap;
  final String data;
  final dynamic controller;



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          width: Get.width * 0.7,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.blue
          ),
          child: Center(child: controller
              ? const CupertinoActivityIndicator(color: Colors.white,)
              : Text(data, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),),
        ),


        // Container(
        //   height: Get.height / 14,
        //   width: Get.width,
        //   alignment: alignment,
        //   decoration: BoxDecoration(
        //     color: Colors.blue,
        //     borderRadius: BorderRadius.circular(10),
        //   ),
        //   child: Center(child: controller
        //       ? const CupertinoActivityIndicator(color: Colors.white,)
        //       : Text(data, style: AppTextStyle().defaultButtonTextStyle(),)),
        // ),
      );
  }
}
