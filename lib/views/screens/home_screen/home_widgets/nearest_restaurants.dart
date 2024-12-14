import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/image_constants.dart';
import '../../../utils/constants/styles.dart';

class NearestRestaurants extends StatelessWidget {
  const NearestRestaurants({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> restaurantImageList = [
      nearestRestaurantImage1,
      nearestRestaurantImage8,
      nearestRestaurantImage3,
      nearestRestaurantImage7,
      nearestRestaurantImage5,
    ];
    List<String> restaurantTitle = [
      "Madhuban",
      "Dawat",
      "Swad Vatika",
      "Grace of India",
      "Bihari Kabab",
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: List.generate(restaurantImageList.length, (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: PhysicalModel(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              elevation: 1,
              child: SizedBox(
                width: Get.width / 2.5,
                height: Get.height / 5,
                child: Column(children: [
                  Image.asset(
                    restaurantImageList[index],
                    width: 100,
                  ),
                  const Spacer(),
                  Text(restaurantTitle[index],style: AppTextStyle().textSize16TextBold(),)
                ]),
              ),
            ),
          );
        },
      )),
    );
  }
}
