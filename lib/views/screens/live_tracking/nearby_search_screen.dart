import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/action_dialog/snackBar.dart';
import 'api_services/api_services.dart';
import 'location_permission_handler.dart';
import 'model/nearby_search_model.dart';

class NearbySearchScreen extends StatefulWidget {
  const NearbySearchScreen({super.key});

  @override
  State<NearbySearchScreen> createState() => _NearbySearchScreenState();
}

class _NearbySearchScreenState extends State<NearbySearchScreen> {

  bool _isSearching = false;
  final TextEditingController _searchingController = TextEditingController();
  LatLng? _currentLatLng;
  bool _isLoading = false;
  CameraPosition? _initialPosition;
  final Set<Marker> _markers = {};
  late GoogleMapController googleMapController;
  // NearbySearchModel _nearbySearchModel = NearbySearchModel();


  @override
  void initState() {
    determinePosition().then((value) {
      _currentLatLng =  LatLng(value.latitude, value.longitude);
      _initialPosition = CameraPosition(
          target: _currentLatLng!,zoom: 15
      );
      setState(() {});
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSearching
      ? AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            setState(() {
              _isSearching = false;
            });
          },
        ),
        title: TextFormField(
          controller: _searchingController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Search Places..."
          ),
        ),
        actions: [
          IconButton(onPressed: () {
            if(_searchingController.text.isNotEmpty){
              if(_currentLatLng != null){
                setState(() {
                  _isLoading = true;
                });
                ApiServices().getNearbySearch(_currentLatLng!.latitude, _currentLatLng!.longitude, _searchingController.text.toString()).then((value) {
                  showBottomSheet(value);
                  _searchingController.clear();
                  _isSearching = false;
                  setState(() {
                    _isLoading = false;
                  });
                },).onError((error, stackTrace) {
                  print("Error :$error");
                  setState(() {
                    _isLoading = false;
                  });
                },);
              }
            }else{
              snackBar(title: "Please Enter", message: "Place Name");
            }
            
          }, icon: _isLoading ? const Center(child: CupertinoActivityIndicator(),) : const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.search),),
          )
        ],
      )
      : AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title:const Text("Search Nearby"),
        actions: [
          IconButton(onPressed: () {
            setState(() {
              _isSearching = true;
            });
            
          }, icon: const Icon(Icons.search))
        ],
      ),
      body: _initialPosition == null ? const Center(child: CupertinoActivityIndicator(),) :  GoogleMap(
        initialCameraPosition: _initialPosition!,
        tiltGesturesEnabled: true,
        compassEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: (controller) {
          googleMapController = controller;
        },
        markers: _markers,
      ),

      floatingActionButton: FloatingActionButton(onPressed: () {
        googleMapController.animateCamera(CameraUpdate.newLatLngZoom(_currentLatLng!, 17));
      },child: const Icon(Icons.my_location_outlined),),




    );
  }

  showBottomSheet(NearbySearchModel nearbySearchModel){
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView.builder(
            itemCount: nearbySearchModel.results!.length,
              itemBuilder: (context, index) {
                _markers.add(
                    Marker(
                        markerId: MarkerId(index.toString()),
                      position: LatLng(nearbySearchModel.results![index].geometry!.location!.lat!, nearbySearchModel.results![index].geometry!.location!.lng!),
                      icon: BitmapDescriptor.defaultMarker
                    )
                );
                return ListTile(
                  title: Text(nearbySearchModel.results![index].name.toString()),
                  subtitle: Text(nearbySearchModel.results![index].openingHours == null ? "Close" : "Open"),
                );
              },
          );
        },
    );
  }
}
