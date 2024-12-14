import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:get/get.dart';

import '../../../../controllers/slider_image_controller.dart';

class CustomCarouselSlider extends StatelessWidget {
  const CustomCarouselSlider({super.key});

  @override
  Widget build(BuildContext context) {
    SliderImageController sliderImageController = Get.put(SliderImageController());
    return Obx(() {
      return SizedBox(
        height: Get.height * 0.20,
        width: double.infinity,
        child: CarouselSlider(
            items: sliderImageController.sliderImage.map((data) =>
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(imageUrl: data.sliderImageName.toString(),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(image: imageProvider,fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => const CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
            ).toList(),
            options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 400),
              viewportFraction: 0.8,
              autoPlayCurve: Curves.fastOutSlowIn,
            )
        ),
      );
    },);
  }
}
