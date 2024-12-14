import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../../../../controllers/rating_controller.dart';

class PopularMenuViewMoreScreen extends StatelessWidget {
  const PopularMenuViewMoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RatingController ratingController = Get.put(RatingController());
    return Scaffold(
      appBar: AppBar(title: const Text("Popular Menu"),centerTitle: true,),
      body: Obx(() {
        if(ratingController.isLoading.value){
          return const Center(child: CupertinoActivityIndicator(),);
        }
        if(ratingController.allPopularMenuProductList.isEmpty){
          return const Center(child: Text("Data Not Available"),);
        }
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            childAspectRatio: 3/4
          ),
          itemCount: ratingController.allPopularMenuProductList.length,
          itemBuilder: (context, index) {
            var data = ratingController.allPopularMenuProductList[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: Get.width,
                height: Get.height * 0.2,
                child: PhysicalModel(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  elevation: 5,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                            imageUrl: data.productImage ?? "",width: 150,height: 120,fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(child: CupertinoActivityIndicator(),),
                          errorWidget: (context, url, error) => const Center(child: Icon(Icons.error),),
                        ),
                      ),
                      const SizedBox(width: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(data.productName ?? "Product Name"),
                          Text(data.productId ?? "Product Id"),
                          Row(
                            children: [
                              SmoothStarRating(
                                size: 20,
                                starCount: 5,
                                onRatingChanged: (value) {},
                              ),
                              const SizedBox(width: 10,),
                              Text("(${data.totalRating})"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
        },);
      },),
    );
  }
}
