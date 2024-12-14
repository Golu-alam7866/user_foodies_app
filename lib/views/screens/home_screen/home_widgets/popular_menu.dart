import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/rating_controller.dart';
import '../../../utils/constants/image_constants.dart';
import '../../../utils/constants/styles.dart';
import '../popular_manu_products/popular_menu_product_details_screen.dart';

class PopularMenu extends StatelessWidget {
  const PopularMenu({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> popularMenuImages = [
      popularMenu1,
      popularMenu2,
      popularMenu7,
      popularMenu4,
      // popularMenu5,
    ];
    List<String> popularMenuTitle = [
      "Chicken Kabab",
      "Beef Kabab",
      "Veg Fried Rice",
      "Pizza",
    ];

    List<String> popularMenuRestaurantName = [
      "Bihari Kabab",
      "Bihari Kabab",
      "Madhuban",
      "Dawat",
    ];
    List<String> popularMenuPrice = [
      "₹ 300",
      "₹ 250",
      "₹ 200",
      "₹ 150",
    ];

    return SingleChildScrollView(
      child: Column(
        children: List.generate(popularMenuImages.length, (index){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: PhysicalModel(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              elevation: 0.5,
              child: SizedBox(
                height: Get.height / 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          popularMenuImages[index],
                          width: 100,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: Get.width/20,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(popularMenuTitle[index],style: AppTextStyle().textSize16TextBold(),),
                          Text(popularMenuRestaurantName[index]),
                        ],
                      ),
                    ],
                  ),
                  Text(popularMenuPrice[index],style: AppTextStyle().textSize16TextBold(),)
                ],),
              ),
            ),
          );
        })
      ),
    );
  }
}


// class GetTodayHighestRatingProducts extends StatelessWidget {
//   const GetTodayHighestRatingProducts({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final RatingController ratingController = Get.put(RatingController());
//
//     return Flexible(
//       child: Obx(() {
//         if (ratingController.isLoading.value) {
//           return const Center(child: CupertinoActivityIndicator());
//         }
//
//         if (ratingController.topFivePopularMenu.isEmpty) {
//           return const Center(child: Text("No data available"));
//         }
//
//         return ListView.builder(
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: ratingController.topFivePopularMenu.length,
//           itemBuilder: (context, index) {
//             var data = ratingController.topFivePopularMenu[index];
//             return Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: PhysicalModel(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.white,
//                 elevation: 0.5,
//                 child: SizedBox(
//                   height: Get.height / 8,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: CachedNetworkImage(
//                               imageUrl: data.productImage ?? "ProductImage",
//                               width: 100,
//                               height: 80,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           SizedBox(width: Get.width / 20),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 data.productTitle ?? "ProductTitle",
//                                 style: AppTextStyle().textSize16TextBold(),
//                               ),
//                               Text(data.shopName ?? "shopName"),
//                             ],
//                           ),
//                         ],
//                       ),
//                       Text(
//                         data.productPrice ?? "₹ 000",
//                         style: AppTextStyle().textSize16TextBold(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }
class GetTodayHighestRatingProducts extends StatelessWidget {
  const GetTodayHighestRatingProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final RatingController ratingController = Get.put(RatingController());

    return Obx(() {
      if (ratingController.isLoading.value) {
        return const Center(child: CupertinoActivityIndicator());
      }

      if (ratingController.topFivePopularMenu.isEmpty) {
        return const Center(child: Text("No data available"));
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ratingController.topFivePopularMenu.length,
        itemBuilder: (context, index) {
          var popularMenu = ratingController.topFivePopularMenu[index];
          return GestureDetector(
            onTap: () {
              Get.to(PopularMenuProductDetailsScreen(popularMenu:popularMenu));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PhysicalModel(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                elevation: 0.5,
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: popularMenu.productImage ?? "ProductImage",
                              width: 100,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: Get.width / 20),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                popularMenu.productName ?? "ProductName",
                                style: AppTextStyle().textSize16TextBold(),
                              ),
                              Text(popularMenu.shopName ?? "shopName"),
                            ],
                          ),
                        ],
                      ),
                      Text("₹ ${popularMenu.productPrice}",
                        style: AppTextStyle().textSize16TextBold(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}


