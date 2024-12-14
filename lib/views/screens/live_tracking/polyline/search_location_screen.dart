import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodies/views/screens/live_tracking/polyline/polyline_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../utils/action_dialog/snackBar.dart';
import '../api_services/api_services.dart';
import '../location_permission_handler.dart';
import '../model/places_model.dart';

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({super.key});

  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {

  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  LatLng? originLatLng;
  LatLng? destinationLatLng;
  bool isSearching = false;
  PlacesModel placesModel = PlacesModel();
  bool isFocusOnOrigin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Location"),),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: TextFormField(
                      controller: _originController,
                      decoration:const InputDecoration(
                        hintText: "Search Place..."
                      ),
                      onChanged: (value) {
                        print("Search Value :$value");
                        ApiServices().getPlaces(value.toString()).then((value) {
                          setState(() {
                            placesModel = value;
                          });
                        },);
                      },
                      onTap: () {
                        setState(() {
                          isFocusOnOrigin = true;
                        });
                      },
                    )
                ),
                const SizedBox(width: 15,),
                const Text("Or"),
                const SizedBox(width: 15,),
                SizedBox(
                  height: 45,
                  width: 150,
                  child: ElevatedButton(
                      onPressed: (){
                        setState(() {
                          isSearching = true;
                        });
                        determinePosition().then((value) {
                          ApiServices().placeFromCoordinates(value.latitude, value.longitude).then((latLng) {
                            _originController.text = latLng.results![0].formattedAddress.toString();
                            originLatLng = LatLng(latLng.results![0].geometry!.location!.lat!, latLng.results![0].geometry!.location!.lng!);
                            isSearching = false;
                            setState(() {});
                          },);
                        },);
                      },
                      child: isSearching ? const CupertinoActivityIndicator() : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.my_location_sharp),
                          Text("Current ")
                        ],
                      )
                  ),
                )
              ],
            ),

            const SizedBox(height: 15,),
            const Text("To",style: TextStyle(fontSize: 20),),
            TextFormField(
              controller: _destinationController,
              decoration:const InputDecoration(
                  hintText: "Search Place..."
              ),
              onChanged: (value) {
                print("Search Value :$value");
                ApiServices().getPlaces(value.toString()).then((value) {
                  setState(() {
                    placesModel = value;
                  });
                },);
              },
              onTap: () {
                setState(() {
                  isFocusOnOrigin = false;
                });
              },
            ),
            const SizedBox(height: 20,),
            Visibility(
              visible: placesModel.predictions == null ? false : true,
              child: Expanded(
                child: ListView.builder(
                  itemCount: placesModel.predictions?.length ?? 0,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        ApiServices().getCoordinatesFromPlaceId(placesModel.predictions![index].placeId.toString()).then((value) {
                          if(isFocusOnOrigin){
                            originLatLng = LatLng(value.result!.geometry!.location!.lat!, value.result!.geometry!.location!.lng!);
                            _originController.text = value.result!.formattedAddress!;
                            placesModel.predictions = null;
                          }else{
                            destinationLatLng = LatLng(value.result!.geometry!.location!.lat!, value.result!.geometry!.location!.lng!);
                            _destinationController.text = value.result!.formattedAddress!;
                            placesModel.predictions = null;
                          }
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
            ),


            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(onPressed: (){
                if(originLatLng == null || destinationLatLng == null){
                  snackBar(title: "Please enter", message: "Required field");
                }else{
                  print("originLatLng :$originLatLng , destinationLatLng :$destinationLatLng");
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PolylineScreen(originPosition: originLatLng!, destinationPosition: destinationLatLng!,),));                }
              }, child:const Text("Submit")),
            )
          ],
        ),
      ),
    );
  }
}
