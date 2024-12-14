import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/location_controller.dart';
import '../../utils/constants/image_constants.dart';
import '../../utils/constants/styles.dart';
import '../../utils/constants/text_constants.dart';
import '../../utils/widgets/custom_app_bar_widget.dart';
import '../../utils/widgets/default_button.dart';

class UserLocationScreen extends StatelessWidget {
  const UserLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LocationController locationController = Get.put(LocationController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(setYourLocationTitle, style: AppTextStyle().userTextBold()),
              SizedBox(height: Get.height / 40),
              const Text(yourLocationDesc),
              SizedBox(height: Get.height / 20),
              Row(
                children: [
                  Image.asset(locationIcon, width: 40, height: 40),
                  const SizedBox(width: 10),
                  const Text("Your Location"),
                ],
              ),
              const SizedBox(height: 20),
              Obx(() {
                return locationController.currentPosition.value != null
                    ? Row(
                  children: [
                    Text(locationController.currentPosition.value!.latitude
                        .toString()),
                    const SizedBox(width: 5),
                    Text(locationController.currentPosition.value!.longitude
                        .toString()),
                  ],
                )
                    : const Text("Current Position Not Available");
              }),
              const SizedBox(height: 20),
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 20),
                  child: Text(locationController.currentAddress.value),
                );
              }),
              const SizedBox(height: 30),
              Obx(() {
                return GestureDetector(
                  onTap: () async{
                    locationController.ensureLocationPermissions().then((value) async{
                      await locationController.getAddressFromLatLng();
                    },);
                  },
                  child: Center(
                    child: Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: locationController.isLoading.value
                              ? const CupertinoActivityIndicator(
                              color: Colors.white)
                              : const Text("Set Location",
                            style: TextStyle(color: Colors.white),),
                        )
                    ),
                  ),
                );
              }),
              const SizedBox(height: 30),
              Obx(() {
                return Center(
                  child: DefaultButton(
                    onTap: () {
                      locationController.addUserLocationAndAddressOnFirebase();
                    },
                    data: next,
                    controller: locationController.isLoading.value,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
