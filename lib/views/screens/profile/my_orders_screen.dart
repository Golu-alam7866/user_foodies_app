import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../../../controllers/order_placing_controller.dart';
import 'order_tracking_screen.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    OrderPlacingController orderPlacingController = Get.put(OrderPlacingController());
    return Scaffold(
      appBar: AppBar(title:const Text("My Orders"),centerTitle: true,),
      body: Obx(() {
        if(orderPlacingController.isLoading.value){
          return const Center(child: CupertinoActivityIndicator(),);
        }
        if(orderPlacingController.currentUserOrderList.isEmpty){
          return const Center(child: Text("Order Not Available"),);
        }
        return ListView.builder(
          itemCount: orderPlacingController.currentUserOrderList.length,
            itemBuilder: (context, index) {
            var data = orderPlacingController.currentUserOrderList[index];
            return GestureDetector(
              onTap: () {
                Get.to(OrderTrackingScreen(data:data));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: Get.width,
                  child: PhysicalModel(
                    color: Colors.white,
                    elevation: 2,
                    borderRadius: BorderRadius.circular(5),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: data.productImage ??
                                      "Image",
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                  const Center(
                                      child:
                                      CupertinoActivityIndicator()),
                                  errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(data.productName ??
                                      "Product Name"),
                                  Text(data.productId ??
                                      "Product Id"),
                                  Text(
                                      data.productDescription ??
                                          "Product Description"),
                                  Row(
                                    children: [
                                      SmoothStarRating(
                                        size: 20,
                                        starCount: 5,
                                        onRatingChanged: (value) {},
                                      ),
                                      const SizedBox(width: 10),
                                      const Text("5"),
                                      const SizedBox(width: 10),
                                      const Text("(9,999)"),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
            },
        );
      },),
    );
  }
}
