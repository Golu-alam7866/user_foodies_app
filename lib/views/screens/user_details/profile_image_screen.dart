import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../controllers/user_image_controller.dart';
import '../../utils/constants/image_constants.dart';
import '../../utils/constants/styles.dart';
import '../../utils/constants/text_constants.dart';
import '../../utils/widgets/custom_app_bar_widget.dart';
import '../../utils/widgets/custom_container.dart';
import '../../utils/widgets/default_button.dart';

class ProfileImageScreen extends StatelessWidget {
  const ProfileImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    UserImageController userImageController = Get.put(UserImageController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profileScreenTitle,
                    style: AppTextStyle().userTextBold(),
                  ),
                  SizedBox(height: Get.height / 40),
                  const Text(profileScreenDesc),
                  SizedBox(height: Get.height / 40),
                  Obx(() {
                    return userImageController.imagePath.value.isNotEmpty
                        ? Center(
                      child: Container(
                        height: Get.height * 0.5,
                        width: Get.width * 0.7,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                            child: Image.file(File(userImageController.imagePath.value),fit: BoxFit.cover,)),
                      ),
                    )
                        : Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // pick from gallery
                            userImageController.getImage(source: ImageSource.gallery);
                          },
                          child: Center(
                            child: CustomContainer(
                              height: Get.height / 8,
                              width: Get.width / 1.3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(galleryImage),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: Get.height / 40),
                        GestureDetector(
                          onTap: () {
                            // pick from camera
                            userImageController.getImage(source: ImageSource.camera);
                          },
                          child: Center(
                            child: CustomContainer(
                              height: Get.height / 8,
                              width: Get.width / 1.3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(cameraImage),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            Obx(() {
              return DefaultButton(
                onTap: () {
                  userImageController.uploadImageOnFirebaseFirestore();
                },
                data: next,
                controller: userImageController.isLoading.value,
              );
            }),
            SizedBox(height: Get.height * 0.05,)
          ],
        ),
      ),
    );
  }
}
