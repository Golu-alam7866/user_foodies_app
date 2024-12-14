import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/get_coordinates_from_place_id_model.dart';
import '../model/nearby_search_model.dart';
import '../model/place_from_coordinates_model.dart';
import '../model/places_model.dart';


class ApiServices{
  static const apiKey = "AlzaSyh1_pQW7D4OW_HMJYczt9dr6Ej_7RSCpoj";

  Future<PlaceFromCoordinatesModel> placeFromCoordinates(double lat, double lng)async{
    Uri url = Uri.parse("https://maps.gomaps.pro/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey");
    var response = await http.get(url);
    if(response.statusCode == 200){
      return PlaceFromCoordinatesModel.fromJson(jsonDecode(response.body));
    }else{
      throw Exception("Api Error PlaceFromCoordinates");
    }
  }

  Future<PlacesModel> getPlaces(String placeName)async{
    Uri url = Uri.parse("https://maps.gomaps.pro/maps/api/place/autocomplete/json?input=$placeName&key=$apiKey");
    var response = await http.get(url);
    if(response.statusCode == 200){
      return PlacesModel.fromJson(jsonDecode(response.body));
    }else{
      throw Exception("Api Error Places");
    }
  }

  Future<GetCoordinatesFromPlacesIdModel> getCoordinatesFromPlaceId(String placeId)async{
    Uri url = Uri.parse("https://maps.gomaps.pro/maps/api/place/details/json?place_id=$placeId&key=$apiKey");
    var response = await http.get(url);
    if(response.statusCode == 200){
      return GetCoordinatesFromPlacesIdModel.fromJson(jsonDecode(response.body));
    }else{
      throw Exception("Api Error Places");
    }
  }

  Future<NearbySearchModel> getNearbySearch(double lat, double lng, String text)async{
    Uri url = Uri.parse("https://maps.gomaps.pro/maps/api/place/nearbysearch/json?keyword=restaurant&location=$lat,$lng&radius=100&type=$text&key=$apiKey");
    var response = await http.get(url);
    if(response.statusCode == 200){
      return NearbySearchModel.fromJson(jsonDecode(response.body));
    }else{
      throw Exception("Api Error Places");
    }
  }




}