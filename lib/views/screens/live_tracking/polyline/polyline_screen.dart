import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PolylineScreen extends StatefulWidget {
  final LatLng originPosition , destinationPosition;
  const PolylineScreen({super.key, required this.originPosition, required this.destinationPosition});

  @override
  State<PolylineScreen> createState() => _PolylineScreenState();
}

class _PolylineScreenState extends State<PolylineScreen> {
  static const apiKey = "AlzaSyh1_pQW7D4OW_HMJYczt9dr6Ej_7RSCpoj";

  final Completer<GoogleMapController> _googleMapController = Completer();
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};

  final List<LatLng> _polyLinesCoordinates = [];
  final PolylinePoints _polylinePoints = PolylinePoints();
  String distance = "";
  bool isLoading = true;

  @override
  void initState() {
    _markers.add(
      Marker(
          markerId: const MarkerId("Origin"),
          position: widget.originPosition,
          icon: BitmapDescriptor.defaultMarker
      ),
    );
    _markers.add(
      Marker(
          markerId: const MarkerId("Destination"),
          position: widget.destinationPosition,
          icon: BitmapDescriptor.defaultMarkerWithHue(90)
      ),
    );
    _getPolyLines();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(distance),centerTitle: true,),
      body: isLoading ? const Center(child: CupertinoActivityIndicator(),) : GoogleMap(
          initialCameraPosition: CameraPosition(
              target: LatLng(widget.originPosition.latitude, widget.originPosition.longitude),
            zoom: 14
          ),
        myLocationEnabled: true,
        tiltGesturesEnabled: true,
        compassEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: (controller) {
            _googleMapController.complete(controller);
        },
        markers: _markers,
        polylines: _polyLines,
      ),
    );
  }

  _getPolyLines()async{
    PolylineResult result = await _polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: apiKey,
        request: PolylineRequest(
            origin: PointLatLng(widget.originPosition.latitude, widget.originPosition.longitude),
            destination: PointLatLng(widget.destinationPosition.latitude, widget.destinationPosition.longitude),
            mode: TravelMode.driving
        ),
    );
    if(result.points.isNotEmpty){
      result.points.forEach((PointLatLng point) {
        _polyLinesCoordinates.add(LatLng(point.latitude, point.longitude));
      },);
    }

    double distanceInMeters = result.totalDistanceValue!.toDouble();
    double distanceInKm = distanceInMeters / 1000;
    distance = "${distanceInKm.toStringAsFixed(1)} km";

    _polyLines.add(
       Polyline(
        polylineId: const PolylineId("PolyLines"),
        color: Colors.blue,
        width: 3,
        points: _polyLinesCoordinates
      )
    );

    isLoading = false;
    setState(() {

    });


  }
}
