import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StaticButton extends StatelessWidget {
  const StaticButton({super.key,
    required this.onTap,
    required this.data,
  });

  final void Function()? onTap;
  final String data;



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          width: Get.width * 0.7,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.blue,
              border: Border.all(color: Colors.grey)
          ),
          child: Center(
            child: Text(data, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),),
        ),


        // Container(
        //   height: Get.height / 14,
        //   width: Get.width,
        //   alignment: alignment,
        //   decoration: BoxDecoration(
        //     color: Colors.blue,
        //     borderRadius: BorderRadius.circular(5),
        //   ),
        //   child: Center(child: Text(data, style: AppTextStyle().defaultButtonTextStyle(),)),
        // ),
      );
  }
}
