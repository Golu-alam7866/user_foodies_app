import 'package:flutter/material.dart';
import 'package:foodies/views/screens/user_details/profile_image_screen.dart';
import 'package:get/get.dart';
import '../../../controllers/payment/payments_controller.dart';
import '../../utils/constants/image_constants.dart';
import '../../utils/constants/styles.dart';
import '../../utils/constants/text_constants.dart';
import '../../utils/widgets/default_button.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PaymentsController paymentsController = Get.put(PaymentsController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        ),
        title: Text('Select Payment Method', style: AppTextStyle().userTextBold()),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(paymentMethodTitle, style: AppTextStyle().userTextBold()),
                    SizedBox(height: Get.height / 40),
                    const Text(paymentMethodDesc),
                    SizedBox(height: Get.height / 20),
                    selectPaymentMethod(controller: paymentsController, method: "Razorpay", image: razorpayImage),
                    SizedBox(height: Get.height / 40),
                    selectPaymentMethod(controller: paymentsController, method: "Stripe", image: stripeImage),
                    SizedBox(height: Get.height / 40),
                    selectPaymentMethod(controller: paymentsController, method: "PayPal", image: payPalImage),
                    SizedBox(height: Get.height / 20),
                  ],
                ),
              ),
            ),
            Obx(() {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0), // Add bottom padding if needed
                child: DefaultButton(
                  onTap: () {
                    if (!paymentsController.isLoading.value) {
                      Get.to(() => const ProfileImageScreen());
                    }
                  },
                  data: next,
                  controller: paymentsController.isLoading.value,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget selectPaymentMethod({required PaymentsController controller, required String method, required String image}) {
    bool isSelected = controller.paymentsMethods.contains(method);
    return GestureDetector(
      onTap: () {
        controller.addPaymentMethod(paymentMethod: method);
      },
      child: Center(
        child: Container(
          height: Get.height / 13,
          width: Get.width / 1.3,
          decoration: BoxDecoration(
            border: Border.all(color: isSelected ? Colors.blue : Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image),
              const SizedBox(width: 10),
              Text(
                method,
                style: TextStyle(color: isSelected ? Colors.blue : Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
