import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/location_controller.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LocationController locationController = Get.put(LocationController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Location Screen"),
      ),
      body: SafeArea(
        child: Center(
          child: Obx(() {
            // Check if it's loading
            if (locationController.isLoading.value) {
              // Show CircularProgressIndicator while loading
              return const CircularProgressIndicator();
            } else {
              // Display the location information once it's available
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Lat: ${locationController.currentPosition.value?.latitude ?? "latitude"}"),
                  Text("Lng: ${locationController.currentPosition.value?.longitude ?? "longitude"}"),
                  Text("Address: ${locationController.currentAddress.value.isNotEmpty ? locationController.currentAddress.value : "Address"}"),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      locationController.ensureLocationPermissions();
                    },
                    child: locationController.isLoading.value
                        ? const CupertinoActivityIndicator(color: Colors.blue)
                        : const Text("Get Current Location"),
                  ),
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}
