import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../demo_user_location/location_screen.dart';
import 'live_location_screen.dart';
import 'nearby_search_screen.dart';

class GoogleMapManageScreen extends StatelessWidget {
  const GoogleMapManageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("Google Map Manage Screen"),centerTitle: true,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LocationScreen(),));
              },
              child: Container(
                height: 50,
                width: Get.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(5),
                ),
                child:const Center(child: Text("Location Screen"),),
              ),
            ),
            const SizedBox(height: 20,),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LiveLocationScreen(),));
              },
              child: Container(
                height: 50,
                width: Get.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(5),
                ),
                child:const Center(child: Text("Live Location Tracking Screen"),),
              ),
            ),
            const SizedBox(height: 20,),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const NearbySearchScreen(),));
              },
              child: Container(
                height: 50,
                width: Get.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(5),
                ),
                child:const Center(child: Text("Nearby Search Screen"),),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
