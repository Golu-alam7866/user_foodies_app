import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../views/screens/congrats_screen/your_profile_is_done_screen.dart';
import '../views/utils/action_dialog/snackBar.dart';

class LocationController extends GetxController {
  RxString currentAddress = "".obs;
  Rxn<Position> currentPosition = Rxn<Position>();
  RxBool isLoading = false.obs;
  var nearbyShops = <DocumentSnapshot>[].obs;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxDouble distance = 0.0.obs;
  var productOrderAround50kmArea = <ProductModel>[].obs;
  var distanceBetweenUserAndProduct = 0.0.obs;
  var getAllProductList = <ProductModel>[].obs;
  RxMap<String, double> productDistances = <String, double>{}.obs;




  /// Ensure location permissions are granted and the service is enabled
  Future<void> ensureLocationPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error("Location Services Disabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Permission Denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return Future.error("Permission Denied Forever");
    }

    try {
      isLoading.value = true;
      Position position = await Geolocator.getCurrentPosition();
      currentPosition.value = position;
      print("Current Position: Latitude: ${position.latitude}, Longitude: ${position.longitude}");
    } catch (e) {
      print("Failed to get location: $e");
      Get.snackbar("Error", "Failed to get location: $e", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> getAddressFromLatLng() async {
    isLoading.value = true;
    try {
      if (currentPosition.value != null) {
        List<Placemark> placeMarkers = await placemarkFromCoordinates(
          currentPosition.value!.latitude,
          currentPosition.value!.longitude,
        );

        if (placeMarkers.isNotEmpty) {
          Placemark placemark = placeMarkers.first;
          currentAddress.value = "${placemark.name}, ${placemark.subThoroughfare}, ${placemark.thoroughfare}, "
              "${placemark.subLocality}, ${placemark.locality}, ${placemark.subAdministrativeArea}, "
              "${placemark.administrativeArea}, ${placemark.postalCode}, ${placemark.country}";
          print("Address => ${currentAddress.value}");
        } else {
          currentAddress.value = "No address found";
        }
      } else {
        currentAddress.value = "Current position is null";
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to get address: $e", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addUserLocationAndAddressOnFirebase()async{
    isLoading.value = true;
    try{
      var data = {
        "address" : currentAddress.value,
        "location" : GeoPoint(currentPosition.value!.latitude, currentPosition.value!.longitude)
      };
      await _db.collection("users").doc(_auth.currentUser!.uid).update(data).then((value) async{
        snackBar(title: "Your Address Added Successfully", message: currentAddress.value);
      },).then((value) async{Get.offAll(()=>const YourProfileIsDoneScreen());},);
      print("User Location => $data");
    }catch(e){
      snackBar(title: "Error", message: e.toString());
    }finally{
      isLoading.value = false;
    }
  }

  /// Calculate the distance between the user's location and the shop
  double calculateDistance({required Position start, required GeoPoint endLocation}) {
    double distance = Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      endLocation.latitude,
      endLocation.longitude,
    ) / 1000; // Convert to kilometers

    print("Calculated Distance: $distance km");
    return distance;
  }


  /// Fetch and display nearby shops by getting the user's current position
  Future<List<DocumentSnapshot>> fetchAndDisplayNearbyShops() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      print("User Current Position: Latitude: ${position.latitude}, Longitude: ${position.longitude}");
      return await getNearbyUserShops(userPosition: position);
    } catch (e) {
      print("Error fetching current position: $e");
      return [];
    }
  }


  // get Shop
  Future<List<DocumentSnapshot>> getNearbyUserShops({required Position userPosition}) async {
    CollectionReference shopCollection = FirebaseFirestore.instance.collection("shop");

    try {
      // Fetch all shops from Firestore
      QuerySnapshot querySnapshot = await shopCollection.get();
      List<DocumentSnapshot> shops = querySnapshot.docs;
      List<DocumentSnapshot> nearbyShops = [];

      for (var shop in shops) {
        if (shop['shopLocation'] is GeoPoint) {
          GeoPoint shopLocation = shop['shopLocation'];
          double distance = calculateDistance(start: userPosition, endLocation: shopLocation);
          print("Shop: ${shop['shopAddress']}, Distance: $distance km");

          // Check if the shop is within the 50 km radius
          if (distance <= 50) {
            nearbyShops.add(shop);
          }
        } else {
          print("Shop ${shop['shopAddress']} does not have a valid GeoPoint");
        }
      }

      if (nearbyShops.isEmpty) {
        print("No nearby shops found within 50 km range");
      } else {
        print("Total nearby shops found: ${nearbyShops.length}");
      }

      return nearbyShops;
    } catch (e) {
      print("Error fetching shops: $e");
      return [];
    }
  }
  
  Future<bool> onlyProductsOrderAround50Km(ProductModel product) async {
    try {
      isLoading.value = true;
      Position position = await Geolocator.getCurrentPosition();
      if (product.shopLocation != null) {
        distance.value = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          product.shopLocation!.latitude,
          product.shopLocation!.longitude,
        ) / 1000; // distance in km
        if (distance.value > 50) {
          // snackBar(title: "Please Order Only", message: "Within a 50 Km Radius");
          Navigator.pop(Get.context!);
          return false; // Out of range
        }
        return true; // Within range
      } else {
        snackBar(title: "Shop Location Missing", message: "Product location is missing.");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllProducts()async{
    try{
      isLoading.value = true;
      _db.collection("products").snapshots().listen((snapshot) => getAllProductList.value = snapshot.docs.map((doc) => ProductModel.fromJson(doc.data()),).toList(),);
    }catch(e){
      print("Error $e");
    }finally{
      isLoading.value = false;
    }
  }

  Future<void> fetchProductDistanceToUser()async{
    try{
      isLoading.value = true;

      Position userPosition = await Geolocator.getCurrentPosition();
      print("User Position : latitude: ${userPosition.latitude}, longitude: ${userPosition.longitude}");

      if(getAllProductList.isEmpty){
        print("Product List is empty");
        return;
      }

      productDistances.clear();

      for(var product in getAllProductList){
        double distanceBetweenUserToProduct = Geolocator.distanceBetween(
            userPosition.latitude,
            userPosition.longitude,
            product.shopLocation!.latitude,
            product.shopLocation!.longitude
        ) / 1000;

        productDistances[product.productId ?? ""] = distanceBetweenUserToProduct;
        print("Distance for ${product.productName} : $distanceBetweenUserToProduct");
      }

    }catch(e){
      print("Error : $e");
      return null;
    }finally{
      isLoading.value = false;
    }
  }



  @override
  void onInit() {
    super.onInit();
    ensureLocationPermissions();
    fetchAllProducts().then((value) {
      fetchProductDistanceToUser();
    },);
    fetchAndDisplayNearbyShops();
  }
}
