import 'package:block/modal/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JailDatabase {
  final String uid;
  JailDatabase({@required this.uid});
  CollectionReference userCollection = Firestore.instance.collection('Jail Management');

  Future userSubmitted(
      String id,
      String email,
      String name,
      String role,
      String issue,
      String address1,
      String address2,
      String city,
      String pincode,
      String state,
      String userContact,
      String details,
      String date,
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
      'Full Name': name,
      'User Role': role,
      'IssueCategory': issue,
      'address1': address1,
      'address2': address2,
      'city': city,
      'state': state,
      'pincode': pincode,
      'contact': userContact,
      'Details of Complain': details,
      'DateofIncident': date,
      'Date of Filing': DateTime.now().toString(),
      'CountryCode': countryIso,
      'CountryName': countryName,
      'Status': 'Pending'
    });
  }
}
