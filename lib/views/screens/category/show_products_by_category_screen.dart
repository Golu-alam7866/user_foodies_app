import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/category_controller.dart';
import '../../../controllers/location_controller.dart';
import '../../../controllers/wishlist_controller.dart';
import '../../../models/category_model.dart';
import '../../../models/wishlist_model.dart';
import 'category_product_detail_screen.dart';

class ShowProductsByCategoryScreen extends StatelessWidget {
  final CategoryModel categoryData;

  const ShowProductsByCategoryScreen({
    super.key,
    required this.categoryData,
  });

  @override
  Widget build(BuildContext context) {
    final CategoryController categoryController = Get.put(CategoryController());
    final WishListController wishListController = Get.put(WishListController());
    LocationController locationController = Get.put(LocationController());


    return Scaffold(
      appBar: AppBar(title: Text("${categoryData.categoryName}")),
      body: Obx(() {
        if (categoryController.productsByCategoryList.isEmpty) {
          return const Center(child: Text("No products available"));
        }
        return GridView.builder(
          itemCount: categoryController.productsByCategoryList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            childAspectRatio: 3 / 4,
          ),
          itemBuilder: (context, index) {
            final data = categoryController.productsByCategoryList[index];
            var isFavourite = data.isFavourite ?? false;
            return GestureDetector(
              onTap: () {
                Get.to(CategoryProductDetailScreen(data: data));
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: data.productImage ?? '',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            placeholder: (context,
                                url) => const CupertinoActivityIndicator(),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(data.productName ?? "Product Name"),
                      Text(data.shopName ?? "Shop Name"),
                      Obx(() {
                        final distance = locationController.productDistances[data.productId ?? ''];
                        return Text(distance != null ? "${distance.toStringAsFixed(1)} km" : "Calculating...");
                      }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("₹ ${data.productPrice}"),
                          GestureDetector(
                            onTap: () {
                              final wishListModel = WishListModel(
                                productId: data.productId,
                                productName: data.productName,
                                productDescription: data.productDescription,
                                productImage: data.productImage,
                                productPrice: data.productPrice,
                                productTitle: data.productTitle,
                                categoryId: data.categoryId,
                                categoryName: data.categoryName,
                                sellerId: data.sellerId,
                                sellerName: data.sellerName,
                                shopId: data.shopId,
                                shopLocation: data.shopLocation,
                                shopName: data.shopName,
                                isFavourite: data.isFavourite,
                                rating: data.rating,
                                ratingCreatedAt: data.ratingCreatedAt,
                                createdAt: data.createdAt,
                                productQuantity: data.productQuantity,
                              );
                              wishListController.toggleFavouriteProduct(
                                productId: data.productId ?? '',
                                currentStatus: isFavourite,
                                wishListModel: wishListModel,
                              );
                            },
                            child: Icon(
                              Icons.favorite,
                              color: isFavourite ? Colors.red : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

