import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/location_controller.dart';
import '../location_based_get_products_screen/location_based_get_product_screen.dart';

class NearestByShop extends StatelessWidget {
  final LocationController locationController = Get.put(LocationController());

  NearestByShop({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      height: 200,
      child: FutureBuilder<List<DocumentSnapshot>>(
        future: locationController.fetchAndDisplayNearbyShops(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No nearby shops found"));
          }

          var shops = snapshot.data!;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: shops.length,
            itemBuilder: (context, index) {
              var shop = shops[index];
              var shopId = shop['shopId'] ?? '';  // Add null check
              var shopImage = shop['shopImage'] ?? ''; // Add null check
              var shopName = shop['shopName'] ?? "Unknown Shop";
              var shopAddress = shop['shopAddress'] ?? "Unknown Address";

              return GestureDetector(
                onTap: () {
                  if (shopId.isNotEmpty) {
                    Get.to(() => LocationBasedGetProductScreen(shopId: shopId));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: PhysicalModel(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    shadowColor: Colors.grey.shade300,
                    elevation: 1,
                    child: SizedBox(
                      width: Get.width / 2.5,
                      height: Get.height / 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: CachedNetworkImage(
                              imageUrl: shopImage,
                              width: Get.width,
                              height: 120,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CupertinoActivityIndicator(color: Colors.white),
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  shopName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  shopAddress,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
