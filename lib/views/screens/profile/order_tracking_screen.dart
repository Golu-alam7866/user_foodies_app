import 'package:another_stepper/another_stepper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../models/order_model.dart';

class OrderTrackingScreen extends StatelessWidget {
  final OrderModel data;
   OrderTrackingScreen({super.key, required this.data});

  List<StepperData> stepperData = [
    StepperData(
      title: StepperText("Order Placed",textStyle: const TextStyle(color: Colors.grey)),
      subtitle: StepperText("Your order has been placed"),
      iconWidget: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(30))
        ),
      )
    ),
    StepperData(
        title: StepperText("Preparing"),
        subtitle: StepperText("Your order has been prepared"),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(30))
          ),
        )
    ),
    StepperData(
        title: StepperText("On the way"),
        subtitle: StepperText("Our delivery executive is on the way to deliver your item"),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(30))
          ),
        )
    ),
    StepperData(
        title: StepperText("Delivered",textStyle: const TextStyle(color: Colors.grey)),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.all(Radius.circular(30))
          ),
        )
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Tracking"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(),
            SizedBox(
              height: 35,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      const Text("Order ID -"),
                      const SizedBox(width: 10,),
                      Text(data.orderId ?? ""),
                    ],
                  ),
                )
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.productName ?? ""),
                      Text(data.sellerId ?? ""),
                      Text(data.productPrice ?? "")
                    ],
                  ),
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(imageUrl: data.productImage ?? "",width: 70,height: 70,fit: BoxFit.cover,))
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnotherStepper(
                  stepperList: stepperData,
                  stepperDirection: Axis.vertical,
                iconHeight: 15,
                iconWidth: 15,
                activeBarColor: Colors.green,
                inActiveBarColor: Colors.grey,
                inverted: false,
                verticalGap: 20,
                activeIndex: 1,
                barThickness: 2,
              ),
            ),
            const SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
