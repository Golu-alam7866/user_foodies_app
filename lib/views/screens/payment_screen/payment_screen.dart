// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:foodys/controllers/add_to_cart_controller.dart';
// import 'package:foodys/controllers/payment/payments_controller.dart';
// import 'package:foodys/models/add_to_cart_model.dart';
// import 'package:foodys/views/utils/constants/image_constants.dart';
// import 'package:get/get.dart';
//
// class PaymentScreen extends StatelessWidget {
//   final List<AddToCartModel> cartDetails;
//
//   const PaymentScreen({super.key, required this.cartDetails});
//
//   @override
//   Widget build(BuildContext context) {
//     AddToCartController addToCartController = Get.put(AddToCartController());
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Payment"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "Order Details",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: cartDetails.length,
//                 itemBuilder: (context, index) {
//                   final product = cartDetails[index];
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 8, vertical: 5),
//                     child: PhysicalModel(
//                       color: Colors.white,
//                       elevation: 3,
//                       borderRadius: BorderRadius.circular(10),
//                       child: Container(
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10)
//                         ),
//                         child: Row(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(15),
//                               child: CachedNetworkImage(
//                                 imageUrl: product.productImage ?? "",
//                                 width: 100,
//                                 height: 100,
//                                 fit: BoxFit.cover,
//                                 placeholder: (context, url) =>
//                                 const Center(
//                                     child: CupertinoActivityIndicator()),
//                                 errorWidget: (context, url,
//                                     error) => const Icon(Icons.error),
//                               ),
//                             ),
//                             Column(
//                               // mainAxisAlignment: MainAxisAlignment.start,
//                               // crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(product.productName ?? ""),
//                                 Text(product.productId ?? ""),
//                                 Text(product.categoryName ?? ""),
//                                 const SizedBox(width: 20,),
//
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment
//                                       .spaceBetween,
//                                   children: [
//                                     Text("Price ${product.productTotalPrice}"),
//                                     Text("Quantity ${product.productQuantity}"),
//                                   ],
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const Divider(),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text("Total Amount", style: TextStyle(
//                     fontSize: 18, fontWeight: FontWeight.bold)),
//                 Text("₹${addToCartController.totalPrice.value.toStringAsFixed(
//                     1)}", style: const TextStyle(
//                     fontSize: 18, fontWeight: FontWeight.bold)),
//               ],
//             ),
//             const SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Logic to confirm the order
//                   // You can add order confirmation code here
//                   Get.back(); // Pop the screen after order confirmation
//                   // Display a success message
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text("Order Confirmed!"),
//                     ),
//                   );
//                 },
//                 child: const Text("Confirm Order"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// class CheckOutPaymentMethodScreen extends StatelessWidget {
//   const CheckOutPaymentMethodScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     RxBool isChecked = false.obs;
//     RxBool razorPay = false.obs;
//     RxBool stripe = false.obs;
//     PaymentsController paymentsController = Get.put(PaymentsController());
//     // var stripePayment = paymentsController.makePayment(context);
//     return Scaffold(
//       appBar: AppBar(title: const Text("Payment Method"),),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           children: [
//             Expanded(
//               flex: 3,
//               child: Column(
//                 children: [
//                   paymentMethodOptionContainer(paymentOption: isChecked,
//                       paymentName: 'RazorPay',
//                       paymentImage: razorpayImage),
//                   const SizedBox(height: 20,),
//                   paymentMethodOptionContainer(paymentOption: isChecked,
//                       paymentName: "Stripe",
//                       paymentImage: stripeImage),
//                   const SizedBox(height: 20,),
//                   paymentMethodOptionContainer(paymentOption: isChecked,
//                       paymentName: "Cash On Delivery",
//                       paymentImage: cashOnDelivery),
//                   const SizedBox(height: 20,),
//                   GestureDetector(
//                     onTap: () {
//                       stripe.value = !stripe.value;
//                     },
//                     child: Container(
//                       width: Get.width,
//                       height: 50,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(5),
//                           border: Border.all(color: Colors.grey)
//                       ),
//                       child: const Center(child: Text("Stripe")),
//                     ),
//                   ),
//                   // Obx(() {
//                   //   return  stripe.value == true
//                   //         ? Future.delayed(Duration.zero,() => paymentsController.makePayment(context),)
//                   //         : Future.delayed(Duration.zero,() => stripe.value = false,),
//                   //
//                   // }),
//                 ],
//               ),
//             ),
//             const Divider(color: Colors.blue,),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text("Price   ₹9999"),
//                 Container(
//                   width: 200,
//                   height: 50,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       color: Colors.blue
//                   ),
//                   child: const Center(child: Text("Confirm Payment",
//                     style: TextStyle(
//                         color: Colors.white, fontWeight: FontWeight.bold),),),
//                 )
//               ],
//             )
//
//           ],
//         ),
//       ),
//     );
//   }
//
//   Container paymentMethodOptionContainer({
//     required RxBool paymentOption,
//     required String paymentName,
//     required String paymentImage,
//     void Function()? onTap
//   }) {
//     return Container(
//       height: 50,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5),
//           border: Border.all(color: Colors.grey)
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   width: 20,
//                   height: 20,
//                   alignment: Alignment.center,
//                   decoration: const BoxDecoration(
//                       gradient: LinearGradient(
//                           colors: [
//                             Color(0xFFF09869),
//                             Color(0xFFC729B2),
//                           ]
//                       ),
//                       borderRadius: BorderRadius.all(Radius.circular(50))
//                   ),
//                   child: Obx(() {
//                     return GestureDetector(
//                       onTap: onTap,
//                       child: paymentOption.value
//                           ? const Icon(
//                         Icons.check_rounded, color: Colors.white, size: 15,)
//                           : Padding(
//                         padding: const EdgeInsets.all(2.5),
//                         child: Container(
//                           height: 20,
//                           width: 20,
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(50)
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//                 const SizedBox(width: 10,),
//                 Text(paymentName),
//               ],
//             ),
//             Image.asset(paymentImage, width: 30, height: 30,)
//           ],
//         ),
//       ),
//     );
//   }
// }
//
