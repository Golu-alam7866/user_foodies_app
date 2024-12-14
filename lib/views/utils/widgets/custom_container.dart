import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
   const CustomContainer({super.key,this.color,this.height,this.width,this.child});

    final double? height;
    final double? width;
    final Widget? child;
    final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: color,
        border: Border.all(color: Colors.blue,width: 1)
      ),
      child: child,
      
    );
  }
}
