import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

import '../../../controllers/add_to_cart_controller.dart';
import '../../../controllers/payment/payments_controller.dart';
import '../../utils/action_dialog/snackBar.dart';

class AddToCartScreen extends StatelessWidget {
  const AddToCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AddToCartController addToCartController = Get.put(AddToCartController());
    PaymentsController paymentsController = Get.put(PaymentsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
      ),
      body: Obx(() {
        if (addToCartController.isLoading.value) {
          return const Center(child: CupertinoActivityIndicator());
        }
        if (addToCartController.allCartProducts.isEmpty) {
          return const Center(child: Text("No products in your cart"));
        }
        return Column(
          children: [
            Expanded(
              flex: 3,
              child: ListView.builder(
                itemCount: addToCartController.allCartProducts.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  var addToCartModel = addToCartController.allCartProducts[index];
                  return GestureDetector(
                    onLongPress: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) =>
                            AlertDialog(
                              title: const Text(
                                "Are you sure you want to delete this product?",
                                style: TextStyle(fontSize: 15),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                          snackBar(
                                            title: "Cancel",
                                            message:
                                            "No, I don't want to delete this product",
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(
                                                10),
                                            border: Border.all(
                                                color: Colors.blue, width: 1),
                                          ),
                                          child: const Text("Cancel"),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          addToCartController
                                              .deleteAddToCartProduct(
                                              productId:
                                              addToCartModel.productId ??
                                                  ""); // Close the dialog
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(
                                                10),
                                            border: Border.all(
                                                color: Colors.blue, width: 1),
                                          ),
                                          child: const Text("Delete"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                      );
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
                                // Product details
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: addToCartModel.productImage ??
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
                                        Text(addToCartModel.productName ??
                                            "Product Name"),
                                        Text(addToCartModel.productId ??
                                            "Product Id"),
                                        Text(
                                            addToCartModel.productDescription ??
                                                "Product Description"),
                                        Row(
                                          children: [
                                            SmoothStarRating(
                                              size: 20,
                                              starCount: 5,
                                              onRatingChanged: (value) {
                                                addToCartController
                                                    .ratingInCart.value = value;
                                              },
                                            ),
                                            const SizedBox(width: 10),
                                            const Text("5"),
                                            const SizedBox(width: 10),
                                            const Text("(9,999)"),
                                          ],
                                        ),
                                        SizedBox(height: Get.height * 0.02),
                                        Row(
                                          children: [
                                            Text(
                                                "Quantity: ${addToCartModel
                                                    .productQuantity ?? 0}"),
                                            SizedBox(width: Get.width * 0.09),
                                            Text(
                                                "Price: ${addToCartModel
                                                    .productTotalPrice ??
                                                    0.0}"),
                                          ],
                                        ),
                                        SizedBox(height: Get.height * 0.01),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(),
                                IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      // Remove Button
                                      GestureDetector(
                                        onTap: () {
                                          addToCartController.decrementQuantity(
                                            productQuantity: addToCartModel
                                                .productQuantity!
                                                .toInt(),
                                            productId:
                                            addToCartModel.productId ?? "",
                                            productPrice:
                                            addToCartModel.productPrice ??
                                                "",
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(50),
                                          ),
                                          height: 30,
                                          width: Get.width * 0.43,
                                          child: const Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                CupertinoIcons.delete,
                                                color: Colors.grey,
                                                size: 20,
                                              ),
                                              SizedBox(width: 10),
                                              Text("Remove"),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const VerticalDivider(color: Colors.grey),
                                      // Add Button
                                      GestureDetector(
                                        onTap: () {
                                          addToCartController.incrementQuantity(
                                            productQuantity: addToCartModel
                                                .productQuantity!
                                                .toInt(),
                                            productId:
                                            addToCartModel.productId ?? "",
                                            productPrice:
                                            addToCartModel.productPrice ??
                                                "",
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(50),
                                          ),
                                          height: 30,
                                          width: Get.width * 0.43,
                                          child: const Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                CupertinoIcons.add,
                                                color: Colors.grey,
                                                size: 20,
                                              ),
                                              SizedBox(width: 5),
                                              Text("Add"),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      addToCartController.fetchProductPrice();
                      return Text(
                        "Price: ${addToCartController.totalPrice.value
                            .toStringAsFixed(1)}",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      );
                    }),
                    GestureDetector(
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
                                          if (method == "Razorpay") {
                                            print("method => $method");
                                            snackBar(
                                                title: "Method",
                                                message: method);
                                            paymentsController
                                                .openCheckout(
                                                price:
                                                addToCartController
                                                    .totalPrice
                                                    .value
                                                    .toString());
                                            Navigator.pop(context);
                                          } else if (method ==
                                              "Cash on delivery") {
                                            print("method => $method");
                                            snackBar(
                                                title: "Method",
                                                message: method);
                                            Navigator.pop(context);
                                          } else {
                                            print("method => $method");
                                            snackBar(
                                                title: "Method",
                                                message: method);
                                            paymentsController.makePayment(
                                                context,
                                                price: addToCartController
                                                    .totalPrice.value
                                                    .toString());
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: Get.width * 0.7,
                                            height: Get.height * 0.07,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  10),
                                              color: Colors.grey[200],
                                              border: Border.all(
                                                  color: Colors.blue,
                                                  width: 1),
                                            ),
                                            child: Center(
                                              child: Text(
                                                method,
                                                style: const TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList()
                                        : [
                                      const Text(
                                          "No Payment Method Available")
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
                        width: 200,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Center(
                          child: Text(
                            "Place Order",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}


