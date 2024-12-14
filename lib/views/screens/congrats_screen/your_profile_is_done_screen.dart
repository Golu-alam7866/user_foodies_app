import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../utils/constants/animation_constants.dart';
import '../../utils/constants/styles.dart';
import '../../utils/constants/text_constants.dart';
import '../../utils/widgets/static_button.dart';
import '../bottom_nav_bar_screen.dart';

class YourProfileIsDoneScreen extends StatelessWidget {
  const YourProfileIsDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 250, height: 250, child: Lottie.asset(done, fit: BoxFit.cover),),
                      Text(congrats,style: AppTextStyle().userTextBold(),),
                      Text(yourProfileIsReady,style: AppTextStyle().addressTextBold(),),
                    ],
                  )
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: StaticButton(onTap: (){
                    Get.offAll(()=>const BottomNavBarScreen());
                  }, data: next)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
