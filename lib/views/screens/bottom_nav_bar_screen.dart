import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodies/views/screens/profile/profile_screen.dart';
import 'package:get/get.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import '../../controllers/add_to_cart_controller.dart';
import 'add_to_cart/add_to_cart_screen.dart';
import 'category/category_screen.dart';
import 'home_screen/home_screen.dart';

class BottomNavBarScreen extends StatelessWidget {
  const BottomNavBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AddToCartController addToCartController = Get.put(AddToCartController());
    PageController controller = PageController(initialPage: 0);
    RxInt selectIndex = 0.obs;
    return Scaffold(
      body: PageView(
        controller: controller,
        onPageChanged: (index) {
          selectIndex.value = index;
        },
        children: const [
          HomeScreen(),
          CategoryScreen(),
          AddToCartScreen(),
          ProfileScreen(),
          // ChatScreen()
        ],
      ),
      bottomNavigationBar: Obx(() {
        return StylishBottomBar(
          option: BubbleBarOptions(
              barStyle: BubbleBarStyle.horizontal,
              bubbleFillStyle: BubbleFillStyle.fill,
              opacity: 0.3),
          iconSpace: 12.0,
          items: [
            BottomBarItem(
              icon: const Icon(CupertinoIcons.home),
              title: const Text("Home"),
              backgroundColor: Colors.red,
            ),
            BottomBarItem(
                icon: const Icon(CupertinoIcons.square_grid_2x2),
                title: const Text("Category"),
                backgroundColor: Colors.red),
            BottomBarItem(
              icon: Stack(
                children: [
                  const Icon(CupertinoIcons.shopping_cart),
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: addToCartController.allCartProducts.isEmpty ? null :Colors.red,
                        borderRadius: BorderRadius.circular(7.5),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 15,
                        minHeight: 15,
                      ),
                      child: Center(
                        child: Text(
                          addToCartController.allCartProducts.isEmpty
                              ? ""
                              : addToCartController.allCartProducts.length.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              title: const Text("Cart"),
              backgroundColor: Colors.red,
            ),

            BottomBarItem(
              icon: const Icon(CupertinoIcons.person),
              title: const Text("Profile"),
              backgroundColor: Colors.red,
            ),
          ],
          hasNotch: true,
          currentIndex: selectIndex.value,
          onTap: (index) {
            selectIndex.value = index;
            controller.jumpToPage(index);
          },
        );
      }),
    );
  }
}
