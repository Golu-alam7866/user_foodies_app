import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodies/views/screens/profile/wishlist_screen.dart';
import 'package:get/get.dart';
import '../../../controllers/profile_controller.dart';
import '../../../controllers/user_auth/user_auth_controller.dart';
import '../../utils/constants/image_constants.dart';
import '../live_tracking/google_map_manage_screen.dart';
import '../order_address/view_all_addresses_screen.dart';
import 'my_orders_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ProfileController profileController = Get.put(ProfileController());
    UserAuthController userAuthController = Get.put(UserAuthController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Profile",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: profileController.userData.value.userProfileImage != null &&
                            profileController.userData.value.userProfileImage!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: profileController.userData.value.userProfileImage.toString(),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const CupertinoActivityIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )
                        : Image.network(defaultSellerProfile),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          profileController.userData.value.firstName.toString(),
                          style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 5,),
                        Text(
                          profileController.userData.value.lastName.toString(),
                          style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      profileController.userData.value.email ??
                          'Email not available',
                      style: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
            ListTile(
              onTap: () {
                Get.to(const MyOrdersScreen());
              },
              leading: const Icon(CupertinoIcons.briefcase),
              title: const Text("My Orders", style: TextStyle(fontSize: 15),),
            ),
            ListTile(
              onTap: () {
                Get.to(const WishlistScreen());
              },
              leading: const Icon(Icons.favorite_outlined, color: Colors.red),
              title: const Text("WishList"),
            ),
            ListTile(
              onTap: () {
                Get.to(const ViewAllAddressesScreen());
              },
              leading: const Icon(Icons.share_location,),
              title: const Text("Saved Addresses"),
            ),
            ListTile(
              onTap: () {
                Get.to(const GoogleMapManageScreen());
              },
              leading: const Icon(Icons.map,),
              title: const Text("Google Map Manage"),
            ),
            ListTile(
              onTap: () {
                userAuthController.logOut();
              },
              leading: const Icon(Icons.settings_power_sharp, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red),),
            ),
          ],
        ),
      ),
    );
  }
}
