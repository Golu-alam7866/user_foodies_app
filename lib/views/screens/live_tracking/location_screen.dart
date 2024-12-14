import 'package:flutter/material.dart';

import 'api_services/api_services.dart';
import 'google_map_screen.dart';
import 'location_permission_handler.dart';
import 'model/places_model.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  final TextEditingController _searchPlacesController = TextEditingController();
  PlacesModel placesModel = PlacesModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("Location",style: TextStyle(color: Colors.white),),backgroundColor: Colors.blue,),
      body: Padding(
        padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
        child: Column(
          children: [
            TextFormField(
              controller: _searchPlacesController,
              decoration: const InputDecoration(
                hintText: "Search Place..."
              ),
              onChanged: (String value) {
                print("Search Value :$value");
                ApiServices().getPlaces(value.toString()).then((value) {
                  setState(() {
                    placesModel = value;
                  });
                },);
              },
            ),

            Visibility(
              visible: _searchPlacesController.text.isEmpty ? false : true,
              child: Expanded(
                child: ListView.builder(
                  itemCount: placesModel.predictions?.length ?? 0,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        print("PlaceId :${placesModel.predictions![index].placeId}");
                        ApiServices().getCoordinatesFromPlaceId(placesModel.predictions![index].placeId.toString()).then((value) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => GoogleMapScreen(
                              lat: value.result!.geometry!.location!.lat!,
                              lng: value.result!.geometry!.location!.lng!),
                          ));
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

            Visibility(
              visible: _searchPlacesController.text.isEmpty ? true : false,
              child: Container(
                margin: const EdgeInsets.only(top: 50),
                child: ElevatedButton(onPressed: (){
                  determinePosition().then((value) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => GoogleMapScreen(lat: value.latitude, lng: value.longitude,),));
                  },).onError((error, stackTrace) {
                    print("Error :$error");
                  },);
                },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.my_location,color: Colors.green,),
                        SizedBox(width: 5,),
                        Text("Current Location"),
                      ],
                    ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
