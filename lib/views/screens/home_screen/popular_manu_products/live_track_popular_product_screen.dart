// import 'dart:ui' as ui;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../../../utils/constants/image_constants.dart';
//
// class LiveTrackProductScreen extends StatefulWidget {
//   final LatLng destinationLatLng;
//   const LiveTrackProductScreen({super.key, required this.destinationLatLng});
//
//   @override
//   State<LiveTrackProductScreen> createState() => _LiveTrackProductScreenState();
// }
//
// class _LiveTrackProductScreenState extends State<LiveTrackProductScreen> {
//   late GoogleMapController _googleMapController;
//   CameraPosition? _initialCameraPosition;
//   final Set<Marker> _markers = {};
//   final Set<Polyline> _polyLines = {};
//   static const apiKey = "AlzaSyh1_pQW7D4OW_HMJYczt9dr6Ej_7RSCpoj";
//   final List<LatLng> _polyLinesCoordinates = [];
//   final PolylinePoints _polylinePoints = PolylinePoints();
//   BitmapDescriptor? liveLocationMarker;
//   String? distance = "";
//   String? destinationAddress = "";
//   LatLng? originLatLng;
//
//   @override
//   void initState() {
//     _determinePosition();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title:const Text("Live Track Product"),
//         centerTitle: true,
//       ),
//       body: _initialCameraPosition == null
//           ? const Center(child: CupertinoActivityIndicator(),)
//           : GoogleMap(
//           initialCameraPosition: _initialCameraPosition!,
//         tiltGesturesEnabled: true,
//         compassEnabled: true,
//         scrollGesturesEnabled: true,
//         zoomGesturesEnabled: true,
//         onMapCreated: (controller) {
//           _googleMapController = controller;
//         },
//         markers: _markers,
//         polylines: _polyLines,
//       ),
//         floatingActionButton: FloatingActionButton(onPressed: () {
//           _googleMapController.animateCamera(CameraUpdate.newLatLngZoom(originLatLng!, 17));
//         },child: const Icon(Icons.my_location_outlined),),
//
//       bottomSheet: distance == ""
//           ? const SizedBox()
//           : Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Distance : $distance",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
//             Text("Destination Address : $destinationAddress",style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 18),),
//           ],
//         ),
//       ),
//     );
//
//   }
//
//
// // This method using for polyline OriginLatLng to DestinationLatLng
//   _getPolyLines()async{
//     PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
//       googleApiKey: apiKey,
//       request: PolylineRequest(
//           origin: PointLatLng(originLatLng!.latitude, originLatLng!.longitude),
//           destination: PointLatLng(widget.destinationLatLng.latitude, widget.destinationLatLng.longitude),
//           mode: TravelMode.driving
//       ),
//     );
//     _polyLinesCoordinates.clear();
//     if(result.points.isNotEmpty){
//       result.points.forEach((PointLatLng point) {
//         _polyLinesCoordinates.add(LatLng(point.latitude, point.longitude));
//       },);
//     }
//
//     double distanceInMeters = result.totalDistanceValue!.toDouble();
//     double distanceInKm = distanceInMeters / 1000;
//     distance = "${distanceInKm.toStringAsFixed(1)} km";
//     destinationAddress = result.endAddress.toString();
//
//     _polyLines.add(
//         Polyline(
//             polylineId: const PolylineId("PolyLines"),
//             color: Colors.blue,
//             width: 8,
//             points: _polyLinesCoordinates
//         )
//     );
//     _googleMapController.animateCamera(CameraUpdate.newLatLngZoom(originLatLng!, 17));
//     setState(() {});
//   }
//
//
//
//   // This method for getting user currentPosition in Stream
//   void _determinePosition()async{
//     final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
//     bool serviceEnable;
//     LocationPermission permission;
//
//     serviceEnable = await _geolocatorPlatform.isLocationServiceEnabled();
//     if(!serviceEnable){
//       _geolocatorPlatform.openAppSettings();
//       return Future.error("Location services are disable");
//     }
//     permission = await _geolocatorPlatform.checkPermission();
//     if(permission == LocationPermission.denied){
//       permission = await _geolocatorPlatform.requestPermission();
//       if(permission == LocationPermission.denied){
//         _geolocatorPlatform.openAppSettings();
//         return Future.error("Location permission are denied");
//       }
//     }
//     if(permission == LocationPermission.deniedForever){
//       _geolocatorPlatform.openAppSettings();
//       return Future.error("Location permission are permanent denied, we cannot request permission");
//     }
//
//     late LocationSettings locationSettings;
//
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       locationSettings = AndroidSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: 100,
//         forceLocationManager: true,
//         intervalDuration: const Duration(seconds: 10),
//       );
//     } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
//       locationSettings = AppleSettings(
//         accuracy: LocationAccuracy.high,
//         activityType: ActivityType.fitness,
//         distanceFilter: 100,
//         pauseLocationUpdatesAutomatically: true,
//         // Only set to true if our app will be started up in the background.
//         showBackgroundLocationIndicator: false,
//       );
//     } else if (kIsWeb) {
//       locationSettings = WebSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: 100,
//         maximumAge: const Duration(minutes: 5),
//       );
//     } else {
//       locationSettings = const LocationSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: 100,
//       );
//     }
//
//
// // for location marker Image
//     await getBytesFromAssets(locationIcon,100).then((value) {
//       setState(() {
//         liveLocationMarker = value;
//       });
//     },);
//
//
// // This method create for getting currentLocation as a stream
//     _geolocatorPlatform.getPositionStream(locationSettings: locationSettings).listen((Position? position) {
//       print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
//       originLatLng = LatLng(position!.latitude, position.longitude);
//       _initialCameraPosition = CameraPosition(target: originLatLng! ,zoom: 15);
//       _markers.removeWhere((element) => element.markerId.value.compareTo("origin") == 0,);
//       _markers.add(
//           Marker(markerId: const MarkerId("origin"),
//               position: originLatLng!,
//               icon: liveLocationMarker!
//           )
//       );
//
//       if(widget.destinationLatLng != null){
//         _getPolyLines();
//       }
//       setState(() {});
//     });
//   }
//
// }
//
// // this method for set maker from using custom image
// Future<BitmapDescriptor> getBytesFromAssets(String path, int width)async{
//   ByteData data = await rootBundle.load(path);
//   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
//   ui.FrameInfo fi = await codec.getNextFrame();
//   final imageData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
//   final image = imageData?.buffer.asUint8List();
//   return BitmapDescriptor.fromBytes(image!);
// }

// 2nd
// import 'dart:ui' as ui;
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import '../../../utils/constants/image_constants.dart';
//
// class LiveTrackProductScreen extends StatefulWidget {
//   final LatLng destinationLatLng;
//   const LiveTrackProductScreen({super.key, required this.destinationLatLng});
//
//   @override
//   State<LiveTrackProductScreen> createState() => _LiveTrackProductScreenState();
// }
//
// class _LiveTrackProductScreenState extends State<LiveTrackProductScreen> {
//   late GoogleMapController _googleMapController;
//   CameraPosition? _initialCameraPosition;
//   final Set<Marker> _markers = {};
//   final Set<Polyline> _polyLines = {};
//   static const apiKey = "AlzaSyh1_pQW7D4OW_HMJYczt9dr6Ej_7RSCpoj";
//   final List<LatLng> _polyLinesCoordinates = [];
//   final PolylinePoints _polylinePoints = PolylinePoints();
//   BitmapDescriptor? liveLocationMarker;
//   String? distance = "";
//   String? destinationAddress = "";
//   LatLng? originLatLng;
//
//   @override
//   void initState() {
//     _determinePosition();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Live Track Product"),
//         centerTitle: true,
//       ),
//       body: _initialCameraPosition == null
//           ? const Center(child: CupertinoActivityIndicator(),)
//           : GoogleMap(
//         initialCameraPosition: _initialCameraPosition!,
//         tiltGesturesEnabled: true,
//         compassEnabled: true,
//         scrollGesturesEnabled: true,
//         zoomGesturesEnabled: true,
//         onMapCreated: (controller) {
//           _googleMapController = controller;
//         },
//         markers: _markers,
//         polylines: _polyLines,
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _googleMapController.animateCamera(CameraUpdate.newLatLngZoom(originLatLng!, 17));
//         },
//         child: const Icon(Icons.my_location_outlined),
//       ),
//       bottomSheet: distance == ""
//           ? const SizedBox()
//           : Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Distance : $distance",
//               style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//             ),
//             Text(
//               "Destination Address : $destinationAddress",
//               style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // This method using for polyline OriginLatLng to DestinationLatLng
//   _getPolyLines() async {
//     PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
//       googleApiKey: apiKey,
//       request: PolylineRequest(
//         origin: PointLatLng(originLatLng!.latitude, originLatLng!.longitude),
//         destination: PointLatLng(widget.destinationLatLng.latitude, widget.destinationLatLng.longitude),
//         mode: TravelMode.driving,
//       ),
//     );
//     _polyLinesCoordinates.clear();
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         _polyLinesCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     }
//
//     double distanceInMeters = result.totalDistanceValue!.toDouble();
//     double distanceInKm = distanceInMeters / 1000;
//     distance = "${distanceInKm.toStringAsFixed(1)} km";
//     destinationAddress = result.endAddress.toString();
//
//     _polyLines.add(
//       Polyline(
//         polylineId: const PolylineId("PolyLines"),
//         color: Colors.blue,
//         width: 8,
//         points: _polyLinesCoordinates,
//       ),
//     );
//     _googleMapController.animateCamera(CameraUpdate.newLatLngZoom(originLatLng!, 17));
//     setState(() {});
//   }
//
//   // This method for getting user currentPosition in Stream
//   void _determinePosition() async {
//     final GeolocatorPlatform geolocatorPlatform = GeolocatorPlatform.instance;
//     bool serviceEnable;
//     LocationPermission permission;
//
//     serviceEnable = await geolocatorPlatform.isLocationServiceEnabled();
//     if (!serviceEnable) {
//       geolocatorPlatform.openAppSettings();
//       return Future.error("Location services are disabled");
//     }
//     permission = await geolocatorPlatform.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await geolocatorPlatform.requestPermission();
//       if (permission == LocationPermission.denied) {
//         geolocatorPlatform.openAppSettings();
//         return Future.error("Location permissions are denied");
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       geolocatorPlatform.openAppSettings();
//       return Future.error("Location permissions are permanently denied");
//     }
//
//     late LocationSettings locationSettings;
//
//     if (defaultTargetPlatform == TargetPlatform.android) {
//       locationSettings = AndroidSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: 100,
//         forceLocationManager: true,
//         intervalDuration: const Duration(seconds: 10),
//       );
//     } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
//       locationSettings = AppleSettings(
//         accuracy: LocationAccuracy.high,
//         activityType: ActivityType.fitness,
//         distanceFilter: 100,
//         pauseLocationUpdatesAutomatically: true,
//         // Only set to true if our app will be started up in the background.
//         showBackgroundLocationIndicator: false,
//       );
//     } else if (kIsWeb) {
//       locationSettings = WebSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: 100,
//         maximumAge: const Duration(minutes: 5),
//       );
//     } else {
//       locationSettings = const LocationSettings(
//         accuracy: LocationAccuracy.high,
//         distanceFilter: 100,
//       );
//     }
//
//     // for location marker Image
//     await getBytesFromAssets(locationIcon, 100).then((value) {
//       setState(() {
//         liveLocationMarker = value;
//       });
//     });
//
//     // Get user's current location and start the location stream
//     geolocatorPlatform.getPositionStream(locationSettings: locationSettings).listen((Position? position) {
//       if (position != null) {
//         print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
//         originLatLng = LatLng(position.latitude, position.longitude);
//         _initialCameraPosition = CameraPosition(target: originLatLng!, zoom: 15);
//         _markers.removeWhere((element) => element.markerId.value.compareTo("origin") == 0);
//         _markers.add(
//           Marker(
//             markerId: const MarkerId("origin"),
//             position: originLatLng!,
//             icon: liveLocationMarker!,
//           ),
//         );
//
//         // Update polyline and distance as the user moves
//         if (widget.destinationLatLng != null) {
//           _getPolyLines();
//         }
//
//         // Update distance
//         double realTimeDistance = Geolocator.distanceBetween(
//           originLatLng!.latitude,
//           originLatLng!.longitude,
//           widget.destinationLatLng.latitude,
//           widget.destinationLatLng.longitude,
//         );
//
//         setState(() {
//           distance = "${(realTimeDistance / 1000).toStringAsFixed(1)} km";
//         });
//       }
//     });
//   }
// }
//
// // this method for set marker using custom image
// Future<BitmapDescriptor> getBytesFromAssets(String path, int width) async {
//   ByteData data = await rootBundle.load(path);
//   ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
//   ui.FrameInfo fi = await codec.getNextFrame();
//   final imageData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
//   final image = imageData?.buffer.asUint8List();
//   return BitmapDescriptor.fromBytes(image!);
// }
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../utils/constants/image_constants.dart';

class LiveTrackProductScreen extends StatefulWidget {
  final LatLng destinationLatLng;
  const LiveTrackProductScreen({super.key, required this.destinationLatLng});

  @override
  State<LiveTrackProductScreen> createState() => _LiveTrackProductScreenState();
}

class _LiveTrackProductScreenState extends State<LiveTrackProductScreen> {
  late GoogleMapController _googleMapController;
  CameraPosition? _initialCameraPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  static const apiKey = "AlzaSyh1_pQW7D4OW_HMJYczt9dr6Ej_7RSCpoj";
  final List<LatLng> _polyLinesCoordinates = [];
  final PolylinePoints _polylinePoints = PolylinePoints();
  BitmapDescriptor? liveLocationMarker;
  String? distance = "";
  String? destinationAddress = "";
  LatLng? originLatLng;

  @override
  void initState() {
    _determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Track Product"),
        centerTitle: true,
      ),
      body: _initialCameraPosition == null
          ? const Center(child: CupertinoActivityIndicator(),)
          : GoogleMap(
        initialCameraPosition: _initialCameraPosition!,
        tiltGesturesEnabled: true,
        compassEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: (controller) {
          _googleMapController = controller;
        },
        markers: _markers,
        polylines: _polyLines,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _googleMapController.animateCamera(CameraUpdate.newLatLngZoom(originLatLng!, 17));
        },
        child: const Icon(Icons.my_location_outlined),
      ),
      bottomSheet: distance == ""
          ? const SizedBox()
          : Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Distance : $distance",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              "Destination Address : $destinationAddress",
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  // This method using for polyline OriginLatLng to DestinationLatLng
  _getPolyLines() async {
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: apiKey,
      request: PolylineRequest(
        origin: PointLatLng(originLatLng!.latitude, originLatLng!.longitude),
        destination: PointLatLng(widget.destinationLatLng.latitude, widget.destinationLatLng.longitude),
        mode: TravelMode.driving,
      ),
    );
    _polyLinesCoordinates.clear();
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        _polyLinesCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    double distanceInMeters = result.totalDistanceValue!.toDouble();
    double distanceInKm = distanceInMeters / 1000;
    distance = "${distanceInKm.toStringAsFixed(1)} km";
    destinationAddress = result.endAddress.toString();

    _polyLines.add(
      Polyline(
        polylineId: const PolylineId("PolyLines"),
        color: Colors.blue,
        width: 8,
        points: _polyLinesCoordinates,
      ),
    );
    _googleMapController.animateCamera(CameraUpdate.newLatLngZoom(originLatLng!, 17));
    setState(() {});
  }

  // This method for getting user currentPosition in Stream
  // void _determinePosition() async {
  //   final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  //   bool serviceEnable;
  //   LocationPermission permission;
  //
  //   serviceEnable = await _geolocatorPlatform.isLocationServiceEnabled();
  //   if (!serviceEnable) {
  //     _geolocatorPlatform.openAppSettings();
  //     return Future.error("Location services are disabled");
  //   }
  //   permission = await _geolocatorPlatform.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await _geolocatorPlatform.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       _geolocatorPlatform.openAppSettings();
  //       return Future.error("Location permissions are denied");
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     _geolocatorPlatform.openAppSettings();
  //     return Future.error("Location permissions are permanently denied");
  //   }
  //
  //   late LocationSettings locationSettings;
  //
  //   if (defaultTargetPlatform == TargetPlatform.android) {
  //     locationSettings = AndroidSettings(
  //       accuracy: LocationAccuracy.high,
  //       distanceFilter: 100,
  //       forceLocationManager: true,
  //       intervalDuration: const Duration(seconds: 10),
  //     );
  //   } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
  //     locationSettings = AppleSettings(
  //       accuracy: LocationAccuracy.high,
  //       activityType: ActivityType.fitness,
  //       distanceFilter: 100,
  //       pauseLocationUpdatesAutomatically: true,
  //       // Only set to true if our app will be started up in the background.
  //       showBackgroundLocationIndicator: false,
  //     );
  //   } else if (kIsWeb) {
  //     locationSettings = WebSettings(
  //       accuracy: LocationAccuracy.high,
  //       distanceFilter: 100,
  //       maximumAge: const Duration(minutes: 5),
  //     );
  //   } else {
  //     locationSettings = const LocationSettings(
  //       accuracy: LocationAccuracy.high,
  //       distanceFilter: 100,
  //     );
  //   }
  //
  //   // for location marker Image
  //   await getBytesFromAssets(locationIcon, 100).then((value) {
  //     setState(() {
  //       liveLocationMarker = value;
  //     });
  //   });
  //
  //   // Get user's current location and start the location stream
  //   _geolocatorPlatform.getPositionStream(locationSettings: locationSettings).listen((Position? position) {
  //     if (position != null) {
  //       print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
  //       originLatLng = LatLng(position.latitude, position.longitude);
  //       _initialCameraPosition = CameraPosition(target: originLatLng!, zoom: 15);
  //       _markers.removeWhere((element) => element.markerId.value.compareTo("origin") == 0);
  //       _markers.add(
  //         Marker(
  //           markerId: const MarkerId("origin"),
  //           position: originLatLng!,
  //           icon: liveLocationMarker!,
  //         ),
  //       );
  //
  //       // Dynamically update polyline
  //       if (_polyLinesCoordinates.isEmpty || _polyLinesCoordinates.last != originLatLng) {
  //         _polyLinesCoordinates.add(originLatLng!); // Add new coordinate to polyline
  //       }
  //
  //
  //
  //       // Create a new Polyline for the updated path
  //       _polyLines.clear(); // Clear the previous polyline
  //       _polyLines.add(
  //         Polyline(
  //           polylineId: const PolylineId("PolyLines"),
  //           color: Colors.blue,
  //           width: 8,
  //           points: _polyLinesCoordinates,
  //         ),
  //       );
  //
  //       // Update distance
  //       double realTimeDistance = Geolocator.distanceBetween(
  //         originLatLng!.latitude,
  //         originLatLng!.longitude,
  //         widget.destinationLatLng.latitude,
  //         widget.destinationLatLng.longitude,
  //       );
  //
  //       setState(() {
  //         distance = "${(realTimeDistance / 1000).toStringAsFixed(1)} km";
  //       });
  //     }
  //   });
  // }

  void _determinePosition() async {
    final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
    bool serviceEnable;
    LocationPermission permission;

    serviceEnable = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnable) {
      _geolocatorPlatform.openAppSettings();
      return Future.error("Location services are disabled");
    }
    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        _geolocatorPlatform.openAppSettings();
        return Future.error("Location permissions are denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      _geolocatorPlatform.openAppSettings();
      return Future.error("Location permissions are permanently denied");
    }

    late LocationSettings locationSettings;

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 10),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        showBackgroundLocationIndicator: false,
      );
    } else if (kIsWeb) {
      locationSettings = WebSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
        maximumAge: const Duration(minutes: 5),
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
    }

    // for location marker Image
    await getBytesFromAssets(locationIcon, 100).then((value) {
      setState(() {
        liveLocationMarker = value;
      });
    });

    // Get user's current location and start the location stream
    _geolocatorPlatform.getPositionStream(locationSettings: locationSettings).listen((Position? position) {
      if (position != null) {
        print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
        originLatLng = LatLng(position.latitude, position.longitude);
        _initialCameraPosition = CameraPosition(target: originLatLng!, zoom: 15);
        _markers.removeWhere((element) => element.markerId.value.compareTo("origin") == 0);
        _markers.add(
          Marker(
            markerId: const MarkerId("origin"),
            position: originLatLng!,
            icon: liveLocationMarker!,
          ),
        );

        // Dynamically update polyline
        if (_polyLinesCoordinates.isEmpty || _polyLinesCoordinates.last != originLatLng) {
          _polyLinesCoordinates.add(originLatLng!); // Add new coordinate to polyline
        }

        // Call _getPolyLines() every time the user moves
        _getPolyLines(); // Update polyline when the user's position changes

        // Create a new Polyline for the updated path
        _polyLines.clear(); // Clear the previous polyline
        _polyLines.add(
          Polyline(
            polylineId: const PolylineId("PolyLines"),
            color: Colors.blue,
            width: 8,
            points: _polyLinesCoordinates,
          ),
        );

        // Update distance
        double realTimeDistance = Geolocator.distanceBetween(
          originLatLng!.latitude,
          originLatLng!.longitude,
          widget.destinationLatLng.latitude,
          widget.destinationLatLng.longitude,
        );

        setState(() {
          distance = "${(realTimeDistance / 1000).toStringAsFixed(1)} km";
        });
      }
    });
  }

}

// this method for set marker using custom image
Future<BitmapDescriptor> getBytesFromAssets(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  final imageData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
  final image = imageData?.buffer.asUint8List();
  return BitmapDescriptor.fromBytes(image!);
}
