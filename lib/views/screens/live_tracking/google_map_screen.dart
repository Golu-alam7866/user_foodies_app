//
// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:foodys/views/utils/constants/image_constants.dart'; // Assuming this is the correct import
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
//
// class GoogleMapScreen extends StatefulWidget {
//   const GoogleMapScreen({super.key});
//
//   @override
//   State<GoogleMapScreen> createState() => _GoogleMapScreenState();
// }
//
// class _GoogleMapScreenState extends State<GoogleMapScreen> {
//   final Completer<GoogleMapController> _controller = Completer();
//   double defaultLat = 37.42796133580664;
//   double defaultLng = -122.085749655962;
//
//   var api_key = "AIzaSyDkUZzoCS3SpgomDG8yKlXBR1XAQAF8sIs";
//
//   static const sourceLocation = LatLng(37.42796133580664, -122.085749655962);
//   static const destination = LatLng(30.42796133580664, -122.085749655962);
//
//
//   List<LatLng> polyLineCoordinates = [];
//   LocationData? currentLocation;
//   BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
//   BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
//
//   // Get current location and update camera position
//   void getCurrentLocation() async {
//     Location location = Location();
//
//     // Check for location permission
//     bool _serviceEnabled;
//     PermissionStatus _permissionGranted;
//
//     _serviceEnabled = await location.serviceEnabled();
//     if (!_serviceEnabled) {
//       _serviceEnabled = await location.requestService();
//       if (!_serviceEnabled) {
//         return;
//       }
//     }
//
//     _permissionGranted = await location.hasPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       _permissionGranted = await location.requestPermission();
//       if (_permissionGranted != PermissionStatus.granted) {
//         return;
//       }
//     }
//
//     location.getLocation().then((location) {
//       currentLocation = location;
//     });
//
//     GoogleMapController googleMapController = await _controller.future;
//
//     location.onLocationChanged.listen((newLocation) {
//       setState(() {
//         currentLocation = newLocation;
//       });
//       googleMapController.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             target: LatLng(newLocation.latitude!, newLocation.longitude!),
//             zoom: 14,
//           ),
//         ),
//       );
//     });
//   }
//
//   // Get polyline points for route
//   void getPolyPoints() async {
//     PolylinePoints polylinePoints = PolylinePoints();
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       googleApiKey: api_key,
//       request: PolylineRequest(
//           origin: PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
//           destination: PointLatLng(destination.latitude, destination.longitude),
//           mode: TravelMode.walking),
//     );
//
//     if (result.points.isNotEmpty) {
//       polyLineCoordinates.clear(); // Clear previous route points
//       result.points.forEach((PointLatLng point) {
//         polyLineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//       setState(() {});
//     }
//   }
//
//   // Set custom marker icons
//   void setCustomMarkerIcon() {
//     BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, locationIcon)
//         .then((icon) {
//       sourceIcon = icon;
//     });
//
//     BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, phoneImage)
//         .then((icon) {
//       destinationIcon = icon;
//     });
//
//     BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, googleImage)
//         .then((icon) {
//       currentLocationIcon = icon;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     getCurrentLocation();
//     setCustomMarkerIcon();
//     getPolyPoints();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Google Map Live Tracking"),
//         centerTitle: true,
//       ),
//       body: currentLocation == null
//           ? const Center(child: CupertinoActivityIndicator())
//           : GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: LatLng(
//             currentLocation!.latitude!,
//             currentLocation!.longitude!,
//           ),
//           zoom: 15,
//         ),
//         polylines: {
//           Polyline(
//             polylineId: const PolylineId("route"),
//             points: polyLineCoordinates,
//             color: Colors.blue,
//             width: 6,
//           ),
//         },
//         onMapCreated: (controller) {
//           _controller.complete(controller);
//         },
//         markers: {
//           Marker(
//             markerId: const MarkerId("currentLocation"),
//             icon: currentLocationIcon,
//             position: LatLng(
//               currentLocation!.latitude!,
//               currentLocation!.longitude!,
//             ),
//           ),
//           Marker(
//             markerId: const MarkerId("source"),
//             icon: sourceIcon,
//             position: sourceLocation,
//           ),
//           Marker(
//             markerId: const MarkerId("destination"),
//             icon: destinationIcon,
//             position: destination,
//           ),
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'api_services/api_services.dart';
import 'model/place_from_coordinates_model.dart';

class GoogleMapScreen extends StatefulWidget {
  final double lat,lng;
  const GoogleMapScreen({super.key, required this.lat, required this.lng});

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {

  double defaultLat = 0.0;
  double defaultLng = 0.0;
  PlaceFromCoordinatesModel placeFromCoordinatesModel = PlaceFromCoordinatesModel();
  bool isLoading = true;

  getAddress(){
    ApiServices().placeFromCoordinates(widget.lat, widget.lng).then((value) {
      setState(() {
        defaultLat = value.results?[0].geometry?.location?.lat ?? 0.0;
        defaultLng = value.results?[0].geometry?.location?.lng ?? 0.0;
        placeFromCoordinatesModel = value;
        print("Current Address ${value.results?[0].formattedAddress}");
        isLoading = false;
      });
    },);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text('Current Location',style: TextStyle(color: Colors.white),),backgroundColor: Colors.blue,),
      body: isLoading ? const Center(child: CupertinoActivityIndicator(),) : Stack(
        children: [
          GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.lat, widget.lng),
                zoom: 14.4746,
              ),
            mapType: MapType.normal,
            minMaxZoomPreference: const MinMaxZoomPreference(12, 20),
            onCameraIdle: () {
              print("Flutter");
              ApiServices().placeFromCoordinates(defaultLat, defaultLng).then((value) {
                setState(() {
                  defaultLat = value.results?[0].geometry?.location?.lat ?? 0.0;
                  defaultLng = value.results?[0].geometry?.location?.lng ?? 0.0;
                  placeFromCoordinatesModel = value;
                  print("Current Address ${value.results?[0].formattedAddress}");
                });
              },);
             
            },
            onCameraMove: (position) {
              print("Lat : ${position.target.latitude} , Lng :${position.target.longitude}");
              setState(() {
                defaultLat = position.target.latitude;
                defaultLng = position.target.longitude;
              });
            },
          ),
          const Center(child: Icon(Icons.location_on,size: 50,color: Colors.redAccent,),)
        ],
      ),
      bottomSheet: Container(
        color: Colors.grey[200],
        padding: const EdgeInsets.only(top: 10,bottom: 30,left: 20,right: 20),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(3.0),
              child: Icon(Icons.location_on),
            ),
            Expanded(child: Text(placeFromCoordinatesModel.results?[0].formattedAddress ?? "Loading...",style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 20),))
          ],
        ),
      ),
    );
  }
}
