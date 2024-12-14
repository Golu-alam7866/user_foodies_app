import 'package:flutter/material.dart';
import 'package:foodies/views/screens/home_screen/search/search_widget/custom_search_bar.dart';
import 'package:foodies/views/screens/home_screen/view_more/nearest_restaurant_view_more_screen.dart';
import 'package:foodies/views/screens/home_screen/view_more/popular_menu_view_more_screen.dart';
import 'package:get/get.dart';
import '../../utils/constants/image_constants.dart';
import '../../utils/constants/styles.dart';
import '../../utils/constants/text_constants.dart';
import '../firebase_cloud_messaging/user_notification_screen.dart';
import 'home_widgets/custom_carousel_slider.dart';
import 'home_widgets/nearest_by_shop.dart';
import 'home_widgets/popular_menu.dart';
import 'home_widgets/title_and_view_all.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          findYourFavouriteFood,
          style: AppTextStyle().loginToYourAccountTextStyle(),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(() => const UserNotificationScreen());
            },
            child: Image.asset(notificationImage, height: Get.height / 20),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: ListView(
          children: [
            SizedBox(height: Get.height / 80),
            const CustomSearchBar(),
            SizedBox(height: Get.height / 80),
            const CustomCarouselSlider(),
            SizedBox(height: Get.height / 50),
            GestureDetector(
              onTap: () {
                Get.to(const NearestRestaurantViewMoreScreen());
              },
                child: const TitleAndViewAllText(
                  data: nearestRestaurant,
                  viewMore: viewMoreNearestRestaurant,),
            ),
            SizedBox(height: Get.height / 50),
            NearestByShop(),
            SizedBox(height: Get.height / 50),
            GestureDetector(
              onTap: () {
                Get.to(const PopularMenuViewMoreScreen());
              },
                child: const TitleAndViewAllText(
                    data: popularMenu,
                    viewMore: popularMenuViewMore),
            ),
            SizedBox(height: Get.height / 50),
            const GetTodayHighestRatingProducts(),
          ],
        ),
      ),
    );
  }
}
