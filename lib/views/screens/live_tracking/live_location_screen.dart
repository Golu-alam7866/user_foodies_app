import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import '../../utils/constants/image_constants.dart';
import 'api_services/api_services.dart';
import 'model/places_model.dart';

class LiveLocationScreen extends StatefulWidget {
  const LiveLocationScreen({super.key});

  @override
  State<LiveLocationScreen> createState() => _LiveLocationScreenState();
}

class _LiveLocationScreenState extends State<LiveLocationScreen> {

  late GoogleMapController googleMapController;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  CameraPosition? initialPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  final List<LatLng> _polyLinesCoordinates = [];
  final PolylinePoints _polylinePoints = PolylinePoints();
  LatLng? originLatLng;
  LatLng? destinationLatLng;
  BitmapDescriptor? liveLocationMarker;
  static const apiKey = "AlzaSyh1_pQW7D4OW_HMJYczt9dr6Ej_7RSCpoj";
  PlacesModel placesModel = PlacesModel();
  String? distance = "";
  String? destinationAddress = "";
  LatLngBounds? _latLngBounds;



  @override
  void initState() {
    super.initState();
    _determinePosition();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSearching
      ?
          AppBar(
            backgroundColor: Colors.blue,
            centerTitle: true,
            leading: BackButton(
              onPressed: () {
                setState(() {
                  isSearching = false;
                });
              },
            ),
            title: TextFormField(
              controller: searchController,
              autofocus: true,
              // style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Search Place..."
              ),
              onChanged: (value) {
                print("Value :$value");
                ApiServices().getPlaces(value.toString()).then((value) {
                  setState(() {
                    placesModel = value;
                  });
                },);
              },
            ),

          )
      :
          AppBar(
            centerTitle: true,
            backgroundColor: Colors.blue,
            title: const Text("Live Location Polyline"),
            actions: [
              IconButton(onPressed: () {
                setState(() {
                  isSearching = true;
                });
              }, icon: const Icon(Icons.search))
            ],

          ),

      body: initialPosition == null
          ? const Center(child: CupertinoActivityIndicator(),)
          : Stack(
            children: [
              GoogleMap(
              initialCameraPosition: initialPosition!,
                      tiltGesturesEnabled: true,
                      compassEnabled: true,
                      scrollGesturesEnabled: true,
                      zoomGesturesEnabled: true,
                      onMapCreated: (controller) {
                googleMapController = controller;
                      },
                      markers: _markers,
                      polylines: _polyLines,
                    ),

              Visibility(
                visible: placesModel.predictions == null ? false : true,
                // child: Expanded(
                  child: Container(
                    color: Colors.white,
                    child: ListView.builder(
                      itemCount: placesModel.predictions?.length ?? 0,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            ApiServices().getCoordinatesFromPlaceId(placesModel.predictions![index].placeId.toString()).then((value) {
                              _polyLinesCoordinates.clear();
                              searchController.clear();
                                destinationLatLng = LatLng(value.result!.geometry!.location!.lat!, value.result!.geometry!.location!.lng!);
                                placesModel.predictions = null;
                                isSearching = false;
                                print("Demo Destination LatLng :$destinationLatLng");

                              _markers.add(
                                  Marker(markerId: const MarkerId("Destination"),
                                      position: destinationLatLng!,
                                      // icon: liveLocationMarker!
                                      icon: BitmapDescriptor.defaultMarker
                                  )
                              );

                              _getPolyLines();


                              setState(() {

                              });
                            },).onError((error, stackTrace) {
                              print("Error PlaceId :$error");
                            },);

                          },
                          title: Text(placesModel.predictions![index].description.toString()),
                          leading: const Icon(Icons.location_on_outlined),
                        );
                      },
                    ),
                  ),
                // ),
              ),
            ],
          ),

      floatingActionButton: FloatingActionButton(onPressed: () {
        googleMapController.animateCamera(CameraUpdate.newLatLngZoom(originLatLng!, 17));
      },child: const Icon(Icons.my_location_outlined),),

      bottomSheet: distance == ""
          ? const SizedBox()
          : Container(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Distance : $distance",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            Text("Destination Address : $destinationAddress",style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 18),),
          ],
        ),
      ),

    );
  }
  _getPolyLines()async{
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: apiKey,
      request: PolylineRequest(
          origin: PointLatLng(originLatLng!.latitude, originLatLng!.longitude),
          destination: PointLatLng(destinationLatLng!.latitude, destinationLatLng!.longitude),
          mode: TravelMode.driving
      ),
    );
    _polyLinesCoordinates.clear();
    if(result.points.isNotEmpty){
      result.points.forEach((PointLatLng point) {
        _polyLinesCoordinates.add(LatLng(point.latitude, point.longitude));
      },);
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
            points: _polyLinesCoordinates
        )
    );
    googleMapController.animateCamera(CameraUpdate.newLatLngZoom(originLatLng!, 17));
    setState(() {});
  }

  void _determinePosition()async{
    final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
    bool serviceEnable;
    LocationPermission permission;

    serviceEnable = await _geolocatorPlatform.isLocationServiceEnabled();
    if(!serviceEnable){
      _geolocatorPlatform.openAppSettings();
      return Future.error("Location services are disable");
    }
    permission = await _geolocatorPlatform.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await _geolocatorPlatform.requestPermission();
      if(permission == LocationPermission.denied){
        _geolocatorPlatform.openAppSettings();
        return Future.error("Location permission are denied");
      }
    }
    if(permission == LocationPermission.deniedForever){
      _geolocatorPlatform.openAppSettings();
      return Future.error("Location permission are permanent denied, we cannot request permission");
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
        // Only set to true if our app will be started up in the background.
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
    await getBytesFromAssets(locationIcon,100).then((value) {
      setState(() {
        liveLocationMarker = value;
      });
    },);


// This method create for getting currentLocation as a stream
    _geolocatorPlatform.getPositionStream(locationSettings: locationSettings).listen((Position? position) {
      print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
      originLatLng = LatLng(position!.latitude, position.longitude);
      initialPosition = CameraPosition(target: originLatLng! ,zoom: 15);
      _markers.removeWhere((element) => element.markerId.value.compareTo("origin") == 0,);
      _markers.add(
        Marker(markerId: const MarkerId("origin"),
          position: originLatLng!,
            icon: liveLocationMarker!
        )
      );

      if(destinationLatLng != null){
        _getPolyLines();
      }
      setState(() {});
    });
  }

}


// this method for set maker from using custom image
Future<BitmapDescriptor> getBytesFromAssets(String path, int width)async{
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  final imageData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
  final image = imageData?.buffer.asUint8List();
  return BitmapDescriptor.fromBytes(image!);
}





