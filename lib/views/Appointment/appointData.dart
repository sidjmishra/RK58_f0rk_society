import 'package:block/modal/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppointDatabase {
  final String uid;
  AppointDatabase({@required this.uid});
  CollectionReference userCollection =
      Firestore.instance.collection('Appointment');

  Future userSubmitted(
      String id,
      String email,
      String userName,
      String name,
      String address1,
      String address2,
      String city,
      String pincode,
      String state,
      String userContact,
      String reason,
      String details,
      String dateOfAppointment,
      String countryIso,
      String countryName) async {
    await userCollection.document(uid).setData({
      'UserName': Constants.myName,
      'Email': Constants.myEmail,
      'Uid': Constants.myUid
    });
    await userCollection
        .document(uid)
        .collection('all_data')
        .document(id)
        .setData({
      'id': id,
      'email': email,
      'Name of User': userName,
      'Full Name': name,
      'address1': address1,
      'address2': address2,
      'city': city,
      'pincode': pincode,
      'state': state,
      'contact': userContact,
      'Reason': reason,
      'DetailsofAppointment': details,
      'DateofAppointment': dateOfAppointment,
      'Date of Filing': DateTime.now().toString(),
      'Confirmed Date': '',
      'CountryCode': countryIso,
      'CountryName': countryName,
      'Status': 'Pending'
    });
  }
}
