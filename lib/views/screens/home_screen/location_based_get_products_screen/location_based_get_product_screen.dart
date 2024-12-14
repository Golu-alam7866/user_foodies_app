
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/current_location_based_products_controller.dart';
import '../../../../controllers/location_controller.dart';
import '../../../../controllers/wishlist_controller.dart';
import '../../../../models/wishlist_model.dart';
import 'location_based_products_details_screen.dart';

class LocationBasedGetProductScreen extends StatelessWidget {
  final String shopId;

  const LocationBasedGetProductScreen({super.key, required this.shopId});

  @override
  Widget build(BuildContext context) {
    final currentBasedLocationProductsController = Get.put(CurrentBasedLocationProductsController());
    LocationController locationController = Get.put(LocationController());
    final wishListController = Get.put(WishListController());

    currentBasedLocationProductsController.currentLocationBasedProductsData(shopId: shopId);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Current Location Based Products"),
      ),
      body: Obx(() {
        if (currentBasedLocationProductsController.locationBasedProductsList.isEmpty) {
          return const Center(child: Text("Products not available"));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.7,
          ),
          itemCount: currentBasedLocationProductsController.locationBasedProductsList.length,
          itemBuilder: (context, index) {
            var data = currentBasedLocationProductsController.locationBasedProductsList[index];
            var isFavorite = data.isFavourite ?? false;
            return Card(
              elevation: 4,
              shadowColor: Colors.grey.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => LocationBasedProductsDetailsScreen(products: data));
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: data.productImage ?? "No image found",
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CupertinoActivityIndicator(color: Colors.white),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.productName ?? "No product name",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Obx(() {
                          final distance = locationController.productDistances[data.productId ?? ''];
                          return Text(distance != null ? "${distance.toStringAsFixed(1)} km" : "Calculating...");
                        }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data.productPrice != null ? "₹ ${data.productPrice}" : "No product price",
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                WishListModel wishListModel = WishListModel(
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
                                  isFavourite: data.isFavourite, // Updated favorite status
                                  rating: data.rating,
                                  ratingCreatedAt: data.ratingCreatedAt,
                                  createdAt: data.createdAt,
                                  productQuantity: data.productQuantity,
                                );
                                wishListController.toggleFavouriteProduct(
                                  productId: data.productId ?? "",
                                  currentStatus: isFavorite,
                                  wishListModel: wishListModel,
                                );
                              },
                              child:  Icon(
                                Icons.favorite,
                                color: isFavorite ? Colors.red : Colors.grey,
                              )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
