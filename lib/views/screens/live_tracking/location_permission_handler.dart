import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';


Future<Position> determinePosition() async {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    _geolocatorPlatform.openLocationSettings();
    return Future.error('Location services are disabled.');
  }

  permission = await _geolocatorPlatform.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await _geolocatorPlatform.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      _geolocatorPlatform.openLocationSettings();
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    _geolocatorPlatform.openAppSettings();
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await _geolocatorPlatform.getCurrentPosition();
}



Future<Position> locationPermissionHandler(BuildContext context) async {
  // Check if location services are enabled
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    // Show an alert dialog asking to enable location services
    _showAlertDialog(
      context,
      title: 'Location Services Disabled',
      message: 'Please enable location services to use this feature.',
      onPressed: () {
        // Request to enable location services
        Geolocator.openLocationSettings();
        Navigator.of(context).pop(); // Close the dialog
      },
    );
    throw Exception('Location services are disabled'); // Throw an exception to indicate failure
  }

  // Check location permission status using permission_handler
  ph.PermissionStatus permissionStatus = await ph.Permission.location.status;

  if (permissionStatus.isDenied) {
    // Show an alert dialog asking for location permission
    _showAlertDialog(
      context,
      title: 'Location Permission Denied',
      message: 'Please grant location permission to use this feature.',
      onPressed: () async {
        // Request location permission
        permissionStatus = await ph.Permission.location.request();
        Navigator.of(context).pop(); // Close the dialog

        // Retry checking the permissions and location services
        locationPermissionHandler(context);
      },
    );
    throw Exception('Location permission denied'); // Throw an exception to indicate failure
  }

  if (permissionStatus.isPermanentlyDenied) {
    // Show an alert dialog asking the user to open settings for permission
    _showAlertDialog(
      context,
      title: 'Location Permission Permanently Denied',
      message: 'Please enable location permission from the app settings.',
      onPressed: () {
        openAppSettings(); // Opens app settings to change permissions
        Navigator.of(context).pop(); // Close the dialog
      },
    );
    throw Exception('Location permission permanently denied'); // Throw an exception to indicate failure
  }

  // Get the current position
  try {
    Position position = await Geolocator.getCurrentPosition();
    print("Current position: $position");
    return position; // Return the position
  } catch (e) {
    // Handle any error that might occur during position fetching
    print("Error fetching position: $e");
    throw Exception('Error fetching location'); // Throw an exception in case of an error
  }
}

void _showAlertDialog(BuildContext context, {required String title, required String message, required VoidCallback onPressed}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: onPressed,
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
