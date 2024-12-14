import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:five_pointed_star/five_pointed_star.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../controllers/add_to_cart_controller.dart';
import '../../../../controllers/location_controller.dart';
import '../../../../controllers/order_address_controller.dart';
import '../../../../controllers/order_buy_controller.dart';
import '../../../../controllers/payment/payments_controller.dart';
import '../../../../controllers/rating_controller.dart';
import '../../../../controllers/wishlist_controller.dart';
import '../../../../models/add_to_cart_model.dart';
import '../../../../models/order_model.dart';
import '../../../../models/popular_products_model.dart';
import '../../../../models/wishlist_model.dart';
import '../../../utils/action_dialog/snackBar.dart';
import '../../order_address/add_order_address_screen.dart';
import 'live_track_popular_product_screen.dart';

class PopularMenuProductDetailsScreen extends StatelessWidget {
  final PopularProductsModel popularMenu;
  const PopularMenuProductDetailsScreen({super.key, required this.popularMenu});

  @override
  Widget build(BuildContext context) {
    AddToCartController addToCartController = Get.put(AddToCartController());
    RatingController ratingController = Get.put(RatingController());
    PaymentsController paymentsController = Get.put(PaymentsController());
    OrderAddressController orderAddressController = Get.put(OrderAddressController());
    WishListController wishListController = Get.put(WishListController());
    OrderBuyController orderBuyController = Get.put(OrderBuyController());
    LocationController locationController = Get.put(LocationController());
    var isFavorite = popularMenu.isFavorite ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Popular Product Details"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: popularMenu.productImage ?? "",
                    placeholder: (context, url) =>
                    const Center(child: CupertinoActivityIndicator(
                      color: Colors.white,)),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(popularMenu.productName ?? "Product Name",
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),),
                      wishlistFunctionalityGestureDetector(wishListController,isFavorite)
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() {
                        final distance = locationController.productDistances[popularMenu.productId ?? ''];
                        return Text(distance != null ? "${distance.toStringAsFixed(1)} km" : "Calculating...");
                      }),
                      GestureDetector(
                        onTap: () {
                          // snackBar(title: "Open Google Map", message: "Track This Product");
                          Get.to(LiveTrackProductScreen(destinationLatLng : LatLng(popularMenu.shopLocation?.latitude ?? 0.0, popularMenu.shopLocation?.longitude ?? 0.0)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue),
                            color: Colors.grey[200]
                          ),
                          child: const Center(child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                            child: Text("Track Product",style: TextStyle(fontWeight: FontWeight.bold),),
                          ),),
                        ),
                      )
                    ],
                  )
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "₹ ${popularMenu.productPrice ?? '0.00'}",
                        style:
                        const TextStyle(fontSize: 20, color: Colors.green),
                      ),
                      ratingFunctionalityFivePointedStar(ratingController),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                addToCartFunctionalityObx(addToCartController),
                paymentGestureDetector(context, paymentsController, orderAddressController, locationController, orderBuyController)
              ],
            ),
          ),
        ],
      ),
    );
  }

  FivePointedStar ratingFunctionalityFivePointedStar(
      RatingController ratingController
      ) {return FivePointedStar(
                      onChange: (count) {
                        ratingController.starCount.value =
                            count; // Update star count
                        var data = PopularProductsModel(
                          ratingCreatedAt: DateTime.now().toString(),
                          rating: ratingController.starCount.value,
                          productTitle: popularMenu.productTitle,
                          shopId: popularMenu.shopId,
                          shopName: popularMenu.shopName,
                          productId: popularMenu.productId,
                          categoryId: popularMenu.categoryId,
                          categoryName: popularMenu.categoryName,
                          productName: popularMenu.productName,
                          productPrice: popularMenu.productPrice,
                          productImage: popularMenu.productImage,
                          userId: ratingController.currentUserId.toString(),
                          totalRating: 0,
                        );

                        ratingController.addInPopular(
                          popularProductsModel: data,
                          productId: popularMenu.productId.toString(),
                          userId: ratingController.currentUserId.toString(),
                        );
                      },
                    );}

  GestureDetector wishlistFunctionalityGestureDetector(
      WishListController wishListController,
      bool isFavorite

  ) {
    return GestureDetector(
                      onTap: () {
                        final wishListModel = WishListModel(
                          productId: popularMenu.productId,
                          productName: popularMenu.productName,
                          productImage: popularMenu.productImage,
                          productPrice: popularMenu.productPrice,
                          productTitle: popularMenu.productTitle,
                          categoryId: popularMenu.categoryId,
                          categoryName: popularMenu.categoryName,
                          shopId: popularMenu.shopId,
                          shopName: popularMenu.shopName,
                          isFavourite: isFavorite,
                          rating: popularMenu.rating,
                          ratingCreatedAt: popularMenu.ratingCreatedAt,
                          createdAt: DateTime.now().toString(),
                        );
                        wishListController.toggleFavouriteProduct(
                          productId: popularMenu.productId ?? '',
                          currentStatus: isFavorite,
                          wishListModel: wishListModel,
                        );
                      },
                      child: Icon(
                        Icons.favorite,
                        color: isFavorite ? Colors.red : Colors.grey,
                      )
                    );
  }

  Obx addToCartFunctionalityObx(
      AddToCartController addToCartController
      ) {
    return Obx(() {
                // Check if the product already exists in the cart
                bool productExists = addToCartController.allCartProducts.any(
                        (cartProduct) =>
                    cartProduct.productId == popularMenu.productId);
                return productExists
                    ? GestureDetector(
                  onTap: () {
                    snackBar(
                      title: "Product already in cart",
                      message: "Please check your cart",
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        "Check your cart",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
                    : GestureDetector(
                  onTap: () async {
                    var data = AddToCartModel(
                      userId: FirebaseAuth.instance.currentUser!.uid,
                      productId: popularMenu.productId,
                      categoryId: popularMenu.categoryId,
                      categoryName: popularMenu.categoryName,
                      productName: popularMenu.productName,
                      productPrice: popularMenu.productPrice,
                      productImage: popularMenu.productImage,
                      productQuantity: 1,
                      createdAt: DateTime.now().toString(),
                      // productTotalPrice: int.parse(popularMenu.productPrice.toString()),
                      productTotalPrice: double.parse(popularMenu.productPrice.toString()),
                      shopName: popularMenu.shopName,
                      shopId: popularMenu.shopId,
                      productTitle: popularMenu.productTitle,
                    );

                    // Add the product to the cart if it doesn't already exist
                    await addToCartController.checkProductExistence(
                      productId: popularMenu.productId.toString(),
                      productPrice: popularMenu.productPrice.toString(),
                      addToCartModel: data,
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        "Add To Cart",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              });
  }

  GestureDetector paymentGestureDetector(
      BuildContext context,
      PaymentsController paymentsController,
      OrderAddressController orderAddressController,
      LocationController locationController,
      OrderBuyController orderBuyController
      ) {
    return GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SizedBox(
                        height: 300,
                        child: Center(
                          child: Obx(() {
                            var paymentMethods = paymentsController
                                .getCurrentUserPaymentMethod;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: paymentMethods.isNotEmpty
                                  ? paymentMethods.map((method) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    if (method == "Razorpay") {
                                      print("method => $method");
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            AlertDialog(
                                              title: const Center(
                                                  child: Text(
                                                    "Confirm Your Order",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  )),
                                              content: Column(
                                                mainAxisSize:
                                                MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    height:
                                                    Get.height * 0.2,
                                                    child: ListView.builder(
                                                      itemCount:
                                                      orderAddressController
                                                          .userSelectedOrderAddress
                                                          .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        var data =
                                                        orderAddressController
                                                            .userSelectedOrderAddress[
                                                        index];
                                                        return Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Text(
                                                                data
                                                                    .fullName ??
                                                                    ""),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                                "${data
                                                                    .houseNumberBuildingName} , ${data
                                                                    .roadNameAreaColony}, ${data
                                                                    .city}, ${data
                                                                    .state} - ${data
                                                                    .pincode}"),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                                data
                                                                    .phoneNumber ??
                                                                    "")
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          snackBar(
                                                              title:
                                                              "Confirm my address",
                                                              message: "");
                                                          Get.to(
                                                              const AddOrderAddressScreen());
                                                          // Navigator.pop(context);
                                                        },
                                                        child: Container(
                                                          width: 100,
                                                          height: 50,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .green,
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  10)),
                                                          child: Center(
                                                            child: Text(
                                                              orderAddressController
                                                                  .userOrderAddressList
                                                                  .isEmpty
                                                                  ? "Add Address"
                                                                  : "Update Address",
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          if (orderAddressController
                                                              .userOrderAddressList
                                                              .isEmpty) {
                                                            snackBar(
                                                                title:
                                                                "Please Add Your",
                                                                message:
                                                                "Delivery Address");
                                                            return;
                                                          } else {
                                                            if (orderAddressController
                                                                .userOrderAddressList
                                                                .isEmpty) {
                                                              snackBar(
                                                                  title:
                                                                  "Please Add Your",
                                                                  message:
                                                                  "Delivery Address");
                                                              return;
                                                            } else {
                                                              if (locationController
                                                                  .distance
                                                                  .value <=
                                                                  50) {
                                                                OrderModel
                                                                orderModelData =
                                                                OrderModel(
                                                                  productId:
                                                                  popularMenu
                                                                      .productId,
                                                                  productName:
                                                                  popularMenu
                                                                      .productName,
                                                                  productTitle:
                                                                  popularMenu
                                                                      .productTitle,
                                                                  productImage:
                                                                  popularMenu
                                                                      .productImage,
                                                                  productPrice: double
                                                                      .parse(
                                                                      popularMenu
                                                                          .productPrice
                                                                          .toString())
                                                                      .toString(),
                                                                  shopId: popularMenu
                                                                      .shopId,
                                                                  shopName:
                                                                  popularMenu
                                                                      .shopName,
                                                                  rating: popularMenu
                                                                      .rating,
                                                                  ratingCreatedAt:
                                                                  popularMenu
                                                                      .ratingCreatedAt,
                                                                  categoryId:
                                                                  popularMenu
                                                                      .categoryId,
                                                                  categoryName:
                                                                  popularMenu
                                                                      .categoryName,
                                                                  createdAt:
                                                                  DateTime
                                                                      .now()
                                                                      .toString(),
                                                                  orderCancelled:
                                                                  false,
                                                                  orderConfirmed:
                                                                  false,
                                                                  orderDelivered:
                                                                  false,
                                                                  orderOutForDelivery:
                                                                  false,
                                                                  orderPending:
                                                                  false,
                                                                  orderProcessing:
                                                                  false,
                                                                  orderShipped:
                                                                  false,
                                                                );
                                                                orderBuyController
                                                                    .buyProductInsertInDatabase(
                                                                    orderModel:
                                                                    orderModelData);
                                                                orderBuyController
                                                                    .buyOpenCheckout(
                                                                    price: popularMenu
                                                                        .productPrice
                                                                        .toString());
                                                                snackBar(
                                                                    title:
                                                                    "Confirm Order",
                                                                    message:
                                                                    "${popularMenu
                                                                        .productId}\n${popularMenu
                                                                        .productPrice}");
                                                                Navigator.pop(
                                                                    context);
                                                              } else {
                                                                snackBar(
                                                                    title:
                                                                    "Please Order Only",
                                                                    message:
                                                                    "Within a 50 km Radius");
                                                              }
                                                            }
                                                          }
                                                        },
                                                        child: Container(
                                                          width: 100,
                                                          height: 50,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .orange,
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  10)),
                                                          child:
                                                          const Center(
                                                              child:
                                                              Text(
                                                                "Confirm Order",
                                                                textAlign:
                                                                TextAlign
                                                                    .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              )),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                      );
                                      snackBar(
                                          title: "Method",
                                          message: method);
                                    } else if (method ==
                                        "Cash on delivery") {
                                      print("method => $method");
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            AlertDialog(
                                              title: const Center(
                                                  child: Text(
                                                    "Confirm Your Order",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  )),
                                              content: Column(
                                                mainAxisSize:
                                                MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    height:
                                                    Get.height * 0.2,
                                                    child: ListView.builder(
                                                      itemCount:
                                                      orderAddressController
                                                          .userSelectedOrderAddress
                                                          .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        var data =
                                                        orderAddressController
                                                            .userSelectedOrderAddress[
                                                        index];
                                                        return Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Text(
                                                                data
                                                                    .fullName ??
                                                                    ""),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                                "${data
                                                                    .houseNumberBuildingName} , ${data
                                                                    .roadNameAreaColony}, ${data
                                                                    .city}, ${data
                                                                    .state} - ${data
                                                                    .pincode}"),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                                data
                                                                    .phoneNumber ??
                                                                    "")
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          snackBar(
                                                              title:
                                                              "Confirm my address",
                                                              message: "");
                                                          Get.to(
                                                              const AddOrderAddressScreen());
                                                          // Navigator.pop(context);
                                                        },
                                                        child: Container(
                                                          width: 100,
                                                          height: 50,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .green,
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  10)),
                                                          child:
                                                          const Center(
                                                            child: Text(
                                                              "Update Address",
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          snackBar(
                                                              title:
                                                              "Confirm Order",
                                                              message: "");
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          width: 100,
                                                          height: 50,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .orange,
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  10)),
                                                          child:
                                                          const Center(
                                                              child:
                                                              Text(
                                                                "Confirm Order",
                                                                textAlign:
                                                                TextAlign
                                                                    .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              )),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                      );
                                      snackBar(
                                          title: "Method",
                                          message: method);
                                    } else {
                                      print("method => $method");
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            AlertDialog(
                                              title: const Center(
                                                  child: Text(
                                                    "Confirm Your Order",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  )),
                                              content: Column(
                                                mainAxisSize:
                                                MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    height:
                                                    Get.height * 0.2,
                                                    child: ListView.builder(
                                                      itemCount:
                                                      orderAddressController
                                                          .userSelectedOrderAddress
                                                          .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        var data =
                                                        orderAddressController
                                                            .userSelectedOrderAddress[
                                                        index];
                                                        return Column(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            Text(
                                                                data
                                                                    .fullName ??
                                                                    ""),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                                "${data
                                                                    .houseNumberBuildingName} , ${data
                                                                    .roadNameAreaColony}, ${data
                                                                    .city}, ${data
                                                                    .state} - ${data
                                                                    .pincode}"),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            Text(
                                                                data
                                                                    .phoneNumber ??
                                                                    "")
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          snackBar(
                                                              title:
                                                              "Confirm my address",
                                                              message: "");
                                                          Get.to(
                                                              const AddOrderAddressScreen());
                                                          // Navigator.pop(context);
                                                        },
                                                        child: Container(
                                                          width: 100,
                                                          height: 50,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .green,
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  10)),
                                                          child:
                                                          const Center(
                                                            child: Text(
                                                              "Update Address",
                                                              textAlign:
                                                              TextAlign
                                                                  .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          paymentsController
                                                              .makePayment(
                                                              context,
                                                              price: popularMenu
                                                                  .productPrice
                                                                  .toString());
                                                          snackBar(
                                                              title:
                                                              "Confirm Order",
                                                              message: "");
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          width: 100,
                                                          height: 50,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .orange,
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  10)),
                                                          child:
                                                          const Center(
                                                              child:
                                                              Text(
                                                                "Confirm Order",
                                                                textAlign:
                                                                TextAlign
                                                                    .center,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              )),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                      );
                                      snackBar(
                                          title: "Method",
                                          message: method);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: Get.width * 0.7,
                                      height: Get.height * 0.07,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            10),
                                        color: Colors.grey[200],
                                        border: Border.all(
                                            color: Colors.blue, width: 1),
                                      ),

                                      child: Center(child: Text(method,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),),),
                                    ),
                                  ),
                                );

                              }).toList()
                                  : [
                                const Text("No Payment Method Available")
                              ],
                            );
                          }),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  height: 50,
                  width: 150,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                    child: Text("Buy", style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold,),),
                  ),
                ),
              );
  }
}