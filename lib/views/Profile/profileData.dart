import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProfileData {

  final String uid;

  ProfileData({@required this.uid});

  CollectionReference collectionReference = Firestore.instance.collection('User Details');

  Future userSubmitted(String uid, String firstName, String lastName, String gender, String dob, String address1, String address2, String pincode, String city, String phone, String state, String type, String idNumber, urls) async {
    await collectionReference.document(uid).setData({
      'uid': uid,
      'First Name': firstName,
      'Last Name': lastName,
      'Gender': gender,
      'Date of Birth': dob,
      'Address Line 1': address1,
      'Address Line 2': address2,
      'Pincode': pincode,
      'City': city,
      'Phone Number': phone,
      'State': state,
      'U.I.D type': type,
      'U.I.D number': idNumber,
      'Urls': urls,
    });
  }
}