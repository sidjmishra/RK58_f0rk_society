import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class Location {
  double latitude;
  double longitude;
  String feature;
  String address;
  String subLocal;
  String local;
  String pin;

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      latitude = position.latitude;
      longitude = position.longitude;
      debugPrint('Location: ${position.latitude}');
      final coordinates = new Coordinates(latitude, longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;
      pin = first.postalCode;
      local = first.thoroughfare;
      subLocal  = first.subLocality;
      feature = first.subAdminArea;
      address = first.addressLine;
    } catch(e) {
      print(e);
    }
  }
}