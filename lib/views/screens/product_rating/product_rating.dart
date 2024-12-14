// import 'package:flutter/material.dart';
// import 'package:five_pointed_star/five_pointed_star.dart';
// import 'package:foodys/controllers/rating_controller.dart';
// import 'package:get/get.dart';
//
// class ProductRating extends StatelessWidget {
//   const ProductRating({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     RatingController ratingController = Get.put(RatingController());
//     return Scaffold(
//       appBar: AppBar(title: const Text('Rating')),
//       body: Center(
//         child: Obx(() {
//           return Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Center(
//                 child: SizedBox(
//                   width: 200,
//                   height: 100,// Set the desired width
//                   child: Center(
//                     child: FivePointedStar(
//                       onChange: (count) {
//                         ratingController.starCount.value = count;
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//               Text(
//                 ratingController.starCount.string.toString(),
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ],
//           );
//         }),
//       ),
//     );
//   }
// }
