import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/payment/payments_controller.dart';
import '../action_dialog/snackBar.dart';

class CustomPaymentOption extends StatelessWidget {
  final PaymentsController paymentController;
  final controller;
  final String orderType;
  final String? orderPrice;
  const CustomPaymentOption({
    super.key,
    required this.paymentController,
    this.controller,
    required this.orderType,
    this.orderPrice});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return SizedBox(
              height: 300,
              child: Center(
                child: Obx(() {
                  var paymentMethods = paymentController.getCurrentUserPaymentMethod;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: paymentMethods.isNotEmpty
                        ? paymentMethods.map((method) {
                      return GestureDetector(
                        onTap: () {
                          if (method == "Razorpay") {
                            print("method => $method");
                            snackBar(title: "Method", message: method);
                            // paymentController.openCheckout(price: controller.totalPrice.value.toString());
                            paymentController.openCheckout(price: controller);
                            Navigator.pop(context);
                          } else if (method == "Cash on delivery") {
                            print("method => $method");
                            snackBar(title: "Method", message: method);
                            Navigator.pop(context);
                          } else {
                            print("method => $method");
                            snackBar(title: "Method", message: method);
                            // paymentController.makePayment(context, price: controller.totalPrice.value.toString());
                            paymentController.makePayment(context, price: controller);
                            Navigator.pop(context);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: Get.width * 0.7,
                            height: Get.height * 0.07,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[200],
                              border: Border.all(
                                  color: Colors.blue, width: 1),
                            ),
                            child: Center(
                              child: Text(
                                method,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList()
                        : [const Text("No Payment Method Available")],
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
        child: Center(
          child: Text(
            orderType,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
