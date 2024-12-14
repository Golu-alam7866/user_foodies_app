import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/wishlist_controller.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WishListController wishListController = Get.put(WishListController());
    return Scaffold(
      appBar: AppBar(title: const Text("Your Wishlist Items"),),
      body: Obx(() {
        if(wishListController.isLoading.value){
          return const Center(child: CupertinoActivityIndicator(),);
        }
        if(wishListController.wishListProduct.isEmpty){
          return const Center(child: Text("Please Add Product In Your WishList"),);
        }
        return GridView.builder(
          itemCount: wishListController.wishListProduct.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            childAspectRatio: 3/4
          ),
            itemBuilder: (context, index) {
            var data = wishListController.wishListProduct[index];
            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                              imageUrl: data.productImage ?? "Product Image",height: 120,width: 200,fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(child: CupertinoActivityIndicator(),),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                    ),
                      Positioned(
                        right: 0,
                          child: Padding(
                            padding:const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                wishListController.toggleFavouriteProduct(
                                    productId: data.productId ?? "",
                                    currentStatus: true,
                                    wishListModel: data
                                );
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)
                                ),
                                  child:const Icon(Icons.favorite_outlined,color: Colors.red,)),
                            ),
                          ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Name :"),
                        Expanded(child: Text(data.productName ?? "Product Name",overflow: TextOverflow.ellipsis,)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Price :"),
                        Text("₹ ${data.productPrice}"),
                      ],
                    ),
                  ),
                ],
              )
            );
            },
        );
      },),
    );
  }
}
