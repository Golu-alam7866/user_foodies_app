import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/constants/image_constants.dart';
import '../../utils/constants/text_constants.dart';
import '../../utils/widgets/static_button.dart';
import 'comfort_food_lives_screen.dart';

class ComfortFoodScreen extends StatelessWidget {
  const ComfortFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: PhysicalModel(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    introScreenImage1,
                    filterQuality: FilterQuality.high,
                    width: Get.width,
                    height: Get.height * 0.5,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: Get.height * 0.35,
              left: 0,
              right: 0,
              child: PhysicalModel(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                shape: BoxShape.rectangle,
                child: Container(
                  height: Get.height * 0.5,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        comfort1FoodTitle,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Get.height / 30),
                      const Text(comfort1FoodDesc, textAlign: TextAlign.center,),
                      SizedBox(height: Get.height / 15),
                      StaticButton(onTap: (){
                        Get.offAll(() => const ComfortFoodLivesScreen());
                      }, data: next)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
